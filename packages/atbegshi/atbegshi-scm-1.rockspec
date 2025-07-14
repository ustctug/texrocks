local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/atbegshi'

rockspec_format = '3.0'
package = 'atbegshi'
version = modrev .. '-' .. specrev

description = {
  summary = [[Execute stuff at \shipout time]],
  detailed =
  [[This package is a modern reimplementation of package everyshi, providing various commands to be executed before a \shipout command. It makes use of e-TeX’s facilities if they are available. The package may be used either with LaTeX or with plain TeX.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/atbegshi',
  license = 'LPPL-1.3c'
}

dependencies = { 'ltxcmds', 'infwarerr', 'iftex' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/atbegshi.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
