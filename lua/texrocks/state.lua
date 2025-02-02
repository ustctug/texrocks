local luarocks = require("texrocks.luarocks")

local M = {}
function M.installed_rocks()
    local installed_rock_list = table.concat(luarocks.cli{'list', '--porcelain'}, " ")
    local rocks = {}
    for name, version, target_version in installed_rock_list:gmatch("(%S+)%s+(%S+)%s+(%S+)%s+%S+") do
        -- Exclude -<specrev> from versions
        rocks[name] = {
            name = name,
            version = version:match("([^-]+)"),
            target_version = target_version:match("([^-]+)"),
        }
    end

    return rocks
end

return M
