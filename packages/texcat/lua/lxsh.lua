---lxsh API for ldoc
---@module lxsh
---@copyright 2025
local texcat = require "texcat"
local search_parsers = require "tree_sitter_highlight".search_parsers
local ft_parser_map = require "rocks_treesitter.ft_parser_map"
local M = {
    formatters = { html = 'html', latex = 'latex', terminal = 'terminal' },
    highlighters = {},
    parsers = {},
    paths = texcat.get_paths(true),
}
M.theme = texcat.get_theme(texcat.get_themes(M.paths), 'solarized-light')
M.all_parsers = search_parsers(M.paths)
texcat.fix_parsers_(M.all_parsers)

---@param _ table
---@param language string
function M.get_highlighter(_, language)
    language = ft_parser_map[language] or language
    M.parsers[language] = texcat.get_parsers(M.all_parsers, language, {})
    local highlighter = function(source, args)
        args.format = args.formatter
        args.source = source
        args.language = language
        args.color_theme = args.color_theme or M.theme

        args.parsers = M.parsers[language]
        if not args.external or args.injections then
            local paths = M.get_paths(args.external)
            local parsers = search_parsers(paths)
            args.parsers = texcat.get_parsers(parsers, language, args.injections or {})
            M.fix_parsers_(args.parsers)
        end
        return texcat.render(args)
    end
    M.highlighters[language] = highlighter
    return highlighter
end

setmetatable(M.highlighters, { __index = M.get_highlighter })
return M
