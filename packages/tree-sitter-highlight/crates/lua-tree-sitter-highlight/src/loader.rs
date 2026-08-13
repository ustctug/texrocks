//! Building [`HighlightConfiguration`]s from the user-supplied `parsers` table.
//!
//! Each entry `{ lang = { "/path/of/lang.so", "/path/of/queries/lang" } }` is turned into a
//! [`HighlightConfiguration`] by loading the `.so` (symbol `tree_sitter_<lang>`) and reading the
//! three `*.scm` query files. Every configuration is `configure`-d with the *same* `theme_names`
//! so that the `Highlight` index space is identical across the host language and any injected
//! languages — this is what lets a single attribute table serve all layers (see `render.rs`).

use std::collections::{HashMap, HashSet};
use std::path::Path;

use thiserror::Error;
use tree_sitter_highlight::HighlightConfiguration;
use tree_sitter_loader::Loader;

/// A single language's parser and its query contents, as discovered by `search_parsers` or
/// supplied directly by a Lua caller's `parsers` table.
///
/// `parser` is the full path to the compiled `parser/<lang>.so`. `highlights`/`injections`/
/// `locals` hold the full text of the corresponding `queries/<lang>/*.scm` files (empty when the
/// file is absent).
pub struct ParserInfo {
    pub parser: String,
    pub highlights: String,
    pub injections: String,
    pub locals: String,
}

#[derive(Debug, Error)]
pub enum Error {
    #[error("failed to load parser for language '{0}': {1}")]
    LoadLanguage(String, String),
    #[error("failed to build highlight configuration for '{0}': {1}")]
    Query(String, String),
}

/// Build a language-name → configuration registry from the `parsers` table.
///
/// `theme_names` is the list of highlight scope names from the theme; every configuration is
/// `configure`-d against it so the `Highlight` indices line up across all languages. The query
/// files have already been read by the caller (see [`ParserInfo`]), so this function performs no
/// I/O of its own.
pub fn build_configs(
    parsers: &HashMap<String, ParserInfo>,
    theme_names: &[String],
) -> Result<HashMap<String, HighlightConfiguration>, Error> {
    let mut configs = HashMap::with_capacity(parsers.len());
    for (lang, info) in parsers {
        let so = Path::new(&info.parser);
        let language = Loader::load_language(so, &format!("tree_sitter_{lang}"))
            .map_err(|e| Error::LoadLanguage(lang.clone(), e.to_string()))?;
        let mut config = HighlightConfiguration::new(
            language,
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
