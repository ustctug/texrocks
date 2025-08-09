---library for `luatex`, `lualatex`, `luatexinfo` and `texlua`
---@module texrocks
---@copyright 2025
---@diagnostic disable: undefined-field
-- luacheck: ignore 143
local lfs = require "lfs"

local M   = {
    fontmap_name = "luatex.map"
}

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

---base name without extension name
---@param path string
---@return string path
function M.name(path)
    return path:match('/([^/.]+)%.?[^/]*$')
end

---get the first non-nil element's index
---@param args string[] index can be negative
---@return integer begin begin index
function M.get_begin_index(args)
    local begin = -1
    while args[begin] do
        begin = begin - 1
    end
    begin = begin + 1
    return begin
end

---texlua has a behaviour about command line arguments.
---`arg` starts from index 0: `arg = {[0] = "ls", "-al"}`
---`os.exec()` starts from index 1: `os.exec{"ls", "-al"}`
---we need to shift it
---@param argv string[] command line arguments
---@param offset integer e.g., `-1` means `args[i + 1] = args[i]`
---@return string[] args
function M.shift(argv, offset)
    local begin = M.get_begin_index(argv)

    local args = {}
    for i = begin, #argv do
        args[i - offset] = argv[i]
    end
    return args
end

---call `os.setenv()` when environment variable doesn't exist
---@param key string
---@param value string
function M.setenv(key, value)
    if os.getenv(key) == nil then
        os.setenv(key, value)
    end
end

---get paths from `package.path`/`package.cpath`. see tests.
---@param path string paths concatenated by `;`
---@param suffix string | nil add `../${suffix}//` to paths when it is not nil
---@return string[] paths
function M.getpaths(path, suffix)
    local parts = {}
    local paths = {}
    for part in string.gmatch(path, "([^;]+)") do
        part = part:gsub("/%?.*", "")
        if not parts[part] then
            parts[part] = true
            if suffix then
                part = part:gsub("/src$", ""):gsub("/lib$", "") .. '/etc/' .. suffix
                -- for test
                if lfs.isdir == nil or lfs.isdir(part) then
                    part = part .. "//"
                    table.insert(paths, part)
                end
            else
                table.insert(paths, part)
            end
        end
    end
    return paths
end

---concatenate `getpaths()`
---@param path string same as `getpaths()`
---@param suffix string | nil same as `getpaths()`
---@return string path concatenated by `;`
---@see getpaths
function M.getenv(path, suffix)
    local processed = M.getpaths(path, suffix)
    return table.concat(processed, ";")
end

---**entry for texlua**
---@param args string[] `arg`
function M.main(args)
    M.setenvs()
    -- progname should be texlua
    M.setotherenv(M.name(args[0]))

    -- luacheck: ignore 121
    arg = M.preparse(args)
    loadfile(arg[0])()
end

---wrap `os.setenv()` for font files due to `OSFONTDIR`
---@param key string
---@param value string
function M.setfontenv(key, value)
    os.setenv(key,
        "$TEXMFDOTDIR;" .. M.getenv(package.path, "fonts/" .. value) .. ";" .. M.OSFONTDIR)
end

