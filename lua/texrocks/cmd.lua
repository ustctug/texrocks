local argparse = require 'argparse'
local adapter = require "texrocks.adapter"
local luarocks = require "texrocks.luarocks"
local M = {}

---get parser
---@return table
local function get_parser()
    local parser = argparse("texrocks", "a package manager for lua(La)TeX")

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
    if args.install then
        cmd = "install"
    elseif args.remove then
        cmd = "remove"
    elseif args.list then
        print(table.concat(luarocks.cli { 'list', args.rock }, "\n"))
        return
    end
    if args.rock ~= '' then
        print(table.concat(luarocks.cli { cmd, args.rock }))
    end
    if args.install or args.remove then
        adapter.sync()
    end
end

return M
