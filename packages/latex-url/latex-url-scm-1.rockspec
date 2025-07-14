local git_ref = 'scm'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://ctan.org/pkg/latex-url'

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
  url = repo_url .. '/releases/download/release-' .. git_ref .. '-PL' .. specrev .. '/' .. package .. '.tds.zip',
  dir = '.'
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
