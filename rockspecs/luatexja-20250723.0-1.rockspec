local git_ref = '20250723.0'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/luatexja/luatexja'

rockspec_format = '3.0'
package = 'luatexja'
version = modrev .. '-' .. specrev

description = {
  summary = [[Typeset Japanese with Lua(La)TeX]],
  detailed =
  [[The package offers support for typesetting Japanese documents with LuaTeX. Either of the Plain and LaTeX2ε formats may be used with the package.]],
  labels = { 'tex', 'latex', 'luatex' },
  homepage = repo_url,
  license = 'BSD'
}

dependencies = { 'infwarerr', 'luatexbase', 'luaotfload', 'ltxcmds',
  'pdftexcmds', 'xkeyval', 'etoolbox', 'l3kernel' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev .. '/src',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/generic/luatexja.zip',
  }
end

build = {
  type = 'command',
  patches = {
    ["fix-path.diff"] = [[
--- old/luatexja-core.sty
+++ new/luatexja-core.sty
@@ -179,7 +179,7 @@
 \directlua{%
   luatexja = {};
   luatexja.lang_ja = \the\ltj@@japanese;
-  dofile(assert(kpse.find_file('luatexja.lua', 'tex'),
+  dofile(assert(kpse.find_file('luatexja.lua', 'lua'),
       "File `luatexja.lua' not found"))
 }
 
]]
  },
  build_command = [[
    luatex --interaction=nonstopmode *.ins
  ]],
  install = {
    lua = {
      ['jfm-CCT'] = 'jfm-CCT.lua',
      ['jfm-banjiao'] = 'jfm-banjiao.lua',
      ['jfm-jis'] = 'jfm-jis.lua',
      ['jfm-kaiming'] = 'jfm-kaiming.lua',
      ['jfm-min'] = 'jfm-min.lua',
      ['jfm-mono'] = 'jfm-mono.lua',
      ['jfm-prop'] = 'jfm-prop.lua',
      ['jfm-propv'] = 'jfm-propv.lua',
      ['jfm-propw'] = 'jfm-propw.lua',
      ['jfm-quanjiao'] = 'jfm-quanjiao.lua',
      ['jfm-tmin'] = 'jfm-tmin.lua',
      ['jfm-ujis'] = 'jfm-ujis.lua',
      ['jfm-ujisv'] = 'jfm-ujisv.lua',
      ['ltj-adjust'] = 'ltj-adjust.lua',
      ['ltj-base'] = 'ltj-base.lua',
      ['ltj-charrange'] = 'ltj-charrange.lua',
      ['ltj-compat'] = 'ltj-compat.lua',
      ['ltj-debug'] = 'ltj-debug.lua',
      ['ltj-direction'] = 'ltj-direction.lua',
      ['ltj-inputbuf'] = 'ltj-inputbuf.lua',
      ['ltj-ivd_aj1'] = 'ltj-ivd_aj1.lua',
      ['ltj-jfmglue'] = 'ltj-jfmglue.lua',
      ['ltj-jfont'] = 'ltj-jfont.lua',
      ['ltj-jisx0208'] = 'ltj-jisx0208.lua',
      ['ltj-lineskip'] = 'ltj-lineskip.lua',
      ['ltj-lotf_aux'] = 'ltj-lotf_aux.lua',
      ['ltj-math'] = 'ltj-math.lua',
      ['ltj-otf'] = 'ltj-otf.lua',
      ['ltj-pretreat'] = 'ltj-pretreat.lua',
      ['ltj-rmlgbm'] = 'ltj-rmlgbm.lua',
      ['ltj-ruby'] = 'ltj-ruby.lua',
      ['ltj-setwidth'] = 'ltj-setwidth.lua',
      ['ltj-stack'] = 'ltj-stack.lua',
      ['ltj-unicode-ccfix'] = 'ltj-unicode-ccfix.lua',
      ['luatexja'] = 'luatexja.lua',
    },
    conf = {
      ['../tex/luatex/luatexja/addons/luatexja-adjust.sty'] = 'addons/luatexja-adjust.sty',
      ['../tex/luatex/luatexja/addons/luatexja-ajmacros.sty'] = 'addons/luatexja-ajmacros.sty',
      ['../tex/luatex/luatexja/addons/luatexja-fontspec-27c.sty'] = 'addons/luatexja-fontspec-27c.sty',
      ['../tex/luatex/luatexja/addons/luatexja-fontspec-29c.sty'] = 'addons/luatexja-fontspec-29c.sty',
      ['../tex/luatex/luatexja/addons/luatexja-fontspec-29e.sty'] = 'addons/luatexja-fontspec-29e.sty',
      ['../tex/luatex/luatexja/addons/luatexja-fontspec.sty'] = 'addons/luatexja-fontspec.sty',
      ['../tex/luatex/luatexja/addons/luatexja-otf.sty'] = 'addons/luatexja-otf.sty',
      ['../tex/luatex/luatexja/addons/luatexja-preset.sty'] = 'addons/luatexja-preset.sty',
      ['../tex/luatex/luatexja/addons/luatexja-ruby.sty'] = 'addons/luatexja-ruby.sty',
      ['../tex/luatex/luatexja/addons/luatexja-zhfonts.sty'] = 'addons/luatexja-zhfonts.sty',
      ['../tex/luatex/luatexja/lltjext.sty'] = 'lltjext.sty',
      ['../tex/luatex/luatexja/ltj-base.sty'] = 'ltj-base.sty',
      ['../tex/luatex/luatexja/ltj-kinsoku.tex'] = 'ltj-kinsoku.tex',
      ['../tex/luatex/luatexja/ltj-latex.sty'] = 'ltj-latex.sty',
      ['../tex/luatex/luatexja/ltj-plain.sty'] = 'ltj-plain.sty',
      ['../tex/luatex/luatexja/ltjarticle.cls'] = 'ltjarticle.cls',
      ['../tex/luatex/luatexja/ltjbk10.clo'] = 'ltjbk10.clo',
      ['../tex/luatex/luatexja/ltjbk11.clo'] = 'ltjbk11.clo',
      ['../tex/luatex/luatexja/ltjbk12.clo'] = 'ltjbk12.clo',
      ['../tex/luatex/luatexja/ltjbook.cls'] = 'ltjbook.cls',
      ['../tex/luatex/luatexja/ltjltxdoc.cls'] = 'ltjltxdoc.cls',
      ['../tex/luatex/luatexja/ltjreport.cls'] = 'ltjreport.cls',
      ['../tex/luatex/luatexja/ltjsarticle.cls'] = 'ltjsarticle.cls',
      ['../tex/luatex/luatexja/ltjsbook.cls'] = 'ltjsbook.cls',
      ['../tex/luatex/luatexja/ltjsize10.clo'] = 'ltjsize10.clo',
      ['../tex/luatex/luatexja/ltjsize11.clo'] = 'ltjsize11.clo',
      ['../tex/luatex/luatexja/ltjsize12.clo'] = 'ltjsize12.clo',
      ['../tex/luatex/luatexja/ltjskiyou.cls'] = 'ltjskiyou.cls',
      ['../tex/luatex/luatexja/ltjspf.cls'] = 'ltjspf.cls',
      ['../tex/luatex/luatexja/ltjsreport.cls'] = 'ltjsreport.cls',
      ['../tex/luatex/luatexja/ltjtarticle.cls'] = 'ltjtarticle.cls',
      ['../tex/luatex/luatexja/ltjtbk10.clo'] = 'ltjtbk10.clo',
      ['../tex/luatex/luatexja/ltjtbk11.clo'] = 'ltjtbk11.clo',
      ['../tex/luatex/luatexja/ltjtbk12.clo'] = 'ltjtbk12.clo',
      ['../tex/luatex/luatexja/ltjtbook.cls'] = 'ltjtbook.cls',
      ['../tex/luatex/luatexja/ltjtreport.cls'] = 'ltjtreport.cls',
      ['../tex/luatex/luatexja/ltjtsize10.clo'] = 'ltjtsize10.clo',
      ['../tex/luatex/luatexja/ltjtsize11.clo'] = 'ltjtsize11.clo',
      ['../tex/luatex/luatexja/ltjtsize12.clo'] = 'ltjtsize12.clo',
      ['../tex/luatex/luatexja/luatexja-compat.sty'] = 'luatexja-compat.sty',
      ['../tex/luatex/luatexja/luatexja-core.sty'] = 'luatexja-core.sty',
      ['../tex/luatex/luatexja/luatexja.sty'] = 'luatexja.sty',
      ['../tex/luatex/luatexja/patches/lltjcore-241201.sty'] = 'patches/lltjcore-241201.sty',
      ['../tex/luatex/luatexja/patches/lltjcore.sty'] = 'patches/lltjcore.sty',
      ['../tex/luatex/luatexja/patches/lltjdefs.sty'] = 'patches/lltjdefs.sty',
      ['../tex/luatex/luatexja/patches/lltjfont.sty'] = 'patches/lltjfont.sty',
      ['../tex/luatex/luatexja/patches/lltjp-array.sty'] = 'patches/lltjp-array.sty',
      ['../tex/luatex/luatexja/patches/lltjp-atbegshi.sty'] = 'patches/lltjp-atbegshi.sty',
      ['../tex/luatex/luatexja/patches/lltjp-collcell.sty'] = 'patches/lltjp-collcell.sty',
      ['../tex/luatex/luatexja/patches/lltjp-everyshi.sty'] = 'patches/lltjp-everyshi.sty',
      ['../tex/luatex/luatexja/patches/lltjp-fontspec.sty'] = 'patches/lltjp-fontspec.sty',
      ['../tex/luatex/luatexja/patches/lltjp-footmisc.sty'] = 'patches/lltjp-footmisc.sty',
      ['../tex/luatex/luatexja/patches/lltjp-geometry.sty'] = 'patches/lltjp-geometry.sty',
      ['../tex/luatex/luatexja/patches/lltjp-listings.sty'] = 'patches/lltjp-listings.sty',
      ['../tex/luatex/luatexja/patches/lltjp-microtype.sty'] = 'patches/lltjp-microtype.sty',
      ['../tex/luatex/luatexja/patches/lltjp-preview.sty'] = 'patches/lltjp-preview.sty',
      ['../tex/luatex/luatexja/patches/lltjp-siunitx.sty'] = 'patches/lltjp-siunitx.sty',
      ['../tex/luatex/luatexja/patches/lltjp-stfloats.sty'] = 'patches/lltjp-stfloats.sty',
      ['../tex/luatex/luatexja/patches/lltjp-tascmac.sty'] = 'patches/lltjp-tascmac.sty',
      ['../tex/luatex/luatexja/patches/lltjp-unicode-math.sty'] = 'patches/lltjp-unicode-math.sty',
      ['../tex/luatex/luatexja/patches/lltjp-xunicode.sty'] = 'patches/lltjp-xunicode.sty',
    }
  }
}
