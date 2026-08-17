---library for `texcat`
---@module texcat
---@copyright 2025
---@diagnostic disable: undefined-global
-- luacheck: ignore 111 113
local ft = require 'vim.filetype'
local fs = require 'vim.fs'
local fn = require 'vim.fn'
local unistd = require 'posix.unistd'
local cjson = require 'cjson'
local PlatformDirs = require 'platformdirs'.PlatformDirs
local argparse = require 'argparse'
local highlight = require "tree_sitter_highlight".highlight
local search_parsers = require "tree_sitter_highlight".search_parsers
local ft_parser_map = require "rocks_treesitter.ft_parser_map"
local M = {
    scopes = {
        module = 'storage',
        constructor = 'support.class',
        tag = 'entity.name.tag',
        ["function"] = 'support.function',
        property = 'support.constant',
        punctuation = 'punctuation.section.embedded',
        attribute = 'entity.other.attribute-name',
        number = 'support.constant',
        constant = 'support.constant',
        operator = 'punctuation.section.embedded',
        type = 'entity.name.type',
        ["comment.todo"] = 'token.debug-token',
        ["comment.note"] = 'token.info-token',
        ["comment.warning"] = 'token.warning-token',
        ["comment.error"] = 'token.error-token',
    }
}
local config_dir = PlatformDirs { appname = 'luarocks' }:user_config_dir()

---@param t table
---@return string[]
function M.table_to_strings(t)
    local strings = {}
    for k, _ in pairs(t) do
        table.insert(strings, k)
    end
    table.sort(strings)
    return strings
end

---get parser
---@param progname string program name
---@param parsers table
---@param themes table
---@return table parser
function M.get_parser(progname, parsers, themes)
    local parser = argparse(progname):add_complete()
    parser:argument('file', 'file name'):args('*')
    parser:option('--language', 'set language'):choices(M.table_to_strings(parsers))
    parser:option('--theme', 'set theme'):choices(M.table_to_strings(themes))
    parser:option('--format', 'output format', "terminal"):choices { "latex", "html", "terminal" }
    parser:option('--layout', 'layout', "document"):choices { "fragment", "document", "line-numbers" }
    parser:option('--style', 'style', "classes"):choices { "minimal", "classes", "inline" }
    parser:option('--prefix', 'command prefix for TeX', "TS")
    parser:option('--math-escape', 'the scope to escape $math TeX code$', {}):count('*')
    parser:option('--injections', 'injection languages, all means all', {}):count('*')
    return parser
end

---@param file string
---@return string
function M.get_language(file)
    local language = ft.match { filename = file } or "unknown"
    return ft_parser_map[language] or language
end

---@param query string
---@return string
function M.fix_query(query)
    query = query:gsub('#set!%s+@%S+', "#set! ")
        :gsub('@spell', "")
        :gsub('@nospell', "")
        :gsub('#any%-eq', "#any-of")
        :gsub('#not%-any%-eq', "#not-any-of")
        :gsub('#has[^?]+', "#any-of")
        :gsub('#not%-has[^?]+', "#not-any-of")
        :gsub('#match', "#any-of")
        :gsub('#not%-match', "#not-any-of")

        :gsub('#vim[^?]+', "#any-of")
        :gsub('#not%-vim[^?]+', "#not-any-of")
        :gsub('#any%-vim[^?]+', "#any-of")
        :gsub('#not%-any%-vim[^?]+', "#not-any-of")

        :gsub('#lua[^?]+', "#any-of")
        :gsub('#not%-lua[^?]+', "#not-any-of")
        :gsub('#any%-lua[^?]+', "#any-of")
        :gsub('#not%-any%-lua[^?]+', "#not-any-of")
    return query
end

---@param parsers table
function M.fix_parsers_(parsers)
    for _, v in pairs(parsers) do
        for name, query in pairs(v) do
            if name ~= 'parser' then
                v[name] = M.fix_query(query)
            end
        end
    end
end

