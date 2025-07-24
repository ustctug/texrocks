local git_ref = '2.9'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'xkeyval'
version = modrev .. '-' .. specrev

description = {
  summary = [[Extension of the keyval package]],
  detailed =
  [[This package is an extension of the keyval package and offers additional macros for setting keys and declaring and setting class or package options. The package allows the programmer to specify a prefix to the name of the macros it defines for keys, and to define families of key definitions; these all help use in documents where several packages define their own sets of keys.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://ctan.org/pkg/xkeyval',
  license = 'LPPL-1.3'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'latex-tools' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/xkeyval.zip",
  dir = 'xkeyval'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/xkeyval.zip',
    dir = 'xkeyval'
  }
end

build = {
  type = 'command',
  patches = {
    ["add-bye.diff"] = [[
--- old/xkeyval.dtx
+++ new/xkeyval.dtx
@@ -85,6 +85,7 @@
   \file{xkeyval.bib}{\from{xkeyval.dtx}{bib}}
 }
 \endgroup
+\bye
 %</batchfile>
 %<*driver>
 \documentclass[a4paper]{ltxdoc}
]]
  },
  build_command = [[
    luatex --interaction=nonstopmode xkeyval.dtx
  ]],
  install = {
    conf = {
      ['../doc/generic/xkeyval/xkeyval.pdf'] = 'xkeyval.pdf',
      ['../tex/generic/xkeyval/keyval.tex'] = 'keyval.tex',
      ['../tex/generic/xkeyval/pst-xkey.tex'] = 'pst-xkey.tex',
      ['../tex/generic/xkeyval/xkeyval.tex'] = 'xkeyval.tex',
      ['../tex/generic/xkeyval/xkvtxhdr.tex'] = 'xkvtxhdr.tex',
      ['../tex/generic/xkeyval/xkvutils.tex'] = 'xkvutils.tex',
      ['../tex/latex/xkeyval/pst-xkey.sty'] = 'pst-xkey.sty',
      ['../tex/latex/xkeyval/xkeyval.sty'] = 'xkeyval.sty',
      ['../tex/latex/xkeyval/xkvltxp.sty'] = 'xkvltxp.sty',
      ['../tex/latex/xkeyval/xkvview.sty'] = 'xkvview.sty',
    }
  }
}
