//! Rendering helpers copied (and lightly adapted) from `tree-sitter/crates/cli/src/highlight.rs`.
//!
//! These functions are intentionally duplicated rather than imported from the `cli` crate so that
//! this binding crate does not depend on `cli`. They operate on this crate's own [`RenderTheme`]
//! type instead of `cli`'s `Theme`/`Style`.

use std::io::Write as IoWrite;

use ansi_colours::{ansi256_from_rgb, rgb_from_ansi256};
use anstyle::{Ansi256Color, AnsiColor, Color, Effects, RgbColor};
use serde_json::Value;
use tree_sitter_highlight::{Highlight, Renderer, TEX_CHAR_ESCAPES};

pub const HTML_HEAD_HEADER: &str = "
<!doctype HTML>
<head>
  <title>Tree-sitter Highlighting</title>
  <style>
    body {
      font-family: monospace
    }";

pub const HTML_LINE_NUMBER_STYLE: &str = "    .line-number {
      user-select: none;
      text-align: right;
      color: rgba(27,31,35,.3);
      padding: 0 10px;
    }
    .line {
      white-space: pre;
    }";

pub const HTML_BODY_HEADER: &str = "
</head>
<body>
";

pub const HTML_FOOTER: &str = "
</body>
";

/// A single highlight scope's resolved style, mirroring `cli`'s `Style`.
#[derive(Debug, Default, Clone)]
pub struct RenderStyle {
    pub ansi: anstyle::Style,
    pub css: Option<String>,
}

/// A highlight theme: a parallel list of scope names and styles that is `configure`-d into the
/// renderer. Mirrors `cli`'s `Theme`.
#[derive(Debug, Default, Clone)]
pub struct RenderTheme {
    pub styles: Vec<RenderStyle>,
    pub highlight_names: Vec<String>,
}

/// How token colors are applied in HTML output. Mirrors `cli`'s `HtmlStyling`.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum StylingMode {
    /// `class="..."` spans plus a generated `<style>` carrying the theme's colors.
    Classes,
    /// `style="..."` spans with the colors inlined.
    Inline,
    /// `class="..."` spans with no colors emitted (supply your own stylesheet).
    Minimal,
}

/// The output format for highlighting.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum OutputFormat {
    Terminal,
    Html,
    Latex,
}

/// The kind of HTML/LaTeX structure emitted around the code markup.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Layout {
    /// A complete, self-contained document.
    Document,
    /// A complete document with a line-number column.
    LineNumbers,
    /// Only the code markup, without the surrounding document.
    Fragment,
}

fn terminal_supports_truecolor() -> bool {
    std::env::var("COLORTERM")
        .is_ok_and(|truecolor| truecolor == "truecolor" || truecolor == "24bit")
}

fn parse_style(style: &mut RenderStyle, json: &Value) {
    if let Value::Object(entries) = json {
        for (property_name, value) in entries {
            match property_name.as_str() {
                "bold" if *value == Value::Bool(true) => {
                    style.ansi = style.ansi.bold();
                }
                "italic" if *value == Value::Bool(true) => {
                    style.ansi = style.ansi.italic();
                }
                "underline" if *value == Value::Bool(true) => {
                    style.ansi = style.ansi.underline();
                }
                "color" => {
                    if let Some(color) = parse_color(value) {
                        style.ansi = style.ansi.fg_color(Some(color));
                    }
                }
                _ => {}
            }
        }
        style.css = Some(style_to_css(style.ansi));
    } else if let Some(color) = parse_color(json) {
        style.ansi = style.ansi.fg_color(Some(color));
        style.css = Some(style_to_css(style.ansi));
    } else {
        style.css = None;
    }

    if let Some(Color::Rgb(RgbColor(red, green, blue))) = style.ansi.get_fg_color()
        && !terminal_supports_truecolor()
    {
        let ansi256 = Color::Ansi256(Ansi256Color(ansi256_from_rgb((red, green, blue))));
        style.ansi = style.ansi.fg_color(Some(ansi256));
    }
}

