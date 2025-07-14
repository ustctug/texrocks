local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/atveryend'

rockspec_format = '3.0'
package = 'atveryend'
version = modrev .. '-' .. specrev

description = {
  summary = 'Hooks at the very end of a document',
  detailed =
  [[This LaTeX package provides some wrapper commands around LaTeX end document hooks.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'texrocks', 'latex-base' }

source = {
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/atveryend.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    tex --interaction=nonstopmode atveryend.dtx
]],
  install = {
    conf = {
      ['../doc/latex/atveryend/atveryend.pdf'] = 'atveryend.pdf',
      ['../tex/latex/atveryend/atveryend.sty'] = 'atveryend.sty',
    }
  }
}
