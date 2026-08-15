//! The language-aware highlight core: turning a registry of languages (each an *already loaded*
//! [`tree_sitter::Language`] plus its three query texts) into a set of
//! [`HighlightConfiguration`]s, and driving a highlight into a string.
//!
//! Unlike the legacy loader, this crate never touches the filesystem or `.so` files: callers (the
//! Lua binding via `tree-sitter-loader`, the Python binding via `tree-sitter` grammar capsules)
//! hand it an in-memory [`Language`]. The query texts are likewise supplied by the caller. This
//! keeps the binding-specific object-interop (Rust ↔ host language) out of the core.

use std::collections::{HashMap, HashSet};

use thiserror::Error;
use tree_sitter_highlight::{HighlightConfiguration, Renderer};
use tree_sitter_config::Config as TsConfig;

use crate::render::{Layout, OutputFormat, RenderTheme, StylingMode};

/// A single language: an already-loaded Tree-sitter [`Language`] together with the texts of its
/// three highlight query files.
///
/// `highlights`/`injections`/`locals` hold the full text of the corresponding `*.scm` files
/// (empty when a file is absent).
pub struct ParserInfo {
    pub language: tree_sitter::Language,
    pub highlights: String,
    pub injections: String,
    pub locals: String,
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("failed to build highlight configuration for '{0}': {1}")]
    Query(String, String),
}

/// Build a language-name → configuration registry from the `parsers` table.
///
/// `theme_names` is the list of highlight scope names from the theme; every configuration is
/// `configure`-d against it so the `Highlight` indices line up across all languages (host and any
/// injected). The `Language` values are already loaded by the caller, so this function performs no
/// I/O or dynamic linking of its own.
pub fn build_configs(
    parsers: &HashMap<String, ParserInfo>,
    theme_names: &[String],
) -> Result<HashMap<String, HighlightConfiguration>, Error> {
    let mut configs = HashMap::with_capacity(parsers.len());
    for (lang, info) in parsers {
        let mut config = HighlightConfiguration::new(
            info.language.clone(),
            lang,
            &info.highlights,
            &info.injections,
            &info.locals,
        )
        .map_err(|e| Error::Query(lang.clone(), e.to_string()))?;
        config.configure(theme_names);
        configs.insert(lang.clone(), config);
    }
    Ok(configs)
}

/// Resolve a list of highlight-scope names (e.g. `{"comment", "string"}`) into the numeric indices
/// used by [`tree_sitter_highlight::TexRenderer`]'s math-escape set, using a configuration's
/// `names()` as the index space.
pub fn resolve_math_escape(names: &[&str], scopes: &[String]) -> HashSet<usize> {
    scopes
        .iter()
        .enumerate()
        .filter_map(|(i, scope)| names.contains(&scope.as_str()).then_some(i))
        .collect()
}

/// Parse the `format`/`layout`/`style` string arguments into the internal enums.
pub fn parse_format(s: &str) -> Result<OutputFormat, String> {
    match s {
        "html" => Ok(OutputFormat::Html),
        "latex" => Ok(OutputFormat::Latex),
        "terminal" => Ok(OutputFormat::Terminal),
        other => Err(format!(
            "unknown format '{other}' (expected html|latex|terminal)"
        )),
    }
}

pub fn parse_layout(s: &str) -> Result<Layout, String> {
    match s {
        "document" => Ok(Layout::Document),
        "line-numbers" => Ok(Layout::LineNumbers),
        "fragment" => Ok(Layout::Fragment),
        other => Err(format!(
            "unknown layout '{other}' (expected document|line-numbers|fragment)"
        )),
    }
}

pub fn parse_style(s: &str) -> Result<StylingMode, String> {
    match s {
        "classes" => Ok(StylingMode::Classes),
        "inline" => Ok(StylingMode::Inline),
        "minimal" => Ok(StylingMode::Minimal),
        other => Err(format!(
            "unknown style '{other}' (expected classes|inline|minimal)"
        )),
    }
}

