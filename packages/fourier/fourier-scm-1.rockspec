local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/fourier'

rockspec_format = '3.0'
package = 'fourier'
version = modrev .. '-' .. specrev

description = {
  summary = [[Using Utopia fonts in LaTeX documents]],
  detailed =
  [[Fourier-GUTenberg is a LaTeX typesetting system which uses Adobe Utopia as its standard base font. Fourier-GUTenberg provides all complementary typefaces needed to allow Utopia based TeX typesetting, including an extensive mathematics set and several other symbols. The system is absolutely stand-alone: apart from Utopia and Fourier, no other typefaces are required.

  The fourier fonts will also work with Adobe Utopia Expert fonts, which are only available for purchase.

  Utopia is a registered trademark of Adobe Systems Incorporated.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.0'
}

build_dependencies = { 'lualatex', 'texrocks', 'latex-base' }

dependencies = { 'iftex', 'latex-base', 'fontspec' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. modrev,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/fonts/fourier-GUT.zip',
  }
end

build = {
  type = 'command',
  copy_directories = { 'doc', 'fonts', 'tex' },
  build_command = [[
    install -Dm644 afm/* -t fonts/afm/fourier
    install -Dm644 tfm/* -t fonts/tfm/fourier
    install -Dm644 vf/* -t fonts/vf/fourier
    install -Dm644 type1/* -t fonts/type1/fourier
    install -Dm644 map/* -t fonts/map/fourier
    install -Dm644 opentype/* -t fonts/opentype/fourier
    install -Dm644 latex/* -t tex/latex/fourier
  ]],
}
