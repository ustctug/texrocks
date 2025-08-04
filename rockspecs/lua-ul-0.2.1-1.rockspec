local git_ref = 'v0.2.1'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/zauguin/luaul'

rockspec_format = '3.0'
package = 'lua-ul'
version = modrev .. '-' .. specrev

description = {
  summary = 'Underlining for LuaLaTeX',
  detailed =
  [[This package provides underlining, strikethough, and highlighting using features in LuaLaTeX which avoid the restrictions imposed by other methods. In particular, kerning is not affected, the underlined text can use arbitrary commands, hyphenation works etc.

The package requires LuaTeX version >= 1.12.0.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/lua-ul-ctan.zip',
  dir = 'lua-ul'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/latex/lua-ul.zip',
    dir = 'lua-ul'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode lua-ul.dtx
]],
  install = {
    conf = {
      ['../tex/lualatex/lua-ul/lua-ul.sty'] = 'lua-ul.sty',
    },
    lua = {
      ['lua-ul'] = 'lua-ul.lua',
      ['lua-ul-patches-preserve-attr'] = 'lua-ul-patches-preserve-attr.lua',
      ['pre_append_to_vlist_filter'] = 'pre_append_to_vlist_filter.lua',
    },
  }
}
