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
TeXRocks is a minimal (La)TeX distribution powered by Luarocks/Lux and LuaTeX.

It has the following features:

- virtual environment: all TeX packages are installed to
`.lux/5.3/XXXXX-package_name@version/`, like nodejs's `node_modules/` and
python's `.venv/`. After development of PDF, You can delete it safely, and it
will not affect your next development of PDF.
- minimal: we only install required packages
- package version control: when you declare `latex-base == "2025.06.01-1"`, it
will install <https://luarocks.org/modules/freed-wu/latex-base/2025.06.01-1> not
other versions! pin the version like nodejs's `package.json` and python's
`requirements.txt`
- package installation in parallel: install many packages at the same time
- a server to host compiled TeX packages: <https://ustctug.github.io/texrocks/>
- use lua to develop TeX packages: <https://luarocks.org/m/texmf>

We also provide some related TeX tools, like kpsewhich and texdef written in
lua. See official website <https://texrocks.readthedocs.io/>

## Quick Start

First coming?

- [tutorial](topics/README.md.html): the steps to build a TeX project
- [install and configure](topics/install.md.html): read it before all examples
- [draw a graph](topics/demo-tikz.md.html): an example for LaTeX
- [use bibliography](topics/demo-bib.md.html): another example for LaTeX
- [write markdown](topics/demo-markdown.md.html): try markdown!

## TeX Dialects

Which TeX do you want to use?

- [plainTeX](topics/luatex.md.html): first TeX
- [LaTeX](topics/lualatex.md.html): most people needed TeX
- [TeXinfo](topics/luatexinfo.md.html): GNU's TeX
- [A toy TeX](topics/initex.md.html): how to create a new TeX dialect?

TODO:

- [publisher](https://github.com/speedata/publisher/)
- ConTeXt

## TeX Tools

Some useful tools for development!

### Developed by others

- l3build: a tool to test/build/pack TeX packages developed by LaTeX 3 team
- texdoc: a tool to search document of any TeX package developed by TeX Live
  team. It needs an extra [configuration](topics/texdoc.md.html).
- luafindfont: a simple tool to search fonts

### Developed by ours

- [tlua](topics/texluap.md.html): a texlua more like lua
- [lua-open](topics/lua-open.md.html): view your PDF
- [texdef](topics/texdef.md.html): which TeX package defines `\macro`?
- [kpsewhich](topics/kpathsea.md.html): where is TeX package XXX?

TODO:

- [epstopdf](https://ctan.org/pkg/epstopdf): convert eps to pdf for
    `\includegraphics{XXX.eps}`. So far you have to convert it by yourself:
    `gs -sOutputFile=XXX.pdf XXX.eps` then `\includegraphics{XXX.pdf}`.
- [latexmk](https://github.com/debian-tex/latexmk): read XXX.log to decide if
    rerun TeX compiler. So far you have to rerun lualatex by yourself.

## Learn More

Know what is under the hood.

- [How to pack a TeX package](topics/pack.md.html): More TeX packages are
  needed: CTAN ~3000 v.s. <https://ustctug.github.io/texrocks/> ~100.
  Welcome to pack!
- [How texrocks work](topics/principle.md.html): see its principle.
- [Roadmap](topics/roadmap.md.html): which features texrocks have supported and
  will support?

## Others

- [manifest](https://luarocks.org/m/texmf): list all current TeX packages
- [rocks](https://ustctug.github.io/texrocks/): some packages cost many time to build. We provide compiled packages for them!
- [repository](https://github.com/ustctug/texrocks): git repository, also include this website.
]]
