# A Toy TeX

TeX compilers have two modes:

## Normal mode

```sh
luahbtex --fmt=lualatex XXX.tex
```

Every TeX dialect has a format file. `--fmt=XXX` will load `XXX.fmt`. If `--fmt`
is missing in command line options, it will search `luahbtex.fmt`, which
`luahbtex` is the program name. It means:

```sh
cp /usr/bin/luahbtex /usr/bin/luatex
luatex XXX.tex
```

is equal to:

```sh
luahbtex --fmt=luatex XXX.tex
```

except `texlua` and `texluac`.

## Initial mode

```sh
luahbtex --ini XXX.ini
```

It will not load any TeX formats and generate `XXX.fmt`. `XXX.ini` is a TeX
file written in TeX primitives without any predefined macros by TeX dialects.
Different from `XXX.tex`, `XXX.ini` must end with `\dump`.

[This example](https://github.com/ustctug/texrocks/tree/main/packages/initex)
is a toy TeX dialect. It only can draw lines, because we don't add any fonts.

## Lua mode

LuaTeX has an extra mode:

```sh
luahbtex --luaonly XXX.lua
luahbtex --luaconly XXX.lua
```

They are equal to:

```sh
texlua XXX.lua
texluac XXX.lua
```

So you can use lua to write TeX tools, like using lua to write Neovim plugins.
