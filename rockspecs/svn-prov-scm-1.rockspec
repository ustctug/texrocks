local git_ref = 'scm'
local modrev = git_ref:gsub('v', '')
local specrev = '1'

local repo_url = 'https://github.com/MartinScharrer/svn-prov'

rockspec_format = '3.0'
package = 'svn-prov'
version = modrev .. '-' .. specrev

description = {
  summary = [[Subversion variants of \Provides... macros]],
  detailed =
  [[The package introduces Subversion variants of the standard LaTeX macros \ProvidesPackage, \ProvidesClass and \ProvidesFile where the file name and date is extracted from Subversion Id keywords. The file name may also be given explicitly as an optional argument.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/svn-prov.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'builtin',
  copy_directories = { 'doc', 'tex' },
}
