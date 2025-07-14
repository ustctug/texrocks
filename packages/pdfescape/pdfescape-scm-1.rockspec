local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/pdfescape'

rockspec_format = '3.0'
package = 'pdfescape'
version = modrev .. '-' .. specrev

description = {
  summary = [[Implements pdfTeX's escape features using TeX or e-TeX]],
  detailed =
  [[This package implements pdfTeX's escape features (\pdfescapehex, \pdfunescapehex, \pdfescapename, \pdfescapestring) using TeX or e-TeX.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/pdfescape',
  license = 'LPPL-1.3c'
}

dependencies = { 'ltxcmds', 'pdftexcmds' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/pdfescape.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
