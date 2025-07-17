local git_ref = 'scm'
local modrev = git_ref
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
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/uniquecounter.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