fn parse_color(json: &Value) -> Option<Color> {
    match json {
        Value::Number(n) => n.as_u64().map(|n| Color::Ansi256(Ansi256Color(n as u8))),
        Value::String(s) => match s.to_lowercase().as_str() {
            "black" => Some(Color::Ansi(AnsiColor::Black)),
            "blue" => Some(Color::Ansi(AnsiColor::Blue)),
            "cyan" => Some(Color::Ansi(AnsiColor::Cyan)),
            "green" => Some(Color::Ansi(AnsiColor::Green)),
            "purple" => Some(Color::Ansi(AnsiColor::Magenta)),
            "red" => Some(Color::Ansi(AnsiColor::Red)),
            "white" => Some(Color::Ansi(AnsiColor::White)),
            "yellow" => Some(Color::Ansi(AnsiColor::Yellow)),
            s => {
                if let Some((red, green, blue)) = hex_string_to_rgb(s) {
                    Some(Color::Rgb(RgbColor(red, green, blue)))
                } else {
                    None
                }
            }
        },
        _ => None,
    }
}

fn hex_string_to_rgb(s: &str) -> Option<(u8, u8, u8)> {
    if s.starts_with('#') && s.len() >= 7 {
        if let (Ok(red), Ok(green), Ok(blue)) = (
            u8::from_str_radix(&s[1..3], 16),
            u8::from_str_radix(&s[3..5], 16),
            u8::from_str_radix(&s[5..7], 16),
        ) {
            Some((red, green, blue))
        } else {
            None
        }
    } else {
        None
    }
}

fn style_to_css(style: anstyle::Style) -> String {
    use std::fmt::Write as _;
    let mut result = String::new();
    let effects = style.get_effects();
    if effects.contains(Effects::UNDERLINE) {
        write!(&mut result, "text-decoration: underline;").unwrap();
    }
    if effects.contains(Effects::BOLD) {
        write!(&mut result, "font-weight: bold;").unwrap();
    }
    if effects.contains(Effects::ITALIC) {
        write!(&mut result, "font-style: italic;").unwrap();
    }
    if let Some(color) = style.get_fg_color() {
        write_color(&mut result, color);
    }
    result
}

fn write_color(buffer: &mut String, color: Color) {
    use std::fmt::Write as _;
    match color {
        Color::Ansi(color) => match color {
            AnsiColor::Black => write!(buffer, "color: black").unwrap(),
            AnsiColor::Red => write!(buffer, "color: red").unwrap(),
            AnsiColor::Green => write!(buffer, "color: green").unwrap(),
            AnsiColor::Yellow => write!(buffer, "color: yellow").unwrap(),
            AnsiColor::Blue => write!(buffer, "color: blue").unwrap(),
            AnsiColor::Magenta => write!(buffer, "color: purple").unwrap(),
            AnsiColor::Cyan => write!(buffer, "color: cyan").unwrap(),
            AnsiColor::White => write!(buffer, "color: white").unwrap(),
            _ => unreachable!(),
        },
        Color::Ansi256(Ansi256Color(n)) => {
            let (r, g, b) = rgb_from_ansi256(n);
            write!(buffer, "color: #{r:02x}{g:02x}{b:02x}").unwrap();
        }
        Color::Rgb(RgbColor(r, g, b)) => write!(buffer, "color: #{r:02x}{g:02x}{b:02x}").unwrap(),
    }
}

/// Resolve the foreground RGB (0–255) of an `anstyle::Style`, or `None` if there is no color.
fn style_rgb(style: anstyle::Style) -> Option<(u8, u8, u8)> {
    match style.get_fg_color()? {
        Color::Rgb(RgbColor(r, g, b)) => Some((r, g, b)),
        Color::Ansi256(Ansi256Color(n)) => {
            let (r, g, b) = rgb_from_ansi256(n);
            Some((r, g, b))
        }
        Color::Ansi(color) => Some(match color {
            AnsiColor::Black => (0, 0, 0),
            AnsiColor::Red => (187, 0, 0),
            AnsiColor::Green => (0, 187, 0),
            AnsiColor::Yellow => (187, 187, 0),
            AnsiColor::Blue => (0, 0, 187),
            AnsiColor::Magenta => (187, 0, 187),
            AnsiColor::Cyan => (0, 187, 187),
            AnsiColor::White => (187, 187, 187),
            _ => (0, 0, 0),
        }),
    }
}

