local git_ref = '1.6'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'kvdefinekeys'
version = modrev .. '-' .. specrev

description = {
  summary = 'Define keys for use in the kvsetkeys package',
  detailed =
  [[The package provides a macro \kv@define@key (analogous to keyval’s \define@key, to define keys for use by kvsetkeys.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://github.com/ho-tex/kvdefinekeys',
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/kvdefinekeys.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/kvdefinekeys.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