---set environment variables for kpathsea
---@source ../packages/kpathsea/lua/kpathsea.lua
function M.setenvs()
    M.setenv("TEXMFDOTDIR", ".")
    if os.getenv "USERPROFILE" == nil then
        M.setenv("HOME", "~")
    else
        M.setenv("HOME", os.getenv "USERPROFILE")
    end
    -- https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
    if os.getenv "LOCALAPPDATA" == nil then
        M.setenv("XDG_CONFIG_HOME", (os.getenv "HOME") .. "/.config")
    else
        M.setenv("XDG_CONFIG_HOME", os.getenv "LOCALAPPDATA")
    end
    if os.getenv "APPDATA" == nil then
        M.setenv("XDG_DATA_HOME", (os.getenv "HOME") .. "/.local/share")
    else
        M.setenv("XDG_CONFIG_HOME", os.getenv "APPDATA")
    end
    if os.getenv "TEMP" == nil then
        M.setenv("XDG_CACHE_HOME", (os.getenv "HOME") .. "/.cache")
    else
        M.setenv("XDG_CACHE_HOME", os.getenv "TEMP")
    end
    -- some tex packages like hyperref support config file such as hyperref.cfg
    M.setenv("TEXMFCONFIG", "$XDG_CONFIG_HOME/texmf")
    M.setenv("TEXMFHOME", "$XDG_DATA_HOME/texmf")
    M.setenv("TEXMFVAR", "$XDG_CACHE_HOME/texmf")
    -- project setting > config > data > cache
    -- create ./*.cnf to override
    os.setenv("TEXMF", "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR")
    -- create ./texmf.cnf to override lua/texrocks/texmf.cnf
    os.setenv("TEXMFCNF",
        "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR;" .. debug.getinfo(1).source:match("@?(.*)/") .. '/texrocks')
    os.setenv("TEXMFDBS", "")

    os.setenv("LUAINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path))
    os.setenv("CLUAINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.cpath))
    os.setenv("TEXINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "tex"))
    os.setenv("BIBINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "bibtex/bib"))
    os.setenv("MLBIBINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "bibtex/mlbib"))
    os.setenv("BSTINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "bibtex/bst"))
    os.setenv("MLBSTINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "bibtex/mlbst"))
    os.setenv("RISINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "biber/ris"))
    os.setenv("BLTXMLINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "biber/bltxml"))
    os.setenv("TEXINDEXSTYLE", "$TEXMFDOTDIR;" .. M.getenv(package.path, "makeindex"))
    os.setenv("MFTINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "mft"))
    os.setenv("MPINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "mp"))
    os.setenv("OCPINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "omega/ocp"))
    os.setenv("OTPINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "omega/otp"))
    os.setenv("WEBINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "web"))
    os.setenv("CWEBINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "cweb"))

    os.setenv("TEXFORMATS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "web2c"))
    os.setenv("TEXDOCS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "doc"))
    os.setenv("TEXSOURCES", "$TEXMFDOTDIR;" .. M.getenv(package.path, "source"))
    os.setenv("MFINPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "fonts/source"))
    os.setenv("MPSUPPORT", "$TEXMFDOTDIR;" .. M.getenv(package.path, "metapost/support"))
    os.setenv("TEXPICTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "images"))
    os.setenv("TEXPOOL", "$TEXMFDOTDIR;" .. M.getenv(package.path, "web2c"))
    os.setenv("TEXPSHEADERS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "dvips"))
    os.setenv("WEB2C", "$TEXMFDOTDIR;" .. M.getenv(package.path, "web2c"))
    os.setenv("TEXMFSCRIPTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "scripts"))

    os.setenv("TEXCONFIG", "$TEXMFDOTDIR;" .. M.getenv(package.path, "conf/dvips"))
    os.setenv("PDFTEXCONFIG", "$TEXMFDOTDIR;" .. M.getenv(package.path, "conf/pdftex"))

    os.setenv("TEXFONTMAPS", ".lux;$XDG_DATA_HOME/lux/tree")
    -- font metrics
    M.setfontenv("TFMFONTS", "tfm")
    M.setfontenv("OFMFONTS", "ofm")
    -- luatex
    M.setfontenv("T1FONTS", "type1")
    M.setfontenv("OVFFONTS", "ovf")
    M.setfontenv("OVPFONTS", "ovp")
    M.setfontenv("VFFONTS", "vf")
    -- luahbtex
    M.setfontenv("TTFONTS", "truetype")
    M.setfontenv("OPENTYPEFONTS", "opentype")
    -- other fonts
    -- /usr/share/groff/{current/font,site-font}/devps
    M.setfontenv("TRFONTS", "groff")
    M.setfontenv("GFFONTS", "gf")
    M.setfontenv("PKFONTS", "pk")
    M.setfontenv("OPLFONTS", "opl")
    M.setfontenv("T42FONTS", "type42")
    M.setfontenv("MISCFONTS", "misc")
    M.setfontenv("ENCFONTS", "enc")
    M.setfontenv("CMAPFONTS", "cmap")
    M.setfontenv("SFDFONTS", "sfd")
    M.setfontenv("LIGFONTS", "lig")
    M.setfontenv("FONTFEATURES", "fea")
    M.setfontenv("FONTCIDMAPS", "cid")
end

---set environment variables for `kpsewhich --show-path 'other text files'`
---@param progname string read <https://texdoc.org/serve/kpathsea/0>
function M.setotherenv(progname)
    M.setenv(progname:upper() .. "INPUTS", "$TEXMFDOTDIR;" .. M.getenv(package.path, "conf"))
end

---get offset from one script to another script
---such as `texlua --option main.lua --option` -> `main.lua --option`
---offset should be 2
---@param args string[] command line arguments
---@return integer offset
function M.get_offset(args)
    local offset
    for i, v in ipairs(args) do
        local char = v:sub(1, 1)
        -- skip \macro and --option
        if char ~= "\\" and char ~= "-" then
            offset = i
            break
        end
    end
    return offset
end

---refer `parse`
---@see parse
---@param args string[] command line arguments
---@param extra_offset integer | nil extra offset
---@return string[] args parsed result
function M.preparse(args, extra_offset)
    local offset = M.get_offset(args)
    if offset == nil then
        error("haven't support")
        os.exit(1)
    end

    return M.shift(args, offset + (extra_offset or 0))
end

---**entry for luatex**
---@param argv string[] `arg`
function M.run(argv)
    local args = M.parse(argv)
    M.setotherenv(M.get_program_name(args))
    M.sync(false)
    M.exec(args)
end

---luahbtex --luaonly texlua luatex:
---texlua will call preparse(), then loadfile("luatex")()
---luatex will call parse(), then os.exec{[0]="luatex", "luahbtex"}
---@param argv string[] command line arguments
---@return string[] args parsed result
---@see preparse
function M.parse(argv)
    local args = M.shift(argv, -1)
    local begin = M.get_begin_index(args)
    args[0] = args[begin]
    return args
end

---see <https://texdoc.org/serve/luatex/0>'s command line options
---@param args string[] command line arguments not `arg`
---@return string progname
function M.get_program_name(args)
    -- --progname is latter first
    for i = #args, 2, -1 do
        if args[i]:match("^--progname=") then
            local progname = args[i]:gsub("^--progname=", "")
            return progname
        elseif args[i - 1] == "--progname" then
            return args[i]
        end
    end

    -- --fmt/--ini is former first
    local opt
    for i = 2, #args do
        if args[i]:match("^--fmt=") then
            local progname = args[i]:gsub("^--fmt=", "")
            return progname
        elseif args[i] == "--fmt" or args[i] == "--ini" then
            opt = args[i]
        elseif args[i]:match("^%-") == args[i]:match("^\\") then
            if opt == "--fmt" then
                return args[i]
            elseif opt == "--ini" then
                local progname = args[i]:gsub(".*/", ""):gsub("%.*", "")
                return progname
            end
        end
    end

    -- usually be luahbtex
    return M.name(args[1])
end

---update font map file: `.lux/luatex.map`
---@param short boolean use relative (short)/absolute (long) path for font files
function M.sync(short)
    local dir = ".lux"
    if not lfs.isdir(dir) then
        lfs.mkdir(dir)
    end
    local fontmap_name = dir .. "/" .. M.fontmap_name
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
    local template = debug.getinfo(1).source:match("@?(.*)/") .. '/texrocks/' .. M.fontmap_name
    local t = io.open(template)
    if t then
        f:write(t:read("*a"))
        t:close()
    end
    f:write(table.concat(lines, "\n"))
    f:close()
end

---texlua's `os.exec()` will not exec when meet error
---we wrap it to add `os.exit()`
---@param args string[] command line arguments
function M.exec(args)
    local _, msg, code = os.exec(args)
    error(msg)
    -- 2: No such file or directory
    -- nil: invalid command line passed
    os.exit(code or 1)
end

---escape and concatenate command line arguments for printing
---@param args string[] command line arguments
---@return string cmd command line
function M.get_cmd(args)
    local cmd = {}
    for _, v in ipairs(args) do
        v = v:gsub(" ", "\\ ")
        table.insert(cmd, v)
    end
    return table.concat(cmd, " ")
end

return M
