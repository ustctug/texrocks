local argparse = require 'argparse'
local adapter = require "texrocks.adapter"
local constants = require "texrocks.constants"
local M = {}

---get parser
---@return table
local function get_parser()
    local parser = argparse("texrocks", "a package manager for lua(La)TeX")

    parser:option("--short", "use short path in " .. constants.fontmap_name):args(0)
    parser:argument("args", "arguments"):args "*"

    return parser
end

function M.main()
    local args = get_parser():parse()
    adapter.run(args.args, args.short)
end

return M
