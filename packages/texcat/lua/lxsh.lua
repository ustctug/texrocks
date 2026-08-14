---API for lxsh
---@module lxsh
---@copyright 2025
local render_source = require "texcat".render_source
local M = {
    formatters = { html = 'html', latex = 'latex', terminal = 'terminal' },
    highlighters = {}
}

---@param _ table
---@param language string
function M.get_highlighter(_, language)
    return function(source, args)
        return render_source(language, source, args)
    end
end

setmetatable(M.highlighters, { __index = M.get_highlighter })
return M
