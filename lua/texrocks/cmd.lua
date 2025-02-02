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

    return parser
end

function M.main()
    local args = get_parser():parse()
    local cmd = ""
    if args.install then
        cmd = "install"
    elseif args.remove then
        cmd = "remove"
    end
    if args.rock ~= '' then
        luarocks.cli { cmd, args.rock }
    end
    adapter.sync()
end

return M
