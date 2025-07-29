local texrocks = require 'texrocks'
local argparse = require 'argparse'
local template = require 'template'
local M = {}

function M.get_parser(name, fmt)
    local parser = argparse(name)
    parser:argument('macro', 'macro name without \\'):args('*')
    parser:option('--output -o', 'output file name', tex.jobname .. '.tex')
    parser:option('--value -v', [[Show value of \the\macro instead]]):args(0)
    if fmt:match 'latex' then
        parser:option('--list -l', 'List user level command sequences of the given packages'):args(0)
        parser:option('--Environment -E', 'Every command name is taken as an environment name'):args(0)
        parser:option('--class -c', 'class name', 'article')
        parser:option('--package -p', 'package name'):count("*")
        parser:option('--environment -e', 'environment name'):count("*")
        parser:option('--othercode -o', 'Add other code into the preamble before the definition is shown'):count("*")
        parser:option('--preamble -P', 'Show definition of the command inside the preamble'):args(0)
        parser:option('--beforeclass -B', [[Show definition of the command before \documentclass]]):args(0)
    end
    parser:option('--before -b', 'Place code before definition is shown'):count("*")
    parser:option('--after -a', 'Place code after definition is shown'):count("*")
    parser:option('--dry-run -n', 'Do not run'):args(0)
    return parser
end

function M.parse(args)
    local cmd_args, fmt = texrocks.preparse(args)
    local parser = M.get_parser(cmd_args[0], fmt)
    cmd_args = parser:parse(cmd_args)
    return M.postparse(cmd_args)
end

function M.postparse(args)
    if args.class and args.class:sub(#args.class, #args.class) ~= '}' then
        args.class = '{' .. args.class .. '}'
    end
    if args.package then
        for i, pkg in ipairs(args.package) do
            if pkg:sub(#pkg, #pkg) ~= '}' then
                args.package[i] = '{' .. args.package[i] .. '}'
            end
        end
    end
    if args.environment then
        for i, pkg in ipairs(args.environment) do
            if pkg:sub(#pkg, #pkg) ~= '}' then
                args.environment[i] = '{' .. args.environment[i] .. '}'
            end
        end
    end
    if args.Environment then
        for i=1,#args.macro do
            table.insert(args.macro, 'end' .. args.macro[i])
        end
    end
    return args
end

function M.print(code)
    code = code:gsub("%.*\n", ""):gsub("\n", "")
    tex.print(code)
end

function M.main()
    print()
    local args = M.parse(arg)
    local filename = 'texdef/main.tex'
    local subfilename = 'texdef/sub.tex'
    local root = debug.getinfo(1).source:match("@?(.*)/")
    local file = root .. '/' .. filename
    local subfile = root .. '/' .. filename
    -- https://github.com/nvim-neorocks/lux/issues/922
    if not lfs.isfile(file) then
        file = lfs.currentdir() .. '/lua/' .. filename
    end
    if not lfs.isfile(subfile) then
        subfile = lfs.currentdir() .. '/lua/' .. subfilename
    end
    args.sub = subfile
    args.ipairs = ipairs
    local code = template.render(file, args)
    if args.dry_run then
        print(code)
    else
        M.f = io.open('.lux/' .. args.output, 'w+')
        if M.f then
            M.print(code)
        end
    end
end

function M.output()
    if M.f then
        print(M.f:read("*a"))
        M.f:close()
    end
end

return M
