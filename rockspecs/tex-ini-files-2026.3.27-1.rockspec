local git_ref = '2026-03-27'
local modrev = git_ref:gsub('-0', '-'):gsub('-', '.')
local specrev = '1'

local repo_url = 'https://github.com/latex3/tex-ini-files'

rockspec_format = '3.0'
package = 'tex-ini-files'
version = modrev .. '-' .. specrev

description = {
  summary = 'Model TeX format creation files',
  detailed =
  [[This bundle provides a collection of model .ini files for creating TeX formats. These files are commonly used to introduced distribution-dependent variations in formats. They are also used to allow existing format source files to be used with newer engines, for example to adapt the plain e-TeX source file to work with XeTeX and LuaTeX.]],
  labels = { 'LaTeX3' },
  homepage = 'https://github.com/latex3/tex-ini-files',
  license = 'CC0-1.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. "-" .. git_ref
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/generic/tex-ini-files.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