---@param parsers table
---@param language string
---@param injections string[]
---@return table
function M.get_parsers(parsers, language, injections)
    if parsers[language] == nil then
        return {}
    end
    local _parsers = {}
    _parsers[language] = parsers[language]
    local _injections = { [language] = true }
    for injection in parsers[language].injections:gmatch('#set!%s+injection%.language%s+"([^"]+)"') do
        if not _injections[injection] then
            _injections[injection] = true
            if parsers[injection] then
                _parsers[injection] = parsers[injection]
            else
                io.stderr:write("No parser found for injection: " .. injection .. "\n")
            end
        end
    end
    for _, injection in pairs(injections) do
        if injection == 'all' then
            return parsers
        end
        _parsers[injection] = parsers[injection]
    end
    return _parsers
end

function M.os_getenv(varname)
    return require "os".getenv(varname)
end

---support `no_manifest = true`
---@param paths string[]
---@param dir string
function M.insert_paths(paths, dir)
    for name in fs.dir(dir) do
        if name:sub(1, 1) ~= '.' then
            name = fs.joinpath(dir, name)
            if fn.isdirectory(name) == 1 then
                for path in fs.dir(name) do
                    if path:sub(1, 1) ~= '.' then
                        path = fs.joinpath(name, path)
                        table.insert(paths, path)
                    end
                end
            end
        end
    end
end

---@param external boolean?
---@return string[]
function M.get_paths(external)
    local paths = {}
    if external then
        if fn.isdirectory('/run/current-system/sw') == 1 then
            table.insert(paths, '/run/current-system/sw/lib/nvim')
            table.insert(paths, '/run/current-system/sw/share/nvim/runtime')
        else
            table.insert(paths, '/usr/lib/nvim')
            table.insert(paths, '/usr/share/nvim/runtime')
            local prefix = os.getenv 'PREFIX' or '/usr/local'
            table.insert(paths, fs.joinpath(prefix, 'lib/nvim'))
            table.insert(paths, fs.joinpath(prefix, 'share/nvim/runtime'))
        end
        -- luarocks
        local func = loadfile(fs.joinpath(config_dir, 'default-lua-version.lua'))
        local version = func and func() or '5.1'
        local luarocks_config = { os_getenv = M.os_getenv, home = M.os_getenv("HOME") or '.' }
        func = loadfile(fs.joinpath(config_dir, "config-" .. version .. ".lua"), "t", luarocks_config)
        ---@diagnostic disable-next-line: deprecated
        if setfenv then
            setfenv(f, luarocks_config)
        end
        if func then
            func()
            for _, tree in ipairs(luarocks_config.rocks_trees or {}) do
                local dir = fs.joinpath(tree.root, "lib", "luarocks", "rocks-" .. version)
                M.insert_paths(paths, dir)
            end
        else
            local p = io.popen('luarocks config --json')
            local dir
            if p then
                local text = p:read '*a'
                p:close()
                dir = (cjson.decode(text).variables or {}).ROCKS_TREE
            end
            if dir then
                M.insert_paths(paths, dir)
            end
        end
    end
    -- lux
    for path in package.path:gmatch('([^;]+)/src/[?]%.lua') do
        path = path .. '/etc'
        table.insert(paths, path)
    end
    return paths
end

