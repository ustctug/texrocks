local git_ref = 'v2.76'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/latex3/lualibs'

rockspec_format = '3.0'
package = 'lualibs'
version = modrev .. '-' .. specrev

description = {
  summary = 'Additional Lua functions for LuaTeX macro programmers',
  detailed =
  [[Lualibs is a collection of Lua modules useful for general programming.

The bundle is based on lua modules shipped with ConTeXt, and made available in this bundle for use independent of ConTeXt.]],
  labels = { 'tex', 'luatex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/luatex/generic/lualibs.tds.zip',
    dir = '.'
  }
end

build_dependencies = { 'luatex', 'latex-base', 'kpathsea' }

build = {
  type = 'l3build',
  patches = {
    ["remove-texmfhome.diff"] = [[
--- old/build.lua
+++ new/build.lua
@@ -53,7 +53,7 @@
 -- to make it easier to run the tests there and to have a complete
 -- set there for users
           
-options["texmfhome"] = "../luaotfload/supporttexmf"           
+-- options["texmfhome"] = "../luaotfload/supporttexmf"           
 ctanreadme= "CTANREADME.md"
 -------------------
 -- documentation
]],
  },
}
