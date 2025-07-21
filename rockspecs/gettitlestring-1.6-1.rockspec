local git_ref = '1.6'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'gettitlestring'
version = modrev .. '-' .. specrev

description = {
  summary = [[Clean up title references]],
  detailed =
  [[Cleans up the title string (removing \label commands) for packages (such as nameref) that typeset such strings.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/gettitlestring',
  license = 'LPPL-1.3c'
}

dependencies = { 'kvoptions' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/gettitlestring.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/gettitlestring.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
