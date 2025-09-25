---library for `texdef` and `latexdef`
---@module texdef
---@copyright 2025
local tex = require 'tex'
local kpse = require 'kpse'
local texrocks = require 'texrocks'
local argparse = require 'argparse'
local template = require 'template'
local M = {}

---get parser
---@param progname string program name
---@param fmt string TeX format name
---@return table parser
function M.get_parser(progname, fmt)
    local parser = argparse(progname):add_complete()
    parser:argument('macro', 'macro name without \\'):args('*')
    parser:option('--value -v', [[Show value of \the\macro instead]]):args(0)
    if fmt:match 'latex' then
        parser:option('--list -l', 'List all command sequences of the given packages by -l, -ll'):args(0):count("*")
        parser:option('--find -f', 'Show full filepath of the file where the command sequence was defined by -f, -ff')
            :args(0):count("*")
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
    parser:option('--defined', 'defined prompt', ': defined by ')
    return parser
end

---parse command line arguments
---@param argv string[] command line arguments
---@return table args parsed result
function M.parse(argv)
    local args = texrocks.preparse(argv)
    local parser = M.get_parser(args[0], tex.formatname)
    args = parser:parse(args)
    return M.postparse(args)
end

---change some values by command line arguments
---@param args table parsed result
---@return table args processed result
function M.postparse(args)
    if args.ignore_regex == '' then
        args.ignore_regex = '$^'
    end
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
    args.fmt = tex.formatname .. '.fmt'
    args.list = args.list or 0
    args.find = args.find or 0
    args.sub = M.get_path('texdef/templates/sub.tex')
    args.ipairs = ipairs
    return args
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

---**first entry for texdef and latexdef**
---@param argv string[] command line arguments
---@return table? args parsed command line arguments
function M.main(argv)
    print()
    local args = M.parse(argv)
    local code = template.render(M.get_path('texdef/templates/main.tex'), args)
    if args.dry_run then
        print(code)
        return
    end
    local output = args.output
    if args.list > 0 then
        output = tex.jobname .. '.log'
    end
    args.f = io.open('.lux/' .. output, 'w+')
    if args.f then
        code = code:gsub("^%s+", ""):gsub("\n", "")
        tex.print(code)
    end
    return args
end

---replace package names with their full paths
---@param text string
---@param defined string
---@return string text
function M.replace(text, defined)
    local paths = {}
    for file in text:gmatch(defined .. '(%S+)') do
        paths[file] = kpse.lookup(file)
    end
    for file, path in pairs(paths) do
        text = text:gsub(defined .. file, defined .. path)
    end
    return text
end

---@alias cs {type: '=' | '->' | '-->', value: string}
---@alias pkg table<string, cs>
---@alias log table<string, pkg>
---extract packages' macros' information from log
---one log contains many packages, one package contains many control sequences
---control sequence can be `k = v`, `k -> v` (macro), `k --> v` (long macro)
---@param f table log file handler
---@param entering string entering prompt
---@param leaving string leaving prompt
---@return log log
function M.parse_log(f, entering, leaving)
    local log = {}
    local pkg_names = {}
    local pkg_name

    for line in f:lines() do
        if line:match(entering) then
            pkg_name = line:gsub(entering, '')
            table.insert(pkg_names, pkg_name)
            log[pkg_name] = {}
        elseif pkg_name and line:match(leaving .. pkg_name) then
            table.remove(pkg_names)
            pkg_name = table.remove(pkg_names)
            if pkg_name then
                table.insert(pkg_names, pkg_name)
            end
        elseif pkg_name and (line:sub(2):match('^into ') or line:sub(2):match('^reassigning ')) then
            line = line:sub(2, #line - 1):gsub("^%S+ ", ""):gsub("\\ETC%.", "..."):gsub(
                'used in a moving argument.', '(moving)')
            local cs_name = line:match("^[^=]+")
            local cs = {
                type = '=',
                value = line:gsub("[^=]+=", ""),
            }
            if cs.value:match("^\\long macro:") then
                cs.type = '-->'
                cs.value = cs.value:gsub("^\\long macro:", "")
            elseif cs.value:match("^macro:") then
                cs.type = '->'
                cs.value = cs.value:gsub("^macro:", "")
            end
            if cs.type ~= '=' then
                local name = cs.value:gsub("%s*->.*", "")
                cs_name = cs_name .. name
                cs.value = cs.value:gsub(name .. '%s*->', "")
            end
            log[pkg_name][cs_name] = cs
        end
    end
    return log
end

---filter log by regex
---@param log log
---@param regex string
---@return log log
function M.filter(log, regex)
    for pkg_name, pkg in pairs(log) do
        for cs_name, _ in pairs(pkg) do
            if cs_name:match(regex) then
                log[pkg_name][cs_name] = nil
            end
        end
    end
    return log
end

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

---sort log and dump output
---@param log log
---@param is_detailed boolean if print control sequences' values
---@return string text
function M.dump(log, is_detailed)
    local pkg_names = M.get_sorted_keys(log)
    local lines = {}
    for _, pkg_name in ipairs(pkg_names) do
        local pkg = log[pkg_name]
        local cs_names = M.get_sorted_keys(pkg)
        local sublines = {}
        for _, cs_name in ipairs(cs_names) do
            local cs = pkg[cs_name]
            local line = cs_name
            if is_detailed then
                line = line .. ' ' .. cs.type .. ' ' .. cs.value
            end
            table.insert(sublines, line)
        end
        if #cs_names ~= 0 then
            table.insert(lines, pkg_name)
            table.insert(lines, table.concat(sublines, "\n"))
        end
    end
    return table.concat(lines, "\n\n")
end

---**final entry for texdef and latexdef**
---@param args table parsed command line arguments
function M.output(args)
    if args == nil or args.f == nil then
        return
    end
    local text
    if args.list ~= 0 then
        local log = M.parse_log(args.f, args.entering, args.leaving)
        log = M.filter(log, args.ignore_regex)
        text = M.dump(log, args.list > 1)
    else
        text = args.f:read("*a"):gsub('=\n', ' = '):gsub('= macro:%->', '-> ')
        if args.find > 1 then
            text = M.replace(text, args.defined)
        end
    end
    print(text)
    args.f:close()
end

return M
