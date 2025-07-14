local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/varwidth'

rockspec_format = '3.0'
package = 'varwidth'
version = modrev .. '-' .. specrev

description = {
  summary = [[A variable-width minipage]],
  detailed =
  [[The varwidth environment is superficially similar to minipage, but the specified width is just a maximum value — the box may get a narrower “natural” width.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/varwidth.zip',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/miscdoc/miscdoc.sty'] = 'miscdoc.sty',
      ['../tex/latex/varwidth/varwidth.sty'] = 'varwidth.sty',
      ['../doc/latex/varwidth/varwidth.pdf'] = 'varwidth-doc.pdf',
    }
  }
}
