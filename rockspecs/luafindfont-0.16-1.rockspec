local git_ref = '0.16'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'luafindfont'
version = modrev .. '-' .. specrev

description = {
  summary = 'Search fonts in the LuaTeX font database',
  detailed =
  [[This Lua script searches for fonts in the font database.]],
  labels = { 'tex', 'luatex' },
  homepage = 'https://ctan.org/pkg/luafindfont',
  license = 'LPPL-1.3c'
}

dependencies = { "texrocks", 'lualibs' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/luafindfont.zip",
  dir = 'luafindfont'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/support/luafindfont.zip',
    dir = 'luafindfont'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc' },
  install = {
    bin = {
      luafindfont = "scripts/luafindfont.lua",
    }
  }
}

deploy = {
  wrap_bin_scripts = false
}
