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

function M.sync_luatex_map()
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

function M.sync()
    M.sync_texmf_cnf()
    M.sync_luatex_map()
end

function M.getenv(path, suffix)
    local parts = {}
    for part in string.gmatch(path, "([^;]+)") do
        table.insert(parts, part)
    end
    local processed = {}
    local seen = {}
    for _, part in ipairs(parts) do
        local cleaned = part:gsub("/%?%.lua$", ""):gsub("/%?/init%.lua$", "")
        if not seen[cleaned] and cleaned ~= "" then
            if suffix ~= "" then
                -- https://nvim-neorocks.github.io/explanations/lux-package-conflicts/#the-problem
                local root = cleaned:gsub("/src$", "")
                if root == suffix then
                    cleand = ""
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
                seen[cleaned] = true
            end
        end
    end
    return table.concat(processed, ";")
end

function M.setenv()
    os.setenv("LUAINPUTS", M.getenv(package.path, ""))
    os.setenv("CLUAINPUTS", M.getenv(package.cpath, ""))
    os.setenv("TEXINPUTS", M.getenv(package.path, "tex"))
end

function M.run(args)
    M.setenv()
    local p = io.popen(table.concat(args, ' '))
    if p then
        print(p:read "*a")
        p:close()
    end
end

function M.dump(fmt)
    M.setenv()
    local p = io.popen(table.concat({ "which", arg[ -1] }, ' '))
    local bin = p:read("*a"):gsub("\n$", "")
    p:close()
    local exe = fmt
    if bin:gsub("%.exe$", '') ~= bin then
        exe = exe .. ".exe"
    end
    p = io.popen(table.concat({ "cp", bin, exe }, ' '))
    p:close()
    local cmdargs = {
        './' .. fmt,
        '--ini',
        "--interaction=nonstopmode",
        fmt .. ".ini"
    }
    p = io.popen(table.concat(cmdargs, ' '))
    if p then
        print(p:read "*a")
        p:close()
    end
end

return M
