//! Building languages from `parser/<lang>.so` files for the Lua binding.
//!
//! Each entry `{ lang = "/path/of/lang.so" }` (discovered by `search_parsers`) is turned into a
//! [`highlight_core::ParserInfo`] by loading the `.so` (symbol `tree_sitter_<lang>`). The query
//! texts are read by `search_parsers` from `queries/<lang>/{highlights,injections,locals}.scm`.
//!
//! The actual [`HighlightConfiguration`] construction lives in `highlight_core::build_configs`
//! (it only needs an already-loaded [`tree_sitter::Language`]); this module is responsible for
//! the Lua-specific step of obtaining that `Language` from a `.so` file.

use std::collections::HashMap;
use std::path::{Path, PathBuf};

use mlua::Error as LuaError;
use thiserror::Error;
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
}

/// Convert a path-based [`ParserInfo`] (`.so` path + query texts) into a [`highlight_core`]
/// [`CoreParserInfo`](highlight_core::CoreParserInfo) by dynamic-linking the `.so` and extracting
/// its `tree_sitter_<lang>` symbol into a [`tree_sitter::Language`].
pub fn load_language(
    info: &ParserInfo,
    lang: &str,
) -> Result<highlight_core::CoreParserInfo, Error> {
    let language = Loader::load_language(Path::new(&info.parser), &format!("tree_sitter_{lang}"))
        .map_err(|e| Error::LoadLanguage(lang.to_string(), e.to_string()))?;
    Ok(highlight_core::CoreParserInfo {
        language,
        highlights: info.highlights.clone(),
        injections: info.injections.clone(),
        locals: info.locals.clone(),
    })
}

/// Scan each directory for `parser/<lang>.so` and `queries/<lang>/`, returning a
/// `{ lang = { parser, highlights, injections, locals } }` registry.
///
/// Two passes are made over the supplied directories:
///
/// 1. For each `parser/<lang>.so` found, the `lang` key is created and its `parser` field set to
///    the `.so`'s full path.
/// 2. For each `lang` in the result, the three `queries/<lang>/{highlights,injections,locals}.scm`
///    files are read (if present) and their full contents stored; missing files yield empty
///    strings.
pub fn search_parsers(dirs: &[String]) -> Result<HashMap<String, ParserInfo>, LuaError> {
    let mut info: HashMap<String, ParserInfo> = HashMap::new();

    // Pass 1: discover parser .so files and register their full paths.
    for dir in dirs {
        let parser_dir = PathBuf::from(dir).join("parser");
        if !parser_dir.is_dir() {
            continue;
        }
        let entries = match std::fs::read_dir(&parser_dir) {
            Ok(e) => e,
            Err(_) => continue,
        };
        for entry in entries.flatten() {
            let name = entry.file_name().to_string_lossy().into_owned();
            if let Some(lang) = name.strip_suffix(".so") {
                info.insert(
                    lang.to_string(),
                    ParserInfo {
                        parser: entry.path().to_string_lossy().into_owned(),
                        highlights: String::new(),
                        injections: String::new(),
                        locals: String::new(),
                    },
                );
            }
        }
    }

    // Pass 2: read the matching query files for each discovered language.
    for dir in dirs {
        let queries_root = PathBuf::from(dir).join("queries");
        for (lang, entry) in info.iter_mut() {
            let lang_queries = queries_root.join(lang);
            if let Ok(scm) = read_scm(&lang_queries.join("highlights.scm")) {
                entry.highlights = scm
            }
            if let Ok(scm) = read_scm(&lang_queries.join("injections.scm")) {
                entry.injections = scm
            }
            if let Ok(scm) = read_scm(&lang_queries.join("locals.scm")) {
                entry.locals = scm
            }
        }
    }

    Ok(info)
}

/// Read a `*.scm` query file to a string. A missing file is treated as an empty query (so a
/// language that ships only `highlights.scm`, for example, still works). Read failures surface as a
/// runtime error.
pub fn read_scm(path: &Path) -> Result<String, LuaError> {
    if !path.exists() {
        return Err(LuaError::RuntimeError(format!("query file {path:?} does not exist")));
    }
    std::fs::read_to_string(path)
        .map_err(|e| LuaError::RuntimeError(format!("failed to read query file {path:?}: {e}")))
}