---@param paths string[]
---@return table<string, string>
function M.get_themes(paths)
    local prefix = '-color-theme.json'
    local themes = {}
    for _, path in pairs(paths) do
        path = fs.joinpath(path, 'extensions')
        if fn.isdirectory(path) == 1 then
            for dir in fs.dir(path) do
                if dir:sub(1, 1) ~= '.' then
                    dir = fs.joinpath(path, dir, 'themes')
                    if fn.isdirectory(dir) == 1 then
                        for theme in fs.dir(dir) do
                            if theme:sub(1, 1) ~= '.' then
                                if theme:sub(- #prefix) == prefix then
                                    themes[theme:sub(1, - #prefix - 1)] = fs.joinpath(dir, theme)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return themes
end

---@param themes table<string, string>
---@param name string
---@return table?
function M.get_theme(themes, name)
    local file = themes[name]
    if file == nil then
        return
    end
    local f = io.open(file, 'r')
    if f == nil then
        return
    end
    local content = f:read('*a')
    f:close()
    content = content:gsub('//[^\n]*\n', ''):gsub(',%s*]', ']')
    local theme = {}
    for _, datum in ipairs(cjson.decode(content).tokenColors or {}) do
        local settings = datum.settings or {}
        local scopes = datum.scope or {}
        if type(scopes) == type '' then
            for scope in scopes:gmatch('[^, ]+') do
                theme[scope] = M.settings_to_theme(settings)
            end
        else
            for _, scope in ipairs(scopes) do
                theme[scope] = M.settings_to_theme(settings)
            end
        end
    end
    for k, v in pairs(M.scopes) do
        if theme[k] == nil then
            theme[k] = theme[v]
        end
    end
    return theme
end

---@param settings table
---@return table
function M.settings_to_theme(settings)
    local theme = { color = settings.foreground }
    for v in (settings.fontStyle or ''):gmatch('%S+') do
        theme[v] = true
    end
    return theme
end

---@param args table
---@return string
function M.get_source(args)
    local source = args.source
    if source == nil then
        local f = io.open(args.file, 'r')
        if f then
            source = f:read '*a'
            f:close()
        end
    end
    return source or ''
end

---@param args table
---@return string
function M.highlight(args)
    if args.parsers[args.language] == nil then
        io.stderr:write("No parser found for language: " .. args.language .. "\n")
        if args.style == 'minimal' then
            return ''
        end
        return M.get_source(args)
    end
    if args.format == 'terminal' and not unistd.isatty(1) then
        return M.get_source(args)
    end
    return highlight(args)
end

---**entry for texcat**
---@param argv string[] command line arguments
function M.main(argv)
    local paths = M.get_paths(true)
    local parsers = search_parsers(paths)
    local themes = M.get_themes(paths)
    local parser = M.get_parser(argv[0], parsers, themes)
    local args = parser:parse(argv)
    M.fix_parsers_(parsers)

    local theme = M.get_theme(themes, args.theme)

    if #args.file == 0 then
        local language = 'json'
        local _parsers = M.get_parsers(parsers, language, args.injections)
        print(M.highlight {
            source = cjson.encode(theme),
            language = language,
            theme = theme,
            parsers = _parsers,
            format = args.format,
            layout = args.layout,
            style = args.style,
            prefix = args.prefix,
            math_escape = args.math_escape,
        })
    end
    for _, file in ipairs(args.file) do
        local language = args.language or M.get_language(file)
        local _parsers = M.get_parsers(parsers, language, args.injections)
        print(M.highlight {
            file = file,
            language = language,
            theme = theme,
            parsers = _parsers,
            format = args.format,
            layout = args.layout,
            style = args.style,
            prefix = args.prefix,
            math_escape = args.math_escape,
        })
    end
end

---output a file
---@param args table
---@return string
function M.render(args)
    local language = args.language or M.get_language(args.file or '')

    local paths = {}
    local parsers = args.parsers
    if parsers == nil then
        paths = M.get_paths(args.external)
        parsers = search_parsers(paths)
        parsers = M.get_parsers(parsers, language, args.injections or {})
        M.fix_parsers_(parsers)
    end

    local theme = args.color_theme
    if theme == nil then
        if #paths == 0 then
            paths = M.get_paths(args.external)
        end
        local themes = M.get_themes(paths)
        theme = M.get_theme(themes, args.theme)
    end

    local prefix = args.prefix or ('TS' .. (args.theme or '')):gsub('[^a-zA-Z]', '')
    local math_escape = args.math_escape or {}

    if tex and tex.print and args.style == nil then
        local out = M.highlight {
            file = args.file,
            source = args.source,
            language = language,
            theme = theme,
            parsers = parsers,
            format = 'latex',
            style = 'minimal',
            prefix = prefix,
            math_escape = math_escape,
        }
        out = out:gsub("^%s+", ""):gsub("\n", "")
        tex.print(out)
    end

    local format = args.format
    local style = args.style
    if tex and tex.print then
        format = format or 'latex'
        style = style or 'classes'
    else
        format = format or 'html'
        style = style or 'inline'
    end
    local out = M.highlight {
        file = args.file,
        source = args.source,
        language = language,
        theme = theme,
        parsers = parsers,
        format = format,
        layout = args.layout or 'fragment',
        style = style,
        prefix = prefix,
        math_escape = math_escape,
    }
    if tex and tex.print then
        local filename = args.filename or fs.joinpath('.lux', (args.file or '') .. '.tex')
        fn.mkdir(fs.dirname(filename), 'p')
        local f = io.open(filename, 'w')
        if f then
            f:write(out)
            f:close()
        end
        return filename
    end
    if format == 'html' then
        out = out:match("<code>(.-)</code>") or out
    end
    return out
end

return M
