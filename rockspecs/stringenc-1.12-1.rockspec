local git_ref = 'release-2019-11-29'
local modrev = '1.12'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/stringenc'

rockspec_format = '3.0'
package = 'stringenc'
version = modrev .. '-' .. specrev

description = {
  summary = [[Converting a string between different encodings]],
  detailed =
  [[This package provides \StringEncodingConvert for converting a string between different encodings. Both LaTeX and plain-TeX are supported.]],
  labels = { 'Encoding juggle' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'infwarerr', 'ltxcmds', 'pdfescape' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/stringenc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
