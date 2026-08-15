//! Python bindings for `tree-sitter-highlight`.
//!
//! Exposes two functions on the `tree_sitter_highlight` module:
//!
//! * `search_parsers(*modules, **named_modules)` — each argument is an imported `tree_sitter_*`
//!   grammar package (e.g. the `tree_sitter_bash` module object). For positional arguments the
//!   language name is derived by stripping the `tree_sitter_` prefix from the module's `__name__`;
//!   for keyword arguments the key is the language name. Returns a dict
//!   `{ lang: { "language": <capsule>, "highlights": str, "injections": str, "locals": str } }`
//!   where `language` is the grammar's `language()` capsule and the query strings are read from the
//!   package's `queries/` directory (falling back to the `HIGHLIGHTS_QUERY` / `INJECTIONS_QUERY` /
//!   `LOCALS_QUERY` module attributes).
//! * `highlight(*, source=None, file=None, language, parsers, theme=None, format="terminal",
//!   layout="document", style="classes", prefix="TS", math_escape=None)` — performs syntax
//!   highlighting and returns the rendered document as a string. `parsers` uses the same shape as
//!   `search_parsers`'s return value: `{ lang: { "language": <capsule>, "highlights": str, ... } }`.

use std::collections::{HashMap, HashSet};
use std::path::PathBuf;

use pyo3::exceptions::PyValueError;
use pyo3::prelude::*;
use pyo3::types::{PyDict, PyDictMethods, PyTuple};

use highlight_core::render::{RenderTheme, parse_theme};
use highlight_core::{CoreParserInfo, resolve_math_escape, run_highlight};

mod lang;
mod theme;

/// Read a query file from a grammar package's `queries/` directory, if present.
///
/// Missing files yield an empty string so a language that ships only `highlights.scm`, for
/// example, still works.
fn read_query_file(module_dir: &std::path::Path, name: &str) -> String {
    let path = module_dir.join("queries").join(name);
    std::fs::read_to_string(&path).unwrap_or_default()
}

/// Derive the language name from a grammar module's `__name__` by stripping the `tree_sitter_`
/// prefix.
fn lang_name_from_module(module: &Bound<'_, PyAny>) -> PyResult<String> {
    let name: String = module
        .getattr("__name__")
        .map_err(|_| PyValueError::new_err("grammar module has no __name__"))?
        .extract()?;
    Ok(name
        .strip_prefix("tree_sitter_")
        .unwrap_or(&name)
        .to_string())
}

/// Extract the `language()` capsule from a grammar module, calling it if it is callable (the common
/// case for modern grammar packages) or using it directly if it is already a capsule.
fn module_language<'py>(module: &Bound<'py, PyAny>) -> PyResult<Bound<'py, PyAny>> {
    let attr = module
        .getattr("language")
        .map_err(|_| PyValueError::new_err("grammar module has no `language` attribute"))?;
    if attr.is_callable() {
        attr.call0()
    } else {
        Ok(attr)
    }
}

/// Resolve the three query strings for a grammar module: prefer the on-disk `queries/*.scm` files,
/// then fall back to the lazy module attributes (`HIGHLIGHTS_QUERY`, `INJECTIONS_QUERY`,
/// `LOCALS_QUERY`).
fn module_queries(
    module: &Bound<'_, PyAny>,
    module_dir: &std::path::Path,
) -> (String, String, String) {
    let highlights = read_query_file(module_dir, "highlights.scm");
    let injections = read_query_file(module_dir, "injections.scm");
    let locals = read_query_file(module_dir, "locals.scm");

    // Fall back to module attributes when the on-disk file is absent.
    let get_attr = |module: &Bound<'_, PyAny>, attr: &str| -> String {
        module
            .getattr(attr)
            .ok()
            .and_then(|v| v.extract::<String>().ok())
            .unwrap_or_default()
    };
    let highlights = if highlights.is_empty() {
        get_attr(module, "HIGHLIGHTS_QUERY")
    } else {
        highlights
    };
    let injections = if injections.is_empty() {
        get_attr(module, "INJECTIONS_QUERY")
    } else {
        injections
    };
    let locals = if locals.is_empty() {
        get_attr(module, "LOCALS_QUERY")
    } else {
        locals
    };
    (highlights, injections, locals)
}

/// `search_parsers(*modules, **named_modules)` — see module docs.
#[pyfunction]
#[pyo3(signature = (*modules, **named_modules))]
fn search_parsers(
    py: Python<'_>,
    modules: &Bound<'_, PyTuple>,
    named_modules: Option<&Bound<'_, PyDict>>,
) -> PyResult<Py<PyDict>> {
    let result = PyDict::new(py);

    // Positional arguments: name derived from `__name__` (minus `tree_sitter_`).
    for module in modules.iter() {
        let lang = lang_name_from_module(&module)?;
        let module_dir = module_dir_of(&module)?;
        let (highlights, injections, locals) = module_queries(&module, &module_dir);
        let language = module_language(&module)?;
        result.set_item(&lang, build_entry(py, &language, &highlights, &injections, &locals)?)?;
    }

    // Keyword arguments: key is the language name.
    if let Some(kwargs) = named_modules {
        for (key, module) in kwargs.iter() {
            let lang: String = key.extract()?;
            let module_dir = module_dir_of(&module)?;
            let (highlights, injections, locals) = module_queries(&module, &module_dir);
            let language = module_language(&module)?;
            result
                .set_item(&lang, build_entry(py, &language, &highlights, &injections, &locals)?)?;
        }
    }

    Ok(result.into())
}

