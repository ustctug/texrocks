local git_ref = '1.12'
local modrev = git_ref
local specrev = '4'

local repo_url = 'https://github.com/josephwright/translator'

rockspec_format = '3.0'
package = 'translator'
version = modrev .. '-' .. specrev

description = {
  summary = [[Easy translation of strings in LaTeX]],
  detailed =
  [[This LaTeX package provides a flexible mechanism for translating individual words into different languages. For example, it can be used to translate a word like “figure” into, say, the German word “Abbildung”. Such a translation mechanism is useful when the author of some package would like to localize the package such that texts are correctly translated into the language preferred by the user.

  This package is not intended to be used to automatically translate more than a few words.]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'GPL'
}

dependencies = { 'latex-graphics' }

source = {
  url = "https://github.com/ustctug/texrocks/releases/download/0.0.1/translator.tds.zip",
  dir = '.'
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/translator.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  copy_directories = { 'doc', 'tex' },
}
