# TeXRocks

[![readthedocs](https://shields.io/readthedocs/texrocks)](https://texrocks.readthedocs.io)
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

A minimal (La)TeX distribution powered by lux/luarocks and luaTeX.

## Tutorial

<!-- markdownlint-disable MD029 -->

1. Create a project

```sh
# answer some questions of lx
lx new my-thesis
cd my-thesis

```

A `lux.toml` will be created:

```toml
package = "my-thesis"
version = "0.1.0"
lua = "==5.3"

[description]
summary = "My thesis"
maintainer = "A TeX user"
labels = ["thesis"]
license = "GPL-3.0"
```

2. Add some dependencies

```sh
# LaTeX support
lx add -b lualatex
# \usepackage{hyperref}
lx add -b hyperref
# \usepackage{graphicx}
lx add -b graphics-cfg
# \usepackage{tikz}
lx add -b pgf
# lua-open main.pdf
lx add -t lua-open
# lx add -b more packages ...
```

`lux.toml`:

```toml
# ...
[build_dependencies]
lualatex = "X.Y.Z-1"
hyperref = "X.Y.Z-1"
graphics-cfg = "X.Y.Z-1"
pgf = "X.Y.Z-1"

[test_dependencies]
lua-open = "X.Y.Z-1"
```

3. Edit your document

```sh
$EDITOR main.tex
```

4. Tell `lx` how to build, install and open your document

`lux.toml`:

```toml
# ...
[build]
type = "command"
build_command = "lualatex --interaction=nonstopmode main.tex"

[build.install.conf]
'../doc/main.pdf' = 'main.pdf'

[test]
type = "command"
command = "lua-open"
flags = ["main.pdf"]
```

5. Build and view your document

```sh
lx build
lx test
```

This is your project structure:

```sh
$ tree -a
 .
├──  .lux  # like node_modules/ or .venv/ :)
│   ├──  .gitignore
│   └──  5.3  # pdf's dependencies are build dependencies not runtime
│       ├──  bin
│       ├──  build_dependencies
│       │   ├──  .gitignore
│       │   └──  5.3
│       │       ├──  bin
│       │       │   ├──  lualatex  # LaTeX compiler
│       │       │   └──  texlua  # Lua interpreter
│       │       ├──  1a043a1a092206fb664a8dd394bdf99e526af762fe7282c6ccf49bc0ec23521e-latex-base@2024.11.01-2
│       │       │   ├──  etc
│       │       │   │   ├──  conf
│       │       │   │   ├──  doc
│       │       │   │   │   └──  latex
│       │       │   │   │       └──  base
│       │       │   │   │           ├── ...
│       │       │   │   │           ├──  usrguide.pdf  # RTFM
│       │       │   │   │           └── ...
│       │       │   │   └──  tex
│       │       │   │       └──  latex
│       │       │   │           └──  base
│       │       │   │               ├── ...
│       │       │   │               ├──  article.cls  # \documentclass{article}
│       │       │   │               └── ...
│       │       │   ├──  lib
│       │       │   ├──  package.rockspec
│       │       │   └──  src
│       │       │       └──  ltluatex.lua
│       │       ├──  6fcffa0eeadc4a75dc246d6869dcfe79594d6e0114ece5b260b9216a3d40cdfb-amsfonts@3.04-1
│       │       │   ├──  etc
│       │       │   │   ├──  conf
│       │       │   │   ├──  doc
│       │       │   │   │   └──  fonts
│       │       │   │   │       └──  amsfonts
│       │       │   │   │           ├── ...
│       │       │   │   │           └── 󰂺 README
│       │       │   │   ├──  fonts
│       │       │   │   │   ├──  afm
│       │       │   │   │   │   └──  public
│       │       │   │   │   │       └──  amsfonts
│       │       │   │   │   │           ├──  cm  # computer modern fonts
│       │       │   │   │   │           │   └── ...
│       │       │   │   │   │           ├── ...
│       │       │   │   │   │           └──  symbols  # math symbol fonts
│       │       │   │   │   │               └── ...
│       │       │   │   │   └── ...  # more font types
│       │       │   │   └──  tex
│       │       │   │       ├──  latex
│       │       │   │       │   └──  amsfonts
│       │       │   │       │       ├──  amsfonts.sty  # \usepackage{amsfonts}
│       │       │   │       │       └── ...
│       │       │   │       └──  plain
│       │       │   │           └──  amsfonts
│       │       │   │               ├──  amssym.def
│       │       │   │               ├──  amssym.tex  # \input{amssym}
│       │       │   │               └──  cyracc.def
│       │       │   ├──  lib
│       │       │   ├──  package.rockspec
│       │       │   └──  src
│       │       ├── ... # more TeX packages
│       │       └──  lux.lock
│       ├──  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX-my-thesis@0.1.0-1
│       │   ├──  etc
│       │   │   ├──  conf
│       │   │   └──  doc
│       │   │       └──  main.pdf
│       │   ├──  lib
│       │   └──  src
│       ├──  lux.lock
│       └──  test_dependencies
│           ├──  .gitignore
│           └──  5.3
│               ├──  ...
│               └──  bin
│                   ├──  lua-open
│                   └──  texlua
├──  lux.lock  # like package-lock.json or requirements.txt
├──  lux.toml  # like package.json or pyproject.toml
└──  main.tex
```

See [documents](https://texrocks.readthedocs.io/) to know more.
