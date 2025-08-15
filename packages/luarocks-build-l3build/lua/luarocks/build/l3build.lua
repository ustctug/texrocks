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
    if not fs.execute_string([[l3build install --texmfhome ]] .. rootdir) then
        return nil, "Failed run l3build"
    end
    -- don't pack source code
    fs.delete(dir.path(rootdir, 'source'))
    fs.delete(dir.path(rootdir, 'fonts', 'source'))

    local luadir = path.lua_dir(rockspec.name, rockspec.version)
    local bindir = path.bin_dir(rockspec.name, rockspec.version)
    local scriptsdir = dir.path(rootdir, 'scripts')
    if fs.is_dir(scriptsdir) then
        for _, name in ipairs(fs.find(scriptsdir)) do
            local file = dir.path(scriptsdir, name)
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
        fs.delete(scriptsdir)
    end
    local texdir = dir.path(rootdir, 'tex')
    if fs.is_dir(texdir) then
        for _, name in ipairs(fs.find(texdir)) do
            local file = dir.path(texdir, name)
            if not fs.is_dir(file) and (file:match("%.lua$") or file:match("%.tlu$")) then
                fs.copy(file, luadir)
                fs.delete(file)
            end
        end
    end
    return true
end

return M
