local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/multido'

rockspec_format = '3.0'
package = 'multido'
version = modrev .. '-' .. specrev

description = {
  summary = [[A loop facility for Generic TeX]],
  detailed =
  [[The package provides the \multido command, which was originally designed for use with PSTricks. Fixed-point arithmetic is used when working on the loop variable, so that the package is equally applicable in graphics applications like PSTricks as it is with the more common integer loops.]],
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
    url = 'https://mirrors.ctan.org/macros/generic/multido.zip',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/multido/multido.sty'] = 'multido.sty',
      ['../doc/latex/multido/multido.pdf'] = 'multido.pdf',
    }
  }
}
