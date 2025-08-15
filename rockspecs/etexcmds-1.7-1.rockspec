local git_ref = 'release-2019-12-15'
local modrev = '1.7'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/etexcmds'

rockspec_format = '3.0'
package = 'etexcmds'
version = modrev .. '-' .. specrev

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'iftex', 'infwarerr' }

description = {
  summary = 'Avoid name clashes with e-TeX commands',
  detailed =
  [[New primitive commands are introduced in e-TeX; sometimes the names collide with existing macros. This package solves the name clashes by adding a prefix to e-TeX’s commands. For example, ε-TeX’s \unexpanded is provided as \etex@unexpanded.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/etexcmds.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
