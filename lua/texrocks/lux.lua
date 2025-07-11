--- https://github.com/luarocks/luarocks/issues/747
local constants = require('texrocks.constants')
local M = {}

function M.cli(args)
    -- luacheck: ignore 143
    ---@diagnostic disable: undefined-field
    local luarocks_cmd = {
        "lx",
        "--lua-version=" .. constants.LUA_VERSION,
    }
    for _, arg in ipairs(args) do
        table.insert(luarocks_cmd, arg)
    end
    local f = io.popen(table.concat(luarocks_cmd, ' '))
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
