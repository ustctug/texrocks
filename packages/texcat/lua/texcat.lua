---library for `texcat`
---@module texcat
---@copyright 2025
---@diagnostic disable: undefined-global
-- luacheck: ignore 111 113
local lfs = require 'lfs'
local argparse = require 'argparse'
local T = require 'texcat.themes'
local TMTheme = require 'texcat.themes.tmtheme'.TMTheme
local TMLanguage = require 'texcat.syntaxes.tmlanguage'.TMLanguage
local Treesitter = require 'texcat.syntaxes.treesitter'.Treesitter
local R = require 'texcat.renderer'
local Renderer = require 'texcat.renderer'.Renderer
local M = {
    -- cache
    themes = {},
    syntaxes = {},
}

---get parser
---@param progname string program name
---@return table parser
function M.get_parser(progname)
    local parser = argparse(progname):add_complete()
    parser:argument('file', 'file name'):args('*')
    parser:option('--output', 'output file name, - means stdout'):count('*')
    parser:option('--syntax', 'set syntax, auto means decided by extension'):count('*')
    parser:option('--theme', 'set theme, auto means first theme such as Abyss'):count('*')
    parser:option('--syntax-type', 'syntax highlight type', 'tree-sitter'):choices { 'textmate', 'tree-sitter' }
    parser:option('--theme-type', 'color scheme type', 'textmate'):choices { 'textmate' }
    parser:option('--extensions-dir',
        'directories for VSCode extensions and tree-sitter grammars/queries', T.get_extensions_dir()):count('*')
    local format = 'ansi'
    if tex and tex.print then
        format = 'tex'
    end
    local formats = {}
    for fmt in lfs.dir(R.get_path('templates')) do
        table.insert(formats, fmt:match('[^.]+%.(.*)$'))
    end
    parser:option('--output-format', 'output format', format):choices(formats)
    parser:option('--list', 'list all themes/syntaxes/...', 'themes'):choices {
        'themes', 'syntaxes', 'extensions_dirs', 'colors', 'links'
    }
    parser:option('--command-prefix', 'command prefix for TeX'):count('*')
    parser:option('--math-escape', 'the scope to escape $math TeX code$', 'comment')
    return parser
end

---@alias str string?
---@alias cfg
---| {
---  text: str,
---  syntax: string,
---  syntax_type: str,
---  theme: str,
---  theme_type: str,
---  extensions_dir: string[]?,
---  format: str,
---  output: str,
---  extra_opts: table<string, any>?}

