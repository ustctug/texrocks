//! Converting a Python `theme` object into a `serde_json::Value` that
//! [`highlight_core::render::parse_theme`] understands (`name -> {color, bold, ...}`).

use pyo3::types::{PyAnyMethods, PyDictMethods};
use pyo3::{Bound, PyAny};

/// Recursively convert a Python object (dict / list / scalar) into a `serde_json::Value`.
///
/// Strings, bytes, ints, floats and bools map to their obvious JSON counterparts; `None` and
/// omitted values become `JsonValue::Null`. Dicts become objects, lists/tuples become arrays.
pub fn py_to_json(obj: &Bound<'_, PyAny>) -> serde_json::Value {
    if obj.is_none() {
        return serde_json::Value::Null;
    }
    // bool must be checked before int (in Python, bool is an int subclass).
    if let Ok(b) = obj.extract::<bool>() {
        return serde_json::Value::Bool(b);
    }
    if let Ok(i) = obj.extract::<i64>() {
        return serde_json::Value::from(i);
    }
    if let Ok(f) = obj.extract::<f64>() {
        return serde_json::Value::from(f);
    }
    if let Ok(s) = obj.extract::<String>() {
        return serde_json::Value::String(s);
    }
    if let Ok(items) = obj.extract::<Vec<Bound<'_, PyAny>>>() {
        return serde_json::Value::Array(items.iter().map(py_to_json).collect());
    }
    if let Ok(dict) = obj.downcast::<pyo3::types::PyDict>() {
        let mut map = serde_json::Map::new();
        for (k, v) in dict.iter() {
            let key = match k.extract::<String>() {
                Ok(s) => s,
                Err(_) => continue,
            };
            map.insert(key, py_to_json(&v));
        }
        return serde_json::Value::Object(map);
    }
    serde_json::Value::Null
}
