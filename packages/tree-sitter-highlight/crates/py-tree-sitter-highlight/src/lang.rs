//! Converting Python `tree_sitter.Language` / grammar-package language capsules into a Rust
//! [`tree_sitter::Language`].
//!
//! A `tree-sitter` grammar package (e.g. `tree_sitter_bash`) exposes its language via a
//! zero-argument function `language()` that returns a `PyCapsule` named `"tree_sitter.Language"`
//! wrapping the raw `TSLanguage*` produced by the grammar's `tree_sitter_bash()` C function. The
//! Python `tree_sitter.Language` class is also constructible from such a capsule. This module
//! recovers that pointer.
//!
//! # Lifetime / safety
//!
//! On the CPython backend, `tree_sitter.Language` stores the pointer as its only field after the
//! standard `PyObject` header, so for a `Language` *instance* we read it at offset
//! `size_of::<ffi::PyObject>()`. For a bare `PyCapsule` we read its pointer directly.
//!
//! The grammar's `TSLanguage` is **static** memory (embedded in the grammar's compiled module), and
//! `ts_language_delete` is a no-op for native (non-WASM) grammars (it only adjusts a refcount for
//! WASM grammars). `Language`'s `Drop` calls `ts_language_delete`, so holding the static pointer in
//! a `Language` and letting it drop is safe — it frees nothing. We still route through
//! `ts_language_copy` (a no-op for native) so that the construction is correct for any grammar
//! variant without relying on the no-op behavior.

use pyo3::ffi::{self as py_ffi};
use pyo3::types::{PyCapsule, PyAnyMethods, PyCapsuleMethods};
use pyo3::{Bound, PyAny};
use tree_sitter::ffi as ts_ffi;

/// The capsule name `tree_sitter` uses to tag a language pointer.
const LANGUAGE_CAPSULE_NAME: &str = "tree_sitter.Language";

/// Extract a raw `TSLanguage*` from a Python object that represents a tree-sitter language.
///
/// Accepts:
/// * a `PyCapsule` whose name is `"tree_sitter.Language"` (the value returned by a grammar
///   package's `language()` function), or
/// * a `tree_sitter.Language` *instance* (which wraps such a capsule).
///
/// Returns the raw, non-null `TSLanguage*` on success.
fn language_ptr(obj: &Bound<'_, PyAny>) -> Result<*const ts_ffi::TSLanguage, String> {
    // Fast path: a bare PyCapsule.
    if let Ok(capsule) = obj.downcast::<PyCapsule>() {
        return capsule_ptr(capsule);
    }

    // A `tree_sitter.Language` instance: read the embedded pointer at the field offset.
    // The `Language` class stores the `TSLanguage*` as its sole field after the standard
    // `PyObject` header, so the offset is `size_of::<PyObject>()`.
    let header_size = std::mem::size_of::<py_ffi::PyObject>();
    let obj_ptr = obj.as_ptr() as *const u8;
    let field_ptr = unsafe { obj_ptr.add(header_size) as *const *const ts_ffi::TSLanguage };
    let raw = unsafe { *field_ptr };
    if raw.is_null() {
        return Err("tree_sitter.Language object holds a null pointer".to_string());
    }
    Ok(raw)
}

/// Read the pointer out of a `tree_sitter.Language` `PyCapsule` (name `"tree_sitter.Language"`).
fn capsule_ptr(capsule: &Bound<'_, PyCapsule>) -> Result<*const ts_ffi::TSLanguage, String> {
    let name = match capsule.name() {
        Ok(Some(c)) => c.to_str().unwrap_or_default(),
        _ => "",
    };
    if name != LANGUAGE_CAPSULE_NAME {
        return Err(format!(
            "expected a PyCapsule named '{LANGUAGE_CAPSULE_NAME}', got '{name}'"
        ));
    }
    let ptr = capsule.pointer() as *const ts_ffi::TSLanguage;
    if ptr.is_null() {
        return Err("language capsule holds a null pointer".to_string());
    }
    Ok(ptr)
}

/// Build an owned Rust [`tree_sitter::Language`] from a Python language object.
///
/// The grammar's `TSLanguage` is static, so we copy it (no-op for native grammars) before wrapping,
/// guaranteeing `Drop` never frees the grammar's memory regardless of which backend produced it.
pub fn extract_language(obj: &Bound<'_, PyAny>) -> Result<tree_sitter::Language, String> {
    let raw = language_ptr(obj)?;
    // `ts_language_copy` retains (WASM) or is a no-op (native) and returns the same pointer.
    let copied = unsafe { ts_ffi::ts_language_copy(raw) };
    // `Language` is a newtype around `*const TSLanguage`; its single field has identical layout.
    let language = unsafe { std::mem::transmute::<*const ts_ffi::TSLanguage, tree_sitter::Language>(copied) };
    Ok(language)
}
