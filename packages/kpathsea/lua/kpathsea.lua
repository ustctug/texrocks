local argparse = require 'argparse'
local M = {
    formats = {
        gf = {
            patterns = { '*.gf' },
            vars = { 'GFFONTS', 'GLYPHFONTS', 'TEXFONTS' }
        },
        pk = {
            patterns = { '*.pk' },
            vars = { 'PKFONTS', 'TEXPKS', 'GLYPHFONTS', 'TEXFONTS' }
        },
        bitmapfont = {
            aliases = { 'bitmap font' },
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
        mpsupport = {
            aliases = { 'MetaPost support' },
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
        doc = {
            vars = { 'TEXDOCS' }
        },
        texpool = {
            patterns = { '*.pool' },
            vars = { 'TEXPOOL', 'TEXMFINI' }
        },
        source = {
            aliases = { 'TeX system sources' },
            patterns = { '*.dtx', '*.ins' },
            vars = { 'TEXSOURCES' }
        },
        ['PostScript header'] = {
            patterns = { '*.pro' },
            vars = { 'TEXPSHEADERS', 'PSHEADERS' }
        },
        trofffont = {
            aliases = { 'Troff fonts' },
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
        dvipsconfig = {
            aliases = { 'dvips config' },
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
        web2c = {
            aliases = { 'web2c files' },
            vars = { 'WEB2C' }
        },
        othertext = {
            aliases = { 'other text files' },
            vars = { 'KPSEWHICHINPUTS' }
        },
        otherbin = {
            aliases = { 'other binary files' },
            vars = { 'KPSEWHICHINPUTS' }
        },
        miscfont = {
            aliases = { 'misc fonts' },
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
        cmap = {
            aliases = { 'cmap files' },
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
        pdftexconfig = {
            aliases = { 'pdftex config' },
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
}

function M.get_parser(name)
    local parser = argparse(name)
    parser:argument('file', 'file name'):args('*')
    parser:option('--progname', 'set program name', arg[-2])
    parser:option('--help-formats -l', 'display information about all supported file formats by -l, -ll'):args(0):count(
        '*')
    parser:option('--expand-braces', 'output variable and brace expansion'):args('*')
    parser:option('--expand-path', 'output complete path expansion'):args('*')
    parser:option('--expand-var', 'output variable expansion'):args('*')
    parser:option('--var-value', 'output variable-expanded value of variable'):args('*')
    parser:option('--show-path', 'output search path for file type'):args('*')
    parser:option('--version', 'display version information number and exit.'):args(0)
    return parser
end

function M.main(args)
    local parser = M.get_parser(args[0])
    local args = parser:parse(args)
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
            local aliases = format.aliases or {}
            table.insert(aliases, name)
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
        print(kpse.expand_braces(v))
    end
    for _, v in ipairs(args.expand_path or {}) do
        print(kpse.expand_path(v))
    end
    for _, v in ipairs(args.expand_var or {}) do
        print(kpse.expand_var(v))
    end
    for _, v in ipairs(args.var_value or {}) do
        print(kpse.var_value(v))
    end
    for _, v in ipairs(args.show_path or {}) do
        print(kpse.show_path(v))
    end
    for _, file in ipairs(args.file) do
        print(kpse.lookup(file))
    end
end

return M
