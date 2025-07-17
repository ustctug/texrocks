local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/xurl'

rockspec_format = '3.0'
package = 'xurl'
version = modrev .. '-' .. specrev

description = {
  summary = 'Allow URL breaks at any alphanumerical character',
  detailed =
  [[This package loads url by default and defines possible URL breaks for all alphanumerical characters, as well as = / . : * - ~ ' "

All arguments which are valid for url can be used and will be passed on to this package. For more information read the documentation of url itself.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

dependencies = { 'latex-url', 'filecontents' }

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '-ctan.zip',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/xurl.zip',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/xurl/xurl.sty'] = 'latex/xurl.sty',
      ['../doc/latex/xurl/xurl.pdf'] = 'doc/xurl.pdf',
    }
  }
}
