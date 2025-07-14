local git_ref = 'scm'
local modrev = git_ref
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
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/bigintcalc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
