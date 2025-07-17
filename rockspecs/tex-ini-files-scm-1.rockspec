local git_ref = '2023-11-17'
local modrev = 'scm'
local specrev = '1'

local repo_url = 'https://github.com/latex3/tex-ini-files'

rockspec_format = '3.0'
package = 'tex-ini-files'
version = modrev .. '-' .. specrev

description = {
  summary = 'Model TeX format creation files',
  detailed =
  [[This bundle provides a collection of model .ini files for creating TeX formats. These files are commonly used to introduced distribution-dependent variations in formats. They are also used to allow existing format source files to be used with newer engines, for example to adapt the plain e-TeX source file to work with XeTeX and LuaTeX.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/latex3/tex-ini-files',
  license = 'CC0-1.0'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/generic/tex-ini-files.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'builtin',
  patches = {
    -- https://github.com/RadioNoiseE/apltex/blob/52b75b9bc64bcf5543207e73875f39e7d4d88613/fmtdump/luatex.ini#L15
    ["add-latex-map.diff"] = [[
--- old/tex/generic/tex-ini-files/luatex.ini
+++ new/tex/generic/tex-ini-files/luatex.ini
@@ -9,4 +9,5 @@
 \input luatexiniconfig.tex
 \input load-unicode-data.tex
 \input etex.src
+\everyjob=\expandafter{\the\everyjob\pdfextension mapfile {luatex.map}}
 \dump
]]
  },
  copy_directories = { 'doc' },
  modules = {
    lualatexquotejobname = 'tex/latex/tex-ini-files/lualatexquotejobname.lua'
  },
  install = {
    conf = {
      ['../tex/generic/tex-ini-files/dviluatex.ini'] = 'tex/generic/tex-ini-files/dviluatex.ini',
      ['../tex/generic/tex-ini-files/luatex.ini'] = 'tex/generic/tex-ini-files/luatex.ini',
      ['../tex/generic/tex-ini-files/luatexconfig.tex'] = 'tex/generic/tex-ini-files/luatexconfig.tex',
      ['../tex/generic/tex-ini-files/luatexiniconfig.tex'] = 'tex/generic/tex-ini-files/luatexiniconfig.tex',
      ['../tex/generic/tex-ini-files/pdftexconfig.tex'] = 'tex/generic/tex-ini-files/pdftexconfig.tex',
      ['../tex/generic/tex-ini-files/pdfxmltex.ini'] = 'tex/generic/tex-ini-files/pdfxmltex.ini',
      ['../tex/generic/tex-ini-files/xetex.ini'] = 'tex/generic/tex-ini-files/xetex.ini',
      ['../tex/generic/tex-ini-files/xmltex.ini'] = 'tex/generic/tex-ini-files/xmltex.ini',
      ['../tex/latex/tex-ini-files/dvilualatex.ini'] = 'tex/latex/tex-ini-files/dvilualatex.ini',
      ['../tex/latex/tex-ini-files/latex.ini'] = 'tex/latex/tex-ini-files/latex.ini',
      ['../tex/latex/tex-ini-files/lualatex.ini'] = 'tex/latex/tex-ini-files/lualatex.ini',
      ['../tex/latex/tex-ini-files/mllatex.ini'] = 'tex/latex/tex-ini-files/mllatex.ini',
      ['../tex/latex/tex-ini-files/pdflatex.ini'] = 'tex/latex/tex-ini-files/pdflatex.ini',
      ['../tex/latex/tex-ini-files/xelatex.ini'] = 'tex/latex/tex-ini-files/xelatex.ini',
    }
  }
}
