local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/placeins'

rockspec_format = '3.0'
package = 'placeins'
version = modrev .. '-' .. specrev

description = {
  summary = [[Control float placement]],
  detailed =
  [[Defines a \FloatBarrier command, beyond which floats may not pass; useful, for example, to ensure all floats for a section appear before the next \section command.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/placeins.zip',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../doc/latex/placeins/placeins.pdf'] = 'placeins-doc.pdf',
      ['../tex/latex/placeins/placeins.sty'] = 'placeins.sty',
    }
  }
}
