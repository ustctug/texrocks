local git_ref = 'hg2git'
-- local modrev = git_ref:gsub('v', '')
local modrev = '3.1859'
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
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/svn-prov.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/svn-prov/svn-prov.sty'] = 'svn-prov.sty',
    }
  }
}
