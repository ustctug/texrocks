local constants = require('texrocks.constants')
local M = {}

function M.cli(args)
    local cmdargs = {
        "lx",
        "--lua-version=" .. constants.LUA_VERSION,
        "--dev",
    }
    for _, arg in ipairs(args) do
        table.insert(cmdargs, arg)
    end
    local f = io.popen(table.concat(cmdargs, ' '))
    local lines = {}
    if f then
        for line in f:lines() do
            table.insert(lines, line)
        end
        f:close()
    end
    return lines
end

return M
