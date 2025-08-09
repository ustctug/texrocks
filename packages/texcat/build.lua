---@diagnostic disable: lowercase-global
-- luacheck: ignore 111 113
loadfile('../../build.lua')()
sourcefiles = {
    "bin",
    ".lux/5.3/*/lib",
    ".lux/5.3/*/src",
    ".lux/5.3/test_dependencies/5.3/*-tree-sitter-*/lib",
    ".lux/5.3/test_dependencies/5.3/*-tree-sitter-*/etc/queries",
    ".lux/5.3/test_dependencies/5.3/*-vscode-extensions*/etc/extensions",
}
