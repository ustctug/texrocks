local git_ref = 'v3.14'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/kvoptions'

rockspec_format = '3.0'
package = 'kvoptions'
version = modrev .. '-' .. specrev

description = {
  summary = 'Key value format for package options',
  detailed =
  [[This package offers support for package authors who want to use options in key-value format for their package options.]],
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'etexcmds', 'ltxcmds', 'latex-graphics', 'iftex' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/kvoptions.zip',
    dir = 'kvoptions'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode kvoptions.dtx
]],
  install = {
    conf = {
      -- ['../doc/latex/kvoptions/kvoptions.pdf'] = 'kvoptions.pdf',
      ['../tex/latex/kvoptions/kvoptions.sty'] = 'kvoptions.sty',
      ['../tex/latex/kvoptions/kvoptions-patch.sty'] = 'kvoptions-patch.sty',
    }
  }
}
