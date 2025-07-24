local git_ref = 'release-2019-12-15'
local modrev = '1.4'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/uniquecounter'

rockspec_format = '3.0'
package = 'uniquecounter'
version = modrev .. '-' .. specrev

dependencies = { 'bigintcalc', 'infwarerr' }

description = {
  summary = 'Provides unlimited unique counter',
  detailed =
  [[This package provides a kind of counter that provides unique number values. Several counters can be created with different names. The numeric values are not limited.]],
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
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/uniquecounter.tds.zip',
    dir = '.'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode uniquecounter.dtx
]],
  install = {
    conf = {
      ['../tex/generic/uniquecounter/uniquecounter.sty'] = 'uniquecounter.sty',
    }
  }
}
