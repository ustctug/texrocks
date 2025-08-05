---library for `sdluatex`
---@module sdluatex
---@copyright 2025
local texrocks = require 'texrocks'
local M = {}

---**entry for sdluatex**
---`publisher.spinit` will read `arg[2]`, `arg[3]`
---@param args string[] `arg`
function M.main(args)
    -- luacheck: ignore 121
    arg = texrocks.preparse(args, -1)
    require 'sdini'
    require "publisher.spinit"
end

return M
