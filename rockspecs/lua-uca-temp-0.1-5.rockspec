local git_ref = 'v0.1e'
local _git_ref = git_ref:gsub('^v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = git_ref.format('%d', _git_ref:gsub('[0-9.]', ''):byte() - 0x60)

package = "lua-uca-temp"
local repo_url = "https://github.com/michal-h21/lua-uca"
version = modrev .. '-' .. specrev
source = {
  url = repo_url .. "/archive/" .. git_ref .. ".zip",
  dir = 'lua-uca-' .. _git_ref
}

dependencies = {
   "lua >= 5.1"
}
description = {
   summary = "Implementation of the Unicode Collation Algorithm for Lua",
   detailed = [[
      This package adds support for the Unicode collation algorithm for Lua 5.3. It is mainly intended for use with LuaTeX and working TeX distribution, but it can work also as a standalone Lua module. You will need to install a required Lua-uni-algos package by hand in that case.]],
   homepage = repo_url,
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      ["lua-uca.chinese"] = "src/lua-uca/lua-uca-chinese.lua",
      ["lua-uca.collator"] = "src/lua-uca/lua-uca-collator.lua",
      ["lua-uca.ducet-jit"] = "src/lua-uca/lua-uca-ducet-jit.lua",
      ["lua-uca.ducet"] = "src/lua-uca/lua-uca-ducet.lua",
      ["lua-uca.languages"] = "src/lua-uca/lua-uca-languages.lua",
      ["lua-uca.reordering-table"] = "src/lua-uca/lua-uca-reordering-table.lua",
      ["lua-uca.tailoring"] = "src/lua-uca/lua-uca-tailoring.lua"
   }
}
