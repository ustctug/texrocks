local kpse = require 'kpse'
local argparse = require 'argparse'
local semver = require 'semver'
local M = {}

function M.get_parser(arg0)
    local parser = argparse(arg0):add_complete()
    parser:argument('file', 'file name'):args('*')
    parser:option('--progname', 'set program name', arg[0])
    parser:option('--help-formats -l', 'display information about all supported file formats by -l, -ll'):args(0):count(
        '*')
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
    parser:option('--debug -d', 'set debug flags'):args(0):count('*')
    return parser
end

function M.main(args)
    local parser = M.get_parser(args[0])
    args = parser:parse(args)
    if args.version then
        print(kpse.version())
        return
    elseif args.help_formats > 0 then
        if args.help_formats > 1 then
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
            if args.help_formats > 1 then
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
    for _, v in ipairs(args.expand_braces or {}) do
        if args.debug == 0 then
            v = v .. ' -> ' .. kpse.expand_braces(v)
        end
        print(v)
    end
    for _, v in ipairs(args.expand_path or {}) do
        if args.debug == 0 then
            v = v .. ' -> ' .. kpse.expand_path(v)
        end
        print(v)
    end
    for _, v in ipairs(args.expand_var or {}) do
        if args.debug == 0 then
            v = v .. ' -> ' .. kpse.expand_var(v)
        end
        print(v)
    end
    for _, v in ipairs(args.var_value or {}) do
        if args.debug == 0 then
            v = v .. ' = ' .. kpse.var_value(v)
        end
        print(v)
    end
    for _, v in ipairs(args.show_path or {}) do
        v = M.aliases[v] or v
        if args.debug == 0 then
            v = v .. ': ' .. kpse.show_path(v)
        end
        print(v)
    end
    local err
    for k, v in ipairs(args.file) do
        if args.debug == 0 then
            v = kpse.lookup(v)
        end
        if v == nil then
            v = args.file[k] .. ' not found'
            err = true
        end
        print(v)
    end
    if err then
        os.exit(1)
    end
end

M.aliases = {
    bitmapfont = 'bitmap font',
    mpsupport = 'MetaPost support',
    source = 'TeX system sources',
    doc = 'TeX system documentation',
    trofffont = 'Troff fonts',
    dvipsconfig = 'dvips config',
    web2c = 'web2c files',
    othertext = 'other text files',
    otherbin = 'other binary files',
    miscfont = 'misc fonts',
    cmap = 'cmap files',
    pdftexconfig = 'pdftex config',
}

