//! Building [`HighlightConfiguration`]s from the user-supplied `parsers` table.
//!
//! Each entry `{ lang = { "/path/of/lang.so", "/path/of/queries/lang" } }` is turned into a
//! [`HighlightConfiguration`] by loading the `.so` (symbol `tree_sitter_<lang>`) and reading the
//! three `*.scm` query files. Every configuration is `configure`-d with the *same* `theme_names`
//! so that the `Highlight` index space is identical across the host language and any injected
//! languages — this is what lets a single attribute table serve all layers (see `render.rs`).

use std::collections::{HashMap, HashSet};
use std::path::{Path, PathBuf};

use thiserror::Error;
use tree_sitter_highlight::HighlightConfiguration;
use tree_sitter_loader::Loader;

#[derive(Debug, Error)]
pub enum Error {
    #[error("failed to load parser for language '{0}': {1}")]
    LoadLanguage(String, String),
    #[error("failed to read query file {0}: {1}")]
    ReadQuery(PathBuf, String),
    #[error("failed to build highlight configuration for '{0}': {1}")]
    Query(String, String),
}

/// Read a query file relative to `queries_dir`. A missing file is treated as an empty query (so a
/// language that ships only `highlights.scm`, for example, still works).
fn read_query(queries_dir: &Path, file_name: &str) -> Result<String, Error> {
    let path = queries_dir.join(file_name);
    if !path.exists() {
        return Ok(String::new());
    }
    std::fs::read_to_string(&path).map_err(|e| Error::ReadQuery(path, e.to_string()))
}

/// Build a language-name → configuration registry from the `parsers` table.
///
/// `theme_names` is the list of highlight scope names from the theme; every configuration is
/// `configure`-d against it so the `Highlight` indices line up across all languages.
pub fn build_configs(
    parsers: &HashMap<String, (PathBuf, PathBuf)>,
    theme_names: &[String],
) -> Result<HashMap<String, HighlightConfiguration>, Error> {
    let mut configs = HashMap::with_capacity(parsers.len());
    for (lang, (so, queries_dir)) in parsers {
        let language = Loader::load_language(so, &format!("tree_sitter_{lang}"))
            .map_err(|e| Error::LoadLanguage(lang.clone(), e.to_string()))?;
        let highlights = read_query(queries_dir, "highlights.scm")?;
        let injections = read_query(queries_dir, "injections.scm")?;
        let locals = read_query(queries_dir, "locals.scm")?;
        let mut config = HighlightConfiguration::new(language, lang, &highlights, &injections, &locals)
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
