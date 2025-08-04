---library for lua-open
---@module open
---@copyright 2025
---@diagnostic disable: undefined-field
-- luacheck: ignore 143
local lfs = require 'lfs'
local texrocks = require 'texrocks'

local M = {}

---get file path according to `lux.toml`
---@param file string PDF file name
---@return string file PDF file path
function M.get_path(file)
    if lfs.isfile(file) then
        return file
    end
    if not lfs.isfile('lux.toml') then
        error(string.format("%s cannot be found", file))
        os.exit(1)
    end
    local f = io.open("lux.toml")
    if f == nil then
        os.exit(1)
    end
    local text = f:read("*a")
    f:close()
    local data = require 'toml'.parse(text)
    local cwd
    if data.package == nil or data.version == nil then
        os.exit(1)
    end
    local pkg = string.format("%s@%s", data.package, data.version)
    if data.version:match("-") == nil then
        pkg = pkg .. "-1"
    end
    for path in package.path:gmatch("[^;]+") do
        if path:match("%-" .. pkg:gsub("%-", "%%-")) then
            cwd = path:gsub("/%?.*", ""):gsub("/src$", "/etc/conf")
            break
        end
    end
    if cwd == nil then
        error(string.format("%s cannot be found", pkg))
        os.exit(2)
    end
    local path
    for dst, src in pairs(data.build.install.conf) do
        if src == file then
            path = dst
            break
        end
    end
    if path == nil then
        error(string.format("%s's %s still cannot be found", pkg, file))
        os.exit(3)
    end
    return table.concat({ cwd, path }, '/')
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

---use correct system tool to open PDF
---@param file string PDF file path
---@return string[] args command line arguments
function M.get_cmd_args(file)
    if os.name == 'macosx' then
        return { "open", file }
    elseif os.name == 'windows' or os.name == 'cygwin' then
        return { "start", file }
    elseif os.getenv "PREFIX" then
        return { "termux-open", file }
    elseif file:gsub(".*%.", "") == "pdf" and os.getenv "DISPLAY" == nil then
        return { "pdftotext", file, "-" }
    else
        return { "xdg-open", file }
    end
end

---**entry for lua-open**
---@param args string[] command line arguments
function M.main(args)
    local file = M.get_path(args[1])
    local cmd_args = M.get_cmd_args(file)
    if file ~= args[1] then
        print('$ ' .. M.get_cmd(cmd_args))
    end
    texrocks.exec(cmd_args)
end

return M
