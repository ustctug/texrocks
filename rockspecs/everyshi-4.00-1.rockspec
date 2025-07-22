local git_ref = '4.00'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/everyshi'

rockspec_format = '3.0'
package = 'everyshi'
version = modrev .. '-' .. specrev

description = {
  summary = [[Take action at every \shipout]],
  detailed =
  [[This package provides hooks into \sshipout called \EveryShipout and \AtNextShipout analogous to \AtBeginDocument.

  With the introduction of the LaTeX hook management this package became obsolete in 2020 and is only provided for backwards compatibility. For current versions of LaTeX it is only mapping the hooks to the original everyshi macros. In case you use an older LaTeX format, everyshi will automatically fall back to its old implementation by loading everyshi-2001-05-15.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/everyshi.zip",
  dir = 'everyshi'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/everyshi.zip',
    dir = 'everyshi'
  }
end

build_dependencies = { 'lualatex', 'latex-base' }

build = {
  type = 'command',
  build_command = [[
    lualatex --interaction=nonstopmode everyshi.ins
]],
  install = {
    conf = {
      ['../doc/latex/everyshi/everyshi.pdf'] = 'everyshi.pdf',
      ['../tex/latex/everyshi/everyshi.sty'] = 'everyshi.sty',
    }
  }
}
