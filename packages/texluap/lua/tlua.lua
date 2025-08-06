---library for `tlua`
---@module tlua
---@copyright 2025
local utils = require "prompt.utils"
local status = require'status'
local M = {}

---**entry for tlua**
---@param argv string[] command line arguments
function M.main(argv)
    utils.init()
    utils.source_configs()
    local parser = utils.get_parser()
    local args = parser:parse(argv)
    if args.v then
        print(status.banner)
        os.exit(0)
    end
    utils.process_args(args, parser)
end

return M