---parse command line arguments
---@param argv string[] command line arguments
---@return cfg[] cfgs parsed configs
function M.parse(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    if #args.file == 0 then
        print(M.get_list(args.list, args.theme_type, args.syntax_type, args.theme, args.extensions_dir))
        return {}
    end
    return M.args_to_cfgs(args)
end

---get list output
---@param list_type string list type
---@param theme_type string theme type
---@param syntax_type string syntax type
---@param extensions_dir string[] extensions directory
---@param theme_names string[] theme names
function M.get_list(list_type, theme_type, syntax_type, theme_names, extensions_dir)
    local class
    local theme
    if theme_type == 'textmate' then
        class = TMTheme
    end
    theme = class { extensions_dir = extensions_dir }
    local syntax
    if syntax_type == 'textmate' then
        class = Treesitter
    elseif syntax_type == 'tree-sitter' then
        class = TMLanguage
    end
    syntax = class { id = 0, extensions_dir = extensions_dir }
    local list
    if list_type == 'extensions_dirs' then
        list = table.concat(extensions_dir, "\n")
    elseif list_type == 'themes' then
        list = theme.list()
    elseif list_type == 'syntaxes' then
        list = syntax.list()
    elseif list_type == 'links' then
        list = T.list_links()
    elseif list_type == 'colors' then
        local theme_infos = {}
        for _, theme_name in ipairs(theme_names) do
            theme = M.themes[theme_name]
            if theme == nil then
                if theme_type == 'textmate' then
                    theme = TMTheme { extensions_dir = extensions_dir, name = theme_name }
                    M.themes[theme_name] = theme
                else
                    return ''
                end
            end
            table.insert(theme_infos, theme.name)
            table.insert(theme_infos, tostring(theme))
        end
        list = table.concat(theme_infos, "\n\n")
    end
    return list
end

---change some values by command line arguments
---@param args table parsed result
---@return cfg[] cfgs parsed configs
function M.args_to_cfgs(args)
    local cfgs = {}
    for i, file in ipairs(args.file) do
        table.insert(cfgs, {
            file,
            text = nil,
            syntax = args.syntax[i],
            syntax_type = args.syntax_type,
            theme = args.theme[i],
            theme_type = args.theme_type,
            extensions_dir = args.extensions_dir,
            format = args.output_format,
            output = args.output[i],
            extra_opts = {
                prefix = args.command_prefix[i],
                math_escape = args.math_escape,
            }
        })
    end
    return cfgs
end

---core function: render a file
---@param cfg cfg
function M.render(cfg)
    -- syntax_type/theme_type
    cfg.syntax_type = cfg.syntax_type or 'tree-sitter'
    cfg.theme_type = cfg.theme_type or 'textmate'

    -- theme
    local class
    if cfg.theme_type == 'textmate' then
        class = TMTheme
    end
    cfg.theme = cfg.theme or 'auto'
    -- no theme auto
    local theme = M.themes[cfg.theme]
    if theme == nil then
        if cfg.theme == 'auto' then
            cfg.theme = nil
        end
        theme = class { name = cfg.theme, extensions_dir = cfg.extensions_dir }
        M.themes[theme.name] = theme
    end

    if cfg[1] then
        local f = io.open(cfg[1])
        if not f then
            return
        end
        cfg.text = f:read('*a'):gsub("\n$", '')
        f:close()
    end
    cfg.text = cfg.text or ''

    -- syntax
    if cfg.syntax_type == 'textmate' then
        class = TMLanguage
    elseif cfg.syntax_type == 'tree-sitter' then
        class = Treesitter
    end
    cfg.syntax = cfg.syntax or 'auto'
    -- no syntax auto
    local syntax = M.themes[cfg.syntax]
    if syntax == nil then
        if cfg.syntax == 'auto' then
            cfg.syntax = class.detect(cfg[1])
        end
        syntax = class { name = cfg.syntax }
        M.syntaxes[syntax.name] = syntax
    end

    -- output
    if cfg.output == nil then
        if tex and tex.print then
            cfg.output = '.lux/%s.tex'
            cfg.output = cfg.output:format(cfg[1] or syntax.name)
        else
            cfg.output = '-'
        end
    end
    cfg.format = cfg.format or 'tex'
    cfg.extra_opts = cfg.extra_opts or {}

    local renderer = Renderer { theme = theme, syntax = syntax }
    if tex and tex.print then
        M.output(renderer:render(cfg.text, 'preamble.tex', cfg.extra_opts), '-')
    end
    local out = renderer:render(cfg.text, cfg.format, cfg.extra_opts)
    if cfg.output == '' then
        return out
    end
    M.output(out, cfg.output)
    return cfg.output
end

---**entry for texcat**
---@param argv string[] command line arguments
function M.main(argv)
    local cfgs = M.parse(argv)
    for _, cfg in ipairs(cfgs) do
        M.render(cfg)
    end
end

---output a file
---@param out string
---@param filename string file name
function M.output(out, filename)
    if filename == '-' then
        if tex and tex.print then
            out = out:gsub("^%s+", ""):gsub("\n", "")
            tex.print(out)
        else
            print(out)
        end
    else
        local dir = filename:match('(.*)/[^/]+$')
        if dir then
            if lfs.mkdirp then
                lfs.mkdirp(dir)
            else
                lfs.mkdir(dir)
            end
        end
        local f = io.open(filename, 'w')
        if f then
            f:write(out)
            f:close()
        end
    end
end

return M
