local git_ref = 'scm'
local modrev = git_ref
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
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
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
    ["lualibs-basic-merged"] = "tex/luatex/lualibs/lualibs-basic-merged.lua",
    ["lualibs-basic"] = "tex/luatex/lualibs/lualibs-basic.lua",
    ["lualibs-boolean"] = "tex/luatex/lualibs/lualibs-boolean.lua",
    ["lualibs-compat"] = "tex/luatex/lualibs/lualibs-compat.lua",
    ["lualibs-dir"] = "tex/luatex/lualibs/lualibs-dir.lua",
    ["lualibs-extended-merged"] = "tex/luatex/lualibs/lualibs-extended-merged.lua",
    ["lualibs-extended"] = "tex/luatex/lualibs/lualibs-extended.lua",
    ["lualibs-file"] = "tex/luatex/lualibs/lualibs-file.lua",
    ["lualibs-function"] = "tex/luatex/lualibs/lualibs-function.lua",
    ["lualibs-io"] = "tex/luatex/lualibs/lualibs-io.lua",
    ["lualibs-lpeg"] = "tex/luatex/lualibs/lualibs-lpeg.lua",
    ["lualibs-lua"] = "tex/luatex/lualibs/lualibs-lua.lua",
    ["lualibs-math"] = "tex/luatex/lualibs/lualibs-math.lua",
    ["lualibs-md5"] = "tex/luatex/lualibs/lualibs-md5.lua",
    ["lualibs-number"] = "tex/luatex/lualibs/lualibs-number.lua",
    ["lualibs-os"] = "tex/luatex/lualibs/lualibs-os.lua",
    ["lualibs-package"] = "tex/luatex/lualibs/lualibs-package.lua",
    ["lualibs-set"] = "tex/luatex/lualibs/lualibs-set.lua",
    ["lualibs-string"] = "tex/luatex/lualibs/lualibs-string.lua",
    ["lualibs-table"] = "tex/luatex/lualibs/lualibs-table.lua",
    ["lualibs-trac-inf"] = "tex/luatex/lualibs/lualibs-trac-inf.lua",
    ["lualibs-unicode"] = "tex/luatex/lualibs/lualibs-unicode.lua",
    ["lualibs-url"] = "tex/luatex/lualibs/lualibs-url.lua",
    ["lualibs-util-deb"] = "tex/luatex/lualibs/lualibs-util-deb.lua",
    ["lualibs-util-dim"] = "tex/luatex/lualibs/lualibs-util-dim.lua",
    ["lualibs-util-fil"] = "tex/luatex/lualibs/lualibs-util-fil.lua",
    ["lualibs-util-jsn"] = "tex/luatex/lualibs/lualibs-util-jsn.lua",
    ["lualibs-util-lua"] = "tex/luatex/lualibs/lualibs-util-lua.lua",
    ["lualibs-util-prs"] = "tex/luatex/lualibs/lualibs-util-prs.lua",
    ["lualibs-util-sac"] = "tex/luatex/lualibs/lualibs-util-sac.lua",
    ["lualibs-util-sta"] = "tex/luatex/lualibs/lualibs-util-sta.lua",
    ["lualibs-util-sto"] = "tex/luatex/lualibs/lualibs-util-sto.lua",
    ["lualibs-util-str"] = "tex/luatex/lualibs/lualibs-util-str.lua",
    ["lualibs-util-tab"] = "tex/luatex/lualibs/lualibs-util-tab.lua",
    ["lualibs-util-tpl"] = "tex/luatex/lualibs/lualibs-util-tpl.lua",
    ["lualibs-util-zip"] = "tex/luatex/lualibs/lualibs-util-zip.lua",
    ["lualibs"] = "tex/luatex/lualibs/lualibs.lua",
  },
}
