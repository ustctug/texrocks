---a class to render
---@module texcat.renderer
---@copyright 2025
---@diagnostic disable: undefined-global
-- luacheck: ignore 111 113
local template = require 'template'
local warna = require 'warna'
warna.options.level = 3

local T = require 'texcat.themes'
local Theme = require 'texcat.themes.tmtheme'.TMTheme
local Syntax = require 'texcat.syntaxes.treesitter'.Treesitter
local M = {
    -- protect escape
    protect_map = {
        bs = [[\]],
        ob = [[{]],
        cb = [[}]],
    },
    -- directly escape
    escape_map = {
        us = [[_]],
        ca = [[^]],
        am = [[&]],
        lt = [[<]],
        gt = [[>]],
        sh = [[#]],
        pc = [[%]],
        dl = [[$]],
        hy = [[-]],
        sq = [[']],
        dq = [["]],
        ti = [[~]],
    },
    Renderer = {}
}

---get path of template
---https://github.com/nvim-neorocks/lux/issues/922
---@param filename string template name
---@return string file template path
function M.get_path(filename)
    local root = debug.getinfo(1).source:match("@?(.*)/")
    local file = root .. '/' .. filename
    return file
end

---get output in format
---@param format string
---@param args table
---@return string text
function M.get_output(format, args)
    return template.render(M.get_path('templates/main.' .. format), args):gsub("\n$", "")
end

---split by "\n"
---@param str string
---@return string[] tokens
function M.split(str)
    local tokens = {}
    local token
    for i = 1, #str do
        local char = str:sub(i, i)
        if char == "\n" then
            if token then
                table.insert(tokens, token)
                token = nil
            end
            table.insert(tokens, "\n")
        elseif token then
            token = token .. char
        else
            token = char
        end
    end
    if token then
        table.insert(tokens, token)
    end
    return tokens
end

---get highlights
---@param text string
---@param captures capture[]
---@return hl[] hls
---@alias hl {text: string, scope: string}
function M.get_hls(text, captures)
    local hls = {}
    for _, capture in ipairs(captures) do
        local str = text:sub(capture.start_index, capture.end_index)
        for _, token in ipairs(M.split(str)) do
            table.insert(hls, { text = token, scope = capture.scope })
        end
    end
    return hls
end

---escape TeX, protect `\`, `{`, `}`
---@param text string
---@param prefix string
---@return string text
function M.escape_tex(text, prefix)
    local cs = [[\%sZ%s{}]]
    text = text:gsub([=[([\\{}])]=], cs:format(prefix, '%1'))
    for name, char in pairs(M.escape_map) do
        local pat = char
        if pat:match('[%%%-^$]') then
            pat = '%' .. pat
        end
        text = text:gsub(pat, cs:format(prefix, name))
    end
    for name, char in pairs(M.protect_map) do
        local pat = cs:format(prefix, char)
        text = text:gsub(pat, cs:format(prefix, name))
    end
    return text
end

---escape TeX with math escape
---@param text string
---@param prefix string
---@param math_escape boolean
---@return string text
function M.escape(text, prefix, math_escape)
    local texts = {}
    if math_escape then
        local is_math = false
        for str in text:gmatch("([^$]*)%$?") do
            if is_math then
                table.insert(texts, str)
            else
                table.insert(texts, M.escape_tex(str, prefix))
            end
            is_math = not is_math
        end
        if not is_math then
            table.insert(texts, '')
        end
    else
        texts = { M.escape_tex(text, prefix) }
    end
    return table.concat(texts, '$')
end

---@type Renderer

---@param renderer table?
---@return table renderer
function M.Renderer:new(renderer)
    renderer = renderer or {}
    renderer.theme = renderer.theme or Theme()
    renderer.syntax = renderer.syntax or Syntax()
    setmetatable(renderer, {
        __index = self
    })
    return renderer
end

setmetatable(M.Renderer, {
    __call = M.Renderer.new
})

---get options
---@param text string
---@param format string
---@param opts table<string, any>?
---@return table<string, any>
function M.Renderer:get_opts(text, format, opts)
    opts = opts or {}
    if format:match 'tex' and opts.prefix == nil then
        opts.prefix = "PY" .. self.theme.name:gsub(" ", "")
    end
    opts.color_map = opts.color_map or self.theme.get_full_color_map()
    opts.hls = opts.hls or M.get_hls(text, self.syntax:capture(text, self.theme))
    opts.ipairs = ipairs
    opts.table = table
    opts.warna = warna
    opts.escape = M.escape
    opts.preamble = M.get_path('texcat/main.preamble.tex')
    opts.tex = M.get_path('texcat/main.tex')
    opts.scopes = T.get_sorted_keys(opts.color_map)
    return opts
end

---render a text
---@param text string
---@param format string
---@param opts table<string, any>?
---@return string
function M.Renderer:render(text, format, opts)
    return M.get_output(format, self:get_opts(text, format, opts))
end

---render a file
---@param filename string
---@param format string
---@param opts table<string, any>?
---@return string
function M.Renderer:render_file(filename, format, opts)
    local f = io.open(filename)
    if not f then
        return ''
    end
    local text = f:read('*a'):gsub("\n$", '')
    f:close()
    return self:render(text, format, opts)
end

return M