/// Resolve whether an `anstyle::Style` requests italic, bold, and/or underline.
/// Returns `(italic, bold, underline)`.
fn style_flags(style: anstyle::Style) -> (bool, bool, bool) {
    let effects = style.get_effects();
    (
        effects.contains(Effects::ITALIC),
        effects.contains(Effects::BOLD),
        effects.contains(Effects::UNDERLINE),
    )
}

/// Build the per-scope *opening attribute* byte strings for the renderer's shared event loop.
///
/// Mirrors the closures in `cli`'s `highlight()` (HTML at `cli/highlight.rs:624-645`, LaTeX at
/// `cli/highlight.rs:677-702`). The returned vector is indexed by [`Highlight`], so its length
/// equals `theme.highlight_names.len()` — the same dimension [`Highlight`](tree_sitter_highlight::Highlight)
/// indices resolve against after `HighlightConfiguration::configure`.
pub fn build_attribute_strings(
    theme: &RenderTheme,
    styling: StylingMode,
    format: OutputFormat,
    prefix: &str,
) -> Vec<Vec<u8>> {
    let mut out = Vec::with_capacity(theme.highlight_names.len());
    for (i, name) in theme.highlight_names.iter().enumerate() {
        let mut bytes = Vec::new();
        match format {
            OutputFormat::Html => {
                // HTML: `<span class='...'>` (Classes/Minimal) or `<span style='...'>` (Inline).
                if styling == StylingMode::Inline {
                    bytes.extend(b"style='");
                    let css = theme
                        .styles
                        .get(i)
                        .and_then(|s| s.css.as_deref())
                        .unwrap_or("");
                    bytes.extend(css.as_bytes());
                } else {
                    bytes.extend(b"class='");
                    let mut parts = name.split('.').peekable();
                    while let Some(part) = parts.next() {
                        bytes.extend(part.as_bytes());
                        if parts.peek().is_some() {
                            bytes.extend(b" ");
                        }
                    }
                }
                bytes.extend(b"'");
            }
            OutputFormat::Latex => {
                // LaTeX: the callback writes the entire opening markup, e.g. `\TS{scope}{` or
                // `\textcolor[rgb]{r,g,b}{`. The renderer owns the closing brace.
                let style = theme.styles.get(i).map(|s| s.ansi).unwrap_or_default();
                match styling {
                    StylingMode::Inline => {
                        // Open a single group; within it emit font switches
                        // (`\bf`/`\it`) and a color command (no extra group of
                        // its own). The renderer closes the group with a single
                        // `}`, keeping the brace balance automatic.
                        bytes.push(b'{');
                        let (italic, bold, _underline) = style_flags(style);
                        if bold {
                            bytes.extend(b"\\bf");
                        }
                        if italic {
                            bytes.extend(b"\\it");
                        }
                        if let Some((r, g, b)) = style_rgb(style) {
                            let (r, g, b) = (r as f64 / 255.0, g as f64 / 255.0, b as f64 / 255.0);
                            write!(bytes, "\\color[rgb]{{{r:.4},{g:.4},{b:.4}}}").unwrap();
                        }
                    }
                    StylingMode::Classes | StylingMode::Minimal => {
                        push_ts_scope(&mut bytes, prefix, name);
                    }
                }
            }
            OutputFormat::Terminal => {
                // Terminal renderer drives its own loop and ignores the callback, so the table is
                // empty entries. (Never actually consulted for Terminal output.)
            }
        }
        out.push(bytes);
    }
    out
}

/// Push the LaTeX `\prefix{scope}{` opening markup for a scope name.
fn push_ts_scope(bytes: &mut Vec<u8>, prefix: &str, name: &str) {
    bytes.push(b'\\');
    bytes.extend(prefix.as_bytes());
    bytes.extend(b"{");
    bytes.extend(name.as_bytes());
    bytes.extend(b"}{");
}

