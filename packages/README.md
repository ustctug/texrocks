# Packages

## TeX Documents

`demo-*` are more complicated examples for LaTeX document than tutor.

## TeX Dialects

`luatex`/`lualatex`/`luatexinfo`/`initex` display how to create a TeX dialect.

## TeX Tools

- `l3build`: a tool to build TeX packages developed by LaTeX 3 team
- `texdoc`: a tool to search document of any TeX package developed by TeX Live
  team.
- `luafindfont`: a simple tool to search fonts
- `texluap`'s `tlua`: tlua use luatex as Lua interpreter and provide a REPL for debug.
- `lua-open`: use correct system tool to open PDF.
- `texdef`: Show definitions of TeX commands. A reimplementation of
  <https://github.com/MartinScharrer/texdef/>.
- `kpathsea`'s `kpsewhich`: provide a CLI API for other TeX tools written in
  other languages.

### texdoc

texdoc need a tlpdb database.
Download
[it](https://github.com/ustctug/texrocks/releases/download/0.0.1/Data.tlpdb.lua)
to `~/.local/share/texmf/texdoc/Data.tlpdb.lua`.
Then create `~/.local/share/texmf/texdoc/texdoc.cnf`:

```ini
texlive_tlpdb = /home/user_name/.local/share/texmf/texdoc/Data.tlpdb.lua
```

Now it can work:

```sh
$ texdoc impatient
You don't appear to have any local documentation installed.

There may be online documentation available for "impatient" at
    https://texdoc.org/serve/impatient/0
This documentation may be for a different version than you have installed.

Would you like to search online? (y/N) y
```

<https://texdoc.org/serve/impatient/0> is opened.
