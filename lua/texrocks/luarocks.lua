--- https://github.com/luarocks/luarocks/issues/747
local config = require('texrocks.config')
local constants = require('texrocks.constants')
local M = {}

function M.cli(args)
    -- luacheck: ignore 143
    ---@diagnostic disable: undefined-field
    os.setenv('LUAROCKS_CONFIG', config.luarocks_config_path)
    local luarocks_cmd = {
        config.luarocks_binary,
        "--force-lock",
        "--lua-version=" .. constants.LUA_VERSION,
        "--tree=" .. config.rocks_path,
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
    os.setenv('LUAROCKS_CONFIG', nil)
    return lines
end

return M
