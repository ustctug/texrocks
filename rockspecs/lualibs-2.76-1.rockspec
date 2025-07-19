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
  homepage = 'https://github.com/latex3/lualibs',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/refs/tags/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/luatex/generic/lualibs.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'builtin',
  copy_directories = { 'doc' },
  modules = {
    ["lualibs-basic-merged"] = "lualibs-basic-merged.lua",
    ["lualibs-basic"] = "lualibs-basic.lua",
    ["lualibs-boolean"] = "lualibs-boolean.lua",
    ["lualibs-compat"] = "lualibs-compat.lua",
    ["lualibs-dir"] = "lualibs-dir.lua",
    ["lualibs-extended-merged"] = "lualibs-extended-merged.lua",
    ["lualibs-extended"] = "lualibs-extended.lua",
    ["lualibs-file"] = "lualibs-file.lua",
    ["lualibs-function"] = "lualibs-function.lua",
    ["lualibs-io"] = "lualibs-io.lua",
    ["lualibs-lpeg"] = "lualibs-lpeg.lua",
    ["lualibs-lua"] = "lualibs-lua.lua",
    ["lualibs-math"] = "lualibs-math.lua",
    ["lualibs-md5"] = "lualibs-md5.lua",
    ["lualibs-number"] = "lualibs-number.lua",
    ["lualibs-os"] = "lualibs-os.lua",
    ["lualibs-package"] = "lualibs-package.lua",
    ["lualibs-set"] = "lualibs-set.lua",
    ["lualibs-string"] = "lualibs-string.lua",
    ["lualibs-table"] = "lualibs-table.lua",
    ["lualibs-trac-inf"] = "lualibs-trac-inf.lua",
    ["lualibs-unicode"] = "lualibs-unicode.lua",
    ["lualibs-url"] = "lualibs-url.lua",
    ["lualibs-util-deb"] = "lualibs-util-deb.lua",
    ["lualibs-util-dim"] = "lualibs-util-dim.lua",
    ["lualibs-util-fil"] = "lualibs-util-fil.lua",
    ["lualibs-util-jsn"] = "lualibs-util-jsn.lua",
    ["lualibs-util-lua"] = "lualibs-util-lua.lua",
    ["lualibs-util-prs"] = "lualibs-util-prs.lua",
    ["lualibs-util-sac"] = "lualibs-util-sac.lua",
    ["lualibs-util-sta"] = "lualibs-util-sta.lua",
    ["lualibs-util-sto"] = "lualibs-util-sto.lua",
    ["lualibs-util-str"] = "lualibs-util-str.lua",
    ["lualibs-util-tab"] = "lualibs-util-tab.lua",
    ["lualibs-util-tpl"] = "lualibs-util-tpl.lua",
    ["lualibs-util-zip"] = "lualibs-util-zip.lua",
    ["lualibs"] = "lualibs.lua",
  },
}
