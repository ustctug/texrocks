local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/tanukihee/ChineseJFM'

rockspec_format = '3.0'
package = 'chinese-jfm'
version = modrev .. '-' .. specrev

description = {
  summary = 'Luatexja-jfm files for Chinese typesetting',
  detailed =
  [[ChineseJFM is a series of luatexja-jfm files for better Chinese typesetting, providing quanjiao, banjiao, and kaiming three styles and other fancy features. It can be used for both horizontal and vertical writing mode in Simplified/Traditional Chinese or Japanese fonts.]],
  labels = { 'tex', 'latex', 'luatex' },
  homepage = repo_url,
  license = 'MIT'
}

dependencies = { 'luatexja' }

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '-ctan.zip',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/generic/chinese-jfm.zip',
  }
end

build = {
  type = 'builtin',
  modules = {
    ['jfm-ja_JP'] = 'jfm-ja_JP.lua',
    ['jfm-zh_CN'] = 'jfm-zh_CN.lua',
    ['jfm-zh_TW'] = 'jfm-zh_TW.lua',
  },
  install = {
    conf = {
      ['../doc/latex/chinese-jfm/chinese-jfm.pdf'] = 'chinese-jfm.pdf',
    }
  }
}
