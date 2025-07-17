local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/ntheorem'

rockspec_format = '3.0'
package = 'ntheorem'
version = modrev .. '-' .. specrev

description = {
  summary = [[Enhanced theorem environment]],
  detailed =
  [[The package offers enhancements for theorem-like environments:

    easier control of layout; proper placement of endmarks even when the environment ends with \end{enumerate} or \end{displaymath} (including support for amsmath displayed-equation environments); and
    support for making a list of theorems, analogous to \listoffigures.]],
  labels = { 'tex', 'latex' },
  homepage = 'http://user.informatik.uni-goettingen.de/~may/Ntheorem/',
  license = 'LPPL-1.0'
}

build_dependencies = { 'lualatex', 'latex-base' }

dependencies = { 'latex-base', 'amsfonts' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/ntheorem.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    latex --interaction=nonstopmode ntheorem.ins
  ]],
  install = {
    conf = {
      ['../doc/latex/ntheorem/ntheorem.pdf'] = 'ntheorem.pdf',
      ['../tex/latex/ntheorem/ntheorem.sty'] = 'ntheorem.sty',
      ['../tex/latex/ntheorem/ntheorem.std'] = 'ntheorem.std',
    }
  }
}
