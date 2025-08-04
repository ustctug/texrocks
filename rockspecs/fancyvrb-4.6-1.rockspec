local git_ref = '4.6'
local modrev = git_ref:gsub("^v", "")
local specrev = '1'

rockspec_format = '3.0'
package = 'fancyvrb'
version = modrev .. '-' .. specrev

description = {
  summary = 'Sophisticated verbatim text',
  detailed =
  [[Flexible handling of verbatim text including: verbatim commands in footnotes; a variety of verbatim environments with many parameters; ability to define new customized verbatim environments; save and restore verbatim text and environments; write and read files in verbatim mode; build "example" environments (showing both result and verbatim source).]],
  labels = { 'tex', 'latex' },
  homepage = 'https://www.ctan.org/pkg/fancyvrb',
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/fancyvrb.zip",
  dir = 'fancyvrb'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/latex/fancyvrb.zip',
    dir = 'fancyvrb'
  }
end

build_dependencies = { 'luatex', 'latex-base' }

build = {
  type = 'builtin',
  install = {
    conf = {
      ['../tex/latex/fancyvrb/fancyvrb.sty'] = 'latex/fancyvrb.sty',
      ['../tex/latex/fancyvrb/fancyvrb-ex.sty'] = 'latex/fancyvrb-ex.sty',
      ['../tex/latex/fancyvrb/hbaw.sty'] = 'latex/hbaw.sty',
      ['../tex/latex/fancyvrb/hcolor.sty'] = 'latex/hcolor.sty',
    },
  }
}
