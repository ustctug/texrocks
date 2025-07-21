local git_ref = '1.11'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/rerunfilecheck'

rockspec_format = '3.0'
package = 'rerunfilecheck'
version = modrev .. '-' .. specrev

description = {
  summary = 'Checksum based rerun checks on auxiliary files',
  detailed =
  [[The package provides additional rerun warnings if some auxiliary files have changed. It is based on MD5 checksum provided by pdfTeX, LuaTeX, XeTeX. ]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'kvoptions', 'infwarerr', 'pdftexcmds', 'atveryend',
  'uniquecounter' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/rerunfilecheck.zip",
  dir = 'rerunfilecheck'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/rerunfilecheck.zip',
    dir = 'rerunfilecheck'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode rerunfilecheck.dtx
]],
  install = {
    conf = {
      ['../doc/latex/rerunfilecheck/rerunfilecheck.pdf'] = 'rerunfilecheck.pdf',
      ['../tex/latex/rerunfilecheck/rerunfilecheck.sty'] = 'rerunfilecheck.sty',
    }
  }
}
