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
texrocks install luatex-fmt
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

Hello, \LaTeX!

\end{document}
```

```sh
texrocks install lualatex-fmt
lualatex examples/tex/latex/main.tex
```

More [required packages](https://ctan.org/pkg/required) is
[WIP](https://luarocks.org/m/texmf).

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

## Credit

- [rocks.nvim](https://github.com/nvim-neorocks/rocks.nvim)
- [apltex](https://github.com/RadioNoiseE/apltex)
