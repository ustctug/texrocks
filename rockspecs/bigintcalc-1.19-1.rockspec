local git_ref = 'release-2019-12-15'
local modrev = '1.19'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/bigintcalc'

rockspec_format = '3.0'
package = 'bigintcalc'
version = modrev .. '-' .. specrev

dependencies = { 'pdftexcmds' }

description = {
  summary = 'Integer calculations on very large numbers',
  detailed =
  [[This package provides expandable arithmetic operations with big integers that can exceed TeX's number limits.]],
  labels = { 'Arithmetic', 'Calculation' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/bigintcalc.tds.zip',
    dir = '.'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'l3build',
}
