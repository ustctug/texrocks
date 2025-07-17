local git_ref = 'scm'
local modrev = git_ref:gsub('v', '')
local specrev = '1'

local repo_url = 'https://github.com/MartinScharrer/filemod'

rockspec_format = '3.0'
package = 'filemod'
version = modrev .. '-' .. specrev

dependencies = { 'pdftexcmds' }

description = {
  summary = [[Provide file modification times, and compare them]],
  detailed =
  [[The package provides macros to read and compare the modification dates of files. The files may be .tex files, images or other files (as long as they can be found by LaTeX). It uses the \pdffilemoddate primitive of pdfLaTeX to find the file modification date as PDF date string, parses the string and returns the value to the user. The package will also work for DVI output with recent versions of the LaTeX compiler which uses pdfLaTeX in DVI mode. The functionality is provided by purely expandable macros or by faster but non-expandable ones.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3'
}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. version.char(specrev + 0x60) .. '/' .. package .. '.tds.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/filemod.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
