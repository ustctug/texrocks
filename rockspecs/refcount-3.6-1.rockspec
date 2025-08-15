local git_ref = 'release-2019-12-15'
local modrev = '3.6'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/refcount'

rockspec_format = '3.0'
package = 'refcount'
version = modrev .. '-' .. specrev

description = {
  summary = 'Counter operations with label references',
  detailed =
  [[Provides commands \setcounterref and \addtocounterref which use the section (or whatever) number from the reference as the value to put into the counter, as in:

      ...\label{sec:foo}
      ...
      \setcounterref{foonum}{sec:foo}

Commands \setcounterpageref and \addtocounterpageref do the corresponding thing with the page reference of the label.

No .ins file is distributed; process the .dtx with plain TeX to create one.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/refcount.tds.zip',
    dir = '.'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'ltxcmds', 'infwarerr' }

build = {
  type = 'l3build',
}
