//! Lua bindings for `tree-sitter-highlight`.
//!
//! Exposes two Lua functions:
//!
//! * `search_parsers({"/a/path", "/b/path"})` — scans each directory for `parser/*.so` and
//!   `queries/*/`, returning a `{ lang = { so, queries_dir } }` table suitable for `highlight`'s
//!   `parsers` argument.
//! * `highlight { source, language, parsers, theme, format, layout, style, prefix, math_escape }`
//!   — performs syntax highlighting and returns the rendered document as a string.
//!
//! See `render.rs` for the copied-from-`cli` rendering helpers and the
//! `attribute_callback` -> precomputed attribute-table design, and `loader.rs` for how the
//! `parsers` table becomes a registry of [`tree_sitter_highlight::HighlightConfiguration`]s.

use std::collections::{HashMap, HashSet};
use std::path::PathBuf;

use anstyle::Style as AnstyleStyle;
use mlua::{Error, Lua, Result, Table, Value};
use serde_json::Value as JsonValue;
use tree_sitter_config::Config as TsConfig;
use tree_sitter_highlight::{
    Error as TsError, Highlighter, Renderer, TerminalRenderer, TexRenderer,
};

pub mod loader;
pub mod render;

use loader::{Error as LoaderError, build_configs, resolve_math_escape};
use render::{
    Layout, OutputFormat, RenderTheme, StylingMode, build_attribute_strings, parse_theme,
    render_highlighted, write_html, write_tex_document, write_tex_linenumbers, write_tex_preamble,
};

/// Scan each directory for `parser/<lang>.so` and `queries/<lang>/`, returning a
/// `{ lang = { so, queries_dir } }` table.
fn search_parsers(dirs: Vec<String>) -> Result<HashMap<String, Vec<String>>> {
    let mut result: HashMap<String, Vec<String>> = HashMap::new();
    for dir in dirs {
        let parser_dir = PathBuf::from(&dir).join("parser");
        if !parser_dir.is_dir() {
            continue;
        }
        let queries_root = PathBuf::from(&dir).join("queries");
        let Ok(entries) = std::fs::read_dir(&parser_dir) else {
            continue;
        };
        for entry in entries.flatten() {
            let file_name = entry.file_name();
            let name = file_name.to_string_lossy();
            if let Some(lang) = name.strip_suffix(".so") {
                let queries_dir = queries_root.join(lang);
                result.insert(
                    lang.to_string(),
                    vec![
                        entry.path().to_string_lossy().to_string(),
                        queries_dir.to_string_lossy().to_string(),
                    ],
                );
            }
        }
    }
    Ok(result)
}

/// Parse the `format`/`layout`/`style` string arguments into the internal enums.
fn parse_format(s: &str) -> Result<OutputFormat> {
    match s {
        "html" => Ok(OutputFormat::Html),
        "latex" => Ok(OutputFormat::Latex),
        "terminal" => Ok(OutputFormat::Terminal),
        other => Err(Error::RuntimeError(format!(
            "unknown format '{other}' (expected html|latex|terminal)"
        ))),
    }
}

fn parse_layout(s: &str) -> Result<Layout> {
    match s {
        "document" => Ok(Layout::Document),
        "line-numbers" => Ok(Layout::LineNumbers),
        "fragment" => Ok(Layout::Fragment),
        other => Err(Error::RuntimeError(format!(
            "unknown layout '{other}' (expected document|line-numbers|fragment)"
        ))),
    }
}

fn parse_style(s: &str) -> Result<StylingMode> {
    match s {
        "classes" => Ok(StylingMode::Classes),
        "inline" => Ok(StylingMode::Inline),
        "minimal" => Ok(StylingMode::Minimal),
        other => Err(Error::RuntimeError(format!(
            "unknown style '{other}' (expected classes|inline|minimal)"
        ))),
    }
}

/// Load the `theme` object from tree-sitter's `config.json` (the same file the CLI reads, resolved
/// via `tree_sitter_config::Config::load`, which uses `etcetera` to find `$XDG_CONFIG_HOME/
/// tree-sitter/config.json`, `%APPDATA%/tree-sitter/config.json`, `$HOME/.tree-sitter/
/// config.json`, etc.). Used as the fallback when the Lua caller does not supply its own theme.
fn load_default_theme() -> Result<RenderTheme> {
    let config = TsConfig::load(None)
        .map_err(|e| Error::RuntimeError(format!("failed to load tree-sitter config: {e}")))?;
    // `config.config` is the parsed `config.json` as a `serde_json::Value`; the `theme` key holds
    // the highlight theme object (name -> {color, bold, ...}), identical in shape to the Lua
    // `theme` table.
    match config.config.get("theme") {
        Some(theme_value) => Ok(parse_theme(theme_value)),
        None => Ok(RenderTheme::default()),
    }
}

