local M             = {}
local config        = require "texrocks.config"
local state         = require "texrocks.state"
local constants     = require "texrocks.constants"
local cfg           = require "luarocks.core.cfg"
local lfs           = require "lfs"
local lfsattributes = lfs.attributes
local gmatch        = string.gmatch

-- FIXME: don't know why luahbtex miss it
-- copied from luatex/source/texk/web2c/luatexdir/lua/luatex-core.lua
if not lfs.mkdirp then
    function lfs.mkdirp(path)
        local full = ""
        local r1, r2, r3
        for sub in gmatch(path, "(/*[^\\/]+)") do
            full = full .. sub
            r1, r2, r3 = lfs.mkdir(full)
        end
        return r1, r2, r3
    end
end

if not lfs.isfile then
    function lfs.isfile(name)
        local m = lfsattributes(name, "mode")
        return m == "file" or m == "link"
    end
end

if not lfs.isdir then
    function lfs.isdir(name)
        local m = lfsattributes(name, "mode")
        return m == "directory"
    end
end

local function get_rock_dir(rock)
    return table.concat({ config.rocks_path, "lib", "luarocks", "rocks-" .. constants.LUA_VERSION, rock.name }, "/")
end

local function get_rock_path(rock)
    local rock_dir = get_rock_dir(rock)
    for file in lfs.dir(rock_dir) do
        -- ignore hidden files
        if file:sub(1, 1) ~= '.' then
            local path = table.concat({ rock_dir, file }, "/")
            if lfs.attributes(path).mode == 'directory' then
                return path
            end
        end
    end
    return ""
end

local function get_rock_paths()
    local paths = {}
    for _, rock in pairs(state.installed_rocks()) do
        table.insert(paths, get_rock_path(rock))
    end
    return paths
end

function M.sync_texmf_cnf()
    local web2c = os.getenv('HOME') .. '/.local/share/texmf/web2c'
    lfs.mkdirp(web2c)
    local f = io.open(web2c .. '/texmf.cnf', 'w')
    if f == nil then
        return
    end
    local str = string.format(constants.texmf_cnf, table.concat(get_rock_paths(), ','))
    f:write(str)
    f:close()
end

function M.sync_luatex_map()
    local fonts = {}

    local function walk(path)
        for file in lfs.dir(path) do
            if file:sub(1, 1) ~= '.' then
                local newpath = path .. '/' .. file
                if lfs.isdir(newpath) then
                    walk(newpath)
                elseif lfs.isfile(newpath) and file:gsub(".*%.", "") == "pfb" then
                    table.insert(fonts, newpath)
                end
            end
        end
    end

    for _, path in ipairs(get_rock_paths()) do
        local type1_dir = path .. '/fonts/'
        if lfs.isdir(type1_dir) then
            walk(type1_dir)
        end
    end
    local lines = {}
    for _, font in ipairs(fonts) do
        local name = font:gsub(".*/", ''):gsub("%..*", '')
        table.insert(lines, string.format("%s %s <%s", name, name:upper(), font))
    end
    local map_dir = os.getenv('HOME') .. '/.local/share/texmf/fonts/map'
    lfs.mkdirp(map_dir)
    local f = io.open(map_dir .. '/luatex.map', 'w')
    if f == nil then
        return
    end
    local str = string.format(constants.luatex_map, table.concat(lines, "\n"))
    f:write(str)
    f:close()
end

---https://github.com/luarocks/luarocks/discussions/1737
function M.fix()
    cfg.init()
    cfg.root_dir = cfg.root_dir or cfg.rocks_trees[1].root
    local target_bin_dir = cfg.root_dir .. '/bin'
    for _, path in ipairs(get_rock_paths()) do
        local bin_dir = path .. '/bin'
        for _, bin_name in ipairs { 'l3build', 'texdoc', 'texlua',
            'luatex', 'luahbtex', 'lualatex', 'texluap', 'hbtexluap' } do
            local bin = bin_dir .. '/' .. bin_name
            if lfs.isfile(bin) then
                local target_bin = target_bin_dir .. '/' .. bin_name
                if lfs.isfile(target_bin) then
                    os.remove(target_bin)
                end
                lfs.link(bin, target_bin, true)
            end
        end
    end
end

function M.sync()
    M.sync_texmf_cnf()
    M.sync_luatex_map()
    M.fix()
end

return M
