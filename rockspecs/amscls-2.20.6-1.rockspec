local git_ref = '2.20.6'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'amscls'
version = modrev .. '-' .. specrev

description = {
  summary = 'AMS document classes for LaTeX',
  detailed =
  [[This bundle contains three AMS classes, amsart (for writing articles for the AMS), amsbook (for books) and amsproc (for proceedings), together with some supporting material.

This material forms one branch of what was originally the AMS-LaTeX distribution. The other branch, amsmath, is now maintained and distributed separately.

The user documentation can be found in the package amscls-doc.]],
  labels = { 'tex', 'latex' },
  homepage = 'http://www.ams.org/tex/amslatex.html',
  license = 'LPPL-1.3c'
}

source = {
  url = 'https://www.ams.org/arc/tex/amscls/amscls2.zip',
  dir = '.'
}

-- \RequirePackage{amsmath}
-- \RequirePackage{amsfonts}
-- \RequirePackage{url}
dependencies = { 'latex-amsmath', 'amsfonts', 'latex-url' }

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/required/amscls.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'tex', 'doc', 'bibtex' },
}
