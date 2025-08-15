local git_ref = 'ctex-v2.5.10'
local modrev = git_ref:gsub('.*%-v', '')
local specrev = '1'

local repo_url = 'https://github.com/CTeX-org/ctex-kit'

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

-- build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'chinese-jfm', 'l3kernel', 'fontspec', 'ctex' }

source = {
  -- url = repo_url .. '/archive/' .. git_ref .. '.zip',
  -- dir = 'ctex-kit-' .. git_ref .. '/' .. package,
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. git_ref .. '.zip',
  dir = '.',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/language/chinese/ctex.tds.zip',
    dir = '.'
  }
end

build = {
  -- type = 'l3build',
  type = 'command',
  -- https://github.com/CTeX-org/ctex-kit/issues/741
  build_command = [[unzip ctex.tds.zip || 7z x ctex.tds.zip]],
  copy_directories = { 'tex' },
  install = {
    lua = {
      ['ctex-zhconv-index'] = 'tex/luatex/ctex/ctex-zhconv-index.lua',
      ['ctex-zhconv'] = 'tex/luatex/ctex/ctex-zhconv.lua',
    }
  }
}
