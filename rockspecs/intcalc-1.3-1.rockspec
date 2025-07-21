local git_ref = '1.3'
local modrev = git_ref
local specrev = '1'

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
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/intcalc.tds.zip",
  dir = '.'
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
