local git_ref = 'v1.11'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/rerunfilecheck'

rockspec_format = '3.0'
package = 'rerunfilecheck'
version = modrev .. '-' .. specrev

description = {
  summary = 'Checksum based rerun checks on auxiliary files',
  detailed =
  [[The package provides additional rerun warnings if some auxiliary files have changed. It is based on MD5 checksum provided by pdfTeX, LuaTeX, XeTeX. ]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'kvoptions', 'infwarerr', 'pdftexcmds', 'atveryend',
  'uniquecounter' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/rerunfilecheck.zip',
    dir = 'rerunfilecheck'
  }
end

build = {
  type = 'l3build',
}
