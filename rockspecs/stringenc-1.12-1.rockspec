local git_ref = 'release-2019-11-29'
local modrev = '1.12'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/stringenc'

rockspec_format = '3.0'
package = 'stringenc'
version = modrev .. '-' .. specrev

description = {
  summary = [[Converting a string between different encodings]],
  detailed =
  [[This package provides \StringEncodingConvert for converting a string between different encodings. Both LaTeX and plain-TeX are supported.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'infwarerr', 'ltxcmds', 'pdfescape' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/stringenc.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'command',
  build_command = [[
    luatex --interaction=nonstopmode stringenc.dtx
]],
  install = {
    conf = {
      ['../tex/generic/stringenc/stringenc.sty'] = 'stringenc.sty',
      ['../tex/generic/stringenc/se-ascii-print.def'] = 'se-ascii-print.def',
      ['../tex/generic/stringenc/se-ascii.def'] = 'se-ascii.def',
      ['../tex/generic/stringenc/se-clean7bit.def'] = 'se-clean7bit.def',
      ['../tex/generic/stringenc/se-cp1250.def'] = 'se-cp1250.def',
      ['../tex/generic/stringenc/se-cp1251.def'] = 'se-cp1251.def',
      ['../tex/generic/stringenc/se-cp1252.def'] = 'se-cp1252.def',
      ['../tex/generic/stringenc/se-cp1257.def'] = 'se-cp1257.def',
      ['../tex/generic/stringenc/se-cp437.def'] = 'se-cp437.def',
      ['../tex/generic/stringenc/se-cp850.def'] = 'se-cp850.def',
      ['../tex/generic/stringenc/se-cp852.def'] = 'se-cp852.def',
      ['../tex/generic/stringenc/se-cp855.def'] = 'se-cp855.def',
      ['../tex/generic/stringenc/se-cp858.def'] = 'se-cp858.def',
      ['../tex/generic/stringenc/se-cp865.def'] = 'se-cp865.def',
      ['../tex/generic/stringenc/se-cp866.def'] = 'se-cp866.def',
      ['../tex/generic/stringenc/se-dec-mcs.def'] = 'se-dec-mcs.def',
      ['../tex/generic/stringenc/se-iso-8859-1.def'] = 'se-iso-8859-1.def',
      ['../tex/generic/stringenc/se-iso-8859-10.def'] = 'se-iso-8859-10.def',
      ['../tex/generic/stringenc/se-iso-8859-11.def'] = 'se-iso-8859-11.def',
      ['../tex/generic/stringenc/se-iso-8859-13.def'] = 'se-iso-8859-13.def',
      ['../tex/generic/stringenc/se-iso-8859-14.def'] = 'se-iso-8859-14.def',
      ['../tex/generic/stringenc/se-iso-8859-15.def'] = 'se-iso-8859-15.def',
      ['../tex/generic/stringenc/se-iso-8859-16.def'] = 'se-iso-8859-16.def',
      ['../tex/generic/stringenc/se-iso-8859-2.def'] = 'se-iso-8859-2.def',
      ['../tex/generic/stringenc/se-iso-8859-3.def'] = 'se-iso-8859-3.def',
      ['../tex/generic/stringenc/se-iso-8859-4.def'] = 'se-iso-8859-4.def',
      ['../tex/generic/stringenc/se-iso-8859-5.def'] = 'se-iso-8859-5.def',
      ['../tex/generic/stringenc/se-iso-8859-6.def'] = 'se-iso-8859-6.def',
      ['../tex/generic/stringenc/se-iso-8859-7.def'] = 'se-iso-8859-7.def',
      ['../tex/generic/stringenc/se-iso-8859-8.def'] = 'se-iso-8859-8.def',
      ['../tex/generic/stringenc/se-iso-8859-9.def'] = 'se-iso-8859-9.def',
      ['../tex/generic/stringenc/se-koi8-r.def'] = 'se-koi8-r.def',
      ['../tex/generic/stringenc/se-mac-centeuro.def'] = 'se-mac-centeuro.def',
      ['../tex/generic/stringenc/se-mac-cyrillic.def'] = 'se-mac-cyrillic.def',
      ['../tex/generic/stringenc/se-mac-roman.def'] = 'se-mac-roman.def',
      ['../tex/generic/stringenc/se-nextstep.def'] = 'se-nextstep.def',
      ['../tex/generic/stringenc/se-pdfdoc.def'] = 'se-pdfdoc.def',
      ['../tex/generic/stringenc/se-utf16le.def'] = 'se-utf16le.def',
      ['../tex/generic/stringenc/se-utf32be.def'] = 'se-utf32be.def',
      ['../tex/generic/stringenc/se-utf32le.def'] = 'se-utf32le.def',
      ['../tex/generic/stringenc/se-utf8.def'] = 'se-utf8.def',
    }
  }
}
