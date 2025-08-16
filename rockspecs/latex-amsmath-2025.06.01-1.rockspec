local git_ref = 'release-2025-06-01-PL1'
local modrev = git_ref:gsub("^release%-", ""):gsub("%-PL.*", ""):gsub('%-', '.')
local specrev = git_ref:gsub(".*%-PL", "")

local repo_url = 'https://github.com/latex3/latex2e'

rockspec_format = '3.0'
package = 'latex-amsmath'
version = modrev .. '-' .. specrev

description = {
  summary = 'The LaTeX standard amsmath bundle',
  detailed =
  [[A collection of (variously) simple amsmath provided as part of the LaTeX required amsmath distribution, comprising the packages: afterpage, array, bm, calc, dcolumn, delarray, enumerate, fileerr, fontsmpl, ftnright, hhline, indentfirst, layout, longtable, multicol, rawfonts, shellesc, showkeys, somedefs, tabularx, theorem, trace, varioref, verbatim, xr, and xspace.]],
  labels = { 'Maths' },
  homepage = 'http://www.ams.org/tex/amslatex.html',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git+https')
  }
end

build = {
  type = 'none',
  copy_directories = { 'tex', 'doc' },
}
