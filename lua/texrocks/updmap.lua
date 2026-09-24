---library for `updmap`
---@module texrocks.updmap
---@copyright 2026
local lfs      = require "lfs"
local argparse = require 'argparse'
local M        = {
    fontmap_name = "pdftex.map"
}

---get parser
---@param progname string program name
---@return table parser
function M.get_parser(progname)
    local parser = argparse(progname):add_complete()
    parser:option('--verbose', 'with full name'):args(0)
    return parser
end

---**entry for updmap**
---@param argv string[] command line arguments
function M.main(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    M.sync(not args.verbose)
end

---get paths from `package.path`/`package.cpath`. see tests.
---@param path string paths concatenated by `;`
---@param suffix string? add `../${suffix}//` to paths when it is not nil
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

---base name without extension name
---@param path string
---@return string path
function M.name(path)
    return path:match('/([^/.]+)%.?[^/]*$')
end

---update font map file
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
    local template = debug.getinfo(1).source:match("@?(.*/)") .. 'templates' .. M.fontmap_name
    local t = io.open(template)
    if t then
        f:write(t:read("*a"))
        t:close()
    end

    local function callback(file)
        local ext = file:match("%.([^.]+)$")
        if ext ~= "pfb" and ext ~= "t3" then
            return
        end
        local basename = file:match('/([^/]+)$')
        local path = file
        if short then
            path = basename
        end
        local name = M.name(file)
        f:write(string.format("%s %s <%s\n", name, name:upper(), path))
    end

    for _, path in ipairs(M.getpaths(package.path, "fonts")) do
        M.walk(path:gsub("//$", ""), callback)
    end
    f:close()
end

---walk all directories except
---@param dir string
---@param callback function
function M.walk(dir, callback)
    if lfs.isdir(dir) then
        for file in lfs.dir(dir) do
            if file ~= "." and file ~= ".." then
                M.walk(dir .. '/' .. file, callback)
            end
        end
    else
        callback(dir)
    end
end

return M
