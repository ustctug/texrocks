local git_ref = 'verse-v2.4c'
local _git_ref = git_ref:gsub('.*%-v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = git_ref.format('%d', _git_ref:gsub('[0-9.]', ''):byte() - 0x60)

local repo_url = 'https://github.com/LaTeX-Package-Repositories/herries-press'

rockspec_format = '3.0'
package = 'latex-verse'
version = modrev .. '-' .. specrev

description = {
  summary = 'Aids for typesetting simple verse',
  detailed =
  [[This package implements color support based on LuaTeX' node attributes.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'herries-press-' .. git_ref .. '/verse',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/verse.zip',
    dir = 'verse'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode verse.ins
]],
  install = {
    conf = {
      ['../tex/latex/verse/verse.sty'] = 'verse.sty',
    },
  }
}
