local texrocks = require 'texrocks'
local argparse = require 'argparse'
local template = require 'template'
local M = {}

function M.get_parser(name, fmt)
    local parser = argparse(name)
    parser:argument('macro', 'macro name without \\'):args('*')
    parser:option('--value -v', [[Show value of \the\macro instead]]):args(0)
    if fmt:match 'latex' then
        parser:option('--list -l', 'List all command sequences of the given packages by -l, -ll'):args(0):count("*")
        parser:option('--ignore-regex -I', 'Ignore all command sequences in the above lists which match lua match()',
            '[@_]')
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
    parser:option('--output', 'output file name', tex.jobname .. '.tex')
    parser:option('--entering', 'entering file prompt', '>> entering file ')
    parser:option('--leaving', 'leaving file prompt', '<< leaving file ')
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
        for i = 1, #args.macro do
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
    M.args = args
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
        return
    end
    if args.list == 0 then
        M.f = io.open('.lux/' .. args.output, 'w+')
    else
        M.f = io.open('.lux/' .. tex.jobname .. '.log', 'w+')
    end
    if M.f then
        M.print(code)
    end
end

function M.output()
    if M.f then
        local text = ""
        local args = M.args
        if args and args.list ~= 0 then
            local macros = {}
            local pkgs = {}
            local pkg, macro
            for line in M.f:lines() do
                if line:match(args.entering) then
                    pkg = line:gsub(args.entering, '')
                    table.insert(pkgs, pkg)
                    macros[pkg] = {}
                elseif pkg and line:match(args.leaving) then
                    local names = {}
                    for name, _ in pairs(macros[pkg]) do
                        table.insert(names, name)
                    end
                    table.sort(names)
                    local lines = {}
                    for _, name in ipairs(names) do
                        local def = macros[pkg][name]
                        if def:match '->' == nil then
                            def = ' = ' .. def
                        end
                        if args.ignore_regex == '' or not name:match(args.ignore_regex) then
                            if M.args.list == 1 then
                                table.insert(lines, name)
                            else
                                table.insert(lines, name .. def)
                            end
                        end
                    end
                    macros[pkg] = lines
                    pkg = table.remove(pkgs)
                    table.insert(pkgs, pkg)
                elseif pkg and (line:sub(2):match('^into ') or line:sub(2):match('^reassigning ')) then
                    line = line:sub(2, #line - 1):gsub("^%S+ ", ""):gsub("\\ETC%.", "..."):gsub(
                        'used in a moving argument.', '(moving)')
                    local def = line:gsub("^[^=]+=", "")
                    if def:match '->' then
                        local name = def:gsub('->.*', '')
                        def = line:gsub(".*->", '')
                        local is_long = 0
                        name, is_long = name:gsub([[\long macro:]], '')
                        name = name:gsub('macro:', '')
                        if is_long > 0 then
                            def = name .. ' --> ' .. def
                        else
                            def = name .. ' -> ' .. def
                        end
                    end
                    macro = line:match("^[^=]+")
                    macros[pkg][macro] = def
                end
            end
            table.sort(pkgs)
            local lines = {}
            for _, pkg in ipairs(pkgs) do
                if #macros[pkg] > 0 then
                    table.insert(lines, pkg)
                    table.insert(lines, table.concat(macros[pkg], "\n"))
                end
            end
            text = table.concat(lines, "\n\n")
        else
            text = M.f:read("*a"):gsub('=\n', ' = '):gsub('= macro:%->', '-> ')
        end
        print(text)
        M.f:close()
    end
end

return M
