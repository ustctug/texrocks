local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/stringenc'

rockspec_format = '3.0'
package = 'stringenc'
version = modrev .. '-' .. specrev

description = {
  summary = [[Converting a string between different encodings]],
  detailed =
  [[This package provides \StringEncodingConvert for converting a string between different encodings. Both LaTeX and plain-TeX are supported.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/stringenc',
  license = 'LPPL-1.3c'
}

dependencies = { 'infwarerr', 'ltxcmds', 'pdfescape' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/stringenc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
