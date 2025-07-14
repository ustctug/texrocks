local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/luatex85'

rockspec_format = '3.0'
package = 'luatex85'
version = modrev .. '-' .. specrev

description = {
  summary = [[pdfTeX aliases for LuaTeX]],
  detailed =
  [[The package provides emulation of pdfTeX primitives for LuaTeX v0.85+.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

build_dependencies = { 'lualatex', 'latex-base' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/luatex85.zip',
  }
end

build = {
  type = 'command',
  build_command = [[
    latex --interaction=nonstopmode luatex85.ins
  ]],
  install = {
    conf = {
      ['../doc/generic/luatex85/luatex85.pdf'] = 'luatex85.pdf',
      ['../tex/generic/luatex85/luatex85.sty'] = 'luatex85.sty',
    }
  }
}
