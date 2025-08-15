local git_ref = 'release-2019-12-09'
local modrev = '1.3'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/bitset'

rockspec_format = '3.0'
package = 'bitset'
version = modrev .. '-' .. specrev

description = {
  summary = [[Handle bit-vector datatype]],
  detailed =
  [[This package defines and implements the data type bit set, a vector of bits. The size of the vector may grow dynamically. Individual bits can be manipulated.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'intcalc', 'infwarerr', 'bigintcalc' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/bitset.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
