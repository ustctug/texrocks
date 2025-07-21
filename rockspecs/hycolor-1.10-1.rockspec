local git_ref = '1.10'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'hycolor'
version = modrev .. '-' .. specrev

description = {
  summary = [[Implements colour for packages hyperref and bookmark]],
  detailed =
  [[This package provides the code for the color option that is used by packages hyperref and bookmark. It is not intended as package for the user.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/hycolor',
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'hopatch' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/hycolor.zip",
  dir = 'hycolor'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/hycolor.zip',
    dir = 'hycolor'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode hycolor.dtx
  ]],
  install = {
    conf = {
      ['../doc/latex/hycolor/hycolor.pdf'] = 'hycolor.pdf',
      ['../tex/latex/hycolor/hycolor.sty'] = 'hycolor.sty',
    }
  }
}
