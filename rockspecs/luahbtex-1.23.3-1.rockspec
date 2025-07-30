local git_ref = '1.23.3'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://gitlab.lisn.upsaclay.fr/texlive/luatex'

rockspec_format = '3.0'
package = 'luahbtex'
version = modrev .. '-' .. specrev

description = {
  summary = 'an extended version of pdfTeX using Lua as an embedded scripting language',
  detailed =
  [[The LuaTeX project's main objective is to provide an open and configurable variant of TeX while at the same time offering downward compatibility]],
  labels = { 'tex', 'lua' },
  homepage = 'https://www.luatex.org/',
  license = "GPL-2.0"
}

source = {
  url = repo_url .. '/-/archive/' .. git_ref .. '/luatex-' .. git_ref .. '.zip',
  dir = 'luatex-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git+https')
  }
end

build = {
  type = 'command',
  patches = {
      ["fix-build.sh.diff"] = [[
--- old/build.sh
+++ new/build.sh
@@ -89,7 +89,7 @@
 USEMUSL=FALSE
 TEXLIVEOPT=
 
-CFLAGS="$CFLAGS"
+export CFLAGS="$CFLAGS -std=gnu99"
 CXXFLAGS="$CXXFLAGS"
 
 
]],
     ["customize-texmf.diff"] = [[
--- old/source/texk/kpathsea/texmf.cnf
+++ new/source/texk/kpathsea/texmf.cnf
@@ -574,33 +574,7 @@
 % since we don't want to scatter ../'s throughout the value.  Hence we
 % explicitly list every directory.  Arguably more understandable anyway.
 %
-TEXMFCNF = {\
-$SELFAUTOLOC,\
-$SELFAUTOLOC/share/texmf-local/web2c,\
-$SELFAUTOLOC/share/texmf-dist/web2c,\
-$SELFAUTOLOC/share/texmf/web2c,\
-$SELFAUTOLOC/texmf-local/web2c,\
-$SELFAUTOLOC/texmf-dist/web2c,\
-$SELFAUTOLOC/texmf/web2c,\
-\
-$SELFAUTODIR,\
-$SELFAUTODIR/share/texmf-local/web2c,\
-$SELFAUTODIR/share/texmf-dist/web2c,\
-$SELFAUTODIR/share/texmf/web2c,\
-$SELFAUTODIR/texmf-local/web2c,\
-$SELFAUTODIR/texmf-dist/web2c,\
-$SELFAUTODIR/texmf/web2c,\
-\
-$SELFAUTOGRANDPARENT/texmf-local/web2c,\
-$SELFAUTOPARENT,\
-\
-$SELFAUTOPARENT/share/texmf-local/web2c,\
-$SELFAUTOPARENT/share/texmf-dist/web2c,\
-$SELFAUTOPARENT/share/texmf/web2c,\
-$SELFAUTOPARENT/texmf-local/web2c,\
-$SELFAUTOPARENT/texmf-dist/web2c,\
-$SELFAUTOPARENT/texmf/web2c\
-}
+TEXMFCNF = {~/.config/texmf,~/.local/share/texmf,$SELFAUTODIR}/web2c
 %
 % For reference, here is the old brace-using definition:
 %TEXMFCNF = {$SELFAUTOLOC,$SELFAUTODIR,$SELFAUTOPARENT}{,{/share,}/texmf{-local,}/web2c}
]]
  },
  build_command = [[sh build.sh --nolua53 --luahb --parallel]],
  install = {
    bin = {
      luahbtex = 'build/texk/web2c/luahbtex'
    },
    conf = {
      ['../web2c/texmf.cnf'] = 'source/texk/kpathsea/texmf.cnf'
    }
  }
}
