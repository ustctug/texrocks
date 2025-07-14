local git_ref = '7.2'
local modrev = git_ref
local specrev = '2'

local repo_url = 'https://github.com/debian-tex/texinfo'

rockspec_format = '3.0'
package = 'texinfo'
version = modrev .. '-' .. specrev

description = {
  summary = 'Texinfo documentation system',
  detailed =
  [[Texinfo is the preferred format for documentation in the GNU project; the format may be used to produce online or printed output from a single source.

  The Texinfo macros may be used to produce printable output using TeX; other programs in the distribution offer online interactive use (with hypertext linkages in some cases).

  The latest release of the texinfo.tex macros and texi2dvi script may be found in the texinfo-latest package, which are usually newer than the last full release.]],
  labels = { 'tex', 'texinfo' },
  homepage = 'https://www.gnu.org/software/texinfo/',
  license = 'GPL-3.0'
}

build_dependencies = { 'texrocks', 'knuth-lib' }

source = {
  url = repo_url .. '/archive/debian/' .. git_ref .. '-' .. specrev .. '.zip',
  dir = 'texinfo-debian-7.2-2'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/texinfo/texinfo.zip',
    dir = 'texinfo'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/generic/epsf/epsf.tex'] = 'doc/epsf.tex',
      ['../tex/texinfo/texinfo.tex'] = 'doc/texinfo.tex',
      ['../tex/texinfo/texinfo-ja.tex'] = 'doc/texinfo-ja.tex',
      ['../tex/texinfo/texinfo-zh.tex'] = 'doc/texinfo-zh.tex',
      ['../tex/texinfo/txi-ca.tex'] = 'doc/txi-ca.tex',
      ['../tex/texinfo/txi-cs.tex'] = 'doc/txi-cs.tex',
      ['../tex/texinfo/txi-de.tex'] = 'doc/txi-de.tex',
      ['../tex/texinfo/txi-en.tex'] = 'doc/txi-en.tex',
      ['../tex/texinfo/txi-es.tex'] = 'doc/txi-es.tex',
      ['../tex/texinfo/txi-fi.tex'] = 'doc/txi-fi.tex',
      ['../tex/texinfo/txi-fr.tex'] = 'doc/txi-fr.tex',
      ['../tex/texinfo/txi-hu.tex'] = 'doc/txi-hu.tex',
      ['../tex/texinfo/txi-is.tex'] = 'doc/txi-is.tex',
      ['../tex/texinfo/txi-it.tex'] = 'doc/txi-it.tex',
      ['../tex/texinfo/txi-ja.tex'] = 'doc/txi-ja.tex',
      ['../tex/texinfo/txi-nb.tex'] = 'doc/txi-nb.tex',
      ['../tex/texinfo/txi-nl.tex'] = 'doc/txi-nl.tex',
      ['../tex/texinfo/txi-nn.tex'] = 'doc/txi-nn.tex',
      ['../tex/texinfo/txi-pl.tex'] = 'doc/txi-pl.tex',
      ['../tex/texinfo/txi-pt.tex'] = 'doc/txi-pt.tex',
      ['../tex/texinfo/txi-ru.tex'] = 'doc/txi-ru.tex',
      ['../tex/texinfo/txi-sr.tex'] = 'doc/txi-sr.tex',
      ['../tex/texinfo/txi-tr.tex'] = 'doc/txi-tr.tex',
      ['../tex/texinfo/txi-uk.tex'] = 'doc/txi-uk.tex',
      ['../tex/texinfo/txi-zh.tex'] = 'doc/txi-zh.tex',
    }
  }
}
