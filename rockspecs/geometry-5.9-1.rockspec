local git_ref = 'release-5.9'
local modrev = git_ref:gsub("^release%-", "")
local specrev = '1'

local repo_url = 'https://github.com/LaTeX-Package-Repositories/geometry'

rockspec_format = '3.0'
package = 'geometry'
version = modrev .. '-' .. specrev

description = {
  summary = [[Flexible and complete interface to document dimensions]],
  detailed =
  [[The package provides an easy and flexible user interface to customize page layout, implementing auto-centering and auto-balancing mechanisms so that the users have only to give the least description for the page layout. For example, if you want to set each margin 2cm without header space, what you need is just \usepackage[margin=2cm,nohead]{geometry}.

  The package knows about all the standard paper sizes, so that the user need not know what the nominal ‘real’ dimensions of the paper are, just its standard name (such as a4, letter, etc.).

  An important feature is the package’s ability to communicate the paper size it’s set up to the output (whether via DVI \specials or via direct interaction with pdf(La)TeX).]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

build_dependencies = { 'luatex', 'latex-base' }

dependencies = { 'latex-graphics', 'iftex', 'atbegshi' }

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/geometry.zip',
    dir = 'geometry'
  }
end

build = {
  type = 'l3build',
}
