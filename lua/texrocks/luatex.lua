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
    local args = texlua.shift(argv, -1)
    local begin = texlua.get_begin_index(args)
    args[0] = args[begin]
    return args
end

---**entry for luatex**
---@param argv string[] `arg`
function M.main(argv)
    local args = M.parse(argv)
    texlua.setotherenv(M.get_program_name(args))
    updmap.sync(false)
    texrocks.exec(args)
end

---see <https://texdoc.org/serve/luatex/0>'s command line options
---@param args string[] command line arguments not `arg`
---@return string progname
function M.get_program_name(args)
    -- --progname is latter first
    for i = #args, 2, -1 do
        if args[i]:match("^--progname=") then
            local progname = args[i]:gsub("^--progname=", "")
            return progname
        elseif args[i - 1] == "--progname" then
            return args[i]
        end
    end

    -- --fmt/--ini is former first
    local opt
    for i = 2, #args do
        if args[i]:match("^--fmt=") then
            local progname = args[i]:gsub("^--fmt=", "")
            return progname
        elseif args[i] == "--fmt" or args[i] == "--ini" then
            opt = args[i]
        elseif args[i]:match("^%-") == args[i]:match("^\\") then
            if opt == "--fmt" then
                return args[i]
            elseif opt == "--ini" then
                local progname = args[i]:gsub(".*/", ""):gsub("%.*", "")
                return progname
            end
        end
    end

    -- usually be luahbtex
    return updmap.name(args[1])
end

return M
