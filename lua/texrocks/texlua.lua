---library for `texlua`
---@module texrocks.texlua
---@copyright 2025
---@diagnostic disable: undefined-field
-- luacheck: ignore 143
local updmap = require "texrocks.updmap"
local M = {}

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
    if offset ~= 1 then
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
    M.setotherenv("texlua")
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
---@param dirname string? same as `getpaths()`
---@param path string? same as `getpaths()`
---@param suffix string?
---@return string path concatenated by `;`
function M.getenv(dirname, suffix, path)
    local processed = updmap.getpaths(dirname, suffix, path)
    return table.concat(processed, ";")
end

---@return string prefixes
function M.get_prefixes()
    if os.type ~= "unix" then
        return ""
    end
    local ret
    if os.getenv "XDG_DATA_DIRS" ~= nil then
        ret = os.getenv("XDG_DATA_DIRS"):gsub(":", ",")
    else
        local prefixes = { "/usr" }
        if os.getenv "PREFIX" ~= nil then
            prefixes = { os.getenv "PREFIX" }
        elseif os.name ~= "cygwin" then
            table.insert(prefixes, "/usr/local")
        elseif os.getenv "MINGW_PREFIX" ~= nil then
            table.insert(prefixes, os.getenv "MINGW_PREFIX")
        end
        ret = table.concat(prefixes, ",")
    end
    return "{" .. ret .. "}"
end

---get OSFONTDIR for XeTeX
function M.get_osfontdir()
    local osfontdir = ""
    if os.type == "windows" then
        osfontdir = "C:/Windows/System32/Fonts"
    elseif os.type == "unix" then
        osfontdir = M.get_prefixes() .. "/share/fonts//"
    end
    if os.name == "macosx" then
        osfontdir = osfontdir .. ";{/System,}/Library/Fonts//"
    elseif os.name == "cygwin" then
        osfontdir = osfontdir .. ";/proc/cygdrive/c/Windows/System32/Fonts"
    end
    return osfontdir
end

