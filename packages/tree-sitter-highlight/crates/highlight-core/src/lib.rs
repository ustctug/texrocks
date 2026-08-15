//! Language-aware syntax-highlighting core shared by the Lua and Python bindings.
//!
//! This crate owns the rendering helpers ([`render`]) and the driver ([`core`]) that turn an
//! in-memory language registry into highlighted output. It deliberately performs **no** filesystem
//! access and **no** dynamic linking of `.so` parser files: the host bindings are responsible for
//! obtaining a [`tree_sitter::Language`] (the Lua binding via `tree-sitter-loader`, the Python
//! binding via `tree-sitter` grammar `PyCapsule`s) and the query texts, then hand them here.

pub mod core;
pub mod render;

pub use core::{
    Error as CoreError, ParserInfo as CoreParserInfo, build_configs, load_default_theme,
    parse_format, parse_layout, parse_style, resolve_math_escape, run_highlight,
};
pub use tree_sitter_highlight::{
    Error as HighlightError, Highlighter, HighlightConfiguration, Renderer, TerminalRenderer,
    TexRenderer, HtmlRenderer,
};
