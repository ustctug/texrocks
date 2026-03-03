---wrap `lfs`
local lfs = require 'lfs'
if lfs.isdir then
    return lfs
end

---@param dir string
---@return boolean
function lfs.isdir(dir)
    local attr = lfs.attributes(dir)
    return attr and attr.mode == "directory"
end

---@param file string
---@return boolean
function lfs.isfile(file)
    local attr = lfs.attributes(file)
    return attr and attr.mode == "file"
end

---@param name string
---@return string
local function dirname(name)
    return name:match("(.*)[\\/][^\\/]+[\\/]?$") or name
end

---@param name string
function lfs.mkdirp(name)
    local parent = dirname(name)
    if not lfs.isdir(parent) then
        lfs.mkdirp(parent)
    end
    lfs.mkdir(name)
end

return lfs
