local utils = require "prompt.utils"
local M = {}

function M.main(args)
    utils.init()
    utils.source_configs()
    local parser = utils.get_parser()
    local cmd_args = parser:parse(args)
    utils.process_args(cmd_args, parser)
end

return M
