local git_ref = 'v1.12-2024-08-07'
local _git_ref = git_ref:gsub("^v", "")
local modrev = _git_ref:gsub("%-.*", "")
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
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. _git_ref,
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
      -- ['../doc/latex/atveryend/atveryend.pdf'] = 'atveryend.pdf',
      ['../tex/latex/atveryend/atveryend.sty'] = 'atveryend.sty',
    }
  }
}
