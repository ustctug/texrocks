local git_ref = 'ec9787500280b3c2bd280906093183589338a809'
local modrev = '3.11'
local specrev = '1'

local repo_url = 'https://github.com/jbezos/enumitem'

rockspec_format = '3.0'
package = 'enumitem'
version = modrev .. '-' .. specrev

description = {
  summary = 'Control layout of itemize, enumerate, description',
  detailed =
  [[This package provides user control over the layout of the three basic list environments: enumerate, itemize and description. It supersedes both enumerate and mdwlist (providing well-structured replacements for all their functionality), and in addition provides functions to compute the layout of labels, and to 'clone' the standard environments, to create new environments with counters of their own.]],
  labels = { 'List' },
  homepage = 'http://www.texnia.com/enumitem.html',
  license = 'LPPL-1.3c'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'enumitem-' .. git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/macros/luatex/latex/enumitem.zip',
    dir = 'enumitem'
  }
end

build = {
  type = 'builtin',
  install = {
    conf = {
      ['../tex/latex/enumitem/enumitem.sty'] = 'enumitem.sty',
    },
  }
}
