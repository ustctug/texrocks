local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/manual'

rockspec_format = '3.0'
package = 'manual'
version = modrev .. '-' .. specrev

description = {
  summary = 'Knuth\'s "manual" fonts',
  detailed =
  [[METAFONT (by Donald Knuth) and Adobe Type 1 (by Taco Hoekwater) versions of the font containing the odd symbols Knuth uses in his books. LaTeX support is available using the manfnt package]],
  labels = { 'tex', 'metafont', 'font' },
  homepage = 'https://ctan.org/pkg/manual',
  license = 'Knuth'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/fonts/manual.zip',
    dir = 'manual',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../fonts/tfm/public/knuth-lib/cmman.tfm'] = 'tfm/cmman.tfm',
      ['../fonts/tfm/public/knuth-lib/manfnt.tfm'] = 'tfm/manfnt.tfm',
      ['../fonts/tfm/public/knuth-lib/random.tfm'] = 'tfm/random.tfm',
      ['../fonts/source/public/knuth-lib/cmman.mf'] = 'mf/cmman.mf',
      ['../fonts/source/public/knuth-lib/manfnt.mf'] = 'mf/manfnt.mf',
      ['../fonts/source/public/knuth-lib/mfman.mf'] = 'mf/mfman.mf',
      ['../fonts/source/public/knuth-lib/random.mf'] = 'mf/random.mf',
      ['../fonts/map/dvips/manfnt-font/manfnt.map'] = 'ps-type1/hoekwater/manfnt.map',
      ['../fonts/afm/hoekwater/manfnt-font/manfnt.afm'] = 'ps-type1/hoekwater/afm/manfnt.afm',
      ['../fonts/type1/hoekwater/manfnt-font/manfnt.pfb'] = 'ps-type1/hoekwater/manfnt.pfb',
      ['../fonts/type1/hoekwater/manfnt-font/manfnt.pfm'] = 'ps-type1/hoekwater/pfm/manfnt.pfm',
    }
  }
}
