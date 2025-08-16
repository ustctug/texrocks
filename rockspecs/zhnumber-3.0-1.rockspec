local git_ref = 'zhnumber-v3.0'
local modrev = git_ref:gsub('.*%-v', '')
local specrev = '1'

local repo_url = 'https://github.com/CTeX-org/ctex-kit'

rockspec_format = '3.0'
package = 'zhnumber'
version = modrev .. '-' .. specrev

description = {
  summary = [[Typeset Chinese representations of numbers]],
  detailed =
  [[The package provides commands to typeset Chinese representations of numbers. The main difference between this package and CJKnumb is that the commands provided are expandable in the ‘proper’ way.]],
  labels = { 'Numbers', 'Chinese' },
  homepage = 'http://www.ctex.org/',
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base', 'ctex-support' }

dependencies = { 'l3packages', 'l3kernel' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'ctex-kit-' .. git_ref .. '/' .. package,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/zhnumber.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
  patches = {
    ["replace-xelatex.diff"] = [[
--- old/build.lua
+++ new/build.lua
@@ -8,6 +8,7 @@
 installfiles     = {"*.sty", "*.cfg", "*.ins"}
 unpacksuppfiles  = {"zhnumber.id", "ctxdocstrip.tex", "ctex-zhconv.lua", "ctex-zhconv-index.lua"}
 typesetsuppfiles = {"ctxdoc.cls"}
+dtxchecksum = { exe = 'luatex' }
 
 tdslocations = {
   "source/latex/zhnumber/*.ins",
]],
  }
}
