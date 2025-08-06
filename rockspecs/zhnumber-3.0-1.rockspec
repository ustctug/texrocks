local git_ref = 'zhnumber-v3.0'
local modrev = git_ref:gsub('.*%-v', '')
local specrev = '1'

local repo_url = 'https://github.com/CTeX-org/ctex-kit'

rockspec_format = '3.0'
package = 'zhnumber'
version = modrev .. '-' .. specrev

description = {
  summary = [[Typeset Chinese representations of numbers]],
  detailed =
  [[The package provides commands to typeset Chinese representations of numbers. The main difference between this package and CJKnumb is that the commands provided are expandable in the ‘proper’ way.]],
  labels = { 'tex', 'latex' },
  homepage = 'http://www.ctex.org/',
  license = 'LPPL-1.3c'
}

dependencies = { 'l3packages', 'l3kernel' }

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. git_ref .. '.zip',
  dir = '.',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/zhnumber.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'command',
  -- https://github.com/CTeX-org/ctex-kit/issues/741
  build_command = [[unzip zhnumber.tds.zip || 7z x zhnumber.tds.zip]],
  copy_directories = { 'tex' },
}