/// The core highlight driver. Shared by the Lua entry point and (eventually) tests.
///
/// `format`/`layout`/`style`/`prefix`/`math_escape` are taken as resolved enums/strings.
/// `math_escape` is ignored for `Terminal`/`Html`; `layout`/`style` are ignored for `Terminal`.
fn run_highlight(
    source: &[u8],
    language: &str,
    parsers: &HashMap<String, (PathBuf, PathBuf)>,
    theme: &RenderTheme,
    format: OutputFormat,
    layout: Layout,
    style: StylingMode,
    prefix: &str,
    math_escape: &HashSet<usize>,
) -> std::result::Result<String, String> {
    let configs =
        build_configs(parsers, &theme.highlight_names).map_err(|e: LoaderError| e.to_string())?;
    let top = configs
        .get(language)
        .ok_or_else(|| format!("language '{language}' not found in `parsers`"))?;

    let mut highlighter = Highlighter::new();
    // `configs` and `highlighter` share this scope; the injection callback borrows `configs`
    // and returns `&HighlightConfiguration`, which is valid for the lifetime of `events`.
    let events = highlighter
        .highlight(top, source, None, None, |name: &str| configs.get(name))
        .map_err(|e: TsError| e.to_string())?;

    match format {
        OutputFormat::Terminal => {
            let styles: Vec<anstyle::Style> = theme.styles.iter().map(|s| s.ansi).collect();
            let default = AnstyleStyle::new();
            let mut renderer = TerminalRenderer::new(&styles, default);
            render_highlighted(&mut renderer, events, source, &[]).map_err(|e| e.to_string())?;
            Ok(String::from_utf8_lossy(renderer.content()).into_owned())
        }
        OutputFormat::Html => {
            let mut renderer = render::HtmlRenderer::new();
            let attrs = build_attribute_strings(theme, style, format, prefix);
            render_highlighted(&mut renderer, events, source, &attrs).map_err(|e| e.to_string())?;
            let body: Vec<String> = renderer.lines().map(|s| s.to_string()).collect();
            let mut out = Vec::new();
            write_html(&mut out, theme, layout, style, &body);
            Ok(String::from_utf8_lossy(&out).into_owned())
        }
        OutputFormat::Latex => {
            let mut renderer = TexRenderer::new(prefix.to_string(), math_escape.clone());
            let attrs = build_attribute_strings(theme, style, format, prefix);
            render_highlighted(&mut renderer, events, source, &attrs).map_err(|e| e.to_string())?;
            let body = String::from_utf8_lossy(renderer.content()).into_owned();
            let mut out = Vec::new();
            // TODO: add a new option to output CSS and preamble.tex for tree-sitter-highlight
            if style == StylingMode::Minimal {
                write_tex_preamble(&mut out, prefix, theme, StylingMode::Classes);
                Ok(String::from_utf8_lossy(&out).into_owned())
            } else {
                match layout {
                    Layout::Fragment => {}
                    Layout::LineNumbers => {
                        write_tex_linenumbers(&mut out, prefix, theme, style, &body)
                    }
                    _ => write_tex_document(&mut out, prefix, theme, style, &body),
                }
                if layout == Layout::Fragment {
                    Ok(body)
                } else {
                    Ok(String::from_utf8_lossy(&out).into_owned())
                }
            }
        }
    }
}

