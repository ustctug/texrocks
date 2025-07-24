local git_ref = 'release-2019-12-03'
local modrev = '1.5'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/infwarerr'

rockspec_format = '3.0'
package = 'infwarerr'
version = modrev .. '-' .. specrev

dependencies = {}

description = {
  summary = 'Complete set of information/warning/error message macros',
  detailed =
  [[This package provides a complete set of macros for information, warning and error messages. Under LaTeX, the commands are wrappers for the corresponding LaTeX commands; under Plain TeX they are available as complete implementations.]],
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/infwarerr.tds.zip',
    dir = '.'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode infwarerr.dtx
]],
  install = {
    conf = {
      ['../tex/generic/infwarerr/infwarerr.sty'] = 'infwarerr.sty',
    }
  }
}
