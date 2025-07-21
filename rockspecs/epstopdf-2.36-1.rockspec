local git_ref = '2.36'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/epstopdf'

rockspec_format = '3.0'
package = 'epstopdf'
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
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/epstopdf-pkg.zip",
  dir = 'epstopdf-pkg'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/epstopdf-pkg.zip',
    dir = 'epstopdf-pkg'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode epstopdf.dtx
]],
  install = {
    conf = {
      ['../doc/latex/epstopdf/epstopdf.pdf'] = 'epstopdf.pdf',
      ['../tex/latex/epstopdf/epstopdf.sty'] = 'epstopdf.sty',
      ['../tex/latex/epstopdf/epstopdf-base.sty'] = 'epstopdf-base.sty',
    }
  }
}
