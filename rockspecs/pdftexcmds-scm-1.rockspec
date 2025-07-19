local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/pdftexcmds'

rockspec_format = '3.0'
package = 'pdftexcmds'
version = modrev .. '-' .. specrev

dependencies = {}

description = {
  summary = 'LuaTeX support for pdfTeX utility functions',
  detailed =
  [[LuaTeX provides most of the commands of pdfTeX 1.40. However, a number of utility functions are not available. This package tries to fill the gap and implements some of the missing primitives using Lua.]],
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/pdftexcmds.zip',
  }
end

build_dependencies = { 'luatex' }

dependencies = { 'infwarerr', 'iftex', 'ltxcmds' }

build = {
  type = 'command',
  build_command = [[
        luatex --interaction=nonstopmode pdftexcmds.dtx
  ]],
  install = {
    lua = {
      'pdftexcmds.lua',
    },
    conf = {
      ['../tex/generic/pdftexcmds/pdftexcmds.sty'] = 'pdftexcmds.sty',
      ['../doc/generic/pdftexcmds/pdftexcmds.pdf'] = 'pdftexcmds.pdf',
    }
  }
}
