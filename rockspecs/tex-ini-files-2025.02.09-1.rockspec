local git_ref = '2025-02-09'
local modrev = git_ref:gsub("-", ".")
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
  url = repo_url .. '/archive/refs/tags/' .. git_ref .. '.zip',
  dir = package .. "-" .. git_ref
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
--- old/luatex.ini
+++ new/luatex.ini
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
    lualatexquotejobname = 'lualatexquotejobname.lua'
  },
  install = {
    conf = {
      ['../tex/generic/tex-ini-files/dviluatex.ini'] = 'dviluatex.ini',
      ['../tex/generic/tex-ini-files/luatex.ini'] = 'luatex.ini',
      ['../tex/generic/tex-ini-files/luatexconfig.tex'] = 'luatexconfig.tex',
      ['../tex/generic/tex-ini-files/luatexiniconfig.tex'] = 'luatexiniconfig.tex',
      ['../tex/generic/tex-ini-files/pdftexconfig.tex'] = 'pdftexconfig.tex',
      ['../tex/generic/tex-ini-files/pdfxmltex.ini'] = 'pdfxmltex.ini',
      ['../tex/generic/tex-ini-files/xetex.ini'] = 'xetex.ini',
      ['../tex/generic/tex-ini-files/xmltex.ini'] = 'xmltex.ini',
      ['../tex/latex/tex-ini-files/dvilualatex.ini'] = 'dvilualatex.ini',
      ['../tex/latex/tex-ini-files/latex.ini'] = 'latex.ini',
      ['../tex/latex/tex-ini-files/lualatex.ini'] = 'lualatex.ini',
      ['../tex/latex/tex-ini-files/mllatex.ini'] = 'mllatex.ini',
      ['../tex/latex/tex-ini-files/pdflatex.ini'] = 'pdflatex.ini',
      ['../tex/latex/tex-ini-files/xelatex.ini'] = 'xelatex.ini',
    }
  }
}
