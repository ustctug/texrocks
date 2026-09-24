---utilities
---@module texrocks
---@copyright 2026
---@diagnostic disable: undefined-field
-- luacheck: ignore 143
local M = {}

---texlua's `os.exec()` will not exec when meet error
---we wrap it to add `os.exit()`
---@param args string[] command line arguments
function M.exec(args)
    local _, msg, code = os.exec(args)
    error(msg)
    -- 2: No such file or directory
    -- nil: invalid command line passed
    os.exit(code or 1)
end

---escape and concatenate command line arguments for printing
---@param args string[] command line arguments
---@return string cmd command line
function M.get_cmd(args)
    local cmd = {}
    for _, v in ipairs(args) do
        v = string.format("%q", v)
        table.insert(cmd, v)
    end
    return table.concat(cmd, " ")
end

return M
