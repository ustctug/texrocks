---library for `epstopdf`
---@module epstopdf
---@copyright 2025
local texrocks = require 'texrocks'
local argparse = require 'argparse'
local M = {}

---get parser
---@param progname string program name
---@return table parser
function M.get_parser(progname)
    local parser = argparse(progname):add_complete()
    parser:argument('epsfile', 'eps file name'):args(1)
    parser:argument('pdffile', 'pdf file name'):args('?')
    parser:option('--debug', 'output debugging info'):args(0)
    parser:option('-o --outfile', 'pdf file name')
    parser:option('--nogs', 'do not run ghostscript'):args(0)
    parser:option('--gscmd', 'pipe output', 'gs')
    parser:option('--gsopt', 'single option for gs split by space', '')
    parser:option('--gsopts', 'options for gs'):count('*')
    parser:option('--device', 'use -sDEVICE=', 'pdfwrite')
    parser:option('--autorotate', 'set AutoRotatePages. PageByPage is equivalent to All for eps', 'None'):choices {
        'None', 'All', 'PageByPage'
    }
    parser:option('--nocompress', 'use compression'):args(0)
    parser:option('--noembed', 'do not embed fonts'):args(0)
    parser:option('--gray', 'grayscale output'):args(0)
    parser:option('--pdfsettings', 'use -dPDFSETTINGS=/', 'prepress'):choices {
        'screen', 'ebook', 'printer', 'prepress', 'default'
    }
    parser:option('--nosafer', 'use -d(NO)SAFER'):args(0)
    parser:option('--noquiet', 'use -q (-dQUIET)'):args(0)
    parser:option('--res', 'set image resolution')
    return parser
end

---parse command line arguments
---@param args string[] command line arguments
---@return table cmd_args parsed result
function M.parse(args)
    local parser = M.get_parser(args[0])
    local cmd_args = parser:parse(args)
    return M.postparse(cmd_args)
end

---change some values by command line arguments
---@param args table parsed result
---@return table cmd_args processed result
function M.postparse(args)
    args.pdffile = args.outfile or args.pdffile or args.epsfile:gsub("%.eps$", ".pdf")
    for opt in args.gsopt:gmatch('(%S+)%s*') do
        table.insert(args.gsopts, opt)
    end
    if args.nosafer then
        table.insert(args.gsopts, '--nosafer')
    else
        table.insert(args.gsopts, '-dSAFER')
    end
    table.insert(args.gsopts, '-dNOPAUSE')
    table.insert(args.gsopts, '-dBATCH')
    table.insert(args.gsopts, '-dCompatibilityLevel=1.5')
    if not args.noquiet then
        table.insert(args.gsopts, '-q')
    end
    table.insert(args.gsopts, '-sDEVICE=' .. args.device)
    table.insert(args.gsopts, '-sOutputFile=' .. args.pdffile)
    if args.nocompress then
        table.insert(args.gsopts, '-dUseFlateCompression=false')
    end
    if not args.noembed then
        table.insert(args.gsopts, '-dPDFSETTINGS#/' .. args.pdfsettings)
        table.insert(args.gsopts, '-dMaxSubsetPct=100')
        table.insert(args.gsopts, '-dSubsetFonts=true')
        table.insert(args.gsopts, '-dEmbedAllFonts=true')
    end
    if args.gray then
        table.insert(args.gsopts, '-sColorConversionStrategy=Gray')
        table.insert(args.gsopts, '-dProcessColorModel=/DeviceGray')
    end
    if args.res then
        table.insert(args.gsopts, '-r' .. args.res)
    end
    table.insert(args.gsopts, '-dAutoRotatePages#/' .. args.autorotate)
    table.insert(args.gsopts, args.epsfile)
    table.insert(args.gsopts, '-c')
    table.insert(args.gsopts, 'quit')
    return args
end

---**entry for epstopdf**
---@param args string[] command line arguments
function M.main(args)
    local cmd_args = M.parse(args)
    local cmd = { cmd_args.gscmd }
    for _, opt in ipairs(cmd_args.gsopts) do
        table.insert(cmd, opt)
    end
    if cmd_args.debug then
        print('$ ' .. texrocks.get_cmd(cmd))
    end
    if cmd_args.nogs then
        return
    end
    texrocks.exec(cmd)
end

return M
