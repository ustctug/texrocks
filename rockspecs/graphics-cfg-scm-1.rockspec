local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/latex3/graphics-cfg'

rockspec_format = '3.0'
package = 'graphics-cfg'
version = modrev .. '-' .. specrev

description = {
  summary = 'Sample configuration files for LaTeX color and graphics',
  detailed =
  [[This bundle includes color.cfg and graphics.cfg files that set default "driver" options for the color and graphics packages.

  It contains support for defaulting the new LuaTeX option which was added to graphics and color in the 2016-02-01 release. The LuaTeX option is only used for LuaTeX versions from 0.87, older versions use the pdfTeX option as before.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'CC0-1.0'
}

dependencies = { 'graphics-def' }

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/' .. package .. '-ctan.zip',
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/graphics-cfg.zip',
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/graphics-cfg/color.cfg'] = 'color.cfg',
      ['../tex/latex/graphics-cfg/graphics.cfg'] = 'graphics.cfg',
    }
  }
}
