local M = {}
local fs = require("luarocks.fs")
local path = require("luarocks.path")
local dir = require("luarocks.dir")

---core function
---@return true | nil, nil | string
function M.run(rockspec, no_install)
    local compile_temp_dir = fs.make_temp_dir("build-" .. rockspec.package .. "-" .. rockspec.version)
    if rockspec.build.variables == nil then
        rockspec.build.variables = {}
    end
    -- l3build uses texlua
    if not fs.execute_env(rockspec.build.variables, [[l3build install --texmfhome ]] .. compile_temp_dir) then
        return nil, "Failed run l3build"
    end
    if no_install then
        return true
    end

    local dir_sep = package.config:sub(1, 1)
    local luadir = path.lua_dir(rockspec.name, rockspec.version)
    local texdir = dir.path(compile_temp_dir, 'tex')
    if fs.is_dir(texdir) then
        for _, name in ipairs(fs.find(texdir)) do
            local file = dir.path(texdir, name)
            if not fs.is_dir(file) and (file:match("%.lua$") or file:match("%.tlu$")) then
                -- generic/pgf/lua/pgf/manual.lua -> pgf
                local mod = name:match('^[^/]+/([^/]+)')
                -- generic/pgf/lua/pgf/manual.lua -> lua/pgf/manual.lua
                name = name:match('^[^/]+/[^/]+/(.*)')
                -- lua/pgf/manual.lua -> lua/pgf/manual -> /pgf
                -- lua/pgf.lua -> lua/pgf -> /pgf
                if name:match('(.*)%.[^.]+$'):match(dir_sep .. mod) then
                    -- lua/pgf/manual.lua -> pgf/manual.lua
                    -- lua/pgf.lua -> pgf.lua
                    name = name:match('.*'.. dir_sep .. '(' .. mod .. '[' .. dir_sep ..  '.].*)')
                end
                local dst = dir.path(luadir, name)
                fs.make_dir(dir.dir_name(dst))
                fs.copy(file, dst)
            end
        end
    end
    local bindir = path.bin_dir(rockspec.name, rockspec.version)
    local scriptsdir = dir.path(compile_temp_dir, 'scripts')
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
                    local dst = dir.path(luadir, name:match('^[^/]+/(.*)'))
                    fs.make_dir(dir.dir_name(dst))
                    fs.copy(file, dst)
                end
            end
        end
    end
    local confdir = path.conf_dir(rockspec.name, rockspec.version)
    local rootdir = dir.dir_name(confdir)
    for _, name in ipairs(fs.find(compile_temp_dir)) do
        -- don't pack source code
        if not name:match('^source' .. dir_sep) and not name:match('^' .. dir.path('font', 'source') .. dir_sep) then
            local file = dir.path(compile_temp_dir, name)
            if not fs.is_dir(file) and not file:match("%.lua$") and not file:match("%.tlu$") then
                local dst = dir.path(rootdir, name)
                fs.make_dir(dir.dir_name(dst))
                fs.copy(file, dst)
            end
        end
    end
    return true
end

return M
