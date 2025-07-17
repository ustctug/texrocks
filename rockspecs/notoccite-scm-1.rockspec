local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/notoccite'

rockspec_format = '3.0'
package = 'notoccite'
version = modrev .. '-' .. specrev

description = {
  summary = [[Prevent trouble from citations in table of contents, etc]],
  detailed =
  [[If you have \cite commands in \section-like commands, or in \caption, the citation will also appear in the table of contents, or list of whatever. If you are also using an unsrt-like bibliography style, these citations will come at the very start of the bibliography, which is confusing. This package suppresses the effect.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/notoccite.zip',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../doc/latex/notoccite/notoccite.pdf'] = 'notoccite.pdf',
      ['../tex/latex/notoccite/notoccite.sty'] = 'notoccite.sty',
    }
  }
}
