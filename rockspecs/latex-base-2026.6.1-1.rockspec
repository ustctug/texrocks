local git_ref = 'release-2026-06-01'
local modrev = git_ref:gsub("^release%-", ""):gsub('-0', '-'):gsub('%-', '.')
local specrev = "1"

local repo_url = 'https://github.com/latex3/latex2e'

rockspec_format = '3.0'
package = 'latex-base'
version = modrev .. '-' .. specrev

-- luaotfload depends on lublibs which depends on lualatex to build
-- 'lm', 'luaotfload'
dependencies = { 'l3kernel', 'knuth-lib', 'latex-url', 'etex' }

description = {
  summary = 'Base sources of LaTeX',
  detailed =
  [[This bundle comprises the source of LaTeX itself, together with several packages which are considered ‘part of the kernel’. This bundle, together with the required packages, constitutes what every LaTeX distribution should contain.]],
  labels = { 'Class', 'Format' },
  homepage = 'https://ctan.org/pkg/latex-base',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = repo_url:gsub('https', 'git+https')
  }
end

build = {
  type = 'tds',
  copy_directories = { 'doc', 'makeindex', 'tex' },
}
