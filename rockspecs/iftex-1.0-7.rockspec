local git_ref = 'v1.0g'
local _git_ref = git_ref:gsub('^v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = git_ref.format('%d', _git_ref:gsub('[0-9.]', ''):byte() - 0x60)

local repo_url = 'https://github.com/latex3/iftex'

rockspec_format = '3.0'
package = 'iftex'
version = modrev .. '-' .. specrev

description = {
  summary = 'Am I running under pdfTeX, XeTeX or LuaTeX?',
  detailed =
  [[The package, which works both for Plain TeX and for LaTeX, defines the \ifPDFTeX, \ifXeTeX, and \ifLuaTeX conditionals for testing which engine is being used for typesetting.

The package also provides the \RequirePDFTeX, \RequireXeTeX, and \RequireLuaTeX commands which throw an error if pdfTeX, XeTeX or LuaTeX (respectively) is not the engine in use.]],
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. _git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/generic/iftex.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/generic/iftex/ifetex.sty'] = 'ifetex.sty',
      ['../tex/generic/iftex/ifluatex.sty'] = 'ifluatex.sty',
      ['../tex/generic/iftex/ifpdf.sty'] = 'ifpdf.sty',
      ['../tex/generic/iftex/iftex.sty'] = 'iftex.sty',
      ['../tex/generic/iftex/ifvtex.sty'] = 'ifvtex.sty',
      ['../tex/generic/iftex/ifxetex.sty'] = 'ifxetex.sty',
    }
  }
}
