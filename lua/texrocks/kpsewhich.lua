---library for `kpsewhich`
---@module texrocks.kpsewhich
---@copyright 2026
local kpse = require 'kpse'
local argparse = require 'argparse'
local cjson = require 'cjson'
local texrocks = require 'texrocks'

---@param name string
---@return table
local function decode(name)
    local root = debug.getinfo(1).source:match("@?(.*).lua$")
    local f = io.open(root .. "/" .. name .. ".json")
    local content = "{}"
    if f then
        content = f:read("*a")
        f:close()
    end
    return cjson.decode(content)
end

local M = {
    aliases = decode("aliases"),
    formats = decode("formats"),
}
-- kpse 6.4.0
M.formats.ris = nil
M.formats.bltxml = nil

---get parser
---@param progname string program name
---@return table parser
function M.get_parser(progname)
    local parser = argparse(progname):add_complete()
    parser:argument('file', 'file name'):args('*')
    parser:option('--progname', 'set program name', progname)
    parser:option('--help-formats', 'display information about all supported file formats'):args(0)
    parser:option('--expand-braces', 'output variable and brace expansion'):count('*')
    parser:option('--expand-path', 'output complete path expansion'):count('*')
    parser:option('--expand-var', 'output variable expansion'):count('*')
    parser:option('--var-value', 'output variable-expanded value of variable'):count('*')
    local names = {}
    for name, _ in pairs(M.formats) do
        table.insert(names, name)
    end
    for alias, _ in pairs(M.aliases) do
        table.insert(names, alias)
    end
    table.sort(names)
    parser:option('--show-path', 'output search path for file type'):count('*'):choices(names)
    parser:option('--version', 'display version information number and exit.'):args(0)
    parser:option('--silent -s', 'decrease verbosity'):args(0):count('*')
    parser:option('--debug -d', 'increase verbosity'):args(0):count('*')
    names = {}
    for name, _ in pairs(M.formats) do
        table.insert(names, name)
    end
    parser:option('--format', 'use specific file type', nil):choices(names)
    parser:option('--dpi', 'use this resolution for this lookup', 600):convert(tonumber)
    parser:option('--path', 'search in the given path', nil)
    parser:option('--all', 'output all matches, not just the first'):args(0)
    parser:option('--must-exist', 'search the disk as well as ls-R if necessary'):args(0)
    parser:option('--mktexpk', 'enable mktexpk generation for this lookup'):args(0)
    parser:option('--mktextex', 'enable mktextex generation for this lookup'):args(0)
    parser:option('--mktexmf', 'enable mktexmf generation for this lookup'):args(0)
    parser:option('--mktextfm', 'enable mktextfm generation for this lookup'):args(0)
    parser:option('--subdir', 'only output matches whose directory part ends with the given strings'):count('*')
    parser:option('--open', 'call PDF browser to open PDF'):args(0)
    return parser
end

---**entry for kpsewhich**
---@param argv string[] command line arguments
function M.main(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    local verbosity = args.debug - args.silent

    if args.version then
        print(kpse.version())
        return
    end

    if args.help_formats then
        if verbosity > 0 then
            kpse.set_program_name(args.progname)
        end

        local names = {}
        for name, _ in pairs(M.formats) do
            table.insert(names, name)
        end
        table.sort(names)
        for _, name in ipairs(names) do
            local format = M.formats[name]
            local aliases = { name }
            for k, v in pairs(M.aliases) do
                if v == name then
                    table.insert(aliases, k)
                end
            end
            print(table.concat(aliases, ', ') ..
                ': ' .. table.concat(format.vars, ', ') .. ': defined by ' .. (format.source or 'texmf.cnf'))
            if verbosity > 0 then
                if format.source then
                    print(kpse.default_texmfcnf())
                else
                    print(kpse.show_path(name))
                end
            end
        end
        return
    end

    kpse.set_program_name(args.progname)
    for _, method in ipairs { "expand_braces", "expand_path", "expand_var", "var_value", "show_path" } do
        for _, v in ipairs(args[method] or {}) do
            local result = kpse[method](v)
            if verbosity > 0 then
                local eq = " -> "
                if method == "var_value" then
                    eq = "="
                end
                result = v .. eq .. result
            end
            print(result)
        end
    end

    local format = args.format
    if args.open then
        format = 'TeX system documentation'
    end
    for k, v in ipairs(args.file) do
        local options = {
            debug = verbosity,
            format = format,
            dpi = args.dpi,
            path = args.path,
            all = args.all,
            mustexist = args.mustexist,
            mktexpk = args.mktexpk,
            mktextex = args.mktextex,
            mktexmf = args.mktexmf,
            mktextfm = args.mktextfm,
            subdir = args.subdir,
        }
        v = kpse.lookup(v, options)
        if v == nil then
            print(args.file[k] .. ' not found')
            os.exit(1)
        end
        if args.open then
            local cmd_args = M.get_cmd_args(v)
            print('$ ' .. texrocks.get_cmd(cmd_args))
            texrocks.exec(cmd_args)
        end
        print(v)
    end
end

---use correct system tool to open PDF
---@param file string PDF file path
---@return string[] args command line arguments
---@diagnostic disable: undefined-field
-- luacheck: ignore 143
function M.get_cmd_args(file)
    if os.name == 'macosx' then
        return { "open", file }
    elseif os.name == 'windows' or os.name == 'cygwin' then
        return { "start", file }
    elseif os.getenv "PREFIX" then
        return { "termux-open", file }
    elseif file:gsub(".*%.", "") == "pdf" and os.getenv "DISPLAY" == nil then
        return { "pdftotext", file, "-" }
    else
        return { "xdg-open", file }
    end
end

return M
