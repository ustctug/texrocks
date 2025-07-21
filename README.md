# texrocks

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/ustctug/texrocks/main.svg)](https://results.pre-commit.ci/latest/github/ustctug/texrocks/main)
[![github/workflow](https://github.com/ustctug/texrocks/actions/workflows/main.yml/badge.svg)](https://github.com/ustctug/texrocks/actions)

[![github/downloads](https://shields.io/github/downloads/ustctug/texrocks/total)](https://github.com/ustctug/texrocks/releases)
[![github/downloads/latest](https://shields.io/github/downloads/ustctug/texrocks/latest/total)](https://github.com/ustctug/texrocks/releases/latest)
[![github/issues](https://shields.io/github/issues/ustctug/texrocks)](https://github.com/ustctug/texrocks/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/ustctug/texrocks)](https://github.com/ustctug/texrocks/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/ustctug/texrocks)](https://github.com/ustctug/texrocks/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/ustctug/texrocks)](https://github.com/ustctug/texrocks/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/ustctug/texrocks)](https://github.com/ustctug/texrocks/discussions)
[![github/milestones](https://shields.io/github/milestones/all/ustctug/texrocks)](https://github.com/ustctug/texrocks/milestones)
[![github/forks](https://shields.io/github/forks/ustctug/texrocks)](https://github.com/ustctug/texrocks/network/members)
[![github/stars](https://shields.io/github/stars/ustctug/texrocks)](https://github.com/ustctug/texrocks/stargazers)
[![github/watchers](https://shields.io/github/watchers/ustctug/texrocks)](https://github.com/ustctug/texrocks/watchers)
[![github/contributors](https://shields.io/github/contributors/ustctug/texrocks)](https://github.com/ustctug/texrocks/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/ustctug/texrocks)](https://github.com/ustctug/texrocks/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/ustctug/texrocks)](https://github.com/ustctug/texrocks/commits)
[![github/release-date](https://shields.io/github/release-date/ustctug/texrocks)](https://github.com/ustctug/texrocks/releases/latest)

[![github/license](https://shields.io/github/license/ustctug/texrocks)](https://github.com/ustctug/texrocks/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/ustctug/texrocks)](https://github.com/ustctug/texrocks)
[![github/languages/top](https://shields.io/github/languages/top/ustctug/texrocks)](https://github.com/ustctug/texrocks)
[![github/directory-file-count](https://shields.io/github/directory-file-count/ustctug/texrocks)](https://github.com/ustctug/texrocks)
[![github/code-size](https://shields.io/github/languages/code-size/ustctug/texrocks)](https://github.com/ustctug/texrocks)
[![github/repo-size](https://shields.io/github/repo-size/ustctug/texrocks)](https://github.com/ustctug/texrocks)
[![github/v](https://shields.io/github/v/release/ustctug/texrocks)](https://github.com/ustctug/texrocks)

[![luarocks](https://img.shields.io/luarocks/v/Freed-Wu/texrocks)](https://luarocks.org/modules/Freed-Wu/texrocks)

A minimal (La)TeX distribution powered by lux and luaTeX.

## Features

- [x] install packages in parallel
- [x] package version control
- [x] virtual environment
- [x] minimal preinstalled packages
- [x] no extra dependencies except a package manager and a TeX compiler while
  TeXLive needs perl, tcl/tk, ...
- [x] support Unix
- [ ] support Win32

## Install

- [lx](https://github.com/nvim-neorocks/lux) >= 0.8.2 as package manager,

```sh
cargo install lux-cli
# For ArchLinux
paru -S lux-cli
# For Nix
nix-env -iA nixos.lux-cli
```

- A LuaTeX compiler named luahbtex. Because LaTeX only support it, not others
  luatex, luajittex, ... It contained in mostly TeX distribution like TeXLive
  and MikTeX. However, you can install it standalone by:

```sh
lx install luahbtex
# For ArchLinux
paru -S luahbtex
# For Nix
nix-env -iA nur.repos.Freed-Wu.luahbtex
```

Now you can use `lx` to install TeX dialects written in TeX and TeX tools written
in lua from [luarocks.org](https://luarocks.org/). See
[packages](./packages) to know how to package missing LuaTeX packages
and publish them to luarocks.org.

## TeX Dialects

### PlainTeX

PlainTeX is the first and simplest TeX Dialect. Original TeX compiler only
supports 256 registers used by PlainTeX. LuaTeX supports 65536 however PlainTeX
cannot use them.

[A minimal example](packages/luatex):

```tex
\hoffset-1in
\voffset-1in
\hsize30mm
\pagewidth\hsize
\vsize20mm
\pageheight\vsize
\parindent0mm

Hello, \TeX!
$$\sum_{n = 1}^\infty{1\over{n^2}} = {\pi^2\over6}$$

\bye
```

```sh
lx run
```

![luatex](https://github.com/user-attachments/assets/47ab4ca2-1fd1-48b1-8016-7a322bbbdb32)

### LaTeX

LaTeX is the most popular TeX Dialect. It can use all LuaTeX registers, which
means you can create a bigger document than PlainTeX.

[A minimal example](packages/lualatex):

```tex
\renewcommand\normalsize{\fontsize{10pt}{12pt}\selectfont}
\title{minimal}
\setlength\hoffset{-1in}
\setlength\voffset{-1in}
\setlength\oddsidemargin{0pt}
\setlength\topmargin{0pt}
\setlength\headheight{0pt}
\setlength\headsep{0pt}
\setlength\textheight{20mm}
\setlength\pageheight{\textheight}
\setlength\textwidth{40mm}
\setlength\pagewidth{\textwidth}
\setlength\parindent{0mm}
\begin{document}

Hello, \LaTeX!
$$\sum_{n = 1}^\infty\frac1{n^2} = \frac{\pi^2}{6}$$

\end{document}
```

```sh
lx run
```

![lualatex](https://github.com/user-attachments/assets/09dd5ddb-8bac-4207-9cc5-ee61724ef7c0)

LaTeX require some [required packages](https://ctan.org/pkg/required).
You can install them by yourself.

- [amscls](https://luarocks.org/modules/ustctug/amscls):
  AMSLaTeX contains some documentclasses and packages for mathematics.
- [babel-base](https://luarocks.org/modules/ustctug/babel-base): multilanguages
- [latex-cyrillic](https://luarocks.org/modules/ustctug/latex-cyrillic):
  cyrillic alphabet fonts.
- [latex-graphics](https://luarocks.org/modules/ustctug/latex-graphics):
  graphics and colours.
- psnfss: WIP
- [latex-tools](https://luarocks.org/modules/ustctug/latex-tools): tables.

Some packages are recommended:

- [hyperref](https://luarocks.org/modules/ustctug/hyperref): hyperlinks.
- [pgf](https://luarocks.org/modules/ustctug/pgf): PGF/TikZ.
- [beamer](https://luarocks.org/modules/ustctug/beamer): slides.
- [ctex](https://luarocks.org/modules/ustctug/ctex): Chinese support. **bug**
- [citation-style-language](https://luarocks.org/modules/ustctug/citation-style-language):
  use [csl](https://citationstyles.org/) for bibliography.

[More packages](https://luarocks.org/m/texmf).

[A more complicated example](packages/demo):

```tex
\documentclass[tikz]{standalone}
\usetikzlibrary{arrows.meta, quotes, graphs, graphdrawing, shapes.geometric}
\usegdlibrary{layered}
\usepackage{hyperref}
\usepackage{hologo}
\title{graph}
\begin{document}
\begin{tikzpicture}[rounded corners, >=Stealth, auto]
  \graph[layered layout, nodes={draw, align=center}]{%
    "\TeX" -> "\hologo{eTeX}" -> "\hologo{pdfTeX}" -> "\hologo{LuaTeX}";
    "\hologo{eTeX}" -> "\hologo{XeTeX}"
  };
\end{tikzpicture}
\end{document}
```

![graph](https://github.com/user-attachments/assets/131a8a31-0dd4-49fa-84dd-1531c89da55c)

### TeXinfo

TeXinfo is a TeX dialect designed by GNU. It uses `@` to start a control sequence,
which is different from other TeX dialects. GNU also create some perl programs
to convert texinfo to `info`, `HTML`, ..., while other TeX dialects doesn't have
good support for outputting HTML like [TeX4ht](https://tug.org/tex4ht/) for
PlainTeX/LaTex/ConTeXt.

[A minimal example](packages/luatexinfo):

```texinfo
@hoffset-1in
@voffset-1in
@node Top
@top Example

@node First Chapter
@nodedescription The first chapter is the only chapter in this sample.
@chapter Hello, @TeX{info}

@cindex chapter, first
This is the first chapter.
@bye
```

```sh
lx run
dvipdfmx main.dvi
pdftocairo -png main.pdf
magick convert main-1.png -crop 50%x10% main.png
```

![texinfo](https://github.com/user-attachments/assets/35507747-65ba-4d76-bfec-a614826ce4c7)

### ConTeXt

TODO

## TeX Tools

### texdoc

`texdoc` is a tool to search document of any TeX package developed by TeX Live
team.

```sh
lx install texdoc
```

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

```sh
lx install l3build
```

### luafindfont

`l3build` is a simple tool to search fonts.

```sh
lx install luafindfont
```

### texluap

Sometimes you need a REPL to debug luatex.
[texluap](https://github.com/wakatime/prompt-style.lua#luatex) do it:

```sh
lx install prompt-style
# For ArchLinux
paru -S lua53-prompt-style texlua
```

## Introduction

For example, you create a virtual environment named `my-thesis`:

```sh
lx new --lua-versions=5.3 my-thesis
cd my-thesis
lx --lua-version=5.3 add your-needed-luatex-package1 you-loved-luatex-package2
"$EDITOR" main.tex
```

PS: luatex supports both luajit (another implementation of lua 5.1) and lua 5.3.
However, lualatex only supports lua 5.3. So we recommend that you use lua 5.3
syntax. you can `lx config edit` to edit config to avoid input
`--lua-version=5.3` every time. We assume you did this at the following code.

`~/.config/lux/config.toml`:

```toml
lua_version = "5.3"
```

If you build it directly:

```sh
luatex main.tex
```

It will fail, because luatex doesn't know where is
`your-needed-luatex-package1.sty` in `\usepackage{your-needed-luatex-package1}`
and `your-needed-luatex-package1.lua` in `\directlua{require"your-needed-luatex-package1"}`.
So you try:

```sh
lx lua --lua=luatex -- main.tex
# or
lx shell
luatex main.tex
```

`lx` will add lua paths of `your-needed-luatex-package1` and
`you-loved-luatex-package2` to `$LUA_PATH` and `$CLUA_PATH`.
lua recognize these variables to set `package.path` and `package.cpath`.
Any `require"package_name"` will search `package_name.lua` in `package.path` and
`package.cpath`.

However, luatex is not a standard lua. It recognizes `$LUAINPUTS` and
`$CLUAINPUTS` for lua files. So we must modify `package.path` and
`package.cpath` to get them. And luatex recognize `$TEXINPUTS` for tex files.
Notice we install tex files in the same directory of lua files, so we also can
get them. Font files are similar.

So we create a lua wrapper named `texrocks` to do this work. `texrocks` calls
`os.setenv()` to set correct environment variables to make luatex work in a
virtual/system environment. We wrap `luatex`:

```sh
luatex main.tex
```

If you don't like virtual environment, just use `lx install` to replace `lx add`.
These packages will be installed to system globally.

```sh
lx install your-needed-luatex-package1 you-loved-luatex-package2
```

It is advised that install TeX tools globally and TeX packages on virtual
environment, and add `lux.lock` to VCS to keep reproducible of your TeX
documents.

For nodejs or python users, you can simply understand:

- `lux.toml`: npm's `package.json` or uv's `pyproject.toml` or
  `requirements.txt`.
- `lux.lock`: npm's `package-lock.json` or uv's `uv.lock`
- `.lux`: npm's `node_modules` or uv's `.venv`

## Related Projects

Except environment variables, TeX compilers also read a config file:

`texmf.cnf`:

```texmf
% comment
VAR = XXX
```

is equal to shell's:

```sh
VAR=XXX texlua
```

or lua's:

```lua
os.setenv("VAR", "XXX")
io.popen("texlua")
```

Many TeX distributions, like TeX Live, MikTeX, doesn't use environment variables.
They use `texmf.cnf` to declare a fixed path, like `/usr/share/texmf`. It is
impossible to support virtual environments.

And these huge TeX distributions usually provide many TeX compilers: pdfTeX,
XeTeX, LuaTeX, ... and many TeX tools written in lua/perl/python/java/...
We only provide LuaTeX and those TeX tools written in lua. That's enough, IMO.

## TODO

- `lx` can be configure by `~/.config/lux/config.toml`. `texrocks` should
  know correct installation positions of TeX files according to it. Currently we
  use default value without any extra config.
- more TeX packages

## Credit

- [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim): a neovim package
  manager powered by luarocks
- [apltex](https://github.com/RadioNoiseE/apltex): inspiration origin
