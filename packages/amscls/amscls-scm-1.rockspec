local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/amscls'

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
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
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
