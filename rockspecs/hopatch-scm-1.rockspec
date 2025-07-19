local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/hopatch'

rockspec_format = '3.0'
package = 'hopatch'
version = modrev .. '-' .. specrev

description = {
  summary = [[Load patches for packages]],
  detailed =
  [[Hopatch provides a command with which the user may register of patch code for a particular package. Hopatch will apply the patch immediately, if the relevant package has already been loaded; otherwise it will store the patch until the package appears.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/hopatch',
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'ltxcmds' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/hopatch.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode hopatch.dtx
  ]],
  install = {
    conf = {
      ['../doc/latex/hopatch/hopatch.pdf'] = 'hopatch.pdf',
      ['../tex/latex/hopatch/hopatch.sty'] = 'hopatch.sty',
      ['../tex/latex/hopatch/hopatch-2016-05-16.sty'] = 'hopatch-2016-05-16.sty',
    }
  }
}
