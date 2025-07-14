local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/footmisc'

rockspec_format = '3.0'
package = 'footmisc'
version = modrev .. '-' .. specrev

description = {
  summary = [[A range of footnote options]],
  detailed =
  [[A collection of ways to change the typesetting of footnotes. The package provides means of changing the layout of the footnotes themselves (including setting them in ‘paragraphs’ — the para option), a way to number footnotes per page (the perpage option), to make footnotes disappear in a ‘moving’ argument (stable option) and to deal with multiple references to footnotes from the same place (multiple option). The package also has a range of techniques for labelling footnotes with symbols rather than numbers.

  Some of the functions of the package are overlap with the functionality of other packages. The para option is also provided by the manyfoot and bigfoot packages, though those are both also portmanteau packages. (Don’t be seduced by fnpara, whose implementation is improved by the present package.) The perpage option is also offered by footnpag and by the rather more general-purpose perpage]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'GPL-2.0'
}

build_dependencies = { 'lualatex', 'texrocks', 'latex-base' }

dependencies = { 'bigfoot' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/footmisc.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    latex --interaction=nonstopmode footmisc.ins
  ]],
  install = {
    conf = {
      ['../tex/latex/footmisc/footmisc.sty'] = 'footmisc.sty',
      ['../doc/latex/footmisc/footmisc.pdf'] = 'footmisc-code.pdf',
    }
  }
}
