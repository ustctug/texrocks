local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/intcalc'

rockspec_format = '3.0'
package = 'intcalc'
version = modrev .. '-' .. specrev

description = {
  summary = [[Expandable arithmetic operations with integers]],
  detailed =
  [[This package provides expandable arithmetic operations with integers, using the e-TeX extension \numexpr if it is available.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/intcalc',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/intcalc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
