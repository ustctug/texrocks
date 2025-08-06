local git_ref = '1.0'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/ctablestack'

rockspec_format = '3.0'
package = 'ctablestack'
version = modrev .. '-' .. specrev

description = {
  summary = 'Catcode table stable support',
  detailed =
  [[This package provides a method for defining category code table stacks in LuaTeX. It builds on code provided by the 2015/10/01 release of LaTeX2ε (also available as ltluatex.sty for plain users). It is required by the luatexbase package (v1.0 onward) which uses ctablestack to provide a back-compatibility form of this concept.]],
  labels = { 'tex', 'latex', 'luatex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/ctablestack.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/luatex/generic/ctablestack.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'tex' },
}
