# Roadmap

## Features

- [x] install packages in parallel, thanks to lx
- [x] package version control, thanks to rockspec
- [x] virtual environment, thanks to lx
- [x] minimal preinstalled packages
- [x] no extra dependencies while TeXLive needs perl, tcl/tk, ...
- [x] support Unix
- [ ] support Win32. We use shebang so a cmd wrapper is needed
- [ ] support lx's config's `entrypoint_layout` to customize search path
- [ ] hyphen

## Hyphen

lualatex replace `tex/plain/etex/etex.src` by `tex/luatex/hyph-utf8/etex.src`:

```tex
\def \uselanguage #1%
    {\ifcsname lang@#1\endcsname
        \language=\csname lang@#1\endcsname
        \lefthyphenmin=\csname lhm@#1\endcsname
        \righthyphenmin=\csname rhm@#1\endcsname
        \ifdefined\directlua % V2.1;0-luatex
          \ifcsname lu@texhyphen@loaded@\the\language\endcsname \else
            \global\expandafter\def\csname
              lu@texhyphen@loaded@\the\language\endcsname{}%
            \directlua{
              if not status.ini_version then
                require("luatex-hyphen")
                luatexhyphen.loadlanguage("\luatexluaescapestring{#1}",
                \the\language)
              end}%
          \fi
        \fi
     \else ...
```

`luatex-hyphen.lua` will read `language.dat.lua` when compile
`*.tex` every time (`status.ini_version == false`).

So we need to realize `tlmgr generate language.dat.lua`, then
every compile `*.tex`, we do

1. `updmap` to generate `.lux/pdftex.map`
2. `tlmgr generate language.dat.lua` to generate `.lux/language.dat.lua`
3. `lualatex *.tex`

## Credit

- [rocks.nvim](https://github.com/lumen-oss/rocks.nvim): a neovim package
  manager powered by luarocks
