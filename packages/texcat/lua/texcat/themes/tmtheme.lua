---a class to wrap textmate theme
---@module texcat.themes.tmtheme
---@copyright 2025
local textmate = require 'textmate'
local T = require 'texcat.themes'
local M = {
    TMTheme = {}
}

---load extensions directories
---@param extensions_dir string[]
function M.load_extensions_dir(extensions_dir)
    for _, dir in ipairs(extensions_dir) do
        textmate.highlight_set_extensions_dir(dir .. '/extensions/')
    end
end

---@type TMTheme

---@param tmtheme table?
---@return table theme
function M.TMTheme:new(tmtheme)
    tmtheme = tmtheme or {}
    tmtheme.extensions_dir = tmtheme.extensions_dir or T.get_extensions_dir()
    M.load_extensions_dir(tmtheme.extensions_dir)
    local themes = textmate.highlight_themes() or {{''}}
    tmtheme.name = tmtheme.name or themes[1][1]
    tmtheme.id = tmtheme.id or textmate.highlight_load_theme(tmtheme.name)
    setmetatable(tmtheme, {
        __tostring = self.list_colors,
        __index = self
    })
    return tmtheme
end

setmetatable(M.TMTheme, {
    __call = M.TMTheme.new
})

---convert theme information to color map
---@return color_map color_map
function M.TMTheme.get_color_map()
    local theme = textmate.highlight_theme_info()
    -- FIXME: https://github.com/icedman/nvim-textmate/issues/10
    theme[22], theme[23], theme[24] = theme[23], theme[22] / 2, (theme[24] + 255) / 2
    theme[25], theme[26], theme[27] = (theme[25] + 255) / 2, theme[26], theme[27] / 2
    for k, v in ipairs(theme) do
        theme[k] = math.floor(v)
    end
    local color_map = {}
    -- FIXME: https://github.com/icedman/nvim-textmate/issues/10
    -- color_map.source = { theme[1], theme[2], theme[3] }
    color_map.source = { 0, 0, 0 }
    -- bg
    color_map.directive = { theme[7], theme[8], theme[9] }
    color_map.comment = { theme[10], theme[11], theme[12] }
    color_map['function'] = { theme[13], theme[14], theme[15] }
    color_map.keyword = { theme[16], theme[17], theme[18] }
    color_map.variable = { theme[19], theme[20], theme[21] }
    color_map.type = { theme[22], theme[23], theme[24] }
    color_map.struct = { theme[25], theme[26], theme[27] }
    color_map.control = { theme[28], theme[29], theme[30] }

    return color_map
end

---list all themes
---@return string information
function M.TMTheme.list()
    return T.list(textmate.highlight_themes())
end

---list all colors
---@return string information
function M.TMTheme:list_colors()
    textmate.highlight_set_theme(self.id)
    local color_map = self.get_color_map()
    local scopes = T.get_sorted_keys(color_map)
    local lines = {}
    for _, scope in ipairs(scopes) do
        table.insert(lines, scope .. ': ' .. table.concat(color_map[scope], ', '))
    end
    return table.concat(lines, "\n")
end

---get full color map
---@return color_map color_map
function M.TMTheme.get_full_color_map()
    local color_map = M.TMTheme.get_color_map()
    local link = T.get_scope_link()
    color_map = T.link_color_map(color_map, link)
    return color_map
end

return M
