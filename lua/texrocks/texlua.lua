---library for `luatex`, `lualatex`, `luatexinfo` and `texlua`
---@module texrocks.texlua
---@copyright 2025
---@diagnostic disable: undefined-field
-- luacheck: ignore 143
local updmap = require "texrocks.updmap"
local M = {}

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

---@param args string[]
---@return string[]
function M.callback(args)
    if args.v then
        print(require 'status'.banner)
        os.exit(0)
    end
    return args
end

---@param args string[] command line arguments
---@param extra_offset integer? extra offset
---@return string[] args parsed result
function M.parse(args, extra_offset)
    local offset = M.get_offset(args)
    if offset == nil then
        require 'prompt.utils'.main(arg, nil, M.callback)
        os.exit()
    end

    return M.shift(args, offset + (extra_offset or 0))
end

---**entry for texlua**
---@param argv string[] `arg`
function M.main(argv)
    -- luacheck: ignore 121
    arg = M.parse(argv)

    M.setenvs()
    -- progname should be texlua
    M.setotherenv(updmap.name(argv[0]))
    loadfile(arg[0])()
end

---call `os.setenv()` when environment variable doesn't exist
---@param key string
---@param value string
function M.setenv(key, value)
    if os.getenv(key) == nil then
        os.setenv(key, value)
    end
end

---concatenate `getpaths()`
---@param path string same as `getpaths()`
---@param suffix string? same as `getpaths()`
---@return string path concatenated by `;`
---@see getpaths
function M.getenv(path, suffix)
    local processed = updmap.getpaths(path, suffix)
    return table.concat(processed, ";")
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
        "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR;" ..
        debug.getinfo(1).source:match("@?(.*/)") .. 'templates')
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

return M
