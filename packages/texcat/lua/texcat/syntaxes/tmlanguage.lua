local T = require 'texcat.themes'
local textmate = require 'textmate'
local M = {
    TMLanguage = {}
}

---@param tmlanguage table?
---@return table language
function M.TMLanguage:new(tmlanguage)
    tmlanguage = tmlanguage or {}
    tmlanguage.name = tmlanguage.name or 'lua'
    tmlanguage.id = tmlanguage.id or textmate.highlight_load_syntax(tmlanguage.name)
    setmetatable(tmlanguage, {
        __index = self
    })
    return tmlanguage
end

setmetatable(M.TMLanguage, {
    __call = M.TMLanguage.new
})

---list all languages
---@return string information
function M.TMLanguage.list()
    return T.list(textmate.highlight_languages())
end

---FIXME: https://github.com/icedman/nvim-textmate/issues/11
---@param text string
---@param theme table
---@return capture[] captures
---@alias capture {start_index: integer, end_index: integer, scope: string}
function M.TMLanguage:capture(text, theme)
    local captures = {}
    textmate.highlight_set_theme(theme.id)
    textmate.highlight_set_syntax(self.id)
    local results = textmate.highlight_line(text, theme.id, self.id, 0)
    for _, result in ipairs(results) do
        local idx, len, _, _, _, scope = result[1] + 1, result[2], result[3], result[4], result[5], result
            [6]
        table.insert(captures, { start_index = idx, end_index = idx + len - 1, scope = scope })
    end
    return captures
end

---detect file type
---@param filename string
---@return string ft
function M.TMLanguage.detect(filename)
    local ext = filename:match('(%.[^.]+)$')
    for _, data in ipairs(textmate.highlight_languages()) do
        if ext == data[3] then
            return data[1]
        end
    end
end

return M
