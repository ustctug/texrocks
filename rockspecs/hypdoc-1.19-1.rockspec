local git_ref = 'v1.19'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/hypdoc'

rockspec_format = '3.0'
package = 'hypdoc'
version = modrev .. '-' .. specrev

description = {
  summary = 'Hyper extensions for doc.sty',
  detailed =
  [[This package adds hypertext features to the package doc that is used in the documentation system of LaTeX2ε. Bookmarks are added and references are linked as far as possible.]],
  labels = { 'Documentation support', 'Hyper' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/hypdoc.zip',
  }
end

build_dependencies = { 'luatex', 'latex-base' }

-- \RequirePackage{doc}
-- \RequirePackage{calc}
-- \RequirePackage{atveryend}[2010/03/24]
-- \RequirePackage{rerunfilecheck}
dependencies = { 'latex-base', 'atveryend', 'latex-tools' }

build = {
  type = 'l3build',
}
