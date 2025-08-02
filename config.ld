---ldoc config
---@diagnostic disable: lowercase-global
-- luacheck: ignore 111
project = "texrocks"
title = "TeXRocks, a minimal (La)TeX distribution"
format = "markdown"
dir = "_readthedocs/html"
template = "assets/html"
readme = {"README.md", "docs", "_readthedocs/markdown"}
file = {
    "lua",
    "_readthedocs/lua",
}
description = title
full_description = [[
## Quick Start

First coming?

- [tutorial](topics/README.md.html): the steps to build a TeX project
- [install and configure](topics/install.md.html): read it before all examples
- [drawing a graph](topics/demo-tikz.md.html): an example
- [use bibliography](topics/demo-bib.md.html): another example

## Learn More

Know what is under the hood.

- [principle](topics/principle.md.html):

## TeX Dialects

Which TeX you want to use?

## TeX Tools

Some useful tools for development!

## Others

- [manifest](https://luarocks.org/m/texmf): list all current TeX packages
- [rocks](https://ustctug.github.io/texrocks/): some packages cost many time to build. We provide compiled packages for them!
- [repository](https://github.com/ustctug/texrocks): git repository, also include this website.
]]
