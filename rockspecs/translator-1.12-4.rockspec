local git_ref = 'v1.12d'
local _git_ref = git_ref:gsub('^v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = git_ref.format('%d', _git_ref:gsub('[0-9.]', ''):byte() - 0x60)

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
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. _git_ref,
}

if modrev == 'scm' or modrev == 'dev' then
  source = {
    url = 'https://mirrors.ctan.org/install/macros/latex/contrib/translator.tds.zip',
    dir = '.'
  }
end

build = {
  type = 'none',
  install = {
    conf = {
      ['../tex/latex/translator/translator.sty'] = 'translator.sty',
      ['../tex/latex/translator/translator-basic-dictionary-Bulgarian.dict'] = 'translator-basic-dictionary-Bulgarian.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Catalan.dict'] = 'translator-basic-dictionary-Catalan.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Croatian.dict'] = 'translator-basic-dictionary-Croatian.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Czech.dict'] = 'translator-basic-dictionary-Czech.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Danish.dict'] = 'translator-basic-dictionary-Danish.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Dutch.dict'] = 'translator-basic-dictionary-Dutch.dict',
      ['../tex/latex/translator/translator-basic-dictionary-English.dict'] = 'translator-basic-dictionary-English.dict',
      ['../tex/latex/translator/translator-basic-dictionary-French.dict'] = 'translator-basic-dictionary-French.dict',
      ['../tex/latex/translator/translator-basic-dictionary-German.dict'] = 'translator-basic-dictionary-German.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Greek.dict'] = 'translator-basic-dictionary-Greek.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Italian.dict'] = 'translator-basic-dictionary-Italian.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Norsk.dict'] = 'translator-basic-dictionary-Norsk.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Nynorsk.dict'] = 'translator-basic-dictionary-Nynorsk.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Polish.dict'] = 'translator-basic-dictionary-Polish.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Portuguese.dict'] = 'translator-basic-dictionary-Portuguese.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Russian.dict'] = 'translator-basic-dictionary-Russian.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Serbian.dict'] = 'translator-basic-dictionary-Serbian.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Spanish.dict'] = 'translator-basic-dictionary-Spanish.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Swedish.dict'] = 'translator-basic-dictionary-Swedish.dict',
      ['../tex/latex/translator/translator-basic-dictionary-Turkish.dict'] = 'translator-basic-dictionary-Turkish.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Bulgarian.dict'] = 'translator-bibliography-dictionary-Bulgarian.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Catalan.dict'] = 'translator-bibliography-dictionary-Catalan.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Croatian.dict'] = 'translator-bibliography-dictionary-Croatian.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Czech.dict'] = 'translator-bibliography-dictionary-Czech.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Danish.dict'] = 'translator-bibliography-dictionary-Danish.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Dutch.dict'] = 'translator-bibliography-dictionary-Dutch.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-English.dict'] = 'translator-bibliography-dictionary-English.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-French.dict'] = 'translator-bibliography-dictionary-French.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-German.dict'] = 'translator-bibliography-dictionary-German.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Greek.dict'] = 'translator-bibliography-dictionary-Greek.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Italian.dict'] = 'translator-bibliography-dictionary-Italian.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Polish.dict'] = 'translator-bibliography-dictionary-Polish.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Portuguese.dict'] = 'translator-bibliography-dictionary-Portuguese.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Russian.dict'] = 'translator-bibliography-dictionary-Russian.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Serbian.dict'] = 'translator-bibliography-dictionary-Serbian.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Spanish.dict'] = 'translator-bibliography-dictionary-Spanish.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Swedish.dict'] = 'translator-bibliography-dictionary-Swedish.dict',
      ['../tex/latex/translator/translator-bibliography-dictionary-Turkish.dict'] = 'translator-bibliography-dictionary-Turkish.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Bulgarian.dict'] = 'translator-environment-dictionary-Bulgarian.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Catalan.dict'] = 'translator-environment-dictionary-Catalan.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Croatian.dict'] = 'translator-environment-dictionary-Croatian.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Czech.dict'] = 'translator-environment-dictionary-Czech.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Danish.dict'] = 'translator-environment-dictionary-Danish.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Dutch.dict'] = 'translator-environment-dictionary-Dutch.dict',
      ['../tex/latex/translator/translator-environment-dictionary-English.dict'] = 'translator-environment-dictionary-English.dict',
      ['../tex/latex/translator/translator-environment-dictionary-French.dict'] = 'translator-environment-dictionary-French.dict',
      ['../tex/latex/translator/translator-environment-dictionary-German.dict'] = 'translator-environment-dictionary-German.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Greek.dict'] = 'translator-environment-dictionary-Greek.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Italian.dict'] = 'translator-environment-dictionary-Italian.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Polish.dict'] = 'translator-environment-dictionary-Polish.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Portuguese.dict'] = 'translator-environment-dictionary-Portuguese.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Russian.dict'] = 'translator-environment-dictionary-Russian.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Serbian.dict'] = 'translator-environment-dictionary-Serbian.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Spanish.dict'] = 'translator-environment-dictionary-Spanish.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Swedish.dict'] = 'translator-environment-dictionary-Swedish.dict',
      ['../tex/latex/translator/translator-environment-dictionary-Turkish.dict'] = 'translator-environment-dictionary-Turkish.dict',
      ['../tex/latex/translator/translator-months-dictionary-Bulgarian.dict'] = 'translator-months-dictionary-Bulgarian.dict',
      ['../tex/latex/translator/translator-months-dictionary-Catalan.dict'] = 'translator-months-dictionary-Catalan.dict',
      ['../tex/latex/translator/translator-months-dictionary-Croatian.dict'] = 'translator-months-dictionary-Croatian.dict',
      ['../tex/latex/translator/translator-months-dictionary-Czech.dict'] = 'translator-months-dictionary-Czech.dict',
      ['../tex/latex/translator/translator-months-dictionary-Danish.dict'] = 'translator-months-dictionary-Danish.dict',
      ['../tex/latex/translator/translator-months-dictionary-Dutch.dict'] = 'translator-months-dictionary-Dutch.dict',
      ['../tex/latex/translator/translator-months-dictionary-English.dict'] = 'translator-months-dictionary-English.dict',
      ['../tex/latex/translator/translator-months-dictionary-French.dict'] = 'translator-months-dictionary-French.dict',
      ['../tex/latex/translator/translator-months-dictionary-German.dict'] = 'translator-months-dictionary-German.dict',
      ['../tex/latex/translator/translator-months-dictionary-Greek.dict'] = 'translator-months-dictionary-Greek.dict',
      ['../tex/latex/translator/translator-months-dictionary-Italian.dict'] = 'translator-months-dictionary-Italian.dict',
      ['../tex/latex/translator/translator-months-dictionary-Norsk.dict'] = 'translator-months-dictionary-Norsk.dict',
      ['../tex/latex/translator/translator-months-dictionary-Nynorsk.dict'] = 'translator-months-dictionary-Nynorsk.dict',
      ['../tex/latex/translator/translator-months-dictionary-Polish.dict'] = 'translator-months-dictionary-Polish.dict',
      ['../tex/latex/translator/translator-months-dictionary-Portuguese.dict'] = 'translator-months-dictionary-Portuguese.dict',
      ['../tex/latex/translator/translator-months-dictionary-Russian.dict'] = 'translator-months-dictionary-Russian.dict',
      ['../tex/latex/translator/translator-months-dictionary-Serbian.dict'] = 'translator-months-dictionary-Serbian.dict',
      ['../tex/latex/translator/translator-months-dictionary-Spanish.dict'] = 'translator-months-dictionary-Spanish.dict',
      ['../tex/latex/translator/translator-months-dictionary-Swedish.dict'] = 'translator-months-dictionary-Swedish.dict',
      ['../tex/latex/translator/translator-months-dictionary-Turkish.dict'] = 'translator-months-dictionary-Turkish.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Bulgarian.dict'] = 'translator-numbers-dictionary-Bulgarian.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Catalan.dict'] = 'translator-numbers-dictionary-Catalan.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Croatian.dict'] = 'translator-numbers-dictionary-Croatian.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Czech.dict'] = 'translator-numbers-dictionary-Czech.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Danish.dict'] = 'translator-numbers-dictionary-Danish.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Dutch.dict'] = 'translator-numbers-dictionary-Dutch.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-English.dict'] = 'translator-numbers-dictionary-English.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-French.dict'] = 'translator-numbers-dictionary-French.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-German.dict'] = 'translator-numbers-dictionary-German.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Greek.dict'] = 'translator-numbers-dictionary-Greek.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Italian.dict'] = 'translator-numbers-dictionary-Italian.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Norsk.dict'] = 'translator-numbers-dictionary-Norsk.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Nynorsk.dict'] = 'translator-numbers-dictionary-Nynorsk.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Polish.dict'] = 'translator-numbers-dictionary-Polish.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Portuguese.dict'] = 'translator-numbers-dictionary-Portuguese.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Russian.dict'] = 'translator-numbers-dictionary-Russian.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Serbian.dict'] = 'translator-numbers-dictionary-Serbian.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Spanish.dict'] = 'translator-numbers-dictionary-Spanish.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Swedish.dict'] = 'translator-numbers-dictionary-Swedish.dict',
      ['../tex/latex/translator/translator-numbers-dictionary-Turkish.dict'] = 'translator-numbers-dictionary-Turkish.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Bulgarian.dict'] = 'translator-theorem-dictionary-Bulgarian.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Catalan.dict'] = 'translator-theorem-dictionary-Catalan.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Croatian.dict'] = 'translator-theorem-dictionary-Croatian.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Czech.dict'] = 'translator-theorem-dictionary-Czech.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Danish.dict'] = 'translator-theorem-dictionary-Danish.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Dutch.dict'] = 'translator-theorem-dictionary-Dutch.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-English.dict'] = 'translator-theorem-dictionary-English.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-French.dict'] = 'translator-theorem-dictionary-French.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-German.dict'] = 'translator-theorem-dictionary-German.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Greek.dict'] = 'translator-theorem-dictionary-Greek.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Italian.dict'] = 'translator-theorem-dictionary-Italian.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Norsk.dict'] = 'translator-theorem-dictionary-Norsk.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Polish.dict'] = 'translator-theorem-dictionary-Polish.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Portuguese.dict'] = 'translator-theorem-dictionary-Portuguese.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Russian.dict'] = 'translator-theorem-dictionary-Russian.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Serbian.dict'] = 'translator-theorem-dictionary-Serbian.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Spanish.dict'] = 'translator-theorem-dictionary-Spanish.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Swedish.dict'] = 'translator-theorem-dictionary-Swedish.dict',
      ['../tex/latex/translator/translator-theorem-dictionary-Turkish.dict'] = 'translator-theorem-dictionary-Turkish.dict',
    }
  }
}
