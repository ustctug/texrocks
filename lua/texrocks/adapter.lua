-- luacheck: ignore 143
---@diagnostic disable: undefined-field
local M         = {}
local constants = require "texrocks.constants"
local lfs       = require "lfs"
local gmatch    = string.gmatch

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

function M.sync(short)
    local dir = ".lux"
    if not lfs.isdir(dir) then
        dir = (os.getenv "XDG_DATA_HOME") .. "/lux/tree"
    end
    dir = dir .. "/" .. constants.LUA_VERSION
    if not lfs.isdir(dir) then
        lfs.mkdirp(dir)
    end
    local fontmap_name = dir .. "/" .. constants.fontmap_name
    local f = io.open(fontmap_name, 'w')
    if f == nil then
        print("fail to generate " .. fontmap_name)
        return
    end
    local fonts = {}

    local function walk(path)
        for file in lfs.dir(path) do
            if file:sub(1, 1) ~= '.' then
                local newpath = path .. '/' .. file
                if lfs.isdir(newpath) then
                    walk(newpath)
                elseif lfs.isfile(newpath) then
                    local ext = file:gsub(".*%.", "")
                    if ext == "pfb" or ext == "t3" then
                        table.insert(fonts, newpath)
                    end
                end
            end
        end
    end

    for _, path in ipairs(M.getpaths(package.path, "fonts")) do
        walk(path:gsub("//$", ""))
    end
    local lines = {}
    for _, font in ipairs(fonts) do
        local basename = font:gsub(".*/", '')
        local name = basename:gsub("%..*", '')
        local path = font
        if short then
            path = basename
        end
        table.insert(lines, string.format("%s %s <%s", name, name:upper(), path))
    end
    local str = string.format(constants.fontmap, table.concat(lines, "\n"))
    f:write(str)
    f:close()
end

function M.getpaths(path, suffix)
    local parts = {}
    for part in string.gmatch(path, "([^;]+)") do
        table.insert(parts, part)
    end
    local processed = {}
    local seen = {}
    for _, part in ipairs(parts) do
        local cleaned = part:gsub("/%?/init%.lua$", ""):gsub("/%?%.lua$", "")
        if seen[cleaned] == nil then
            local old = cleaned
            if suffix ~= "" then
                -- https://nvim-neorocks.github.io/explanations/lux-package-conflicts/#the-problem
                local root = cleaned:gsub("/src$", "")
                if root == suffix then
                    cleaned = ""
                else
                    cleaned = root .. '/etc/' .. suffix
                    if lfs.isdir(cleaned) then
                        cleaned = cleaned .. "//"
                    else
                        cleaned = ""
                    end
                end
            end
            if cleaned ~= "" then
                table.insert(processed, cleaned)
                seen[old] = true
            end
        end
    end
    return processed
end

function M.getenv(path, suffix)
    local processed = M.getpaths(path, suffix)
    return table.concat(processed, ";")
end

function M.setenv(key, value)
    if os.getenv(key) == nil then
        os.setenv(key, value)
    end
end

function M.setfontenv(key, value)
    os.setenv(key,
        "$TEXMFDOTDIR;" .. M.getenv(package.path, "fonts/" .. value) .. ";" .. M.OSFONTDIR)
end

if os.type == "windows" then
    M.OSFONTDIR = "C:/Windows/System32/Fonts"
elseif os.type == "unix" then
    if os.getenv "XDG_DATA_DIRS" ~= nil then
        M.OSFONTDIR = "{" .. os.getenv("XDG_DATA_DIRS"):gsub(":", ",") .. "}/share/fonts//"
    else
        local prefixes = { "/usr" }
        if os.getenv "PREFIX" ~= nil then
            prefixes = { os.getenv "PREFIX" }
        elseif os.name ~= "cygwin" then
            table.insert(prefixes, "/usr/local")
        elseif os.getenv "MINGW_PREFIX" ~= nil then
            table.insert(prefixes, os.getenv "MINGW_PREFIX")
        end
        M.OSFONTDIR = "{" .. table.concat(prefixes, ",") .. "}/share/fonts//"
    end
end
if os.name == "macosx" then
    M.OSFONTDIR = M.OSFONTDIR .. ";{/System,}/Library/Fonts//"
elseif os.name == "cygwin" then
    M.OSFONTDIR = M.OSFONTDIR .. ";/proc/cygdrive/c/Windows/System32/Fonts"
end

function M.setenvs()
    M.setenv("TEXMFDOTDIR", ".")
    if os.getenv "USERPROFILE" == nil then
        M.setenv("HOME", "~")
    else
        M.setenv("HOME", os.getenv "USERPROFILE")
    end
    -- https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
    M.setenv("XDG_CONFIG_HOME", (os.getenv "HOME") .. "/.config")
    M.setenv("XDG_DATA_HOME", (os.getenv "HOME") .. "/.local/share")
    M.setenv("XDG_CACHE_HOME", (os.getenv "HOME") .. "/.cache")
    -- some tex packages like hyperref support config file such as hyperref.cfg
    M.setenv("TEXMFCONFIG", "$XDG_CONFIG_HOME/texmf")
    M.setenv("TEXMFHOME", "$XDG_DATA_HOME/texmf")
    M.setenv("TEXMFVAR", "$XDG_CACHE_HOME/texmf")
    -- project setting > config > data > cache
    -- create ./*.cnf to override
    os.setenv("TEXMF", "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR")
    -- create ./texmf.cnf to override
    os.setenv("TEXMFCNF", "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR")

    os.setenv("LUAINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, ""))
    os.setenv("CLUAINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.cpath, ""))
    os.setenv("TEXINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "tex"))

    os.setenv("TEXFONTMAPS", "{.lux,$XDG_DATA_HOME/lux/tree}/" .. constants.LUA_VERSION)
    os.setenv("TEXFORMATS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "web2c"))
    -- font metrics
    M.setfontenv("TFMFONTS", "tfm")
    M.setfontenv("OFMFONTS", "ofm")
    -- luatex
    M.setfontenv("T1FONTS", "type1")
    M.setfontenv("OVFFONTS", "ovf")
    M.setfontenv("VFFONTS", "vf")
    -- luahbtex
    M.setfontenv("TTFONTS", "truetype")
    M.setfontenv("OPENTYPEFONTS", "opentype")
end

function M.run(args, short)
    M.setenvs()
    M.sync(short)
    if #args == 0 then
        args = { os.getenv "SHELL" or os.getenv "ComSpec" or "sh" }
    end
    os.exec(table.concat(args, ' '))
end

return M
