local git_ref = 'scm'
local modrev = git_ref:gsub('v', '')
local specrev = '1'

local repo_url = 'https://github.com/MartinScharrer/gincltex'

rockspec_format = '3.0'
package = 'gincltex'
version = modrev .. '-' .. specrev

dependencies = { 'adjustbox', 'svn-prov' }

description = {
  summary = [[Include TeX files as graphics (.tex support for \includegraphics)]],
  detailed =
  [[The package builds on the standard LaTeX packages graphics and/or graphicx and allows external LaTeX source files to be included, in the same way as graphic files, by \includegraphics. In effect, then package adds support for the .tex extension.

  Some of the lower level operations like clipping and trimming are implemented using the adjustbox package which includes native pdfLaTeX support and uses the pgf package for other output formats.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/gincltex.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'builtin',
  copy_directories = { 'doc', 'tex' },
}
