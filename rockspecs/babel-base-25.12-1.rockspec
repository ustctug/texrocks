local git_ref = '25.12'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/latex3/babel'

rockspec_format = '3.0'
package = 'babel-base'
version = modrev .. '-' .. specrev

dependencies = { 'luatexbase' }

description = {
  summary = 'Multilingual support for LaTeX, LuaLaTeX, XeLaTeX, and Plain TeX',
  detailed =
  [[This package manages culturally-determined typographical (and other) rules for a wide range of languages. A document may select a single language to be supported, or it may select several, in which case the document may switch from one language to another in a variety of ways.

Babel uses contributed configuration files that provide the detail of what has to be done for each language, as well as .ini files for about 300 languages from around the World, including many written in non-Latin and RTL scripts. Many of them work with pdfLaTeX, as well as with XeLaTeX and LuaLaTeX, out of the box. A few even work with plain formats.]],
  labels = { 'tex', 'latex', 'plaintex', 'makeindex' },
  homepage = 'https://latex3.github.io/babel/',
  license = 'LPPL-1.3'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'babel-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/required/babel-base.tds.zip',
    dir = '.'
  }
end

build = {
  patches = {
    ["fix-kpsewhich.diff"] = [[
--- old/build.lua
+++ new/build.lua
@@ -36,7 +36,7 @@
 checkconfigs = {"build","config-lua"}
 
 -- Find and run the build system
-kpse.set_program_name ("kpsewhich")
-if not release_date then
-  dofile(kpse.lookup("l3build.lua"))
-end
+-- kpse.set_program_name ("kpsewhich")
+-- if not release_date then
+--   dofile(kpse.lookup("l3build.lua"))
+-- end
]],
  },
  type = 'l3build',
}
