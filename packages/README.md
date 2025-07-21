# Packages

## TeX documents

`demo` is a more complicated example for LaTeX document than tutor.

## TeX dialects

`luatex`/`lualatex`/`luatexinfo`/`initex` display how to create a TeX dialect.

## TeX Tools

### texdoc

`texdoc` is a tool to search document of any TeX package developed by TeX Live
team.

Note, texdoc need a tlpdb database.
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

### l3build

`l3build` is a tool to build TeX packages developed by LaTeX 3 team.

### luafindfont

`l3build` is a simple tool to search fonts.

### texluap

Sometimes you need a REPL to debug luatex.
[texluap](https://github.com/wakatime/prompt-style.lua#luatex) do it:

```sh
lx install prompt-style
# For ArchLinux
paru -S lua53-prompt-style texlua
```
