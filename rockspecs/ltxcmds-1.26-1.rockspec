local git_ref = '1.26'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/ltxcmds'

rockspec_format = '3.0'
package = 'ltxcmds'
version = modrev .. '-' .. specrev

build_dependencies = { "luatex", 'latex-base' }

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
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/ltxcmds.zip",
  dir = 'ltxcmds'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/ltxcmds.zip',
    dir = 'ltxcmds'
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
