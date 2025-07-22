package = 'colortbl'
local modrev = '1.0'
local specrev = '11'
local git_ref = package .. '-1.0' .. package.char(specrev + 0x60)

local repo_url = 'https://github.com/davidcarlisle/dpctex/'

rockspec_format = '3.0'
version = modrev .. '-' .. specrev

description = {
  summary = 'Add colour to LaTeX tables',
  detailed =
  [[The package allows rows and columns to be coloured, and even individual cells.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'dpctex-' .. git_ref .. '/' .. package,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/colortbl.zip',
    dir = 'colortbl'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'latex-tools' }

build = {
  type = 'command',
  build_command = [[
  luatex --interaction=nonstopmode colortbl.ins
]],
  install = {
    conf = {
      -- ['../doc/latex/colortbl/colortbl.pdf'] = 'colortbl.pdf',
      ['../tex/latex/colortbl/colortbl.sty'] = 'colortbl.sty',
    }
  }
}
