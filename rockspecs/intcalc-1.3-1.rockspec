local git_ref = 'release-2019-12-15'
local modrev = '1.3'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/intcalc'

rockspec_format = '3.0'
package = 'intcalc'
version = modrev .. '-' .. specrev

description = {
  summary = [[Expandable arithmetic operations with integers]],
  detailed =
  [[This package provides expandable arithmetic operations with integers, using the e-TeX extension \numexpr if it is available.]],
  labels = { 'Calculation', 'Arithmetic' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/intcalc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
