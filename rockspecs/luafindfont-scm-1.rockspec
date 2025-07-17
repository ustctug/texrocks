local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/latex3/luafindfont'

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

dependencies = { 'lualibs' }

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/support/luafindfont.zip',
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