/// Lua entry point: `highlight { ... }`.
fn lua_highlight(args: Table) -> Result<String> {
    // `source` is the literal text to highlight. When it is omitted, `file` is treated as a
    // filename whose contents become the source; `file == "-"` reads from standard input.
    let source: String = match args.get::<Value>("source") {
        Ok(Value::String(s)) => s
            .to_str()
            .map_err(|e| Error::RuntimeError(e.to_string()))?
            .to_string(),
        _ => {
            let file: String = args.get("file")?;
            if file == "-" {
                use std::io::Read as _;
                let mut buf = String::new();
                std::io::stdin()
                    .read_to_string(&mut buf)
                    .map_err(|e| Error::RuntimeError(format!("failed to read stdin: {e}")))?;
                buf
            } else {
                std::fs::read_to_string(&file).map_err(|e| {
                    Error::RuntimeError(format!("failed to read file '{file}': {e}"))
                })?
            }
        }
    };
    let language: String = args.get("language")?;

    // `parsers`: `{ lang = { "/path/of/lang.so", "/path/of/queries/lang" } }`.
    let parsers_tbl: Table = args.get("parsers")?;
    let mut parsers: HashMap<String, (PathBuf, PathBuf)> = HashMap::new();
    for pair in parsers_tbl.pairs::<String, Value>() {
        let (lang, val) = pair?;
        if let Value::Table(pair_tbl) = val {
            let so: String = pair_tbl.get(1)?;
            let queries: String = pair_tbl.get(2)?;
            parsers.insert(lang, (PathBuf::from(so), PathBuf::from(queries)));
        } else {
            return Err(Error::RuntimeError(format!(
                "parsers['{lang}'] must be a table {{ so, queries_dir }}"
            )));
        }
    }
    if parsers.is_empty() {
        return Err(Error::RuntimeError(
            "`parsers` is empty; nothing to highlight with".to_string(),
        ));
    }

    // `theme`: a `name -> {color, bold, ...}` JSON object (mirrors cli's theme JSON). An explicit,
    // non-empty Lua table takes priority; when it is omitted or empty, fall back to the `theme`
    // from tree-sitter's `config.json`.
    let theme: RenderTheme = match args.get::<Value>("theme") {
        Ok(Value::Table(t)) if !t.is_empty() => {
            let json: JsonValue = lua_table_to_json(t)?;
            parse_theme(&json)
        }
        _ => load_default_theme()?,
    };

    let format = {
        let raw: String = args
            .get::<String>("format")
            .unwrap_or_else(|_| "terminal".into());
        parse_format(&raw)?
    };
    let layout = {
        let raw: String = args
            .get::<String>("layout")
            .unwrap_or_else(|_| "document".into());
        parse_layout(&raw)?
    };
    let style = {
        let raw: String = args
            .get::<String>("style")
            .unwrap_or_else(|_| "classes".into());
        parse_style(&raw)?
    };
    let prefix: String = args.get::<String>("prefix").unwrap_or_else(|_| "TS".into());

    // `math_escape`: a list of scope names; resolved against the host config's names.
    let math_escape_names: Vec<String> = match args.get::<Value>("math_escape")? {
        Value::Table(t) => t.sequence_values::<String>().collect::<Result<Vec<_>>>()?,
        _ => Vec::new(),
    };
    let math_escape: HashSet<usize> = {
        let names_refs: Vec<&str> = math_escape_names.iter().map(String::as_str).collect();
        // Resolve against the host language's scope names (all configs share `theme_names`).
        let scopes = theme.highlight_names.clone();
        resolve_math_escape(&names_refs, &scopes)
    };

    run_highlight(
        source.as_bytes(),
        &language,
        &parsers,
        &theme,
        format,
        layout,
        style,
        &prefix,
        &math_escape,
    )
    .map_err(Error::RuntimeError)
}

/// Convert a Lua table into a `serde_json::Value`. Nested tables become objects (string keys)
/// or arrays (integer keys, sorted).
fn lua_table_to_json(t: Table) -> Result<JsonValue> {
    // Prefer array shape when the table has a contiguous 1..n integer sequence.
    let len = t.raw_len();
    if len > 0 {
        let mut arr = Vec::with_capacity(len);
        for i in 1..=len {
            let v: Value = t
                .get(i)
                .map_err(|e| Error::RuntimeError(format!("theme table array element {i}: {e}")))?;
            arr.push(lua_value_to_json(v)?);
        }
        return Ok(JsonValue::Array(arr));
    }
    let mut map = serde_json::Map::new();
    for pair in t.pairs::<Value, Value>() {
        let (k, v) =
            pair.map_err(|e| Error::RuntimeError(format!("theme table iteration: {e}")))?;
        let key = match k {
            Value::String(s) => s
                .to_str()
                .map_err(|e| Error::RuntimeError(e.to_string()))?
                .to_string(),
            Value::Integer(i) => i.to_string(),
            other => {
                return Err(Error::RuntimeError(format!(
                    "theme key must be string or integer, got {other:?}"
                )));
            }
        };
        map.insert(key, lua_value_to_json(v)?);
    }
    Ok(JsonValue::Object(map))
}

fn lua_value_to_json(v: Value) -> Result<JsonValue> {
    match v {
        Value::Nil => Ok(JsonValue::Null),
        Value::Boolean(b) => Ok(JsonValue::Bool(b)),
        Value::Integer(i) => Ok(JsonValue::from(i)),
        Value::Number(n) => Ok(JsonValue::from(n)),
        Value::String(s) => Ok(JsonValue::String(
            s.to_str()
                .map_err(|e| Error::RuntimeError(e.to_string()))?
                .to_string(),
        )),
        Value::Table(t) => lua_table_to_json(t),
        other => Err(Error::RuntimeError(format!(
            "unsupported theme value: {other:?}"
        ))),
    }
}

/// Register the module's Lua functions.
#[mlua::lua_module]
fn tree_sitter_highlight(lua: &Lua) -> Result<Table> {
    let exports = lua.create_table()?;
    exports.set(
        "highlight",
        lua.create_function(|_: &Lua, args: Table| lua_highlight(args))?,
    )?;
    exports.set(
        "search_parsers",
        lua.create_function(|_: &Lua, dirs: Vec<String>| search_parsers(dirs))?,
    )?;
    Ok(exports)
}
