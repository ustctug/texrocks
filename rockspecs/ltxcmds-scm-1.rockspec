local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/ltxcmds'

rockspec_format = '3.0'
package = 'ltxcmds'
version = modrev .. '-' .. specrev

dependencies = {}

description = {
  summary = 'Some LaTeX kernel commands for general use',
  detailed =
  [[This package exports some utility macros from the LaTeX kernel into a separate namespace and also makes them available for other formats such as plain TeX.]],
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
    url = 'https://mirrors.ctan.org/macros/generic/ltxcmds.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
  luatex --interaction=nonstopmode ltxcmds.dtx
]],
  install = {
    conf = {
      ['../doc/generic/ltxcmds/ltxcmds.pdf'] = 'ltxcmds.pdf',
      ['../tex/generic/ltxcmds/ltxcmds.sty'] = 'ltxcmds.sty',
    }
  }
}
