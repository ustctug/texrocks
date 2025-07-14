local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/needspace'

rockspec_format = '3.0'
package = 'needspace'
version = modrev .. '-' .. specrev

description = {
  summary = 'Insert pagebreak if not enough space',
  detailed =
  [[Provides commands to disable pagebreaking within a given vertical space. If there is not enough space between the command and the bottom of the page, a new page will be started.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '-ctan.zip',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/needspace.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' }
}