---set environment variables for kpathsea
---@source ../packages/kpathsea/lua/kpathsea.lua
function M.setenvs()
    M.setenv("TEXMFDOTDIR", ".")
    M.setenv("HOME", os.getenv "HOME" or os.getenv "USERPROFILE" or "~")
    -- https://wiki.archlinux.org/title/XDG_Base_Directory#Partial
    M.setenv("XDG_CONFIG_HOME", os.getenv "LOCALAPPDATA" or (os.getenv("HOME") .. "/.config"))
    M.setenv("XDG_DATA_HOME", os.getenv "LOCALAPPDATA" or (os.getenv "HOME") .. "/.local/share")
    M.setenv("XDG_CACHE_HOME", os.getenv "TEMP" or (os.getenv "HOME") .. "/.cache")
    -- some tex packages like hyperref support config file such as hyperref.cfg
    M.setenv("TEXMFCONFIG", "$XDG_CONFIG_HOME/texmf")
    M.setenv("TEXMFHOME", "$XDG_DATA_HOME/texmf")
    M.setenv("TEXMFVAR", "$XDG_CACHE_HOME/texmf")
    -- project setting > config > data > cache
    -- create ./*.cnf to override
    os.setenv("TEXMF", "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR")
    -- create ./texmf.cnf to override lua/texrocks/texmf.cnf
    os.setenv("TEXMFCNF", "$TEXMFDOTDIR;$TEXMFCONFIG;$TEXMFHOME;$TEXMFVAR;" ..
        debug.getinfo(1).source:match("@?(.*/)") .. 'templates')
    -- don't use ls-R
    os.setenv("TEXMFDBS", "")

    os.setenv("CLUAINPUTS", "$TEXMFDOTDIR;" .. M.getenv(nil, "//", package.cpath))
    os.setenv("LUAINPUTS", "$TEXMFDOTDIR;" .. M.getenv(nil))
    os.setenv("TEXINPUTS", "$TEXMFDOTDIR;" .. M.getenv("tex"))
    os.setenv("BIBINPUTS", "$TEXMFDOTDIR;" .. M.getenv("bibtex/bib"))
    os.setenv("MLBIBINPUTS", "$TEXMFDOTDIR;" .. M.getenv("bibtex/mlbib"))
    os.setenv("BSTINPUTS", "$TEXMFDOTDIR;" .. M.getenv("bibtex/bst"))
    os.setenv("MLBSTINPUTS", "$TEXMFDOTDIR;" .. M.getenv("bibtex/mlbst"))
    os.setenv("RISINPUTS", "$TEXMFDOTDIR;" .. M.getenv("biber/ris"))
    os.setenv("BLTXMLINPUTS", "$TEXMFDOTDIR;" .. M.getenv("biber/bltxml"))
    os.setenv("TEXINDEXSTYLE", "$TEXMFDOTDIR;" .. M.getenv("makeindex"))
    os.setenv("MFTINPUTS", "$TEXMFDOTDIR;" .. M.getenv("mft"))
    os.setenv("MPINPUTS", "$TEXMFDOTDIR;" .. M.getenv("mp"))
    os.setenv("OCPINPUTS", "$TEXMFDOTDIR;" .. M.getenv("omega/ocp"))
    os.setenv("OTPINPUTS", "$TEXMFDOTDIR;" .. M.getenv("omega/otp"))
    os.setenv("WEBINPUTS", "$TEXMFDOTDIR;" .. M.getenv("web"))
    os.setenv("CWEBINPUTS", "$TEXMFDOTDIR;" .. M.getenv("cweb"))

    os.setenv("TEXFORMATS", "$TEXMFDOTDIR;" .. M.getenv("web2c", "{/$engine,}"))
    os.setenv("TEXDOCS", "$TEXMFDOTDIR;" .. M.getenv("doc"))
    os.setenv("TEXSOURCES", "$TEXMFDOTDIR;" .. M.getenv("source"))
    os.setenv("MFINPUTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/source"))
    os.setenv("MPSUPPORT", "$TEXMFDOTDIR;" .. M.getenv("metapost/support"))
    os.setenv("TEXPICTS", "$TEXMFDOTDIR;" .. M.getenv("images"))
    os.setenv("TEXPOOL", "$TEXMFDOTDIR;" .. M.getenv("web2c"))
    os.setenv("TEXPSHEADERS", "$TEXMFDOTDIR;" .. M.getenv("dvips"))
    os.setenv("WEB2C", "$TEXMFDOTDIR;" .. M.getenv("web2c"))

    os.setenv("TEXMFSCRIPTS", os.getenv("PATH"):gsub(":", ";"))
    os.setenv("TEXCONFIG", "$TEXMFDOTDIR;" .. M.getenv("conf/dvips"))
    os.setenv("PDFTEXCONFIG", "$TEXMFDOTDIR;" .. M.getenv("conf/pdftex"))

    -- updmap
    os.setenv("TEXFONTMAPS", "$TEXMFDOTDIR;.lux;$XDG_DATA_HOME/lux/tree;" .. M.getenv("fonts/map"))
    -- PDFTeX
    -- PLFONTS is TFMFONTS
    os.setenv("TFMFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/tfm"))
    os.setenv("T1FONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/type1"))
    os.setenv("PKFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/pk"))
    os.setenv("VFFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/vf"))
    -- XeTeX
    os.setenv("OSFONTDIR", "$TEXMFDOTDIR;" .. M.get_osfontdir())
    -- Omega
    os.setenv("OPLFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/opl"))
    os.setenv("OFMFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/ofm"))
    os.setenv("OVPFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/ovp"))
    os.setenv("OVFFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/ovf"))
    -- LuaLaTeX
    os.setenv("TTFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/truetype") .. ";$OSFONTDIR")
    os.setenv("OPENTYPEFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/opentype") .. ";$OSFONTDIR")
    -- groff
    os.setenv("TRFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/groff") .. ";" ..
        M.get_prefixes() .. "/groff/{current/font,site-font}/devps")
    -- others
    os.setenv("GFFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/gf"))
    os.setenv("T42FONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/type42"))
    os.setenv("MISCFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/misc"))
    os.setenv("ENCFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/enc"))
    os.setenv("CMAPFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/cmap"))
    os.setenv("SFDFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/sfd"))
    os.setenv("LIGFONTS", "$TEXMFDOTDIR;" .. M.getenv("fonts/lig"))
    os.setenv("FONTFEATURES", "$TEXMFDOTDIR;" .. M.getenv("fonts/fea"))
    os.setenv("FONTCIDMAPS", "$TEXMFDOTDIR;" .. M.getenv("fonts/cid"))
end

---set environment variables for `kpsewhich --show-path 'other text files'`
---@param progname string read <https://texdoc.org/serve/kpathsea/0>
function M.setotherenv(progname)
    M.setenv(progname:upper() .. "INPUTS", "$TEXMFDOTDIR;" .. M.getenv("conf"))
end

return M
