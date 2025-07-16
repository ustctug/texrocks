local argparse = require 'argparse'
local adapter = require "texrocks.adapter"
local constants = require "texrocks.constants"
local M = {}

---get parser
---@return table
local function get_parser()
    local parser = argparse("texrocks", "a package manager for lua(La)TeX")

    parser:option("--dump", "dump format file")
    parser:option("--short", "use short path in " .. constants.fontmap_name):args(0)
    parser:argument("args", "arguments"):args "*"

    return parser
end

function M.main()
    local args = { args = {}, short = true }
    local cmd = arg[1]
    if cmd ~= nil and (cmd:gsub("^-", "") == cmd or cmd == "--short") then
        local short = arg[1] == "--short"
        if short then
            for i, v in ipairs(arg) do
                if i ~= 1 then
                    table.insert(args.args, v)
                end
            end
        else
            args = { args = arg, short = short }
        end
    else
        args = get_parser():parse()
    end
    if args.dump then
        adapter.dump(args.dump)
    else
        adapter.run(args.args, args.short)
    end
end

return M
