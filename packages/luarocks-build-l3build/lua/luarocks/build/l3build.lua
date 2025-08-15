local M = {}
local fs = require("luarocks.fs")
local path = require("luarocks.path")
local dir = require("luarocks.dir")

---core function
---@return true | nil, nil | string
function M.run(rockspec, no_install)
    if no_install then
        return true
    end
    local confdir = path.conf_dir(rockspec.name, rockspec.version)
    local rootdir = dir.dir_name(confdir)
    -- l3build uses texlua
    local p = io.popen([[l3build install --texmfhome ]] .. rootdir)
    if p then
        print(p:read '*a')
        p:close()
    end
    -- don't pack source code
    fs.delete(dir.path(rootdir, 'source'))
    fs.delete(dir.path(rootdir, 'fonts', 'source'))

    if fs.is_dir(dir.path(rootdir, 'scripts')) then
        local luadir = path.lua_dir(rockspec.name, rockspec.version)
        local bindir = path.bin_dir(rockspec.name, rockspec.version)
        for _, name in ipairs(fs.find(dir.path(rootdir, 'scripts'))) do
            local file = dir.path(rootdir, 'scripts', name)
            if not fs.is_dir(file) then
                local f = io.open(file)
                local line = ""
                if f then
                    line = f:read(2)
                    f:close()
                end
                if line == '#!' then
                    local exe = dir.base_name(file):gsub("%.lua$", ""):gsub("%.tlu$", "")
                    fs.copy(file, dir.path(bindir, exe), 'exec')
                else
                    fs.copy(file, luadir)
                end
            end
        end
        fs.delete(dir.path(rootdir, 'scripts'))
    end
    return true
end

return M
