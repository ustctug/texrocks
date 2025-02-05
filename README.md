# texrocks

[![readthedocs](https://shields.io/readthedocs/texrocks)](https://texrocks.readthedocs.io)
[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/Freed-Wu/texrocks/main.svg)](https://results.pre-commit.ci/latest/github/Freed-Wu/texrocks/main)
[![github/workflow](https://github.com/Freed-Wu/texrocks/actions/workflows/main.yml/badge.svg)](https://github.com/Freed-Wu/texrocks/actions)
[![codecov](https://codecov.io/gh/Freed-Wu/texrocks/branch/main/graph/badge.svg)](https://codecov.io/gh/Freed-Wu/texrocks)
[![DeepSource](https://deepsource.io/gh/Freed-Wu/texrocks.svg/?show_trend=true)](https://deepsource.io/gh/Freed-Wu/texrocks)

[![github/downloads](https://shields.io/github/downloads/Freed-Wu/texrocks/total)](https://github.com/Freed-Wu/texrocks/releases)
[![github/downloads/latest](https://shields.io/github/downloads/Freed-Wu/texrocks/latest/total)](https://github.com/Freed-Wu/texrocks/releases/latest)
[![github/issues](https://shields.io/github/issues/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/issues)
[![github/issues-closed](https://shields.io/github/issues-closed/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/issues?q=is%3Aissue+is%3Aclosed)
[![github/issues-pr](https://shields.io/github/issues-pr/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/pulls)
[![github/issues-pr-closed](https://shields.io/github/issues-pr-closed/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/pulls?q=is%3Apr+is%3Aclosed)
[![github/discussions](https://shields.io/github/discussions/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/discussions)
[![github/milestones](https://shields.io/github/milestones/all/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/milestones)
[![github/forks](https://shields.io/github/forks/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/network/members)
[![github/stars](https://shields.io/github/stars/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/stargazers)
[![github/watchers](https://shields.io/github/watchers/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/watchers)
[![github/contributors](https://shields.io/github/contributors/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/graphs/contributors)
[![github/commit-activity](https://shields.io/github/commit-activity/w/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/graphs/commit-activity)
[![github/last-commit](https://shields.io/github/last-commit/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/commits)
[![github/release-date](https://shields.io/github/release-date/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/releases/latest)

[![github/license](https://shields.io/github/license/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks/blob/main/LICENSE)
[![github/languages](https://shields.io/github/languages/count/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks)
[![github/languages/top](https://shields.io/github/languages/top/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks)
[![github/directory-file-count](https://shields.io/github/directory-file-count/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks)
[![github/code-size](https://shields.io/github/languages/code-size/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks)
[![github/repo-size](https://shields.io/github/repo-size/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks)
[![github/v](https://shields.io/github/v/release/Freed-Wu/texrocks)](https://github.com/Freed-Wu/texrocks)

[![luarocks](https://img.shields.io/luarocks/v/Freed-Wu/texrocks)](https://luarocks.org/modules/Freed-Wu/texrocks)

A (La)TeX package manager powered by luarocks and luaTeX.

## Usage

### LuaTeX

[example](examples/tex/plain/main.tex):

```tex
Hello, \TeX!

$$\sum_{n = 1}^\infty{1\over{n^2}} = {\pi^2\over6}$$

\bye
```

```sh
texrocks install luatex
luatex examples/tex/plain/main.tex
pdftocairo -png main.pdf
magick convert main-1.png -gravity North -crop 100%x20% main.png
```

![luatex](https://github.com/user-attachments/assets/18e6d10f-6387-4501-9d97-067a5a1629e7)

### LuaLaTeX

[example](examples/tex/latex/main.tex):

```tex
\documentclass{article}
\title{main}
\begin{document}

\section{Hello, \LaTeX!}

$$\sum_{n = 1}^\infty\frac1{n^2} = \frac{\pi^2}{6}$$

\end{document}
```

```sh
texrocks install lualatex
lualatex examples/tex/latex/main.tex
pdftocairo -png main.pdf
magick convert main-1.png -gravity North -crop 100%x30% main.png
```

![lualatex](https://github.com/user-attachments/assets/6e77a463-9231-4bed-b2c6-84b6eb2f1463)

LaTeX require some [required packages](https://ctan.org/pkg/required).
You can install them by yourself.

- [amscls](https://luarocks.org/modules/Freed-Wu/amscls):
  AMSLaTeX contains some documentclasses and packages for mathematics.
- [babel-base](https://luarocks.org/modules/Freed-Wu/babel-base): multilanguages
- [latex-cyrillic](https://luarocks.org/modules/Freed-Wu/latex-cyrillic):
  cyrillic alphabet fonts.
- [latex-graphics](https://luarocks.org/modules/Freed-Wu/latex-graphics):
  graphics and colours.
- psnfss: WIP
- [latex-tools](https://luarocks.org/modules/Freed-Wu/latex-tools): tables.

Some packages are recommended:

- [hyperref](https://luarocks.org/modules/Freed-Wu/hyperref): hyperlinks.

[More packages](https://luarocks.org/m/texmf).

### texdoc

```sh
texrocks install texdoc
```

Note, texdoc need a tlpdb database.
Download
[it](https://github.com/Freed-Wu/texrocks/releases/download/0.0.1/Data.tlpdb.lua)
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

## Install

```sh
luarocks --lua-version=5.3 install texrocks
```

luarocks version must be `> 3.11.1-1` to support `build_dependencies`.
The latest is `dev-1`.

## Configure

By default:

`~/.config/texmf/init.lua`:

```lua
local home = os.getenv('HOME')
rocks_path = home .. '/.local/share/texmf'
luarocks_config_path = home .. '/.luarocks/config-5.3.lua'
luarocks_binary = 'luarocks'
```

Where:

- all rocks will be installed to `rocks_path`
- will use `luarocks_config_path` to configure `luarocks_binary`. See
  [config](https://github.com/luarocks/luarocks/wiki/Config-file-format)

By default, `~/.local/share/texmf/fonts/map/luatex.map` and
`~/.local/share/texmf/web2c/texmf.cnf` will be generated to configure `luatex`.

You can use `~/.config/texmf/fonts/map/luatex.map` and
`~/.config/texmf/web2c/texmf.cnf` to override it.

## Package

### Version

Github release can tag version while CTAN cannot. Such as:

- <https://github.com/latex3/latex2e/releases/download/release-2024-11-01-PL2/latex-graphics.tds.zip>
  is for version 2024-11-01, we package it to 2024.11.01-1
- <http://mirrors.ctan.org/install/macros/latex/contrib/hyperref.tds.zip>
  is for latest version. we package it to scm-1

### Formats

TeX packages have two formats:

- source package `*.ctan.zip`, like:
  - lua: `*.src.rock`
  - python : sdist `*.tar.gz`
- binary package `*.tds.zip`, like:
  - lua: `*.any.rock`, `*.wi-x86_64.rock`
  - python: `*-any.whl`, `*-win_amd64.whl`

Like converting typescript to javascript, we need convert `*.ctan.zip`'s `*.dts`
and `*.ins` to `*.tds.zip`'s `*.cls` and `*.sty`. We package `*.tds.zip` to skip
converting, like `npmjs.org` packages only contain `*.js` not `*.ts`.

A lua package looks like:

- `~/.luarocks/share/lua/5.3/foo.lua`: lua module
- `~/.luarocks/lib/lua/5.3/foo.so`: lua binary module
- `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/bin/foo`: executable program
- `~/.luarocks/bin/foo`: a lua wrapper for above
- `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/doc/README.md`
- `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/doc/LICENSE`
- `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/foo-1.0.0-1.rockspec`: package
  build script
- `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/rock_manifest`: package
  manifest

We repackage `*.tds.zip` to:

- `doc/latex/foo/foo.pdf`:
  `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/doc/latex/foo/foo.pdf`
- `tex/latex/foo/foo.sty`:
  `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/tex/latex/foo/foo.sty`
- `tex/latex/foo/foo.cls`:
  `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/tex/latex/foo/foo.cls`
- `tex/latex/foo/foo.lua`:
  `~/.luarocks/share/lua/5.3/foo.lua`
- `source/foo/foo.dts`: skip source code of LaTeX
- `source/foo/foo.ins`: skip source code of LaTeX
- `source/foo/foo.teal`: skip source code of lua, see
  [tl](https://github.com/teal-language/tl)
- `source/foo/foo.ts`: skip source code of lua, see
  [TypeScriptToLua](https://github.com/TypeScriptToLua/TypeScriptToLua)
- `fonts/type1/foo/foo.pfb`:
  `~/.luarocks/lib/luarocks/rocks-5.3/foo/1.0.0-1/fonts/type1/foo/foo.pfb`
- `fonts/source/foo/foo.mf`: skip source code of metafont

### Dependencies

`*.tds.zip` doesn't have meta information about packages. when we create
`*.rockspec`, we need add it from [CTAN](https://ctan.org/).

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
  luatex --interaction=nonstopmode foo.dtx # or foo.ins, see its README.md
```

or:

```sh
l3build ctan
```

add `{ 'texrocks', 'luatex', 'latex-base' }` or `{ 'l3build', 'latex-base' }` to
`build_dependencies`.

## Credit

- [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim)
- [apltex](https://github.com/RadioNoiseE/apltex)
