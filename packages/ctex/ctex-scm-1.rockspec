local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ctex/ctex'

rockspec_format = '3.0'
package = 'ctex'
version = modrev .. '-' .. specrev

description = {
  summary = [[LaTeX classes and packages for Chinese typesetting]],
  detailed =
  [[ctex is a collection of macro packages and document classes for LaTeX Chinese typesetting.]],
  labels = { 'tex', 'latex' },
  homepage = 'http://www.ctex.org/',
  license = 'LPPL-1.3c'
}

dependencies = { 'chinese-jfm', 'l3kernel', 'fontspec', 'zhnumber' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/language/chinese/ctex.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
  install = {
    lua = {
      ['ctex-zhconv-index'] = 'tex/luatex/ctex/ctex-zhconv-index.lua',
      ['ctex-zhconv'] = 'tex/luatex/ctex/ctex-zhconv.lua',
    }
  }
}
