local git_ref = '1.7'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/etexcmds'

rockspec_format = '3.0'
package = 'etexcmds'
version = modrev .. '-' .. specrev

dependencies = { 'iftex', 'infwarerr' }

description = {
  summary = 'Avoid name clashes with e-TeX commands',
  detailed =
  [[New primitive commands are introduced in e-TeX; sometimes the names collide with existing macros. This package solves the name clashes by adding a prefix to e-TeX’s commands. For example, ε-TeX’s \unexpanded is provided as \etex@unexpanded.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/etexcmds',
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/etexcmds.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/etexcmds.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
