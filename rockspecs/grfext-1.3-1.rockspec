local git_ref = '1.3'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/grfext'

rockspec_format = '3.0'
package = 'grfext'
version = modrev .. '-' .. specrev

description = {
  summary = [[Manipulate the graphics package's list of extensions]],
  detailed =
  [[This package provides macros for adding to, and reordering the list of graphics file extensions recognised by package graphics.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

dependencies = { 'infwarerr', 'kvdefinekeys' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/grfext.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/grfext.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
