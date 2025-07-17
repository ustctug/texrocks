local git_ref = 'scm'
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
  dir = package .. '-' .. modrev,
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
--- old/src/luatexja-core.sty	2024-10-14 03:29:58.000000000 +0800
+++ new/src/luatexja-core.sty
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
  sh -c 'install -Dm644 src/*.lua -t lua &&
    install -Dm644 doc/*.pdf -t luatex/luatexja &&
    rm -rf src/*.lua doc &&
    mkdir -p tex/luatex doc &&
    mv src tex/luatex/luatexja &&
    mv luatex doc'
  ]],
  copy_directories = { 'doc', 'tex', 'lua' },
}
