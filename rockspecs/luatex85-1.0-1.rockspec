local git_ref = 'v1.0'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/josephwright/luatex85'

rockspec_format = '3.0'
package = 'luatex85'
version = modrev .. '-' .. specrev

description = {
  summary = [[pdfTeX aliases for LuaTeX]],
  detailed =
  [[The package provides emulation of pdfTeX primitives for LuaTeX v0.85+.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

build_dependencies = { 'luatex', 'latex-base' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/luatex85.zip',
  }
end

build = {
  type = 'l3build',
  patches = {
    ["fix-kpsewhich.diff"] = [[
--- old/build.lua
+++ new/build.lua
@@ -31,5 +31,5 @@
 end
 
 -- Find and run the build system
-kpse.set_program_name ("kpsewhich")
-dofile (kpse.lookup ("l3build.lua"))
+-- kpse.set_program_name ("kpsewhich")
+-- dofile (kpse.lookup ("l3build.lua"))
]],
  },
}