/// Emit the shared LaTeX preamble/definitions used by `Document` and `LineNumbers` layouts.
pub fn write_tex_preamble<W: IoWrite>(
    w: &mut W,
    prefix: &str,
    theme: &RenderTheme,
    style: StylingMode,
) {
    let _ = w.write_all(b"\\makeatletter\n");
    for (ch, suffix) in TEX_CHAR_ESCAPES {
        let _ = w.write_all(
            format!(
                "\\def\\{prefix}{suffix}{{\\char`\\{ch}}}\n",
                prefix = prefix,
                suffix = suffix,
                ch = ch
            )
            .as_bytes(),
        );
    }
    let _ = w.write_all(
        format!(
            "\\def\\{prefix}@reset{{\\let\\{prefix}@it=\\relax\\let\\{prefix}@bf=\\relax\\let\\{prefix}@ul=\\relax \\let\\{prefix}@tc=\\relax\\let\\{prefix}@bc=\\relax\\let\\{prefix}@ff=\\relax}}\n",
            prefix = prefix
        )
        .as_bytes(),
    );
    let _ = w.write_all(
        format!(
            "\\def\\{prefix}@tok#1{{\\csname {prefix}@tok@#1\\endcsname}}\n",
            prefix = prefix
        )
        .as_bytes(),
    );
    let _ = w.write_all(
        format!(
            "\\def\\{prefix}@toks#1+{{\\ifx\\relax#1\\empty\\else\\{prefix}@tok{{#1}}\\expandafter\\{prefix}@toks\\fi}}\n",
            prefix = prefix
        )
        .as_bytes(),
    );
    let _ = w.write_all(
        format!(
            "\\def\\{prefix}@do#1{{\\{prefix}@bc{{\\{prefix}@tc{{\\{prefix}@ul{{\\{prefix}@it{{\\{prefix}@bf{{\\{prefix}@ff{{#1}}}}}}}}}}}}}}\n",
            prefix = prefix
        )
        .as_bytes(),
    );
    let _ = w.write_all(
        format!(
            "\\def\\{prefix}#1#2{{\\{prefix}@reset\\{prefix}@toks#1+\\relax+\\{prefix}@do{{#2}}}}\n",
            prefix = prefix
        )
        .as_bytes(),
    );
    if style != StylingMode::Inline {
        for (name, style) in theme.highlight_names.iter().zip(&theme.styles) {
            let rgb = style_rgb(style.ansi);
            let (italic, bold, underline) = style_flags(style.ansi);
            // Emit a named color/style definition whenever the scope carries a
            // color or any of the supported font styles (italic/bold/underline).
            if rgb.is_some() || italic || bold || underline {
                let mut def = String::new();
                // Style switches are emitted before `\def\TS@tc` so they take
                // effect when `@do` applies the token (see the `\TS@do` macro).
                if italic {
                    def.push_str(&format!("\\let\\{prefix}@it=\\textit"));
                }
                if bold {
                    def.push_str(&format!("\\let\\{prefix}@bf=\\textbf"));
                }
                if underline {
                    def.push_str(&format!("\\let\\{prefix}@ul=\\underline"));
                }
                if let Some((r, g, b)) = rgb {
                    let (r, g, b) = (r as f64 / 255.0, g as f64 / 255.0, b as f64 / 255.0);
                    def.push_str(&format!(
                        "\\def\\{prefix}@tc##1{{\\textcolor[rgb]{{{r:.4},{g:.4},{b:.4}}}{{##1}}}}",
                        prefix = prefix,
                        r = r,
                        g = g,
                        b = b
                    ));
                } else {
                    // No color: reset the text-color slot to a no-op so only the
                    // style switches (if any) apply.
                    def.push_str(&format!("\\let\\{prefix}@tc=\\relax"));
                }
                let _ = w.write_all(
                    format!("\\@namedef{{{prefix}@tok@{name}}}{{{def}}}\n", prefix = prefix, name = name, def = def)
                        .as_bytes(),
                );
            }
        }
    }
    let _ = w.write_all(b"\\makeatother\n");
}

