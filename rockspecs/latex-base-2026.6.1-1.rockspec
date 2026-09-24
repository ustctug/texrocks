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
  patches = {
    -- https://github.com/RadioNoiseE/apltex/blob/52b75b9bc64bcf5543207e73875f39e7d4d88613/fmtdump/luatex.ini#L15
    ["add-latex-map.diff"] = [[
--- old/tex/latex/base/latex.ltx
+++ new/tex/latex/base/latex.ltx
@@ -20362,6 +20362,7 @@
 \@input{latex2e-first-aid-for-external-files.ltx}
 \makeatother
 \errorstopmode
+\everyjob=\expandafter{\the\everyjob\pdfextension mapfile {luatex.map}}
 \dump
 \endinput
 %%
]]
  },
  copy_directories = { 'makeindex', 'tex' },
}
