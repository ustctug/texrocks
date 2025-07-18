local git_ref = '2021-02-05'
local modrev = git_ref:gsub("-", ".")
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/knuth-lib'

rockspec_format = '3.0'
package = 'knuth-lib'
version = modrev .. '-' .. specrev

dependencies = { 'cm-tfm', 'manual' }

description = {
  summary = 'Core TeX and METAFONT sources from Knuth',
  detailed =
  [[A collection of core TeX and METAFONT macro files from DEK, apart from the plain format and base. Includes the MF logo font(s), webmac.tex, etc]],
  labels = { 'tex', 'metafont' },
  homepage = repo_url,
  license = 'Knuth'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/lib.zip",
  dir = 'lib'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/systems/knuth/dist/lib.zip',
    dir = 'lib'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/plain/knuth-lib/manmac.tex'] = 'manmac.tex',
      ['../tex/plain/knuth-lib/mftmac.tex'] = 'mftmac.tex',
      ['../tex/plain/knuth-lib/story.tex'] = 'story.tex',
      ['../tex/plain/knuth-lib/testfont.tex'] = 'testfont.tex',
      ['../tex/plain/knuth-lib/webmac.tex'] = 'webmac.tex',
      ['../tex/generic/knuth-lib/null.tex'] = 'null.tex',
      ['../tex/generic/hyphen/hyphen.tex'] = 'hyphen.tex',
      ['../tex/plain/base/plain.tex'] = 'plain.tex',
      ['../fonts/source/public/knuth-lib/3test.mf'] = '3test.mf',
      ['../fonts/source/public/knuth-lib/6test.mf'] = '6test.mf',
      ['../fonts/source/public/knuth-lib/expr.mf'] = 'expr.mf',
      ['../fonts/source/public/knuth-lib/grayf.mf'] = 'grayf.mf',
      ['../fonts/source/public/knuth-lib/io.mf'] = 'io.mf',
      ['../fonts/source/public/knuth-lib/logo.mf'] = 'logo.mf',
      ['../fonts/source/public/knuth-lib/logo8.mf'] = 'logo8.mf',
      ['../fonts/source/public/knuth-lib/logo9.mf'] = 'logo9.mf',
      ['../fonts/source/public/knuth-lib/logo10.mf'] = 'logo10.mf',
      ['../fonts/source/public/knuth-lib/logobf10.mf'] = 'logobf10.mf',
      ['../fonts/source/public/knuth-lib/logosl10.mf'] = 'logosl10.mf',
      ['../fonts/source/public/knuth-lib/manfnt.mf'] = 'manfnt.mf',
      ['../fonts/source/public/knuth-lib/null.mf'] = 'null.mf',
      ['../fonts/source/public/knuth-lib/rtest.mf'] = 'rtest.mf',
      ['../fonts/source/public/knuth-lib/slant.mf'] = 'slant.mf',
      ['../fonts/source/public/knuth-lib/test.mf'] = 'test.mf',
      ['../fonts/source/public/knuth-lib/waits.mf'] = 'waits.mf',
      ['../fonts/source/public/knuth-lib/ztest.mf'] = 'ztest.mf',
    }
  }
}
