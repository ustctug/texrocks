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
    local p = io.popen(table.concat(cmdargs, ' '))
    if p then
        print(p:read("*a"))
        p:close()
    end
end

return M
