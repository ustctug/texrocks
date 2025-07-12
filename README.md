# texrocks

[![readthedocs](https://shields.io/readthedocs/texrocks)](https://texrocks.readthedocs.io)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/ustctug/texrocks/main.svg)](https://results.pre-commit.ci/latest/github/ustctug/texrocks/main)
[![github/workflow](https://github.com/ustctug/texrocks/actions/workflows/main.yml/badge.svg)](https://github.com/ustctug/texrocks/actions)
[![codecov](https://codecov.io/gh/ustctug/texrocks/branch/main/graph/badge.svg)](https://codecov.io/gh/ustctug/texrocks)
[![DeepSource](https://deepsource.io/gh/ustctug/texrocks.svg/?show_trend=true)](https://deepsource.io/gh/ustctug/texrocks)

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

[![luarocks](https://img.shields.io/luarocks/v/ustctug/texrocks)](https://luarocks.org/modules/ustctug/texrocks)

A (La)TeX package manager powered by luarocks and luaTeX, also
[a minimal (La)TeX distribution](https://freed-wu.github.io/2025/03/01/minimal-latex-distribution.html).

## Introduction

For example, you create a virtual environment named `my-thesis`:

```sh
lx --lua-version new my-thesis
cd my-thesis
lx --lua-version 5.3 --dev add your-needed-luatex-package1 you-loved-luatex-package2
vi main.tex
```

If you build it directly:

```sh
luatex main.tex
```

It will fail, because luatex doesn't know where is
`your-needed-luatex-package1.sty` in `\usepackage{your-needed-luatex-package1}`
and `your-needed-luatex-package1.lua` in `\directlua{your-needed-luatex-package1}`.
So you try:

```sh
lx --lua-version 5.3 lua --lua=luatex -- main.tex
```

`lx` will add lua paths of `your-needed-luatex-package1` and
`you-loved-luatex-package2` to `$LUA_PATH` and `$CLUA_PATH`.
lua recognize these variables to set `package.path` and `package.cpath`.
Any `require"package_name"` will search `package_name.lua` in `package.path` and
`package.cpath`.

However, luatex is not a standard lua. it recognizes `$LUAINPUTS` and
`$CLUAINPUTS` for lua files. so we must modify `package.path` and
`package.cpath` to get them. and luatex recognize `$TEXINPUTS` for tex files.
Notice we install tex files in the same directory of lua files, so we also can
get them. Font files are similar.

So we create a wrapper named `texrocks` to do this work.

```sh
texrocks luatex main.tex
```

luatex can be configured by environment variables or a config file `texmf.cnf`.

`texmf.cnf`:

```texmf
% comment
VAR = XXX
```

is equal to:

```sh
VAR=XXX texlua
```

in shell.

`texrocks` is a wrapper. It calls `os.setenv()` to set correct environment
variables to make luatex work in a virtual/system environment.

We create some scripts to use it easily:

```sh
tex main.tex
# is equal to
texrocks luatex main.tex
```

`latex`, `texinfo` is similar.

If you don't like virtual environment, just install these packages to system.

```sh
lx --lua-version=5.3 install your-needed-luatex-package1 you-loved-luatex-package2
```

`lx` will know what you want is a virtual environment or a system environment
according to `lux.toml` created by `lux new` to set correct `$LUA_PATH`
and `$CLUA_PATH`.

## Install

texrocks uses

- [lx](https://github.com/nvim-neorocks/lux) >= 0.8.2 as package manager,

```sh
cargo install lux-cli
# For ArchLinux
paru -S lux-cli
# For Nix
nix-env -iA nixos.lux-cli
```

Remember update `$PATH`:

```sh
PATH="$PATH:$HOME/.local/share/lux/tree/5.3/bin"
```

- texlua as lua 5.3 interpreter, contained in mostly TeX distribution like
  TeXLive and MikTeX. However, you can install it standalone by:

```sh
lx --lua-version=5.3 install texlua
# For ArchLinux
paru -S texlua
```

Then you can:

```sh
lx --lua-version=5.3 install texrocks
```

Now you can use `lx` to install TeX dialects written in TeX and TeX tools written
in lua from [luarocks.org](https://luarocks.org/). See
[packages](packages/README.md) to know how to package missing LuaTeX packages
and publish them to luarocks.org.

## TeX Dialects

### PlainTeX

PlainTeX is the first and simplest TeX Dialect. Original TeX interpreter only
supports 256 registers which is PlainTeX used. LuaTeX support 65536 however
PlainTeX cannot use it.

[A minimal example](examples/tex/plain/minimal.tex):

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
lx --lua-version=5.3 --dev install luatex
tex examples/tex/plain/minimal.tex
```

![luatex](https://github.com/user-attachments/assets/47ab4ca2-1fd1-48b1-8016-7a322bbbdb32)

### LaTeX

LaTeX is the most popular TeX Dialect. It can use all LuaTeX registers, which
means you can create a bigger document than PlainTeX.

[A minimal example](examples/tex/latex/minimal.tex):

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
lx --lua-version=5.3 --dev install lualatex
latex examples/tex/latex/minimal.tex
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

[A more complicated example](examples/tex/latex/graph.tex):

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

[A minimal example](examples/tex/texinfo/minimal.tex):

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
lx --lua-version=5.3 --dev install luatexinfo
texinfo examples/tex/texinfo/minimal.tex
dvipdfmx minimal.dvi
pdftocairo -png minimal.pdf
magick convert minimal-1.png -crop 50%x10% minimal.png
```

![texinfo](https://github.com/user-attachments/assets/35507747-65ba-4d76-bfec-a614826ce4c7)

### ConTeXt

TODO

## TeX Tools

### texdoc

`texdoc` is a tool to search document of any TeX package developed by TeX Live
team.

```sh
lx --lua-version=5.3 --dev install texdoc
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
$ texrocks texdoc impatient
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
lx --lua-version=5.3 install l3build
```

### luafindfont

`l3build` is a simple tool to search fonts.

```sh
lx --lua-version=5.3 --dev install luafindfont
```

### texluap

Sometimes you need a REPL to debug luatex.
[texluap](https://github.com/wakatime/prompt-style.lua#luatex) do it:

```sh
lx --lua-version=5.3 install prompt-style
# For ArchLinux
paru -S lua53-prompt-style texlua
```

## Credit

- [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim): a neovim package
  manager powered by luarocks
- [apltex](https://github.com/RadioNoiseE/apltex): inspiration origin
