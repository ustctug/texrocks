local git_ref = '1.15'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'hologo'
version = modrev .. '-' .. specrev

description = {
  summary = [[A collection of logos with bookmark support]],
  detailed =
  [[The package defines a single command \hologo, whose argument is the usual case-confused ASCII version of the logo. The command is bookmark-enabled, so that every logo becomes available in bookmarks without further work.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/hologo',
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'ltxcmds', 'infwarerr', 'kvsetkeys', 'kvdefinekeys',
  'pdftexcmds', 'iftex', 'kvoptions' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/hologo.zip",
  dir = 'hologo'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/generic/hologo.zip',
    dir = 'hologo'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode hologo.dtx
  ]],
  install = {
    conf = {
      ['../doc/latex/hologo/hologo.pdf'] = 'hologo.pdf',
      ['../tex/latex/hologo/hologo.sty'] = 'hologo.sty',
    }
  }
}
