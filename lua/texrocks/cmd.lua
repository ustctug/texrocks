local argparse = require 'argparse'
local adapter = require "texrocks.adapter"
local luarocks = require "texrocks.luarocks"
local M = {}

---get parser
---@return table
local function get_parser()
    local parser = argparse("texrocks", "a package manager for lua(La)TeX")

    parser:command("run", "run luatex/lualatex/... with correct environment variables")
        :argument("args", "arguments"):args"*"
    parser:command("dump", "dump format file")
        :argument("fmt", "format name", "luatex")
    parser:command("install", "install a rock then synchronize")
        :argument("rock", "rock name", "")
    parser:command("remove", "remove a rock then synchronize")
        :argument("rock", "rock name", "")
    parser:command("list", "list all installed rocks")

    return parser
end

function M.main()
    local args = get_parser():parse()
    local cmd = ""
    if args.dump then
        cmd = "dump"
    elseif args.install then
        cmd = "install"
    elseif args.remove then
        cmd = "remove"
    elseif args.list then
        print(table.concat(luarocks.cli { 'list', args.rock }, "\n"))
        return
    end
    if args.dump then
        adapter.dump(args.fmt)
    end
    if args.run then
        adapter.run(args.args)
    end
    if args.rock ~= nil then
        print(table.concat(luarocks.cli { cmd, args.rock }, "\n"))
    end
    if args.install or args.remove then
        adapter.sync()
    end
end

return M
