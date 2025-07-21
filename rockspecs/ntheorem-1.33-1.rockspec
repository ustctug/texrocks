local git_ref = '1.33'
local modrev = git_ref
local specrev = '1'

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
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/ntheorem.zip",
  dir = 'ntheorem'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/ntheorem.zip',
    dir = 'ntheorem'
  }
end

build = {
  type = 'command',
  build_command = [[
    lualatex --interaction=nonstopmode ntheorem.ins
  ]],
  install = {
    conf = {
      ['../doc/latex/ntheorem/ntheorem.pdf'] = 'ntheorem.pdf',
      ['../tex/latex/ntheorem/ntheorem.sty'] = 'ntheorem.sty',
      ['../tex/latex/ntheorem/ntheorem.std'] = 'ntheorem.std',
    }
  }
}
