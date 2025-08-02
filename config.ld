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
