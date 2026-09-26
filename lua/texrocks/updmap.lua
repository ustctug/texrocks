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
    parser:option('--silent -s', 'decrease verbosity'):args(0):count('*')
    parser:option('--debug -d', 'increase verbosity'):args(0):count('*')
    return parser
end

---**entry for updmap**
---@param argv string[] command line arguments
function M.main(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    local verbosity = args.debug - args.silent
    M.sync(verbosity)
end

---get paths from `package.path`/`package.cpath`. see tests.
---@param dirname string? add `../${dirname}${suffix}` to paths when it is not nil
---@param suffix string?
---@param path string? paths concatenated by `;`
---@return string[] paths
function M.getpaths(dirname, suffix, path)
    suffix = suffix or '//'
    path = path or package.path
    local parts = {}
    local paths = {}
    for part in string.gmatch(path, "([^;]+)") do
        part = part:gsub("/%?.*", "")
        if not parts[part] then
            parts[part] = true
            if dirname then
                part = part:gsub("/src$", ""):gsub("/lib$", "") .. '/etc/' .. dirname
                -- for test
                if lfs.isdir == nil or lfs.isdir(part) then
                    part = part .. suffix
                    table.insert(paths, part)
                end
            else
                table.insert(paths, part)
            end
        end
    end
    return paths
end

---@param f table
---@param filename string
---@param verbosity integer verbosity level
function M.write(f, filename, verbosity)
    local t = io.open(filename)
    if t then
        if verbosity > 0 then
            print(filename)
        end
        f:write(t:read("*a"))
        t:close()
    end
end

---update font map file
---@param verbosity integer? verbosity level
function M.sync(verbosity)
    verbosity = verbosity or 0
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
    local template = debug.getinfo(1).source:match("@?(.*/)") .. 'templates/' .. M.fontmap_name
    M.write(f, template, verbosity)

    local function callback(filename)
        local ext = filename:match("%.([^.]+)$")
        if ext ~= "map" then
            return
        end
        M.write(f, filename, verbosity)
    end

    for _, path in ipairs(M.getpaths("fonts")) do
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
