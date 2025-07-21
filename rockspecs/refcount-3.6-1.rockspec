local git_ref = '3.6'
local modrev = git_ref
local specrev = '1'

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
  homepage = 'https://github.com/ho-tex/refcount',
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/pdfescape.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/refcount.tds.zip',
    dir = '.'
  }
end

dependencies = { 'ltxcmds', 'infwarerr' }

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
