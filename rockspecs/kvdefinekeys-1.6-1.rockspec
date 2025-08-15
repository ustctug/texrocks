local git_ref = 'release-2019-12-19'
local modrev = '1.6'
local specrev = '1'

local repo_url = 'https://github.com/ho-tex/kvdefinekeys'

rockspec_format = '3.0'
package = 'kvdefinekeys'
version = modrev .. '-' .. specrev

description = {
  summary = 'Define keys for use in the kvsetkeys package',
  detailed =
  [[The package provides a macro \kv@define@key (analogous to keyval’s \define@key, to define keys for use by kvsetkeys.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/kvdefinekeys.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'l3build',
}
