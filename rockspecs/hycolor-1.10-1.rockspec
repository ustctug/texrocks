local git_ref = 'release-2020-01-27'
local modrev = '1.10'
local specrev = '1'

rockspec_format = '3.0'
package = 'hycolor'
version = modrev .. '-' .. specrev

local repo_url = 'https://github.com/ho-tex/hycolor'

description = {
  summary = [[Implements colour for packages hyperref and bookmark]],
  detailed =
  [[This package provides the code for the color option that is used by packages hyperref and bookmark. It is not intended as package for the user.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'hopatch' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
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
      -- ['../doc/latex/hycolor/hycolor.pdf'] = 'hycolor.pdf',
      ['../tex/latex/hycolor/hycolor.sty'] = 'hycolor.sty',
    }
  }
}
