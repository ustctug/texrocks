local git_ref = '1.0'
local modrev = git_ref
local specrev = '7'

local repo_url = 'https://github.com/latex3/iftex'

rockspec_format = '3.0'
package = 'iftex'
version = modrev .. '-' .. specrev

description = {
  summary = 'Am I running under pdfTeX, XeTeX or LuaTeX?',
  detailed =
  [[The package, which works both for Plain TeX and for LaTeX, defines the \ifPDFTeX, \ifXeTeX, and \ifLuaTeX conditionals for testing which engine is being used for typesetting.

The package also provides the \RequirePDFTeX, \RequireXeTeX, and \RequireLuaTeX commands which throw an error if pdfTeX, XeTeX or LuaTeX (respectively) is not the engine in use.]],
  labels = { 'tex', 'plaintex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

source = {
    url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/iftex.tds.zip",
    dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/generic/iftex.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
