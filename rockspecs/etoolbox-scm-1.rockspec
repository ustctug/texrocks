local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/etoolbox'

rockspec_format = '3.0'
package = 'etoolbox'
version = modrev .. '-' .. specrev

description = {
  summary = [[e-TeX tools for LaTeX]],
  detailed =
  [[The package is a toolbox of programming facilities geared primarily towards LaTeX class and package authors. It provides LaTeX frontends to some of the new primitives provided by e-TeX as well as some generic tools which are not strictly related to e-TeX but match the profile of this package. Note that the initial versions of this package were released under the name elatex.

  The package provides functions that seem to offer alternative ways of implementing some LaTeX kernel commands; nevertheless, the package will not modify any part of the LaTeX kernel.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/etoolbox',
  license = 'LPPL-1.3c'
}

dependencies = { 'etex' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/etoolbox.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
