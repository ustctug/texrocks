---library for `tlmgr`
---@module texrocks.tlmgr
---@copyright 2026
local lfs      = require "lfs"
local argparse = require 'argparse'
local util     = require "cjson.util"
local M        = {}

---get parser
---@param progname string program name
---@return table parser
function M.get_parser(progname)
    local parser = argparse(progname):add_complete()
    parser:option('--silent -s', 'decrease verbosity'):args(0):count('*')
    parser:option('--debug -d', 'increase verbosity'):args(0):count('*')
    parser:option('--dry-run -n', 'no output'):args(0)
    local cmd = parser:command('generate',
        'The "generate" action overwrites any manual changes made in the' ..
        'respective files: it recreates them from scratch based on the' ..
        'information of the installed packages, plus local adaptations. The TeX' ..
        'Live installer and "tlmgr" routinely call "generate" for all of these' ..
        'files.')
    cmd:argument "files":choices { "language", "language.dat", "language.dat.lua", "language.def" }:args "+"
    parser:command('recreate-tlpdb', [[recreate tlpdb]])
    return parser
end

---**entry for tlmgr**
---@param argv string[] command line arguments
function M.main(argv)
    local parser = M.get_parser(argv[0])
    local args = parser:parse(argv)
    local verbosity = args.debug - args.silent

    local dir = ".lux"
    if not lfs.isdir(dir) then
        lfs.mkdir(dir)
    end

    if args.generate then
        local files = args.files
        for _, file in ipairs(args.files) do
            if file == 'language' then
                files = { 'language.dat', 'language.dat.lua', 'language.def' }
            end
        end
        for _, file in ipairs(files) do
            local ext = file:sub(-3)
            if ext == 'lua' then
                M.generate(verbosity, args.dry_run)
            elseif not args.dry_run then
                local f = io.open(".lux/" .. file, 'w')
                if f then
                    if ext == 'dat' then
                        f:write("% ex: filetype=texmf\n")
                    else
                        f:write("% ex: filetype=tex\n")
                    end
                    f:write("% lualatex only use language.dat.lua")
                    f:close()
                end
            end
        end
    end
end

---convert `*.tlpsrc` to `language.dat.lua`
---@param verbosity integer? verbosity level
---@param dry_run boolean? no output
function M.generate(verbosity, dry_run)
    verbosity = verbosity or 0
    -- TODO: https://github.com/hyphenation/tex-hyphen/tree/master/TL/tlpkg/tlpsrc
    local data = {}
    if verbosity > 0 then
        print(data)
    end
    if not dry_run then
        local f = io.open(".lux/language.dat.lua", 'w')
        if f then
            f:write("return " .. util.serialise_value(data))
            f:close()
        end
    end
end

return M
