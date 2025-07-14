local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/float'

rockspec_format = '3.0'
package = 'float'
version = modrev .. '-' .. specrev

description = {
  summary = [[Improved interface for floating objects]],
  detailed =
  [[Improves the interface for defining floating objects such as figures and tables. Introduces the boxed float, the ruled float and the plaintop float. You can define your own floats and improve the behaviour of the old ones.

  The package also provides the H float modifier option of the obsolete here package. You can select this as automatic default with \floatplacement{figure}{H}.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

build_dependencies = { 'lualatex', 'texrocks', 'latex-base' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/float.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    latex --interaction=nonstopmode float.ins
  ]],
  install = {
    conf = {
      ['../doc/latex/float/float.pdf'] = 'float.pdf',
      ['../tex/latex/float/float.sty'] = 'float.sty',
    }
  }
}