/// Build the `{ "language", "highlights", "injections", "locals" }` entry dict for one language.
fn build_entry(
    py: Python<'_>,
    language: &Bound<'_, PyAny>,
    highlights: &str,
    injections: &str,
    locals: &str,
) -> PyResult<Py<PyDict>> {
    let entry = PyDict::new(py);
    entry.set_item("language", language)?;
    entry.set_item("highlights", highlights)?;
    entry.set_item("injections", injections)?;
    entry.set_item("locals", locals)?;
    Ok(entry.into())
}

/// Locate the package directory of a grammar module (the directory holding its `__init__.py` or the
/// directory of a single-file module).
fn module_dir_of(module: &Bound<'_, PyAny>) -> PyResult<PathBuf> {
    // Prefer `__file__` (points at `__init__.py` or `module.py`); the directory is then the parent.
    if let Ok(file) = module.getattr("__file__") {
        if let Ok(path) = file.extract::<PathBuf>() {
            if let Some(parent) = path.parent() {
                return Ok(parent.to_path_buf());
            }
        }
    }
    // Fall back to `__path__` (namespace packages expose a list of path strings).
    if let Ok(path) = module.getattr("__path__") {
        if let Ok(list) = path.extract::<Vec<PathBuf>>() {
            if let Some(first) = list.into_iter().next() {
                return Ok(first);
            }
        }
    }
    Err(PyValueError::new_err(
        "cannot determine grammar module directory (no __file__ or __path__)",
    ))
}

/// `highlight(...)` — see module docs.
#[pyfunction]
#[pyo3(signature = (*, source=None, file=None, language, parsers, theme=None, format="terminal", layout="document", style="classes", prefix="TS", math_escape=None))]
#[allow(clippy::too_many_arguments)]
fn highlight(
    py: Python<'_>,
    source: Option<String>,
    file: Option<String>,
    language: String,
    parsers: &Bound<'_, PyDict>,
    theme: Option<&Bound<'_, PyAny>>,
    format: &str,
    layout: &str,
    style: &str,
    prefix: &str,
    math_escape: Option<&Bound<'_, PyAny>>,
) -> PyResult<String> {
    // `source` is the literal text; when omitted, `file` is read (`"-"` means stdin).
    let source = if let Some(s) = source {
        s
    } else {
        let file = file.ok_or_else(|| {
            PyValueError::new_err("`source` or `file` is required for highlight")
        })?;
        if file == "-" {
            use std::io::Read as _;
            let mut buf = String::new();
            std::io::stdin()
                .read_to_string(&mut buf)
                .map_err(|e| PyValueError::new_err(format!("failed to read stdin: {e}")))?;
            buf
        } else {
            std::fs::read_to_string(&file)
                .map_err(|e| PyValueError::new_err(format!("failed to read file '{file}': {e}")))?
        }
    };

    // Build the core language registry from the `parsers` dict.
    let mut core_parsers: HashMap<String, CoreParserInfo> = HashMap::new();
    for (lang_key, entry) in parsers.iter() {
        let lang: String = lang_key.extract()?;
        let entry = match entry.downcast::<PyDict>() {
            Ok(e) => e,
            Err(_) => {
                return Err(PyValueError::new_err(format!(
                    "parsers['{lang}'] must be a dict {{ 'language', 'highlights', 'injections', 'locals' }}"
                )))
            }
        };
        let language_obj = match entry.get_item("language")? {
            Some(v) => v,
            None => {
                return Err(PyValueError::new_err(format!(
                    "parsers['{lang}'] missing 'language'"
                )))
            }
        };
        let ts_language = lang::extract_language(&language_obj).map_err(PyValueError::new_err)?;
        let get = |k: &str| -> String {
            entry
                .get_item(k)
                .ok()
                .flatten()
                .and_then(|v| v.extract::<String>().ok())
                .unwrap_or_default()
        };
        core_parsers.insert(
            lang,
            CoreParserInfo {
                language: ts_language,
                highlights: get("highlights"),
                injections: get("injections"),
                locals: get("locals"),
            },
        );
    }
    if core_parsers.is_empty() {
        return Err(PyValueError::new_err(
            "`parsers` is empty; nothing to highlight with",
        ));
    }

    let theme: RenderTheme = match theme {
        Some(t) if !t.is_none() => parse_theme(&theme::py_to_json(t)),
        _ => highlight_core::load_default_theme()
            .map_err(PyValueError::new_err)?,
    };

    let format = highlight_core::parse_format(format).map_err(PyValueError::new_err)?;
    let layout = highlight_core::parse_layout(layout).map_err(PyValueError::new_err)?;
    let style = highlight_core::parse_style(style).map_err(PyValueError::new_err)?;
    let prefix = prefix.to_string();

    let math_escape: HashSet<usize> = {
        let names: Vec<String> = match math_escape {
            Some(list) if !list.is_none() => list.extract().unwrap_or_default(),
            _ => Vec::new(),
        };
        let names_refs: Vec<&str> = names.iter().map(String::as_str).collect();
        let scopes = theme.highlight_names.clone();
        resolve_math_escape(&names_refs, &scopes)
    };

    let out = run_highlight(
        source.as_bytes(),
        &language,
        &core_parsers,
        &theme,
        format,
        layout,
        style,
        &prefix,
        &math_escape,
    )
    .map_err(PyValueError::new_err)?;
    let _ = py;
    Ok(out)
}

/// The `tree_sitter_highlight` Python module.
#[pymodule]
fn tree_sitter_highlight(m: &Bound<'_, PyModule>) -> PyResult<()> {
    m.add_function(wrap_pyfunction!(search_parsers, m)?)?;
    m.add_function(wrap_pyfunction!(highlight, m)?)?;
    Ok(())
}
