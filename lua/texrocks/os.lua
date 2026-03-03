---wrap `os`
local os = require 'os'
---@diagnostic disable-next-line: undefined-field
if os.setenv then
    return os
end

os.name = require 'posix.sys.utsname'.uname()

---@param key string
---@param value string
function os.setenv(key, value)
    require 'posix.stdlib'.setenv(key, value)
end

---@param argt string[]
---@return integer
function os.exec(argt)
    local path = argt[0] or argt[1]
    local _, _, ret = require 'posix.unistd'.exec(path, argt)
    return ret
end

return os
