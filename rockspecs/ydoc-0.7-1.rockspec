local git_ref = 'cbc34fa4445e60ac9731867b7e6c58f9dc44ab24'
local modrev = '0.7'
local specrev = '1'

local repo_url = 'https://github.com/MartinScharrer/ydoc'

rockspec_format = '3.0'
package = 'ydoc'
version = modrev .. '-' .. specrev

description = {
  summary = 'Macros for documentation of LaTeX classes and packages',
  detailed =
  [[The package provides macros and environments to document LaTeX packages and classes. It is an (as yet unfinished) alternative to the ltxdoc class and the doc or xdoc packages. The aim is to provide a different layout and more modern styles (using the xcolor, hyperref packages, etc.)

  This is an alpha release, and should probably not (yet) be used with other packages, since the implementation might change. Nevertheless, the author uses it to document his own packages.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

dependencies = { 'newverbs', 'listings', 'float', 'latex-base',
  'latex-url', 'etoolbox', 'xcolor', 'hyperref', 'latex-tools', 'needspace' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/ydoc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  build = {
    install = {
      conf = {
        ['../tex/generic/ydoc/ydocincl.tex'] = 'ydocincl.tex',
        ['../tex/generic/ydoc/ydocstrip.tex'] = 'ydocstrip.tex',
        ['../tex/latex/ydoc/ydoc-code.sty'] = 'ydoc-code.sty',
        ['../tex/latex/ydoc/ydoc-desc.sty'] = 'ydoc-desc.sty',
        ['../tex/latex/ydoc/ydoc-doc.sty'] = 'ydoc-doc.sty',
        ['../tex/latex/ydoc/ydoc-expl.sty'] = 'ydoc-expl.sty',
        ['../tex/latex/ydoc/ydoc.cfg'] = 'ydoc.cfg',
        ['../tex/latex/ydoc/ydoc.cls'] = 'ydoc.cls',
        ['../tex/latex/ydoc/ydoc.sty'] = 'ydoc.sty',
      }
    }
  }
}
