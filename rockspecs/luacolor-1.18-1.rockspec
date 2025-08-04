local git_ref = 'v1.18'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/luacolor'

rockspec_format = '3.0'
package = 'luacolor'
version = modrev .. '-' .. specrev

description = {
  summary = 'Color support based on LuaTeX\' node attributes',
  detailed =
  [[This package implements color support based on LuaTeX' node attributes.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'luacolor-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/latex/luacolor.zip',
    dir = 'luacolor'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode luacolor.dtx
]],
  install = {
    conf = {
      ['../tex/latex/luacolor/luacolor.sty'] = 'luacolor.sty',
    },
    lua = {
      ['luacolor'] = 'luacolor.lua',
    },
  }
}
