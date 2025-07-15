local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'luatex'
version = modrev .. '-' .. specrev

description = {
  summary = 'LuaTeX for plainTeX',
  detailed =
  [[See https://github.com/Freed-Wu/texrocks]],
  labels = { 'tex' },
  homepage = 'https://www.luatex.org/',
  license = 'GPL-3.0'
}

build_dependencies = { }

dependencies = { 'amsfonts', 'texrocks' }

source = {
  url = "https://github.com/Freed-Wu/texrocks/releases/download/0.0.1/luatex.zip",
  dir = '.'
}

build = {
  type = 'command',
  build_command = "texlua ./build.lua " .. package,
  install = {
    bin = { 'luatex', 'tex' },
    conf = {
      ['../web2c/luahbtex/luatex.fmt'] = 'luatex.fmt'
    }
  }
}

deploy = {
  wrap_bin_scripts = false
}
