local git_ref = 'v2.9e'
local _git_ref = git_ref:gsub('^v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = git_ref.format('%d', _git_ref:gsub('[0-9.]', ''):byte() - 0x60)

local repo_url = 'https://github.com/latex3/fontspec'

rockspec_format = '3.0'
package = 'fontspec'
version = modrev .. '-' .. specrev

dependencies = { 'l3packages', 'luaotfload' }

description = {
  summary = 'Advanced font selection in XeLaTeX and LuaLaTeX',
  detailed =
  [[Fontspec is a package for XeLaTeX and LuaLaTeX. It provides an automatic and unified interface to feature-rich AAT and OpenType fonts through the NFSS in LaTeX running on XeTeX or LuaTeX engines.

  The package requires the l3kernel and xparse bundles from the LaTeX3 development team.]],
  labels = { 'tex', 'latex', 'luatex' },
  homepage = repo_url,
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
  type = 'builtin',
  modules = {
     fontspec = 'tex/latex/fontspec/fontspec.lua'
  },
  copy_directories = { 'doc' },
  install = {
    conf = {
      ['../tex/latex/fontspec/fontspec-luatex.sty'] = 'tex/latex/fontspec/fontspec-luatex.sty',
      ['../tex/latex/fontspec/fontspec-xetex.sty'] = 'tex/latex/fontspec/fontspec-xetex.sty',
      ['../tex/latex/fontspec/fontspec.cfg'] = 'tex/latex/fontspec/fontspec.cfg',
      ['../tex/latex/fontspec/fontspec.sty'] = 'tex/latex/fontspec/fontspec.sty',
    }
  }
}
