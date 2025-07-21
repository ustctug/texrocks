local git_ref = '5.9'
local modrev = git_ref
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

build_dependencies = { 'lualatex', 'latex-base' }

dependencies = { 'latex-graphics', 'iftex', 'atbegshi' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/geometry.zip",
  dir = 'geometry'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/geometry.zip',
    dir = 'geometry'
  }
end

build = {
  type = 'command',
  patches = {
    ['add-geometry-ins.diff'] = [[
--- old/changes.txt
+++ new/changes.txt
@@ -1,3 +1,4 @@
+\iffalse
 2020-01-02 Release 5.9
   * Include German translation (previously distributed as geometry-de on ctan)
   * Use iftex versions of \ifxetex, \ifpdf
@@ -355,3 +356,15 @@
   * Use keyval interface.
 
 EOF
+\fi
+\input docstrip
+\usedir{tex/latex/geometry}
+\generate{
+  \file{geometry.ins}{\from{geometry.dtx}{install}}%
+  \file{geometry.drv}{\from{geometry.dtx}{driver}}%
+  \usedir{tex/latex/geometry}%
+  \file{geometry.sty}{\from{geometry.dtx}{package}}%
+  \file{geometry.cfg}{\from{geometry.dtx}{config}}%
+  \file{geometry-samples.tex}{\from{geometry.dtx}{samples}}%
+}
+\endbatchfile
    ]]
  },
  build_command = [[
    lualatex --interaction=nonstopmode changes.txt
  ]],
  install = {
    conf = {
      ['../tex/latex/geometry/geometry.sty'] = 'geometry.sty',
      ['../doc/generic/geometry/geometry.pdf'] = 'geometry.pdf',
    }
  }
}
