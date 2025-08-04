local git_ref = '2.7'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'paralist'
version = modrev .. '-' .. specrev

description = {
  summary = 'Execute Lua code in any TeX engine that exposes the shell',
  detailed =
  [[This is an expl3(-generic) package for plain TeX, LaTeX, and ConTeXt that allows you to execute Lua code in LuaTeX or any other TeX engine that exposes the shell.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://www.ctan.org/pkg/paralist',
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/paralist.zip",
  dir = 'paralist'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/paralist.zip',
    dir = 'paralist'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode paralist.ins
]],
  install = {
    conf = {
      ['../tex/latex/paralist/paralist.sty'] = 'paralist.sty',
    },
  }
}
