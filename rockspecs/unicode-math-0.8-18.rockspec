local git_ref = 'v0.8r'
local _git_ref = git_ref:gsub('v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = git_ref.format('%d', _git_ref:gsub('[0-9.]', ''):byte() - 0x60)

local repo_url = 'https://github.com/latex3/unicode-math'

rockspec_format = '3.0'
package = 'unicode-math'
version = modrev .. '-' .. specrev

description = {
  summary = 'Unicode mathematics support for XeTeX and LuaTeX',
  detailed =
  [[This package provides a comprehensive implementation of unicode maths for XeLaTeX and LuaLaTeX. Unicode maths requires an OpenType mathematics font, of which there are now a number available via CTAN.

While backwards compatibility is strived for, there are some differences between the legacy mathematical definitions in LaTeX and amsmath, and the Unicode mathematics definitions. Care should be taken when transitioning from a legacy workflow to a Unicode-based one.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'unicode-math-' .. _git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/unicodetex/latex/unicode-math.tds.zip',
    dir = '.'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

dependencies = {'lm-math', 'fontspec', 'l3kernel', 'l3packages', 'lualatex-math'}

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode unicode-math.ins
]],
  install = {
    conf = {
      ['../tex/latex/unicode-math/unicode-math.sty'] = 'unicode-math.sty',
      ['../tex/latex/unicode-math/unicode-math-table.tex'] = 'unicode-math-table.tex',
      ['../tex/latex/unicode-math/unicode-math-luatex.sty'] = 'unicode-math-luatex.sty',
      ['../tex/latex/unicode-math/unicode-math-xetex.sty'] = 'unicode-math-xetex.sty',
    },
  }
}
