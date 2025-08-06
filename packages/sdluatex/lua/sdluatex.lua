---library for `sdluatex`
---@module sdluatex
---@copyright 2025
local texrocks = require 'texrocks'
local M = {}

---**entry for sdluatex**
---`publisher.spinit` will read `arg[2]`, `arg[3]`
---@param argv string[] `arg`
function M.main(argv)
    -- luacheck: ignore 121
    arg = texrocks.preparse(argv, -1)
    require 'sdini'
    require "publisher.spinit"
end

return M
