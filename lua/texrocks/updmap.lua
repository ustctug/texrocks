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
    parser:option('--dry-run -n', 'no output'):args(0)
    return parser
end

---**entry for updmap**
---@param argv string[] command line arguments
function M.main(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    local verbosity = args.debug - args.silent
    M.sync(verbosity, args.dry_run)
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

---TODO: read from a config file
---@param filename string
---@return integer priority
function M.get_priority(filename)
    return #(filename:match("([^/]+)$") or "")
end

---compare priorities
---@param new string
---@param old string
---@return boolean
function M.is_prior(new, old)
    return M.get_priority(new) < M.get_priority(old)
end

---@param lines string[]
---@param seen table
---@param filename string
---@param verbosity integer verbosity level
function M.insert(lines, seen, filename, verbosity)
    local t = io.open(filename)
    if t == nil then
        return
    end
    if #lines > 0 then
        table.insert(lines, "")
        table.insert(lines, "%! " .. filename)
    end
    for line in t:lines() do
        local name = line:match("^[^%% ]+") or line
        if not seen[name] then
            table.insert(lines, line)
            seen[name] = { #lines, filename }
        else
            local old_number = seen[name][1]
            local old_line = lines[old_number]
            if old_line ~= line then
                local old_filename = seen[name][2]
                if M.is_prior(filename, old_filename) then
                    -- comment old
                    lines[old_number] = "%% " .. old_line
                    -- insert new
                    table.insert(lines, line)
                    seen[name] = { #lines, filename }
                end
                if name:sub(1, 1) ~= "%" then
                    if verbosity > 0 then
                        print(("%s"):format(name))
                    elseif verbosity > 1 then
                        print(("%s: %s is overridden by %s"):format(name, old_filename, filename))
                    end
                end
            end
        end
    end
    t:close()
end

---update font map file
---@param verbosity integer? verbosity level
---@param dry_run boolean? no output
function M.sync(verbosity, dry_run)
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
    local lines = {}
    local seen = {}
    M.insert(lines, seen, template, verbosity)

    local function callback(filename)
        local ext = filename:match("%.([^.]+)$")
        if ext ~= "map" then
            return
        end
        M.insert(lines, seen, filename, verbosity)
    end

    for _, path in ipairs(M.getpaths("fonts")) do
        M.walk(path:gsub("//$", ""), callback)
    end
    if not dry_run then
        f:write(table.concat(lines, "\n"))
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