M.formats = {
    gf = {
        patterns = { '*.gf' },
        vars = { 'GFFONTS', 'GLYPHFONTS', 'TEXFONTS' }
    },
    pk = {
        patterns = { '*.pk' },
        vars = { 'PKFONTS', 'TEXPKS', 'GLYPHFONTS', 'TEXFONTS' }
    },
    ['bitmap font'] = {
        vars = { 'GLYPHFONTS', 'TEXFONTS' }
    },
    tfm = {
        patterns = { '*.tfm' },
        vars = { 'TFMFONTS', 'TEXFONTS' }
    },
    afm = {
        patterns = { '*.afm' },
        vars = { 'AFMFONTS', 'TEXFONTS' }
    },
    base = {
        patterns = { '*.base' },
        vars = { 'MFBASES', 'TEXMFINI' }
    },
    bib = {
        patterns = { '*.bib' },
        vars = { 'BIBINPUTS', 'TEXBIB' }
    },
    bst = {
        patterns = { '*.bst' },
        vars = { 'BSTINPUTS' }
    },
    cnf = {
        source = 'paths.h',
        patterns = { '*.cnf' },
        vars = { 'TEXMFCNF' }
    },
    ['ls-R'] = {
        patterns = { 'ls-R', 'ls-r' },
        vars = { 'TEXMFDBS' }
    },
    fmt = {
        patterns = { '*.fmt' },
        vars = { 'TEXFORMATS', 'TEXMFINI' }
    },
    map = {
        patterns = { '*.map' },
        vars = { 'TEXFONTMAPS', 'TEXFONTS' }
    },
    mem = {
        patterns = { '*.mem' },
        vars = { 'MPMEMS', 'TEXMFINI' }
    },
    mf = {
        patterns = { '*.mf' },
        vars = { 'MFINPUTS' }
    },
    mfpool = {
        patterns = { '*.pool' },
        vars = { 'MFPOOL', 'TEXMFINI' }
    },
    mft = {
        patterns = { '*.mft' },
        vars = { 'MFTINPUTS' }
    },
    mp = {
        patterns = { '*.mp' },
        vars = { 'MPINPUTS' }
    },
    mppool = {
        patterns = { '*.pool' },
        vars = { 'MPPOOL', 'TEXMFINI' }
    },
    ['MetaPost support'] = {
        vars = { 'MPSUPPORT' }
    },
    ocp = {
        patterns = { '*.ocp' },
        vars = { 'OCPINPUTS' }
    },
    ofm = {
        patterns = { '*.ofm' },
        vars = { 'OFMFONTS', 'TEXFONTS' }
    },
    opl = {
        patterns = { '*.opl', '*.pl' },
        vars = { 'OPLFONTS', 'TEXFONTS' }
    },
    otp = {
        patterns = { '*.otp' },
        vars = { 'OTPINPUTS' }
    },
    ovf = {
        patterns = { '*.ovf', '*.vf' },
        vars = { 'OVFFONTS', 'TEXFONTS' }
    },
    ovp = {
        patterns = { '*.ovp', '*.vpl' },
        vars = { 'OVPFONTS', 'TEXFONTS' }
    },
    ['graphic/figure'] = {
        patterns = { '*.eps', '*.epsi' },
        vars = { 'TEXPICTS', 'TEXINPUTS' }
    },
    tex = {
        patterns = { '*.tex', '*.sty', '*.cls', '*.fd', '*.aux', '.bbl', '.def', '.clo', '.ldf' },
        vars = { 'TEXINPUTS' }
    },
    ['TeX system documentation'] = {
        vars = { 'TEXDOCS' }
    },
    texpool = {
        patterns = { '*.pool' },
        vars = { 'TEXPOOL', 'TEXMFINI' }
    },
    ['TeX system sources'] = {
        patterns = { '*.dtx', '*.ins' },
        vars = { 'TEXSOURCES' }
    },
    ['PostScript header'] = {
        patterns = { '*.pro' },
        vars = { 'TEXPSHEADERS', 'PSHEADERS' }
    },
    ['Troff fonts'] = {
        vars = { 'TRFONTS' }
    },
    ['type1 fonts'] = {
        patterns = { '*.pfa', '*.pfb' },
        vars = { 'T1FONTS', 'T1INPUTS', 'TEXFONTS', 'TEXPSHEADERS', 'PSHEADERS' }
    },
    vf = {
        patterns = { '*.vf' },
        vars = { 'VFFONTS', 'TEXFONTS' }
    },
    ['dvips config'] = {
        vars = { 'TEXCONFIG' }
    },
    ist = {
        patterns = { '*.ist' },
        vars = { 'TEXINDEXSTYLE', 'INDEXSTYLE' }
    },
    ['truetype fonts'] = {
        patterns = { '*.ttf ', '*.ttc ', '*.TTF ', '*.TTC ', '*.dfont' },
        vars = { 'TTFONTS', 'TEXFONTS' }
    },
    ['type42 fonts'] = {
        patterns = { '*.t42 ', '*.T42 ' },
        vars = { 'T42FONTS', 'TEXFONTS' }
    },
    ['web2c files'] = {
        vars = { 'WEB2C' }
    },
    ['other text files'] = {
        vars = { '${PROGNAME}INPUTS' }
    },
    ['other binary files'] = {
        vars = { '${PROGNAME}INPUTS' }
    },
    ['misc fonts'] = {
        vars = { 'MISCFONTS', 'TEXFONTS' }
    },
    web = {
        patterns = { '*.web', '*.ch' },
        vars = { 'WEBINPUTS' }
    },
    cweb = {
        patterns = { '*.w', '*.web', '*.ch' },
        vars = { 'CWEBINPUTS' }
    },
    ['enc files'] = {
        patterns = { '*.enc' },
        vars = { 'ENCFONTS', 'TEXFONTS' }
    },
    ['cmap files'] = {
        vars = { 'CMAPFONTS', 'TEXFONTS' }
    },
    ['subfont definition files'] = {
        patterns = { '*.sfd' },
        vars = { 'SFDFONTS', 'TEXFONTS' }
    },
    ['opentype fonts'] = {
        patterns = { '*.otf', '*.OTF' },
        vars = { 'OPENTYPEFONTS', 'TEXFONTS' }
    },
    ['pdftex config'] = {
        vars = { 'PDFTEXCONFIG' }
    },
    ['lig files'] = {
        patterns = { '*.lig' },
        vars = { 'LIGFONTS', 'TEXFONTS' }
    },
    texmfscripts = {
        vars = { 'TEXMFSCRIPTS' }
    },
    lua = {
        patterns = { '*.lua', '*.luatex', '*.luc', '*.luctex', '*.texlua', '*.texluc', '*.tlu' },
        vars = { 'LUAINPUTS' }
    },
    ['font feature files'] = {
        patterns = { '*.fea' },
        vars = { 'FONTFEATURES' }
    },
    ['cid maps'] = {
        patterns = { '*.cid', '*.cidmap' },
        vars = { 'FONTCIDMAPS' }
    },
    mlbib = {
        patterns = { '*.mlbib', '*.bib' },
        vars = { 'MLBIBINPUTS', 'BIBINPUTS', 'TEXBIB' }
    },
    mlbst = {
        patterns = { '*.mlbst', '*.bst' },
        vars = { 'MLBSTINPUTS', 'BSTINPUTS' }
    },
    clua = {
        patterns = { '*.dll', '*.so' },
        vars = { 'CLUAINPUTS' }
    },
    ris = {
        patterns = { '*.ris' },
        vars = { 'RISINPUTS' }
    },
    bltxml = {
        patterns = { '*.bltxml' },
        vars = { 'BLTXMLINPUTS' }
    },
}
local v = semver(kpse.version():gsub(".* ", ''):gsub("/dev", ""))
if v < semver(6, 4, 0) then
    M.formats.ris = nil
    M.formats.bltxml = nil
end

return M
