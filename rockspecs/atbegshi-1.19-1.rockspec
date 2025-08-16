local git_ref = 'release-2019-12-05'
local modrev = '1.19'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/atbegshi'

rockspec_format = '3.0'
package = 'atbegshi'
version = modrev .. '-' .. specrev

description = {
  summary = [[Execute stuff at \shipout time]],
  detailed =
  [[This package is a modern reimplementation of package everyshi, providing various commands to be executed before a \shipout command. It makes use of e-TeX’s facilities if they are available. The package may be used either with LaTeX or with plain TeX.]],
  labels = { 'Defer stuff' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'ltxcmds', 'infwarerr', 'iftex' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/atbegshi.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
