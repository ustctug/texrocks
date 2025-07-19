local git_ref = '1.5'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'filecontents'
version = modrev .. '-' .. specrev

description = {
  summary = 'Create an external file from within a LaTeX document',
  detailed =
  [[LaTeX2ε’s filecontents and filecontents* environments enable a LaTeX source file to generate external files as it runs through LaTeX. However, there are two limitations of these environments: they refuse to overwrite existing files, and they can only be used in the preamble of a document. The filecontents package removes these limitations, letting you overwrite existing files and letting you use filecontents/filecontents* anywhere.

  As of September 2019 the author tells us: “This package is no longer necessary due to its functionality having moved into recent LaTeX kernels. It’s probably better not to move the package to obsolete because users may need it to rebuild old documents. Version 1.5 provides full functionality when run with an older kernel but issues a warning message and disables itself when run with a newer kernel.”

  Supply the overwrite option to LaTeX’s built-in filecontents environment to mimic this package’s behavior:

  \begin{filecontents}[overwrite]{my-file}...\end{filecontents}]],
  labels = { 'tex', 'latex' },
  homepage = 'https://ctan.org/pkg/filecontents',
  license = 'LPPL-1.3c'
}

build_dependencies = { 'lualatex', 'latex-base' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/filecontents.zip",
  dir = "filecontents"
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/filecontents.zip',
    dir = "filecontents"
  }
end

build = {
  type = 'command',
  build_command = [[
        lualatex --interaction=nonstopmode filecontents.ins
  ]],
  install = {
    conf = {
      ['../tex/latex/filecontents/filecontents.sty'] = 'filecontents.sty',
      ['../doc/latex/filecontents/filecontents.pdf'] = 'filecontents.pdf',
    }
  }
}
