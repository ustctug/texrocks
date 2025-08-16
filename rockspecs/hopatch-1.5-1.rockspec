local git_ref = 'release-2023-01-07'
local modrev = '1.5'
local specrev = '1'

rockspec_format = '3.0'
package = 'hopatch'
version = modrev .. '-' .. specrev

local repo_url = 'https://github.com/ho-tex/hopatch'

description = {
  summary = [[Load patches for packages]],
  detailed =
  [[Hopatch provides a command with which the user may register of patch code for a particular package. Hopatch will apply the patch immediately, if the relevant package has already been loaded; otherwise it will store the patch until the package appears.]],
  labels = { 'Macro support' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'ltxcmds' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/hopatch.zip',
    dir = 'hopatch'
  }
end

build = {
  type = 'l3build',
}
