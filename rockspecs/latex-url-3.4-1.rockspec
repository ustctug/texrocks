local git_ref = '3.4'
local modrev = git_ref
local specrev = '1'

rockspec_format = '3.0'
package = 'latex-url'
version = modrev .. '-' .. specrev

description = {
  summary = 'Verbatim with URL-sensitive line breaks',
  detailed =
  [[The command \url is a form of verbatim command that allows linebreaks at certain characters or combinations of characters, accepts reconfiguration, and can usually be used in the argument to another command. (The \urldef command provides robust commands that serve in cases when \url doesn't work in an argument.) The command is intended for email addresses, hypertext links, directories/paths, etc., which normally have no spaces, so by default the package ignores spaces in its argument. However, a package option “allows spaces”, which is useful for operating systems where spaces are a common part of file names.]],
  labels = { 'tex', 'latex' },
  homepage = 'https://ctan.org/pkg/url',
  license = 'LPPL-1.3c'
}

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/url.zip",
  dir = 'url'
}

dependencies = {}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/latex/contrib/url.zip',
    dir = 'url'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/url/url.sty'] = 'url.sty',
      ['../tex/latex/url/miscdoc.sty'] = 'miscdoc.sty',
      ['../doc/latex/url/url.pdf'] = 'url.pdf',
    }
  }
}
