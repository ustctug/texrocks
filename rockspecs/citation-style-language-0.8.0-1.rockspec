local git_ref = 'v0.8.0'
local modrev = git_ref:gsub('^v', '')
local specrev = 1
local repo_url = "https://github.com/zepinglee/citeproc-lua"

rockspec_format = "3.0"
package = "citation-style-language"
version = modrev .. '-' .. specrev

source = {
  url = repo_url .. "/archive/" .. git_ref .. ".zip",
  dir = 'citeproc-lua-' .. modrev
}

description = {
   summary = "Bibliography formatting with Citation Style Language",
   detailed =
   "The Citation Style Language (CSL) is an XML-based language that defines the formats of citations and bibliography. There are currently thousands of styles in CSL including the most widely used APA, Chicago, Vancouver, etc. The citation-style-language package is aimed to provide another reference formatting method for LaTeX that utilizes the CSL styles. It contains a citation processor implemented in pure Lua (citeproc-lua) which reads bibliographic metadata and performs sorting and formatting on both citations and bibliography according to the selected CSL style. A LaTeX package (citation-style-language.sty) is provided to communicate with the processor.",
   homepage = repo_url,
   license = "MIT"
}
dependencies = {
   "lua >= 5.3",
   "api7-lua-tinyyaml >= 0.4.3",
   "datafile >= 0.8",
   -- "lpeg >= 1.0.2",
   "lua-uca-temp >= 0.1",
   -- "luautf8 >= 0.1",
   "mhluaxml-temp >= 0.1",
   "citation-style-language-styles",
   "citation-style-language-locales",
   "l3packages",
   "lualibs",
   "lua-uni-algos",
}

build = {
   type = "builtin",
   patches = {
      -- https://github.com/zepinglee/citeproc-lua/issues/96
      ['fix-other-text-files.diff'] = [[
--- old/citeproc/citeproc-manager.lua
+++ new/citeproc/citeproc-manager.lua
@@ -38,7 +38,7 @@
   if ftype then
     path = kpse.find_file(file_name, ftype)
   else
-    path = kpse.find_file(file_name)
+    path = kpse.find_file(file_name, 'other text files')
   end
 
   if not path then
@@ -112,7 +112,7 @@
 local function make_citeproc_sys(item_dict)
   local citeproc_sys = {
     retrieveLocale = function (lang)
-      local locale_file_format = "csl-locales-%s.xml"
+      local locale_file_format = "locales-%s.xml"
       local filename = string.format(locale_file_format, lang)
       return read_file(filename, nil, "locale file")
     end,
]],
   },
   install = {
      bin = {
         ['citeproc-lua'] = 'citeproc/citeproc-lua.lua',
      },
      conf = {
         ['../tex/latex/citation-style-language/citation-style-language-bib.sty'] = 'latex/citation-style-language-bib.sty',
         ['../tex/latex/citation-style-language/citation-style-language-cite.sty'] = 'latex/citation-style-language-cite.sty',
         ['../tex/latex/citation-style-language/citation-style-language-compatible.sty'] = 'latex/citation-style-language-compatible.sty',
         ['../tex/latex/citation-style-language/citation-style-language-data.sty'] = 'latex/citation-style-language-data.sty',
         ['../tex/latex/citation-style-language/citation-style-language-init.sty'] = 'latex/citation-style-language-init.sty',
         ['../tex/latex/citation-style-language/citation-style-language.sty'] = 'latex/citation-style-language.sty',
      }
   },
   modules = {
      ["citeproc-bibtex-data"] = "citeproc/citeproc-bibtex-data.lua",
      ["citeproc-bibtex-parser"] = "citeproc/citeproc-bibtex-parser.lua",
      ["citeproc-bibtex2csl"] = "citeproc/citeproc-bibtex2csl.lua",
      ["citeproc-cli"] = "citeproc/citeproc-cli.lua",
      ["citeproc-context"] = "citeproc/citeproc-context.lua",
      ["citeproc-element"] = "citeproc/citeproc-element.lua",
      ["citeproc-engine"] = "citeproc/citeproc-engine.lua",
      ["citeproc-ir-node"] = "citeproc/citeproc-ir-node.lua",
      ["citeproc-journal-data"] = "citeproc/citeproc-journal-data.lua",
      ["citeproc-latex-data"] = "citeproc/citeproc-latex-data.lua",
      ["citeproc-latex-parser"] = "citeproc/citeproc-latex-parser.lua",
      ["citeproc-lua-uni-words"] = "citeproc/citeproc-lua-uni-words.lua",
      ["citeproc-manager"] = "citeproc/citeproc-manager.lua",
      ["citeproc-node-bibliography"] = "citeproc/citeproc-node-bibliography.lua",
      ["citeproc-node-choose"] = "citeproc/citeproc-node-choose.lua",
      ["citeproc-node-citation"] = "citeproc/citeproc-node-citation.lua",
      ["citeproc-node-date"] = "citeproc/citeproc-node-date.lua",
      ["citeproc-node-group"] = "citeproc/citeproc-node-group.lua",
      ["citeproc-node-label"] = "citeproc/citeproc-node-label.lua",
      ["citeproc-node-layout"] = "citeproc/citeproc-node-layout.lua",
      ["citeproc-node-locale"] = "citeproc/citeproc-node-locale.lua",
      ["citeproc-node-names"] = "citeproc/citeproc-node-names.lua",
      ["citeproc-node-number"] = "citeproc/citeproc-node-number.lua",
      ["citeproc-node-sort"] = "citeproc/citeproc-node-sort.lua",
      ["citeproc-node-style"] = "citeproc/citeproc-node-style.lua",
      ["citeproc-node-text"] = "citeproc/citeproc-node-text.lua",
      ["citeproc-nodes"] = "citeproc/citeproc-nodes.lua",
      ["citeproc-output"] = "citeproc/citeproc-output.lua",
      ["citeproc-unicode"] = "citeproc/citeproc-unicode.lua",
      ["citeproc-util"] = "citeproc/citeproc-util.lua",
      ["citeproc-yaml"] = "citeproc/citeproc-yaml.lua",
      ["citeproc"] = "citeproc/citeproc.lua",
   }
}
test_dependencies = {
   "dkjson >= 2.1.0",
   "luafilesystem >= 1.5.0"
}
test = {
   type = "busted",
   flags = {
      "--lpath=''",
      "--run=citeproc"
   }
}

deploy = {
  wrap_bin_scripts = false
}
