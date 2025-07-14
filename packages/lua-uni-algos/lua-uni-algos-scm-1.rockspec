local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/latex3/lua-uni-algos'

rockspec_format = '3.0'
package = 'lua-uni-algos'
version = modrev .. '-' .. specrev

description = {
  summary = 'Unicode algorithms for LuaTeX',
  detailed =
  [[Lua code working with Unicode data has to deal with quite some challenges. For example there are many canonically equivalent sequences which should be treated in the same way, and even identifying a single character becomes quite different once you have to deal with all kinds of combining characters, emoji sequences and syllables in different scripts.

  Therefore lua-uni-algos wants to build a collection of small libraries implementing algorithms to deal with lots of the details in Unicode, such that authors of LuaTeX packages can focus on their actual functionality instead of having to fight against the peculiarities of Unicode.

  Given that this package provides Lua modules, it is only useful in Lua(HB)TeX. Additionally, it expects an up-to-date version of the unicode-data package to be present.

  This package is intended for package authors only; no user-level functionality provided.]],
  labels = { 'tex', 'latex', 'luatex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/generic/lua-uni-algos.zip'
  }
end

build = {
  type = 'builtin',
  modules = {
    ['lua-uni-algos'] = 'lua-uni-algos.lua',
    ['lua-uni-case'] = 'lua-uni-case.lua',
    ['lua-uni-graphemes'] = 'lua-uni-graphemes.lua',
    ['lua-uni-normalize'] = 'lua-uni-normalize.lua',
    ['lua-uni-parse'] = 'lua-uni-parse.lua',
  },
  install = {
    conf = {
      ['../doc/luatex/lua-uni-algos/lua-uni-algos.pdf'] = 'lua-uni-algos.pdf',
    }
  }
}
