---https://github.com/drivendataorg/repro-zipfile/pull/23
local lfs = require("texrocks.lfs")
local ZipWriter = require "ZipWriter"

local M = {
    -- Unix permission
    file_modes = {
        -- normal file
        [0] = tonumber("644", 8),
        -- executable file
        tonumber("755", 8),
        -- directory
        tonumber("755", 8) + tonumber("40000", 8)
    },
    Entry = {
        filename   = ".",
        chunk_size = 1024,
        istext     = true,
        isfile     = true,
        isdir      = false,
        mtime      = 315532800,
        platform   = 'unix',
        exattrib   = {
            ZipWriter.NIX_FILE_ATTR.IFREG,
            ZipWriter.NIX_FILE_ATTR.IWUSR,
            ZipWriter.NIX_FILE_ATTR.IRUSR,
            ZipWriter.NIX_FILE_ATTR.IRGRP,
            ZipWriter.NIX_FILE_ATTR.IROTH,
        },
    }
}

---@param path string
---@return boolean
function M.is_executable(path)
    local attr = lfs.attributes(path) or {}
    local perms = attr.permissions or ""
    if #perms < 10 then
        return false
    end
    return perms:sub(4, 4) == "x" or
        perms:sub(7, 7) == "x" or
        perms:sub(10, 10) == "x"
end

---@param entry table?
---@return table entry
function M.Entry:new(entry)
    entry = entry or {}
    setmetatable(entry, {
        __index = self
    })
    if lfs.isdir(entry.filename) then
        entry.isdir    = true
        entry.isfile   = false
        entry.istext   = false
        entry.exattrib = {
            ZipWriter.NIX_FILE_ATTR.IFDIR,
            ZipWriter.NIX_FILE_ATTR.IWUSR,
            ZipWriter.NIX_FILE_ATTR.IRUSR,
            ZipWriter.NIX_FILE_ATTR.IRGRP,
            ZipWriter.NIX_FILE_ATTR.IROTH,
            ZipWriter.NIX_FILE_ATTR.IXUSR,
            ZipWriter.NIX_FILE_ATTR.IXGRP,
            ZipWriter.NIX_FILE_ATTR.IXOTH,
        }
    elseif M.is_executable(entry.filename) then
        entry.istext = false
        entry.exattrib = {
            ZipWriter.NIX_FILE_ATTR.IFREG,
            ZipWriter.NIX_FILE_ATTR.IWUSR,
            ZipWriter.NIX_FILE_ATTR.IRUSR,
            ZipWriter.NIX_FILE_ATTR.IRGRP,
            ZipWriter.NIX_FILE_ATTR.IROTH,
            ZipWriter.NIX_FILE_ATTR.IXUSR,
            ZipWriter.NIX_FILE_ATTR.IXGRP,
            ZipWriter.NIX_FILE_ATTR.IXOTH,
        }
    end
    entry.mtime = os.getenv "SOURCE_DATE_EPOCH" or entry.mtime
    return entry
end

setmetatable(M.Entry, {
    __call = M.Entry.new
})

function M.Entry:add(writer)
    local f = assert(io.open(self.filename, 'rb'))
    local reader = self.reader or function()
        local chunk = f:read(self.chunk_size)
        if chunk then return chunk end
        f:close()
    end
    writer:write(self.filename, self, self.isfile and reader, self.comment)
end

---@param filename string
---@param entries table[]
---@return string? err
function M.zip_entries(filename, entries)
    local f, err = io.open(filename, 'wb')
    if f == nil then
        return err
    end
    local writer = ZipWriter.new()
    writer:open_stream(f, true)
    for _, entry in ipairs(entries) do
        entry:add(writer)
    end
    writer:close()
end

---@param path string
---@param callback fun(entry: table)
function M.call(path, callback)
    local entry = M.Entry { filename = path }
    callback(entry)
    if entry.isdir then
        for file in lfs.dir(path) do
            if file ~= "." and file ~= ".." then
                M.call(path .. "/" .. file, callback)
            end
        end
    end
end

---@param filename string
---@param ... string
function M.zip(filename, ...)
    local entries = {}
    for _, path in ipairs { ... } do
        M.call(path, function(entry)
            table.insert(entries, entry)
        end)
    end
    local err = M.zip_entries(filename, entries)
    if err then
        print(err)
    end
end

---@param args string[]
function M.main(args)
    local filename
    local entries = {}
    for _, path in ipairs(args) do
        if path:sub(1, 1) ~= "-" then
            if filename == nil then
                filename = path
            else
                M.call(path, function(entry)
                    table.insert(entries, entry)
                end)
            end
        end
    end
    local err = M.zip_entries(filename, entries)
    if err then
        print(err)
    end
end

return M
