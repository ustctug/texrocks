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

## Install

texrocks uses

- [lx](https://github.com/nvim-neorocks/lux) >= 0.8.2 as package manager,

```sh
cargo install lux-cli
# For ArchLinux
paru -S lux-cli
# For NixOS
nix-env -iA nixos.lux-cli
```

Remember update `$PATH`:

```sh
PATH="$PATH:$HOME/.local/share/lux/tree/5.3/bin"
```

- texlua as lua interpreter, contained in mostly TeX distribution like TeXLive and MikTeX.
  However, you can install it standalone by:

```sh
lx --lua-version=5.3 install texlua
# For ArchLinux
paru -S texlua
```

Then you can:

```sh
lx --lua-version=5.3 install texrocks
```

## TeX Dialects

### LuaTeX

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
texrocks install luatex
luatex examples/tex/plain/minimal.tex
```

![luatex](https://github.com/user-attachments/assets/47ab4ca2-1fd1-48b1-8016-7a322bbbdb32)

### LuaLaTeX

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
texrocks install lualatex
lualatex examples/tex/latex/minimal.tex
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
texrocks install texinfo
texinfo examples/tex/texinfo/minimal.tex
dvipdfmx minimal.dvi
pdftocairo -png minimal.pdf
magick convert minimal-1.png -crop 50%x10% minimal.png
```

![texinfo](https://github.com/user-attachments/assets/35507747-65ba-4d76-bfec-a614826ce4c7)

### Create your TeX dialect

See [packages](packages/README.md)

## Tools Related to TeX

### texdoc

```sh
texrocks install texdoc
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

```sh
texrocks install l3build
```

### texluap

Sometimes you need a REPL to debug luatex. you can refer
[texluap](https://github.com/wakatime/prompt-style.lua#luatex):

```sh
texrocks install prompt-style
```

## Package

### Version

Github release can tag version while CTAN cannot. Such as:

- <https://github.com/latex3/latex2e/releases/download/release-2024-11-01-PL2/latex-graphics.tds.zip>
  is for version 2024-11-01, we package it to 2024.11.01-1
- <http://mirrors.ctan.org/install/macros/latex/contrib/hyperref.tds.zip>
  is for latest version. we package it to scm-1

### Formats

TeX packages have two formats:

- source package `*-ctan.zip`, like:
  - lua: `*.src.rock`
  - python : sdist `*.tar.gz`
- binary package `*.tds.zip`, like:
  - lua: `*.any.rock`, `*.win-x86_64.rock`
  - python: `*-any.whl`, `*-win_amd64.whl`

Like converting typescript to javascript, we need convert `*-ctan.zip`'s `*.dts`
and `*.ins` to `*.tds.zip`'s `*.cls` and `*.sty`. We package `*.tds.zip` to skip
converting, like `npmjs.org` packages only contain `*.js` not `*.ts`.

We repackage `*.tds.zip` to `*.src.rock` in order to upload them to luarocks.org.

### Dependencies

`*.tds.zip` doesn't have meta information about packages. when we create
`*.rockspec`, we need to add it from [CTAN](https://ctan.org/).

CTAN doesn't provide dependence information. You need search it. e.g.,

`tex/latex/base/ltnews.cls`:

```tex
% ...
\IfFileExists{hyperref.sty}{%
  \RequirePackage[hidelinks]{hyperref}}{}
% ...
```

`hyperref` is an optional dependency of `latex-base`.

### Build Dependencies

Some TeX packages don't provide `*.tds.zip`. You have to build it from
`*.ctan.zip`.

```sh
texrocks install &&
  lualatex --interaction=nonstopmode foo.ins
```

or:

```sh
l3build ctan
```

add `{ 'texrocks', 'lualatex', 'latex-base' }` or `{ 'l3build', 'latex-base' }` to
`build_dependencies`.

## Credit

- [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim): a neovim package
  manager powered by luarocks
- [apltex](https://github.com/RadioNoiseE/apltex): inspiration origin
