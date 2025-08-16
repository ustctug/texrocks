local git_ref = 'b93300821373d3092e378e57ae22ecb8e9082c62'
local modrev = '1.3'
local specrev = '1'

rockspec_format = '3.0'
package = 'fandol'
version = modrev .. '-' .. specrev

local repo_url = 'https://github.com/Yixf-Self/fandol-fonts'

description = {
  summary = 'Four basic fonts for Chinese typesetting',
  detailed =
  [[Fandol fonts designed for Chinese typesetting. The current version contains four styles: Song, Hei, Kai, Fang.

All fonts are in OpenType format.]],
  labels = { 'CJK Font', 'Chinese', 'Font', 'OTF Font' },
  homepage = repo_url,
  license = 'GPL'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'fandol-fonts-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/fonts/fandol.zip',
    dir = 'fandol',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../fonts/opentype/public/fandol/FandolBraille-Display.otf'] = 'FandolBraille-Display/FandolBraille-Display.otf',
      ['../fonts/opentype/public/fandol/FandolBraille-Regular.otf'] = 'FandolBraille-Regular/FandolBraille-Regular.otf',
      ['../fonts/opentype/public/fandol/FandolFang-Regular.otf'] = 'FandolFang-Regular/FandolFang-Regular.otf',
      ['../fonts/opentype/public/fandol/FandolHei-Bold.otf'] = 'FandolHei-Bold/FandolHei-Bold.otf',
      ['../fonts/opentype/public/fandol/FandolHei-Regular.otf'] = 'FandolHei-Regular/FandolHei-Regular.otf',
      ['../fonts/opentype/public/fandol/FandolKai-Regular.otf'] = 'FandolKai-Regular/FandolKai-Regular.otf',
      ['../fonts/opentype/public/fandol/FandolSong-Bold.otf'] = 'FandolSong-Bold/FandolSong-Bold.otf',
      ['../fonts/opentype/public/fandol/FandolSong-Regular.otf'] = 'FandolSong-Regular/FandolSong-Regular.otf',
    }
  }
}
