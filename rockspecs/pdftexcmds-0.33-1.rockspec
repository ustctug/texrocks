local git_ref = 'v0.33'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/pdftexcmds'

rockspec_format = '3.0'
package = 'pdftexcmds'
version = modrev .. '-' .. specrev

description = {
  summary = 'LuaTeX support for pdfTeX utility functions',
  detailed =
  [[LuaTeX provides most of the commands of pdfTeX 1.40. However, a number of utility functions are not available. This package tries to fill the gap and implements some of the missing primitives using Lua.]],
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/pdftexcmds.zip',
    dir = 'pdftexcmds'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'infwarerr', 'iftex', 'ltxcmds' }

build = {
  type = 'l3build',
}
