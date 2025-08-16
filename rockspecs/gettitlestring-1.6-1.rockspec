local git_ref = 'release-2019-12-15'
local modrev = '1.6'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/gettitlestring'

rockspec_format = '3.0'
package = 'gettitlestring'
version = modrev .. '-' .. specrev

description = {
  summary = [[Clean up title references]],
  detailed =
  [[Cleans up the title string (removing \label commands) for packages (such as nameref) that typeset such strings.]],
  labels = { 'Macro support' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'kvoptions' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/gettitlestring.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
