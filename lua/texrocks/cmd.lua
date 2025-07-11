local argparse = require 'argparse'
local adapter = require "texrocks.adapter"
local luarocks = require "texrocks.lux"
local M = {}

---get parser
---@return table
local function get_parser()
    local parser = argparse("texrocks", "a package manager for lua(La)TeX")

    parser:command("run", "run luatex/lualatex/... with correct environment variables")
        :argument("args", "arguments"):args "*"
    parser:command("dump", "dump format file")
        :argument("fmt", "format name", "luatex")
    parser:command("install", "install a rock")
        :argument("rock", "rock name", "")
    parser:command("uninstall", "uninstall a rock")
        :argument("rock", "rock name", "")
    parser:command("list", "list all installed rocks")

    return parser
end

function M.main()
    local args = get_parser():parse()
    local cmd = ""
    if args.install then
        cmd = "install"
    elseif args.uninstall then
        cmd = "uninstall"
    elseif args.list then
        cmd = "list"
    elseif args.dump then
        adapter.dump(args.fmt)
    elseif args.run then
        adapter.run(args.args)
    end
    if cmd ~= "" then
        luarocks.cli { cmd, args.rock }
    end
end

return M
