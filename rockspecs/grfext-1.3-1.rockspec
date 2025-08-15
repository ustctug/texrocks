local git_ref = 'release-2019-12-03'
local modrev = '1.3'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/grfext'

rockspec_format = '3.0'
package = 'grfext'
version = modrev .. '-' .. specrev

description = {
  summary = [[Manipulate the graphics package's list of extensions]],
  detailed =
  [[This package provides macros for adding to, and reordering the list of graphics file extensions recognised by package graphics.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'infwarerr', 'kvdefinekeys' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/grfext.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
