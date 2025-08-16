local git_ref = 'ctex-v2.5.10'
local modrev = git_ref:gsub('.*%-v', '')
local specrev = '1'

local repo_url = 'https://github.com/CTeX-org/ctex-kit'

rockspec_format = '3.0'
package = 'ctex-support'
version = modrev .. '-' .. specrev

description = {
  summary = [[Tools to build ctex packages]],
  detailed =
  [[ctex is a collection of macro packages and document classes for LaTeX Chinese typesetting.]],
  labels = { 'tex', 'latex' },
  homepage = 'http://www.ctex.org/',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'ctex-kit-' .. git_ref .. '/support',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/language/chinese/ctex.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  install = {
    lua = {
      dtxchecksum = 'dtxchecksum.lua',
      ['ctex-zhconv'] = 'ctex-zhconv.lua',
      ['ctex-zhconv-index'] = 'ctex-zhconv-index.lua',
    },
    conf = {
      ['../tex/generic/ctex/ctxdocstrip.tex'] = 'ctxdocstrip.tex'
    }
  }
}
