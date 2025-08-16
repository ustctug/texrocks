local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'chngpage'
version = modrev .. '-' .. specrev

dependencies = { 'l3kernel', 'l3backend', 'knuth-lib' }

description = {
  summary = 'Change the page layout in the middle of a document',
  detailed =
  [[The package provides broadly similar functionality to changepage, with which it is distributed. It is, however, considered obsolete, and should not be used in new documents.]],
  labels = { 'Geometry', 'Obsolete' },
  homepage = 'https://ctan.org/pkg/chngpage',
  license = 'LPPL-1.3c'
}

source = {
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/changepage.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