/// The core highlight driver. Shared by every host binding (Lua, Python).
///
/// `format`/`layout`/`style`/`prefix`/`math_escape` are taken as resolved enums/strings.
/// `math_escape` is ignored for `Terminal`/`Html`; `layout`/`style` are ignored for `Terminal`.
pub fn run_highlight(
    source: &[u8],
    language: &str,
    parsers: &HashMap<String, ParserInfo>,
    theme: &RenderTheme,
    format: OutputFormat,
    layout: Layout,
    style: StylingMode,
    prefix: &str,
    math_escape: &HashSet<usize>,
) -> Result<String, String> {
    let configs = build_configs(parsers, &theme.highlight_names).map_err(|e| e.to_string())?;
    let top = configs
        .get(language)
        .ok_or_else(|| format!("language '{language}' not found in `parsers`"))?;

    let mut highlighter = tree_sitter_highlight::Highlighter::new();
    // `configs` and `highlighter` share this scope; the injection callback borrows `configs`
    // and returns `&HighlightConfiguration`, which is valid for the lifetime of `events`.
    let events = highlighter
        .highlight(top, source, None, None, |name: &str| configs.get(name))
        .map_err(|e: tree_sitter_highlight::Error| e.to_string())?;

    match format {
        OutputFormat::Terminal => {
            let styles: Vec<anstyle::Style> = theme.styles.iter().map(|s| s.ansi).collect();
            let default = anstyle::Style::new();
            let mut renderer = tree_sitter_highlight::TerminalRenderer::new(&styles, default);
            crate::render::render_highlighted(&mut renderer, events, source, &[])
                .map_err(|e| e.to_string())?;
            Ok(String::from_utf8_lossy(renderer.content()).into_owned())
        }
        OutputFormat::Html => {
            let mut renderer = crate::render::HtmlRenderer::new();
            let attrs = crate::render::build_attribute_strings(theme, style, format, prefix);
            crate::render::render_highlighted(&mut renderer, events, source, &attrs)
                .map_err(|e| e.to_string())?;
            let body: Vec<String> = renderer.lines().map(|s| s.to_string()).collect();
            let mut out = Vec::new();
            crate::render::write_html(&mut out, theme, layout, style, &body);
            Ok(String::from_utf8_lossy(&out).into_owned())
        }
        OutputFormat::Latex => {
            let mut renderer =
                tree_sitter_highlight::TexRenderer::new(prefix.to_string(), math_escape.clone());
            let attrs = crate::render::build_attribute_strings(theme, style, format, prefix);
            crate::render::render_highlighted(&mut renderer, events, source, &attrs)
                .map_err(|e| e.to_string())?;
            let body = String::from_utf8_lossy(renderer.content()).into_owned();
            let mut out = Vec::new();
            // TODO: add a new option to output CSS and preamble.tex for tree-sitter-highlight
            if style == StylingMode::Minimal {
                crate::render::write_tex_preamble(&mut out, prefix, theme, StylingMode::Classes);
                Ok(String::from_utf8_lossy(&out).into_owned())
            } else {
                match layout {
                    Layout::Fragment => {}
                    Layout::LineNumbers => {
                        crate::render::write_tex_linenumbers(&mut out, prefix, theme, style, &body)
                    }
                    _ => crate::render::write_tex_document(&mut out, prefix, theme, style, &body),
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

/// Load the `theme` object from tree-sitter's `config.json` (the same file the CLI reads, resolved
/// via `tree_sitter_config::Config::load`, which uses `etcetera` to find `$XDG_CONFIG_HOME/
/// tree-sitter/config.json`, `%APPDATA%/tree-sitter/config.json`, `$HOME/.tree-sitter/
/// config.json`, etc.). Used as the fallback when the caller does not supply its own theme.
pub fn load_default_theme() -> Result<RenderTheme, String> {
    let config = TsConfig::load(None)
        .map_err(|e| format!("failed to load tree-sitter config: {e}"))?;
    match config.config.get("theme") {
        Some(theme_value) => Ok(crate::render::parse_theme(theme_value)),
        None => Ok(RenderTheme::default()),
    }
}
