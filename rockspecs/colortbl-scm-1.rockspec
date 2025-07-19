local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/colortbl'

rockspec_format = '3.0'
package = 'colortbl'
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
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/colortbl.zip',
    dir = 'colortbl'
  }
end

build_dependencies = { 'lualatex' }

dependencies = { 'latex-tools' }

build = {
  type = 'command',
  build_command = [[
  lualatex --interaction=nonstopmode colortbl.ins
]],
  install = {
    conf = {
      ['../tex/latex/colortbl/colortbl.sty'] = 'colortbl.sty',
      ['../doc/latex/colortbl/colortbl.pdf'] = 'colortbl.pdf',
    }
  }
}
