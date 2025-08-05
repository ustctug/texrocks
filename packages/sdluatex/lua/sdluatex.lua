local texrocks = require 'texrocks'
local M = {}
function M.main(args)
    -- publisher.spinit will read arg[2], arg[3]
    -- luacheck: ignore 121
    arg = texrocks.preparse(args)
    require 'sdini'
    require "publisher.spinit"
end

return M
