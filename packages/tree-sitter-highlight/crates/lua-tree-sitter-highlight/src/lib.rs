//! Lua bindings for `tree-sitter-highlight`.
//!
//! Exposes two Lua functions:
//!
//! * `search_parsers({"/a/path", "/b/path"})` — scans each directory for `parser/<lang>.so` and
//!   `queries/<lang>/`, returning a `{ lang = { parser, highlights, injections, locals } }` table
//!   suitable for `highlight`'s `parsers` argument. `parser` is the full path to the `.so`;
//!   `highlights`/`injections`/`locals` are the full text of the matching `queries/<lang>/*.scm`
//!   files (empty when a file is absent).
//! * `highlight { source, language, parsers, theme, format, layout, style, prefix, math_escape }`
//!   — performs syntax highlighting and returns the rendered document as a string. Its `parsers`
//!   argument uses the same `{ lang = { parser, highlights, injections, locals } }` shape.
//!
//! The language registry and rendering live in `highlight_core`; this crate only provides the
//! Lua object interop (reading the `parsers` table, dynamic-linking each `parser/*.so`) and the
//! `search_parsers` filesystem scan.

use std::collections::{HashMap, HashSet};
use std::path::Path;

use mlua::{Error, Lua, Result, Table, Value};
use serde_json::Value as JsonValue;

use highlight_core::render::{RenderTheme, parse_theme};
use highlight_core::{resolve_math_escape, run_highlight, CoreParserInfo};

pub mod loader;

use loader::{search_parsers as _search_parsers, ParserInfo};

/// Scan each directory for `parser/<lang>.so` and `queries/<lang>/`, returning a
/// `{ lang = { parser, highlights, injections, locals } }` Lua table.
///
/// Two passes are made over the supplied directories:
///
/// 1. For each `parser/<lang>.so` found, the `lang` key is created and its `parser` field set to
///    the `.so`'s full path.
/// 2. For each `lang` in the result, the three `queries/<lang>/{highlights,injections,locals}.scm`
///    files are read (if present) and their full contents stored; missing files yield empty
///    strings.
fn search_parsers(lua: &Lua, dirs: Vec<String>) -> Result<Table> {
    let info = _search_parsers(&dirs)?;
    Ok(parser_info_to_table(lua, &info)?)
}

/// Read a `*.scm` query file to a string. A missing file is treated as an empty query (so a
/// language that ships only `highlights.scm`, for example, still works). Read failures surface as a
/// runtime error.
pub fn read_scm(path: &Path) -> Result<String> {
    if !path.exists() {
        return Err(Error::RuntimeError(format!("query file {path:?} does not exist")));
    }
    std::fs::read_to_string(path).map_err(|e| Error::RuntimeError(format!("failed to read query file {path:?}: {e}")))
}

/// Convert the `{ lang = ParserInfo }` registry into the Lua table
/// `{ lang = { parser, highlights, injections, locals } }`.
fn parser_info_to_table(lua: &Lua, info: &HashMap<String, ParserInfo>) -> Result<Table> {
    let out = lua.create_table_with_capacity(0, info.len())?;
    for (lang, p) in info {
        let entry = lua.create_table_with_capacity(0, 4)?;
        entry.set("parser", p.parser.clone())?;
        entry.set("highlights", p.highlights.clone())?;
        entry.set("injections", p.injections.clone())?;
        entry.set("locals", p.locals.clone())?;
        out.set(lang.clone(), entry)?;
    }
    Ok(out)
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

    // `parsers`: `{ lang = { parser, highlights, injections, locals } }`.
    let parsers_tbl: Table = args.get("parsers")?;
    let mut raw_parsers: HashMap<String, ParserInfo> = HashMap::new();
    for pair in parsers_tbl.pairs::<String, Value>() {
        let (lang, val) = pair?;
        if let Value::Table(pair_tbl) = val {
            let parser: String = pair_tbl.get("parser")?;
            let highlights: String = pair_tbl.get("highlights").unwrap_or_default();
            let injections: String = pair_tbl.get("injections").unwrap_or_default();
            let locals: String = pair_tbl.get("locals").unwrap_or_default();
            raw_parsers.insert(
                lang,
                ParserInfo {
                    parser,
                    highlights,
                    injections,
                    locals,
                },
            );
        } else {
            return Err(Error::RuntimeError(format!(
                "parsers['{lang}'] must be a table {{ parser, highlights, injections, locals }}"
            )));
        }
    }
    if raw_parsers.is_empty() {
        return Err(Error::RuntimeError(
            "`parsers` is empty; nothing to highlight with".to_string(),
        ));
    }

    // Dynamic-link each `parser/*.so` into a `tree_sitter::Language`, then build the core registry.
    let mut parsers: HashMap<String, CoreParserInfo> = HashMap::with_capacity(raw_parsers.len());
    for (lang, info) in &raw_parsers {
        let core = loader::load_language(info, lang)
            .map_err(|e: loader::Error| Error::RuntimeError(e.to_string()))?;
        parsers.insert(lang.clone(), core);
    }

    // `theme`: a `name -> {color, bold, ...}` JSON object (mirrors cli's theme JSON). An explicit,
    // non-empty Lua table takes priority; when it is omitted or empty, fall back to the `theme`
    // from tree-sitter's `config.json`.
    let theme: RenderTheme = match args.get::<Value>("theme") {
        Ok(Value::Table(t)) if !t.is_empty() => {
            let json: JsonValue = lua_table_to_json(t)?;
            parse_theme(&json)
        }
        _ => highlight_core::load_default_theme()
            .map_err(|e| Error::RuntimeError(e))?,
    };

    let format = {
        let raw: String = args
            .get::<String>("format")
            .unwrap_or_else(|_| "terminal".into());
        highlight_core::parse_format(&raw).map_err(Error::RuntimeError)?
    };
    let layout = {
        let raw: String = args
            .get::<String>("layout")
            .unwrap_or_else(|_| "document".into());
        highlight_core::parse_layout(&raw).map_err(Error::RuntimeError)?
    };
    let style = {
        let raw: String = args
            .get::<String>("style")
            .unwrap_or_else(|_| "classes".into());
        highlight_core::parse_style(&raw).map_err(Error::RuntimeError)?
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
        lua.create_function(|lua: &Lua, dirs: Vec<String>| search_parsers(lua, dirs))?,
    )?;
    Ok(exports)
}
