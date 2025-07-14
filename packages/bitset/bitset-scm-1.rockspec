local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/bitset'

rockspec_format = '3.0'
package = 'bitset'
version = modrev .. '-' .. specrev

description = {
  summary = [[Handle bit-vector datatype]],
  detailed =
  [[This package defines and implements the data type bit set, a vector of bits. The size of the vector may grow dynamically. Individual bits can be manipulated.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/bitset',
  license = 'LPPL-1.3c'
}

dependencies = { 'intcalc', 'infwarerr', 'bigintcalc' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/bitset.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
