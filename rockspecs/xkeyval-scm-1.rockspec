local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/xkeyval'

rockspec_format = '3.0'
package = 'xkeyval'
version = modrev .. '-' .. specrev

description = {
  summary = [[Extension of the keyval package]],
  detailed =
  [[This package is an extension of the keyval package and offers additional macros for setting keys and declaring and setting class or package options. The package allows the programmer to specify a prefix to the name of the macros it defines for keys, and to define families of key definitions; these all help use in documents where several packages define their own sets of keys.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

build_dependencies = { 'lualatex', 'latex-base' }

dependencies = { 'latex-tools' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/xkeyval.zip',
  }
end

build = {
  type = 'command',
  patches = {
    ["add-xkeyval-ins.diff"] = [[
--- old/README
+++ new/README
@@ -1,3 +1,4 @@
+\iffalse
 xkeyval v2.9
 ------------
 
@@ -85,3 +86,29 @@
 distributed as a whole: readme, xkeyval.pdf, keyval.tex,
 pst-xkey.sty, pst-xkey.tex, xkeyval.sty, xkeyval.tex, xkvview.sty,
 xkvltxp.sty, xkvtxhdr.tex, xkvutils.tex, pst-xkey.dtx and xkeyval.dtx.
+\fi
+\input docstrip
+\usedir{tex/latex/\jobname}
+\generate{
+  \file{xkeyval.tex}{\from{xkeyval.dtx}{xkvtex}}
+  \file{xkeyval.sty}{\from{xkeyval.dtx}{xkvlatex}}
+  \file{xkvview.sty}{\from{xkeyval.dtx}{xkvview}}
+  \file{xkvltxp.sty}{\from{xkeyval.dtx}{xkvltxpatch}}
+  \file{keyval.tex}{\from{xkeyval.dtx}{xkvkeyval}}
+  \file{xkvtxhdr.tex}{\from{xkeyval.dtx}{xkvheader}}
+  \file{xkvutils.tex}{\from{xkeyval.dtx}{xkvutils}}
+  \file{pst-xkey.tex}{\from{xkeyval.dtx}{pxktex}}
+  \file{pst-xkey.sty}{\from{xkeyval.dtx}{pxklatex}}
+  \file{xkvex1.tex}{\from{xkeyval.dtx}{xkvex1}}
+  \file{xkvex2.tex}{\from{xkeyval.dtx}{xkvex2}}
+  \file{xkvex3.tex}{\from{xkeyval.dtx}{xkvex3}}
+  \file{xkvex4.tex}{\from{xkeyval.dtx}{xkvex4}}
+  \file{xkveca.cls}{\from{xkeyval.dtx}{xkveca}}
+  \file{xkvecb.cls}{\from{xkeyval.dtx}{xkvecb}}
+  \file{xkvesa.sty}{\from{xkeyval.dtx}{xkvesa}}
+  \file{xkvesb.sty}{\from{xkeyval.dtx}{xkvesb}}
+  \file{xkvesc.sty}{\from{xkeyval.dtx}{xkvesc}}
+  \file{xkvpream.ble}{\from{xkeyval.dtx}{preamble}}
+  \file{xkeyval.bib}{\from{xkeyval.dtx}{bib}}
+}
+\endbatchfile
    ]]
  },
  build_command = [[
    lualatex --interaction=nonstopmode README
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
