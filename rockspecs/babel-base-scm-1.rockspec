local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/babel-base'

rockspec_format = '3.0'
package = 'babel-base'
version = modrev .. '-' .. specrev

dependencies = { 'luatexbase' }

description = {
  summary = 'Multilingual support for LaTeX, LuaLaTeX, XeLaTeX, and Plain TeX',
  detailed =
  [[This package manages culturally-determined typographical (and other) rules for a wide range of languages. A document may select a single language to be supported, or it may select several, in which case the document may switch from one language to another in a variety of ways.

Babel uses contributed configuration files that provide the detail of what has to be done for each language, as well as .ini files for about 300 languages from around the World, including many written in non-Latin and RTL scripts. Many of them work with pdfLaTeX, as well as with XeLaTeX and LuaLaTeX, out of the box. A few even work with plain formats.]],
  labels = { 'tex', 'latex', 'plaintex', 'makeindex' },
  homepage = 'https://latex3.github.io/babel/',
  license = 'LPPL-1.3'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/required/babel-base.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'command',
  build_command = [[
    mkdir -p lua
    mv tex/generic/babel/*.lua lua
  ]],
  copy_directories = { 'doc', 'tex', 'lua', 'makeindex' },
}