/// Wrap the already-rendered body (from [`TexRenderer`]) into a complete LaTeX document.
pub fn write_tex_document<W: IoWrite>(
    w: &mut W,
    prefix: &str,
    theme: &RenderTheme,
    style: StylingMode,
    body: &str,
) {
    let _ = w.write_all(b"\\documentclass{article}\n");
    let _ = w.write_all(b"\\usepackage{fancyvrb}\n");
    let _ = w.write_all(b"\\usepackage{color}\n");
    let _ = w.write_all(b"\\usepackage[utf8]{inputenc}\n");
    let _ = w.write_all(b"\n");
    write_tex_preamble(w, prefix, theme, style);
    let _ = w.write_all(b"\\begin{document}\n");
    let _ = w.write_all(b"\n");
    let _ = w.write_all(
        b"\\begin{Verbatim}[commandchars=\\\\\\{\\},codes={\\catcode`\\$=3\\catcode`\\^=7\\catcode`\\_=8\\relax}]\n",
    );
    let _ = w.write_all(body.as_bytes());
    let _ = w.write_all(b"\\end{Verbatim}\n");
    let _ = w.write_all(b"\n");
    let _ = w.write_all(b"\\end{document}\n");
}

/// Wrap the body into a LaTeX `longtable` (line number + code), preserving leading whitespace.
pub fn write_tex_linenumbers<W: IoWrite>(
    w: &mut W,
    prefix: &str,
    theme: &RenderTheme,
    style: StylingMode,
    body: &str,
) {
    let _ = w.write_all(b"\\documentclass{article}\n");
    let _ = w.write_all(b"\\usepackage{fancyvrb}\n");
    let _ = w.write_all(b"\\usepackage{color}\n");
    let _ = w.write_all(b"\\usepackage[utf8]{inputenc}\n");
    let _ = w.write_all(b"\\usepackage{longtable}\n");
    let _ = w.write_all(b"\n");
    write_tex_preamble(w, prefix, theme, style);
    let _ = w.write_all(b"\\begin{document}\n");
    let _ = w.write_all(b"\n");
    let _ = w.write_all(b"\\begin{longtable}{rl}\n");
    let lines: Vec<&str> = body.split('\n').collect();
    let count = lines.len().saturating_sub(1); // trailing newline => empty last element
    for (i, line) in lines.into_iter().take(count).enumerate() {
        let _ = w.write_all(
            format!(
                "{} & \\Verb[commandchars=\\\\\\{{\\}},codes={{\\catcode`\\$=3\\catcode`\\^=7\\catcode`\\_=8\\relax}}]-{line}-\\\\\n",
                i + 1
            )
            .as_bytes(),
        );
    }
    let _ = w.write_all(b"\\end{longtable}\n");
    let _ = w.write_all(b"\n");
    let _ = w.write_all(b"\\end{document}\n");
}

/// Wrap the already-rendered body (from [`HtmlRenderer`]) into the requested HTML layout.
pub fn write_html<W: IoWrite>(
    w: &mut W,
    theme: &RenderTheme,
    layout: Layout,
    style: StylingMode,
    body_lines: &[String],
) {
    if layout != Layout::Fragment {
        let _ = w.write_all(HTML_HEAD_HEADER.as_bytes());
        if layout == Layout::LineNumbers {
            let _ = w.write_all(HTML_LINE_NUMBER_STYLE.as_bytes());
        }
        if style == StylingMode::Classes {
            for (name, style) in theme.highlight_names.iter().zip(&theme.styles) {
                if let Some(css) = &style.css {
                    let _ = writeln!(w, "    .{name} {{ {css}; }}");
                }
            }
        }
        let _ = w.write_all(b"  </style>");
        let _ = w.write_all(HTML_BODY_HEADER.as_bytes());
    }

    match layout {
        Layout::LineNumbers => {
            let _ = w.write_all(b"<table>");
            for (i, line) in body_lines.iter().enumerate() {
                let _ = writeln!(
                    w,
                    "<tr><td class=line-number>{}</td><td class=line>{line}</td></tr>",
                    i + 1
                );
            }
            let _ = w.write_all(b"</table>");
        }
        _ => {
            let mut body = body_lines.concat();
            if body.ends_with('\n') {
                body.pop();
            }
            let _ = writeln!(
                w,
                "<div class=\"highlight\">\n<pre><code>{body}</code></pre>\n</div>"
            );
        }
    }

    if layout != Layout::Fragment {
        let _ = w.write_all(HTML_FOOTER.as_bytes());
    }
}

