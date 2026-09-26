local git_ref = '2026-09-09'
local modrev = git_ref:gsub('-0', '-'):gsub('-', '.')
local specrev = '1'

local repo_url = 'https://github.com/latex3/l3build'

rockspec_format = '3.0'
package = 'l3build'
version = modrev .. '-' .. specrev

description = {
  summary = 'A testing and building system for LaTeX',
  detailed =
  [[The build system supports testing and building LaTeX3 code, on Linux, Mac OS X and Windows systems. The package offers:

    A unit testing system for (La)TeX code (whether kernel code or contributed packages);
    A system for typesetting package documentation; and
    An automated process for creating CTAN releases.

The package is essentially independent of other material released by the LaTeX3 team, and may be updated on a different schedule.]],
  labels = { 'Macro support', 'Package development', 'CTAN' },
  homepage = 'https://ctan.org/pkg/l3build',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git+https')
  }
end

dependencies = { "texrocks" }

build = {
  type = 'tds',
  patches = {
    ["fix-set_program.diff"] = [[
--- old/scripts/l3build/l3build-install.lua
+++ new/scripts/l3build/l3build-install.lua
@@ -36,7 +36,7 @@
 local insert = table.insert
 
 local function gethome()
-  set_program("latex")
+  set_program("kpsewhich")
   local result = options["texmfhome"] or var_value("TEXMFHOME")
   if not result or result == "" or match(result, os_pathsep) then
     print("Ambiguous TEXMFHOME setting: please use the --texmfhome option")
]],
    ["fix-exe.diff"] = [[
--- old/scripts/l3build/l3build-variables.lua
+++ new/scripts/l3build/l3build-variables.lua
@@ -105,15 +105,15 @@
 unpackdeps  = unpackdeps  or { }

 -- Executable names plus following options
-typesetexe = typesetexe or "pdflatex"
-unpackexe  = unpackexe  or "pdftex"
+typesetexe = typesetexe or "lualatex"
+unpackexe  = unpackexe  or "luatex"

 checkopts   = checkopts   or "-interaction=nonstopmode"
 typesetopts = typesetopts or "-interaction=nonstopmode"
 unpackopts  = unpackopts  or ""

 -- Engines for testing
-checkengines = checkengines or {"pdftex", "xetex", "luatex"}
+checkengines = checkengines or {"luatex"}
 checkformat  = checkformat  or "latex"
 specialformats = specialformats or { }
 specialformats.context = specialformats.context or {
]],
    ["fix-l3build.diff"] = [[
--- old/scripts/l3build/l3build.lua
+++ new/scripts/l3build/l3build.lua
@@ -44,7 +44,6 @@ local open             = io.open

 -- l3build setup and functions
 kpse.set_program_name("kpsewhich")
-build_kpse_path = match(lookup("l3build.lua"),"(.*[/])")
 local function build_require(s)
   require(lookup("l3build-"..s..".lua", { path = build_kpse_path } ) )
 end
]],
  },
}

deploy = {
  wrap_bin_scripts = false
}
