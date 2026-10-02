---library for `luatex`, `lualatex`, `luatexinfo` and `initex`
local utils = require "prompt.utils"
local updmap = require "texrocks.updmap"
local texlua = require "texrocks.texlua"
local texrocks = require 'texrocks'
local M = {}

---luahbtex --luaonly texlua luatex:
---texlua will call parse(), then loadfile("luatex")()
---luatex will call parse(), then os.exec{[0]="luatex", "luahbtex"}
---@param argv string[] command line arguments
---@return string[] args parsed result
function M.parse(argv)
    local args = utils.shift(argv, -1)
    local begin = utils.get_begin_index(args)
    args[0] = args[begin]
    return args
end

---**entry for luatex**
---@param argv string[] `arg`
function M.main(argv)
    texlua.setotherenv(M.get_program_name(argv))
    updmap.sync()
    local args = M.parse(argv)
    texrocks.exec(args)
end

---see <https://texdoc.org/serve/luatex/0>'s command line options
---@param argv string[] command line arguments not `arg`
---@return string progname
function M.get_program_name(argv)
    local begin = utils.get_begin_index(argv)
    local end_ = begin + #argv - 1
    -- --progname is latter first
    for i = end_, begin + 1, -1 do
        if argv[i]:match("^--progname=") then
            local progname = argv[i]:gsub("^--progname=", "")
            return progname
        elseif argv[i - 1] == "--progname" then
            return argv[i]
        end
    end

    -- --fmt/--ini is former first
    local opt
    for i = begin + 1, end_ do
        if argv[i]:match("^--fmt=") then
            local progname = argv[i]:gsub("^--fmt=", "")
            return progname
        elseif argv[i] == "--fmt" or argv[i] == "--ini" then
            opt = argv[i]
        elseif argv[i]:match("^%-") == argv[i]:match("^\\") then
            if opt == "--fmt" then
                return argv[i]
            elseif opt == "--ini" then
                local progname = argv[i]:gsub(".*/", ""):gsub("%.*", "")
                return progname
            end
        end
    end

    -- usually be luahbtex
    return texlua.match_program_name(argv[begin])
end

return M
