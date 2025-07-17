local git_ref = 'scm'
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
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/rerunfilecheck.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    tex --interaction=nonstopmode rerunfilecheck.dtx
]],
  install = {
    conf = {
      ['../doc/latex/rerunfilecheck/rerunfilecheck.pdf'] = 'rerunfilecheck.pdf',
      ['../tex/latex/rerunfilecheck/rerunfilecheck.sty'] = 'rerunfilecheck.sty',
    }
  }
}
