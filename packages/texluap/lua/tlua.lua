---library for `tlua`
---@module tlua
local utils = require "prompt.utils"
local status = require'status'
local M = {}

---**entry for tlua**
---@param args string[] command line arguments
function M.main(args)
    utils.init()
    utils.source_configs()
    local parser = utils.get_parser()
    local cmd_args = parser:parse(args)
    if args.v then
        print(status.banner)
        os.exit(0)
    end
    utils.process_args(cmd_args, parser)
end

return M
