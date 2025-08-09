---@diagnostic disable: lowercase-global
-- luacheck: ignore 111 113
loadfile('../../build.lua')()
sourcefiles = {
    "bin",
    "lua",
    ".lux/5.3/*/lib",
    ".lux/5.3/*/src",
    ".lux/5.3/test_dependencies/*-vscode-extensions@*/src",
    ".lux/5.3/test_dependencies/*-tree-sitter-*@*/lib",
    ".lux/5.3/test_dependencies/*-tree-sitter-*@*/etc/queries",
}
