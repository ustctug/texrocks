# tree-sitter-highlight

Language bindings for [tree-sitter-highlight](https://crates.io/crates/tree-sitter-highlight).

## lua-tree-sitter-highlight

```lua
local tree_sitter_highlight = require "tree_sitter_highlight"
local parsers = tree_sitter_highlight.search_parsers {
    "/usr/lib/nvim",
    "/usr/share/nvim/runtime",
}
local code = tree_sitter_highlight.highlight {
    file = "/home/user/.config/nvim/init.vim",
    source = nil,
    language = "vim",
    parsers = parsers,
    theme = { variable = { color = "#F8F8F2" } },
    format = "terminal",
    layout = "document",
    style = "classes",
    prefix = "TS",
    math_escape = {"comment", "string"},
}
```

### [ldoc](https://github.com/lunarmodules/ldoc/)

`config.ld`:

```lua
pretty = 'lxsh'
```

```sh
luarocks install ldoc
luarocks install texcat
luarocks install tree-sitter-XXX
ldoc .
```

[An example](https://texrocks.readthedocs.io/).

### [texlua](https://www.luatex.org/): LaTeX

See [texcat](https://texrocks.readthedocs.io/en/latest/topics/texcat.md.html).

## py-tree-sitter-highlight

```python
import tree_sitter_bash
import tree_sitter_highlight
import tree_sitter_python


parsers = tree_sitter_highlight.search_parsers(
    tree_sitter_python,
    # same as:
    # python=tree_sitter_python,
    sh = tree_sitter_bash,
)
code = tree_sitter_highlight.highlight {
    file = "/home/user/.bashrc",
    source = nil,
    language = "sh",
    parsers = parsers,
    theme = {"variable": {"color": "#F8F8F2"}},
    format = "terminal",
    layout = "document",
    style = "classes",
    prefix = "TS",
    math_escape = ["comment", "string"],
}
```

### [sphinxcontrib-tree-sitter](https://github.com/sphinx-contrib/tree-sitter)

See [sphinxcontrib-tree-sitter](https://github.com/sphinx-contrib/tree-sitter).
