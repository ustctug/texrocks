---Some generic utilities for themes
local lfs = require 'lfs'
local M = {
    scope_link = {
        -- ignore punctuation, spell, _*
        import = 'directive',
        module = 'struct',
        string = 'directive',
        number = 'struct',
        constant = 'type',
        operator = 'control',
        constructor = 'function',
    }
}

---list themes or syntaxes
---@param data string[][]
---@return string information
function M.list(data)
    local lines = {}
    for _, theme in ipairs(data) do
        table.insert(lines, theme[1] .. ': ' .. theme[3] .. "\n" .. theme[2])
    end
    return table.concat(lines, "\n\n")
end

---get scope link
---@return link link
function M.get_scope_link()
    ---@alias hl_name string
    ---@type table<hl_name, scope[]>
    local hl_scope_map = {}
    for _, scope_hl in ipairs(require 'nvim-textmate.colormap'.scope_hl_map) do
        local scope, hl = scope_hl[1], scope_hl[2]
        if hl_scope_map[hl] == nil then
            hl_scope_map[hl] = {}
        end
        table.insert(hl_scope_map[hl], scope)
    end

    local link = M.scope_link
    for _, scopes in pairs(hl_scope_map) do
        for i = 2, #scopes do
            link[scopes[i]] = scopes[1]
        end
    end
    return link
end

---link color map
---@param color_map color_map
---@param link link
---@return color_map color_map
function M.link_color_map(color_map, link)
    for src, dst in pairs(link) do
        if color_map[dst] then
            color_map[src] = color_map[dst]
        else
            color_map[dst] = color_map[src]
        end
    end
    return color_map
end

---get extensions directories
---@return string[]
function M.get_extensions_dir()
    local home = os.getenv 'HOME' or os.getenv 'USERPROFILE' or '.'
    local prefix = os.getenv 'PREFIX' or os.getenv 'MINGW_PREFIX' or '/run/current-system/sw'
    if not lfs.isdir(prefix) then
        prefix = '/usr'
    end
    local dirs = { home .. '/.vscode', prefix .. '/lib/nvim', prefix .. '/share/nvim/runtime',
        '/usr/local/lib/nvim', '/usr/local/share/nvim/runtime' }
    for path in package.cpath:gmatch("([^;]+)/lib/%?") do
        table.insert(dirs, path .. '/etc')
    end
    return dirs
end

---sort dictionary's keys
---@param input table
---@return table names
function M.get_sorted_keys(input)
    local names = {}
    for name, _ in pairs(input) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

---list all links
---@return string
function M.list_links()
    local link = M.get_scope_link()
    local scopes = M.get_sorted_keys(link)
    local lines = {}
    for _, scope in ipairs(scopes) do
        table.insert(lines, scope .. ' -> ' .. link[scope])
    end
    return table.concat(lines, "\n")
end

return M
