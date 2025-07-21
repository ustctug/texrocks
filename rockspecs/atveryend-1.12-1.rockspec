local git_ref = '1.12'
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

build_dependencies = { 'luatex', 'latex-base' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/atveryend.zip",
  dir = 'atveryend'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/atveryend.zip',
    dir = 'atveryend'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode atveryend.dtx
]],
  install = {
    conf = {
      ['../doc/latex/atveryend/atveryend.pdf'] = 'atveryend.pdf',
      ['../tex/latex/atveryend/atveryend.sty'] = 'atveryend.sty',
    }
  }
}
