---library for `texcat`
---@module texcat
---@copyright 2025
-- luacheck: ignore 111 113
---@diagnostic disable: undefined-global
local lfs = require 'lfs'
local argparse = require 'argparse'
local template = require 'template'
local textmate = require 'textmate'
local ltreesitter = require 'ltreesitter'
local warna = require 'warna'
warna.options.level = 3
local M = {
    protect_map = {
        bs = [[\]],
        ob = [[{]],
        cb = [[}]],
    },
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

---@alias scope string
---@alias link table<scope, scope>

---get scope link
---@return link link
function M.get_scope_link()
    ---@alias hl_name string
    ---@type table<hl_name, scope[]>
    local hl_scope_map = {}
    for _, scope_hl in ipairs(require 'nvim-textmate.colormap'.scope_hl_map) do
        local scope, hl = scope_hl[1], scope_hl[2]
        -- FIXME: https://github.com/icedman/nvim-textmate/issues/10
        if scope == 'variable' then
            hl = 'Variable'
        end
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

---get parser
---@param progname string program name
---@return table parser
function M.get_parser(progname)
    local parser = argparse(progname):add_complete()
    parser:argument('file', 'file name'):args('*')
    parser:option('--output', 'output file name, - means stdout'):count('*')
    parser:option('--language', 'set language, auto means decided by extension'):count('*')
    parser:option('--theme', 'set theme, auto means first theme such as Abyss'):count('*')
    parser:option('--syntax-type', 'syntax highlight type', 'tree-sitter'):choices { 'textmate', 'tree-sitter' }
    parser:option('--theme-type', 'color scheme type', 'textmate'):choices { 'textmate' }
    local dirs = M.get_extensions_dir()
    parser:option('--extensions-dir',
        'directories for VSCode extensions and tree-sitter grammars/queries', dirs):count('*')
    local format = 'ansi'
    if tex and tex.print then
        format = 'tex'
    end
    local formats = {}
    for fmt in lfs.dir(M.get_path('texcat')) do
        table.insert(formats, fmt:match('[^.]+%.(.*)$'))
    end
    parser:option('--output-format', 'output format', format):choices(formats)
    parser:option('--list', 'list all themes/languages/...', 'none'):choices {
        'none', 'themes', 'languages', 'extensions_dirs', 'colors', 'links'
    }
    parser:option('--command-prefix', 'command prefix for TeX', [[PY]])
    -- parser:option('--math-escape', 'escape $math TeX code$'):args(0)
    return parser
end

---list themes or languages
---@param data string[][]
---@return string information
function M.list(data)
    local lines = {}
    for _, theme in ipairs(data) do
        table.insert(lines, theme[1] .. ': ' .. theme[3] .. "\n" .. theme[2])
    end
    return table.concat(lines, "\n\n")
end

---fill a table by the last element
---@param input table
---@param number integer
---@return table
function M.fill(input, number)
    for i = #input + 1, number do
        input[i] = input[i - 1]
    end
    return input
end

---parse command line arguments
---@param argv string[] command line arguments
---@return table args parsed result
function M.parse(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    return M.postparse(args)
end

---change some values by command line arguments
---@param args table parsed result
---@return table args processed result
function M.postparse(args)
    if args.theme_type == 'textmate' or args.syntax_type == 'textmate' then
        for _, dir in ipairs(args.extensions_dir) do
            textmate.highlight_set_extensions_dir(dir .. '/extensions/')
        end
    end

    if #args.output == 0 then
        if tex and tex.print then
            args.output[1] = '.lux/%s.tex'
            args.output[1] = args.output[1]:format(args.file[1])
        else
            args.output[1] = '-'
        end
    end
    args.output = M.fill(args.output, #args.file)

    if #args.theme == 0 then
        args.theme[1] = 'auto'
    end
    args.theme = M.fill(args.theme, #args.file)
    local themes = textmate.highlight_themes()
    if #themes > 0 then
        for i, name in ipairs(args.theme) do
            if name == 'auto' then
                args.theme[i] = themes[1][1]
            end
        end
    end

    if #args.language == 0 then
        args.language[1] = 'auto'
    end
    args.language = M.fill(args.language, #args.file)
    local languages = textmate.highlight_languages()
    if #languages > 0 then
        for i, name in ipairs(args.language) do
            if name == 'auto' then
                local ext = args.file[i] or ''
                ext = ext:match('(%.[^.]+)$')
                for _, data in ipairs(languages) do
                    if ext == data[3] then
                        args.language[i] = data[1]
                        break
                    end
                end
            end
        end
    end

    if args.list == 'none' then
        args.list = nil
    elseif args.list == 'links' then
        local link = M.get_scope_link()
        local scopes = M.get_sorted_keys(link)
        local lines = {}
        for _, scope in ipairs(scopes) do
            table.insert(lines, scope .. ' -> ' .. link[scope])
        end
        args.list = table.concat(lines, "\n")
    elseif args.list == 'colors' then
        local theme_infos = {}
        for _, theme_name in ipairs(args.theme) do
            if args.theme_type == 'textmate' then
                if themes[theme_name] == nil then
                    themes[theme_name] = textmate.highlight_load_theme(theme_name)
                end
                themes[theme_name] = textmate.highlight_load_theme(theme_name)
                textmate.highlight_set_theme(themes[theme_name])
                local color_map = M.get_color_map()
                local scopes = M.get_sorted_keys(color_map)
                local lines = { theme_name }
                for _, scope in ipairs(scopes) do
                    table.insert(lines, scope .. ': ' .. table.concat(color_map[scope], ', '))
                end
                table.insert(theme_infos, table.concat(lines, "\n"))
            end
        end
        args.list = table.concat(theme_infos, "\n\n")
    elseif args.list == 'themes' then
        args.list = M.list(textmate.highlight_themes())
    elseif args.list == 'extensions_dirs' then
        args.list = table.concat(args.extensions_dir, "\n")
    elseif args.list == 'languages' then
        if args.syntax_type == 'textmate' then
            args.list = M.list(textmate.highlight_languages())
        elseif args.syntax_type == 'tree-sitter' then
            local parsers = M.search(args.extensions_dir, 'parser')
            local langs = M.get_sorted_keys(parsers)
            local lines = {}
            for _, lang in ipairs(langs) do
                table.insert(lines, lang .. ': ' .. parsers[lang])
            end
            args.list = table.concat(lines, "\n\n")
        end
    end
    return args
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

---**entry for texcat**
---@param argv string[] command line arguments
function M.main(argv)
    local args = M.parse(argv)
    if args.list then
        print(args.list)
        return
    end
    -- cache
    local themes = {}
    local languages = {}
    for i, file in ipairs(args.file) do
        local f = io.open(file)
        if f then
            local text = f:read('*a'):gsub("\n$", '')
            f:close()

            local color_map = {}
            local theme_name = args.theme[i]
            if args.theme_type == 'textmate' then
                if themes[theme_name] == nil then
                    themes[theme_name] = textmate.highlight_load_theme(theme_name)
                end
                textmate.highlight_set_theme(themes[theme_name])
                if args.syntax_type ~= 'textmate' then
                    color_map = M.get_color_map()
                    local link = M.get_scope_link()
                    color_map = M.link_color_map(color_map, link)
                end
            end

            local captures = {}
            if args.syntax_type == 'textmate' then
                local language_name = args.language[i]
                if languages[language_name] == nil then
                    languages[language_name] = textmate.highlight_load_language(language_name)
                end
                textmate.highlight_set_language(languages[language_name])

                -- FIXME: https://github.com/icedman/nvim-textmate/issues/11
                local results = textmate.highlight_line(text, themes[theme_name], languages[language_name], 0)
                for _, result in ipairs(results) do
                    local idx, len, r, g, b, scope = result[1] + 1, result[2], result[3], result[4], result[5], result
                        [6]
                    color_map[scope] = {}
                    local str = '%d'
                    for _, v in ipairs { r, g, b } do
                        table.insert(color_map[scope], tonumber(str:format(v)))
                    end
                    table.insert(captures, { start_index = idx, end_index = idx + len - 1, scope = scope })
                end
            elseif args.syntax_type == 'tree-sitter' then
                local language_name = args.language[i]
                if languages[language_name] == nil then
                    languages[language_name] = M.get_language(language_name, args.extensions_dir)
                end
                local tree = languages[language_name].parser:parse_string(text)
                local node = tree:root()
                for capture, name in languages[language_name].query:capture(node) do
                    -- lua index start from 1
                    table.insert(captures,
                        { start_index = capture:start_byte() + 1, end_index = capture:end_byte(), scope = name })
                end
                color_map = M.add_scope(color_map, captures)
                captures = M.filter_captures(captures, color_map)
                captures = M.cut_captures(captures, #text)
            end

            args.hls = M.get_hls(text, captures)
            args.color_map = color_map
            args.scopes = M.get_sorted_keys(color_map)
            args.ipairs = ipairs
            args.table = table
            args.warna = warna
            args.escape = M.escape
            args.tex = M.get_path('texcat/main.tex')
            M.output(M.get_output(args.output_format, args), args.output[i])
        end
    end
end

---convert theme information to color map
---@return color_map color_map
function M.get_color_map()
    local theme = textmate.highlight_theme_info()
    -- FIXME: https://github.com/icedman/nvim-textmate/issues/10
    theme[22], theme[23], theme[24] = theme[23], theme[22] / 2, (theme[24] + 255) / 2
    theme[25], theme[26], theme[27] = (theme[25] + 255) / 2, theme[26], theme[27] / 2
    for k, v in ipairs(theme) do
        theme[k] = math.floor(v)
    end
    ---@type color_map
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

-- remove captures without color
---@param captures capture[]
---@param color_map color_map
---@return capture[] captures
function M.filter_captures(captures, color_map)
    ---@type capture[]
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
---@alias capture {start_index: integer, end_index: integer, scope: string}
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
    ---@type range[]
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

---get highlights
---@param text string
---@param captures capture[]
---@return hl[] hls
---@alias hl {text: string, scope: scope}
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

---add child scopes to color map
---@param color_map color_map
---@param captures capture[]
---@alias color_map table<scope, integer[]>
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

---get tree-sitter language information
---@param name string
---@param extensions_dir string[]
---@return language language
---@alias language {parser: table, query: table}
function M.get_language(name, extensions_dir)
    local parser = M.require(name, extensions_dir)
    local filename = M.search(extensions_dir, 'queries/' .. name .. '/highlights.scm')[1]
    local f = io.open(filename)
    local code = ''
    if f then
        code = f:read '*a'
        f:close()
    end
    code = M.filter_query(code)
    local query = parser:query(code)
    return {
        parser = parser,
        query = query,
    }
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

---output a file
---@param out string
---@param filename string file name
function M.output(out, filename)
    if filename == '-' then
        if tex and tex.print then
            tex.print(out:gsub("%[^\n]*\n", ""):gsub("\n", " "))
        else
            print(out)
        end
    else
        local dir = filename:match('(.*)/[^/]+$')
        if dir then
            if lfs.mkdirp then
                lfs.mkdirp(dir)
            else
                lfs.mkdirp(dir)
            end
        end
        local f = io.open(filename, 'w')
        if f then
            f:write(out)
            f:close()
            if tex and tex.print then
                -- tex.print() cannot accept "\n"
                tex.print([[\input ]] .. filename)
            end
        end
    end
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

---escape TeX, protect `\`, `{`, `}`
---@param text string
---@param prefix string
---@return string text
function M.escape(text, prefix)
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
    return template.render(M.get_path('texcat/main.' .. format), args):gsub("\n$", "")
end

return M