/// Drive one of the renderers with a precomputed [`build_attribute_strings`] table and return the
/// final, layout-wrapped output as a `String`.
///
/// This is the safe wrapper around `Renderer::render` that avoids exposing the `Fn(Highlight,
/// &mut Vec<u8>)` closure generic to Lua (mirrors the approach in `c_lib.rs`).
pub fn render_highlighted<R: Renderer>(
    renderer: &mut R,
    highlighter: impl Iterator<
        Item = Result<tree_sitter_highlight::HighlightEvent, tree_sitter_highlight::Error>,
    >,
    source: &[u8],
    attributes: &[Vec<u8>],
) -> Result<(), tree_sitter_highlight::Error> {
    renderer.render(highlighter, source, &|h: Highlight, out: &mut Vec<u8>| {
        if let Some(bytes) = attributes.get(h.0) {
            out.extend_from_slice(bytes);
        }
    })
}

/// Convenience: parse a `theme` JSON object (`name -> {color, bold, ...}` or a color number/string)
/// into a [`RenderTheme`], then `configure`-ready `highlight_names`.
pub fn parse_theme(value: &Value) -> RenderTheme {
    let mut theme = RenderTheme::default();
    if let Value::Object(map) = value {
        for (name, style_value) in map {
            let mut style = RenderStyle::default();
            parse_style(&mut style, style_value);
            theme.highlight_names.push(name.clone());
            theme.styles.push(style);
        }
    }
    theme
}

/// Re-export of the renderer types so callers need only `crate::render`.
pub use tree_sitter_highlight::HtmlRenderer;

#[cfg(test)]
mod tests {
    use super::*;
    use serde_json::{json, Map, Value};

    /// Build a one-scope theme (color optional) with the given flags, returning the inner `anstyle::Style`.
    fn style_with(
        name: &str,
        color: Option<&str>,
        bold: bool,
        italic: bool,
        underline: bool,
    ) -> anstyle::Style {
        let mut json = Map::new();
        if let Some(c) = color {
            json.insert("color".into(), Value::String(c.to_string()));
        }
        if bold {
            json.insert("bold".into(), Value::Bool(true));
        }
        if italic {
            json.insert("italic".into(), Value::Bool(true));
        }
        if underline {
            json.insert("underline".into(), Value::Bool(true));
        }
        let theme = parse_theme(&json!({ name: Value::Object(json) }));
        theme.styles[0].ansi
    }

