local git_ref = 'release-2020-01-24'
local modrev = '2.36'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/epstopdf'

rockspec_format = '3.0'
package = 'epstopdf-pkg'
version = modrev .. '-' .. specrev

description = {
  summary = [[Call epstopdf "on the fly"]],
  detailed =
  [[The package adds support for EPS files in the graphicx package when running under pdfTeX. If an EPS graphic is detected, the package spawns a process to convert the EPS to PDF, using the script epstopdf. This of course requires that shell escape is enabled for the pdfTeX run.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'grfext', 'pdftexcmds', 'infwarerr', 'kvoptions' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'epstopdf-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/epstopdf-pkg.zip',
    dir = 'epstopdf-pkg'
  }
end

build = {
  type = 'l3build',
}
