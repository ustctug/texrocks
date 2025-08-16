local git_ref = '2.2.2'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/witiko/lt3luabridge'

rockspec_format = '3.0'
package = 'lt3luabridge'
version = modrev .. '-' .. specrev

description = {
  summary = 'Execute Lua code in any TeX engine that exposes the shell',
  detailed =
  [[This is an expl3(-generic) package for plain TeX, LaTeX, and ConTeXt that allows you to execute Lua code in LuaTeX or any other TeX engine that exposes the shell.]],
  labels = { 'Experimental LaTeX3', 'Exec foreign' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

dependencies = {'l3kernel'}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/lt3luabridge.zip',
  dir = 'lt3luabridge'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/lt3luabridge.zip',
    dir = 'lt3luabridge'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode lt3luabridge.ins
]],
  install = {
    conf = {
      ['../tex/context/third/lt3luabridge/t-lt3luabridge.tex'] = 't-lt3luabridge.tex',
      ['../tex/generic/lt3luabridge/lt3luabridge.tex'] = 'lt3luabridge.tex',
      ['../tex/latex/lt3luabridge/lt3luabridge.sty'] = 'lt3luabridge.sty',
    },
  }
}