    #[test]
    fn test_latex_classes_style_switches() {
        // keyword: color + italic; parameter: color + underline;
        // constant: color + bold; comment: italic only (no color).
        let theme = RenderTheme {
            highlight_names: vec![
                "keyword".into(),
                "variable.parameter".into(),
                "constant.builtin".into(),
                "comment".into(),
            ],
            styles: vec![
                RenderStyle { ansi: style_with("keyword", Some("#3d7a7a"), false, true, false), css: None },
                RenderStyle { ansi: style_with("variable.parameter", Some("#fcfcfc"), false, false, true), css: None },
                RenderStyle { ansi: style_with("constant.builtin", Some("#5f00af"), true, false, false), css: None },
                RenderStyle { ansi: style_with("comment", None, false, true, false), css: None },
            ],
        };
        let mut buf: Vec<u8> = Vec::new();
        write_tex_preamble(&mut buf, "TS", &theme, StylingMode::Classes);
        let out = String::from_utf8(buf).unwrap();

        assert!(
            out.contains("\\@namedef{TS@tok@keyword}{\\let\\TS@it=\\textit\\def\\TS@tc##1{\\textcolor[rgb]{0.2392,0.4784,0.4784}{##1}}}"),
            "keyword namedef missing italic switch:\n{out}"
        );
        assert!(
            out.contains("\\@namedef{TS@tok@variable.parameter}{\\let\\TS@ul=\\underline\\def\\TS@tc##1{\\textcolor[rgb]{0.9882,0.9882,0.9882}{##1}}}"),
            "parameter namedef missing underline switch:\n{out}"
        );
        assert!(
            out.contains("\\@namedef{TS@tok@constant.builtin}{\\let\\TS@bf=\\textbf\\def\\TS@tc##1{\\textcolor[rgb]{0.3725,0.0000,0.6863}{##1}}}"),
            "constant namedef missing bold switch:\n{out}"
        );
        assert!(
            out.contains("\\@namedef{TS@tok@comment}{\\let\\TS@it=\\textit\\let\\TS@tc=\\relax}"),
            "comment namedef (no color) wrong:\n{out}"
        );
    }

    /// Count the net opening braces (`{` minus `}`) in a byte string, ignoring
    /// those escaped as `\{`/`\}`.
    fn net_braces(s: &[u8]) -> i32 {
        let mut net = 0i32;
        let mut i = 0;
        while i < s.len() {
            if s[i] == b'\\' && i + 1 < s.len() {
                i += 2; // skip an escaped char
                continue;
            }
            match s[i] {
                b'{' => net += 1,
                b'}' => net -= 1,
                _ => {}
            }
            i += 1;
        }
        net
    }

    #[test]
    fn test_latex_inline_style_switches() {
        // Replicate the Inline branch of `build_attribute_strings` for a bold+italic+color scope.
        // `build_attribute_strings` emits only the *opening* markup; the renderer's
        // `end_highlight` appends the single closing `}`, so the opening string must
        // carry exactly one net-unbalanced `{`.
        let style = style_with("kw", Some("#3d7a7a"), true, true, false);
        let (italic, bold, _underline) = style_flags(style);

        let mut bytes: Vec<u8> = Vec::new();
        bytes.push(b'{');
        if bold {
            bytes.extend(b"\\bf");
        }
        if italic {
            bytes.extend(b"\\it");
        }
        if let Some((r, g, b)) = style_rgb(style) {
            let (r, g, b) = (r as f64 / 255.0, g as f64 / 255.0, b as f64 / 255.0);
            write!(bytes, "\\color[rgb]{{{r:.4},{g:.4},{b:.4}}}").unwrap();
        }

        let out = String::from_utf8(bytes.clone()).unwrap();
        assert!(out.contains("\\bf"));
        assert!(out.contains("\\it"));
        assert!(out.contains("\\color[rgb]{0.2392,0.4784,0.4784}"));
        assert_eq!(net_braces(&bytes), 1, "opening markup must have one net `{{` (renderer supplies the closing `}}`): {out}");
    }

    #[test]
    fn test_latex_inline_no_style_opens_single_group() {
        let style = style_with("plain", Some("#abcdef"), false, false, false);
        let (italic, bold, _underline) = style_flags(style);

        let mut bytes: Vec<u8> = Vec::new();
        bytes.push(b'{');
        if bold {
            bytes.extend(b"\\bf");
        }
        if italic {
            bytes.extend(b"\\it");
        }
        if let Some((r, g, b)) = style_rgb(style) {
            let (r, g, b) = (r as f64 / 255.0, g as f64 / 255.0, b as f64 / 255.0);
            write!(bytes, "\\color[rgb]{{{r:.4},{g:.4},{b:.4}}}").unwrap();
        }

        let out = String::from_utf8(bytes.clone()).unwrap();
        assert!(!out.contains("\\bf"));
        assert!(!out.contains("\\it"));
        assert!(out.contains("\\color[rgb]{0.6706,0.8039,0.9373}"));
        assert_eq!(net_braces(&bytes), 1, "opening markup must have one net `{{`: {out}");
    }
}
