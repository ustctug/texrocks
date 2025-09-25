---a class to wrap treesitter parsers and queries
---@module texcat.syntaxes.treesitter
---@copyright 2025
local lfs = require 'lfs'
local ltreesitter = require 'ltreesitter'
local T = require 'texcat.themes'
local M = {
    Treesitter = {}
}

---get tree-sitter parser, wrap `ltreesitter.require()`
---@param name string
---@param extensions_dir string[]
---@return table parser
function M.require(name, extensions_dir)
    local paths = {}
    local ext = package.cpath:match('[^.]+;?$')
    for _, dir in ipairs(extensions_dir) do
        dir = dir:gsub('/etc$', '/lib') .. '/?.' .. ext
        table.insert(paths, dir)
    end
    local cpath = package.cpath
    package.cpath = table.concat(paths, ';')
    local parser = ltreesitter.require(name)
    package.cpath = cpath
    return parser
end

---search parsers or queries
---@param extensions_dir string[]
---@param subdir string
---@return table parsers
function M.search(extensions_dir, subdir)
    local parsers = {}
    for _, dir in ipairs(extensions_dir) do
        dir = dir .. '/' .. subdir
        if lfs.isdir(dir) then
            for path in lfs.dir(dir) do
                local lang = path:match('([^.]+)%.')
                if lang then
                    parsers[lang] = dir .. '/' .. path
                end
            end
        elseif lfs.isfile(dir) then
            return { dir }
        end
    end
    return parsers
end

---get tree-sitter syntax information
---@param parser table
---@param name string
---@param extensions_dir string[]
---@return table query
function M.get_syntax(parser, name, extensions_dir)
    local filename = M.search(extensions_dir, 'queries/' .. name .. '/highlights.scm')[1]
    local f = io.open(filename)
    local code = ''
    if f then
        code = f:read '*a'
        f:close()
    end
    code = M.filter_query(code)
    return parser:query(code)
end

---remove neovim's query syntax
---@param code string
function M.filter_query(code)
    code = code:gsub('%(#set!%s+[^)]+%)', '')
        :gsub('%(#lua%-match%?%s+%S+%s+"[^"]+"%)', '')
        :gsub('%(#any%-of%?%s+[^)]+%)', '')
        :gsub('%(#has%-ancestor%?%s+[^)]+%)', '')
    return code
end

---add child scopes to color map
---@param color_map color_map
---@param captures capture[]
---@alias color_map table<string, integer[]>
function M.add_scope(color_map, captures)
    for _, capture in ipairs(captures) do
        local scope = capture.scope
        while scope do
            if color_map[scope] then
                color_map[capture.scope] = color_map[scope]
                break
            end
            -- get parent scope: punctuation.bracket -> punctuation
            scope = scope:match('(.*)%.[^.]+$')
        end
    end
    return color_map
end

-- remove captures without color
---@param captures capture[]
---@param color_map color_map
---@return capture[] captures
function M.filter_captures(captures, color_map)
    local new_captures = {}
    for _, capture in ipairs(captures) do
        if color_map[capture.scope] then
            table.insert(new_captures, capture)
        end
    end
    return new_captures
end

---cut captures to make them unoverlapped
---@param len integer text length
---@param captures capture[]
---@return capture[] captures
function M.cut_captures(captures, len)
    local index_set = { [1] = true }
    for _, capture in ipairs(captures) do
        index_set[capture.start_index] = true
        index_set[capture.end_index + 1] = true
    end
    local indices = {}
    for i = 1, len do
        if index_set[i] then
            table.insert(indices, i)
        end
    end
    ---@alias range {start_index: integer, end_index: integer, scope: string, len: integer}
    local ranges = {}
    for i = 1, #indices - 1 do
        table.insert(ranges, { start_index = indices[i], end_index = indices[i + 1] - 1, scope = 'source', len = len })
    end
    table.insert(ranges, { start_index = indices[#indices], end_index = len, scope = 'source', len = len })

    for _, range in ipairs(ranges) do
        for _, capture in ipairs(captures) do
            local length = capture.end_index - capture.start_index + 1
            if capture.start_index <= range.start_index and
                range.end_index <= capture.end_index and range.len > length then
                range.len = length
                range.scope = capture.scope
            end
        end
    end

    return ranges
end

---@type Treesitter

---@param treesitter table?
---@return table treesitter
function M.Treesitter:new(treesitter)
    treesitter = treesitter or {}
    treesitter.name = treesitter.name or 'lua'
    treesitter.extensions_dir = treesitter.extensions_dir or T.get_extensions_dir()
    treesitter.parser = treesitter.parser or M.require(treesitter.name, treesitter.extensions_dir)
    treesitter.query = treesitter.query or M.get_syntax(treesitter.parser, treesitter.name, treesitter.extensions_dir)
    setmetatable(treesitter, {
        __index = self
    })
    return treesitter
end

setmetatable(M.Treesitter, {
    __call = M.Treesitter.new
})

---capture text as captures according to theme
---@param text string
---@param theme table
---@return capture[] captures
function M.Treesitter:capture(text, theme)
    local tree = self.parser:parse_string(text)
    local node = tree:root()
    local captures = {}
    for capture, name in self.query:capture(node) do
        -- lua index start from 1
        table.insert(captures,
            { start_index = capture:start_byte() + 1, end_index = capture:end_byte(), scope = name })
    end
    local color_map = theme.get_full_color_map()
    color_map = M.add_scope(color_map, captures)
    captures = M.filter_captures(captures, color_map)
    captures = M.cut_captures(captures, #text)
    return captures
end

function M.Treesitter:list()
    local parsers = M.search(self.extensions_dir, 'parser')
    local langs = T.get_sorted_keys(parsers)
    local lines = {}
    for _, lang in ipairs(langs) do
        table.insert(lines, lang .. ': ' .. parsers[lang])
    end
    return table.concat(lines, "\n\n")
end

---detect file type
---TODO: /usr/share/nvim/runtime/lua/vim/filetype.lua
---@param filename string
---@return string ft
function M.Treesitter.detect(filename)
    return require 'texcat.syntaxes.tmlanguage'.TMLanguage.detect(filename)
end

return M
