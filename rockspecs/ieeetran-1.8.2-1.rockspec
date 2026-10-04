local git_ref = '1.8b'
local modrev = git_ref:gsub('[^0-9.]', '')
local _git_ref = git_ref.format('%d', git_ref:gsub('[0-9.]', ''):byte() - 0x60)
modrev = modrev .. '.' .. _git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'ieeetran'
version = modrev .. '-' .. specrev

description = {
  summary = 'Document class for IEEE Transactions journals and conferences',
  detailed =
  [[The class and its BibTeX style enable authors to produce officially-correct output for the Institute of Electrical and Electronics Engineers (IEEE) transactions, journals and conferences.]],
  labels = { 'Class', 'Journal' },
  homepage = 'http://www.ieee.org/publications_standards/publications/authors/author_templates.html',
  license = 'LPPL-1.3c'
}

source = {
  url = 'https://github.com/ustctug/texrocks/releases/download/0.0.1/IEEEtran.zip',
  dir = 'IEEEtran'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/IEEEtran.zip',
    dir = 'IEEEtran'
  }
end

dependencies = {}

build = {
  type = 'none',
  install = {
    conf = {
      ['../doc/latex/ieeetran/IEEEtran_HOWTO.pdf'] = 'IEEEtran_HOWTO.pdf',
      ['../doc/bibtex/bst/ieeetran/IEEEtran_bst_HOWTO.pdf'] = 'bibtex/IEEEtran_bst_HOWTO.pdf',
      ['../tex/latex/ieeetran/IEEEtran.cls'] = 'IEEEtran.cls',
      ['../tex/latex/ieeetran/IEEEtrantools.sty'] = 'tools/IEEEtrantools.sty',
      ['../tex/bibtex/bst/ieeetran/IEEEtran.bst'] = 'bibtex/IEEEtran.bst',
      ['../tex/bibtex/bst/ieeetran/IEEEtranN.bst'] = 'bibtex/IEEEtranN.bst',
      ['../tex/bibtex/bst/ieeetran/IEEEtranS.bst'] = 'bibtex/IEEEtranS.bst',
      ['../tex/bibtex/bst/ieeetran/IEEEtranSA.bst'] = 'bibtex/IEEEtranSA.bst',
      ['../tex/bibtex/bst/ieeetran/IEEEtranSN.bst'] = 'bibtex/IEEEtranSN.bst',
    }
  }
}
