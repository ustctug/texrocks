local git_ref = '3.11.4'
local modrev = git_ref
local specrev = '1'

local repo_url = 'https://github.com/Witiko/markdown/'

rockspec_format = '3.0'
package = 'markdown2tex'
version = modrev .. '-' .. specrev

description = {
  summary = 'Converting and rendering markdown documents inside TeX',
  detailed =
  [[The package provides macros to collect and process a macro argument (i.e., something which looks like a macro argument) as a horizontal box rather than as a real macro argument.

  The “arguments” are stored as if they had been saved by \savebox or by the lrbox environment. Grouping tokens \bgroup and \egroup may be used, which allows the user to have the beginning and end of a group in different macro invocations, or to place them in the begin and end code of an environment. Arguments may contain verbatim material or other special use of characters.

  The macros were designed for use within other macros.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'LPPL-1.3c'
}

-- TODO:
-- 'unicode-math',
dependencies = {'lt3luabridge', 'paralist', 'latex-amsmath', 'ltxcmds', 'l3kernel', 'graphics-cfg', 'fancyvrb', 'csvsimple', 'enumitem', 'latex-url', 'latex-verse', 'lua-ul', 'luacolor'}

source = {
  url = repo_url .. '/releases/download/' .. git_ref .. '/markdown.zip',
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/generic/markdown.tds.zip',
    dir = '.'
  }
end

build = {
  -- type = 'builtin',
  type = 'command',
  build_command = [[unzip markdown.tds.zip || 7z x markdown.tds.zip]],
  install = {
    bin = {
      ['markdown2tex'] = 'scripts/markdown/markdown2tex.lua',
      ['markdown-cli'] = 'scripts/markdown/markdown-cli.lua',
    },
    conf = {
      ['../tex/context/third/markdown/t-markdown.tex'] = 'tex/context/third/markdown/t-markdown.tex',
      ['../tex/context/third/markdown/t-markdownthemewitiko_markdown_defaults.tex'] = 'tex/context/third/markdown/t-markdownthemewitiko_markdown_defaults.tex',
      ['../tex/generic/markdown/markdown.tex'] = 'tex/generic/markdown/markdown.tex',
      ['../tex/generic/markdown/markdownthemewitiko_markdown_defaults.tex'] = 'tex/generic/markdown/markdownthemewitiko_markdown_defaults.tex',
      ['../tex/latex/markdown/markdown.sty'] = 'tex/latex/markdown/markdown.sty',
      ['../tex/latex/markdown/markdownthemewitiko_markdown_defaults.sty'] = 'tex/latex/markdown/markdownthemewitiko_markdown_defaults.sty',
    },
    lua = {
      ['markdown-parser'] = 'tex/luatex/markdown/markdown-parser.lua',
      ['markdown-unicode-data'] = 'tex/luatex/markdown/markdown-unicode-data.lua',
      ['markdown'] = 'tex/luatex/markdown/markdown.lua',
    }
  }
}

deploy = {
  wrap_bin_scripts = false
}
