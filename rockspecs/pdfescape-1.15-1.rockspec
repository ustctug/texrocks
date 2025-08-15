local git_ref = 'release-2019-12-09'
local modrev = '1.15'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/pdfescape'

rockspec_format = '3.0'
package = 'pdfescape'
version = modrev .. '-' .. specrev

description = {
  summary = [[Implements pdfTeX's escape features using TeX or e-TeX]],
  detailed =
  [[This package implements pdfTeX's escape features (\pdfescapehex, \pdfunescapehex, \pdfescapename, \pdfescapestring) using TeX or e-TeX.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'ltxcmds', 'pdftexcmds' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/pdfescape.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
