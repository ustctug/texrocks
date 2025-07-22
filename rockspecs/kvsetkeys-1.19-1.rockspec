local git_ref = 'release-2019-12-15'
local modrev = '1.19'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/kvsetkeys'

rockspec_format = '3.0'
package = 'kvsetkeys'
version = modrev .. '-' .. specrev

description = {
  summary = 'Key value parser with default handler support',
  detailed =
  [[This package provides \kvsetkeys, a variant of package keyval's \setkeys. It allows the user to specify a handler that deals with unknown options. Active commas and equal signs may be used (e.g. see babel's shorthands) and only one level of curly braces are removed from the values.]],
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
    url = 'https://mirrors.ctan.org/macros/latex/contrib/kvsetkeys.zip',
    dir = 'kvsetkeys'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode kvsetkeys.dtx
]],
  install = {
    conf = {
      -- ['../doc/latex/kvsetkeys/kvsetkeys.pdf'] = 'kvsetkeys.pdf',
      ['../tex/latex/kvsetkeys/kvsetkeys.sty'] = 'kvsetkeys.sty',
    }
  }
}
