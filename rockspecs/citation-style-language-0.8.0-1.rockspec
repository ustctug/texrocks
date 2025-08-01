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
      ['fix-lua-uca.diff'] = [[
--- old/citeproc/citeproc-node-sort.lua
+++ new/citeproc/citeproc-node-sort.lua
@@ -6,34 +6,23 @@
 
 local sort = {}
 
-local uca_languages
-local uca_ducet
-local uca_collator
-
-local element
-local output
-local util
-local node_date
-
-local using_luatex, kpse = pcall(require, "kpse")
-if using_luatex then
-  uca_languages = require("lua-uca-languages")
-  uca_ducet = require("lua-uca-ducet")
-  uca_collator = require("lua-uca-collator")
-  element = require("citeproc-element")
-  output = require("citeproc-output")
-  util = require("citeproc-util")
-  node_date = require("citeproc-node-date")
-else
-  uca_languages = require("citeproc.lua-uca.languages")
-  uca_ducet = require("citeproc.lua-uca.ducet")
-  uca_collator = require("citeproc.lua-uca.collator")
-  element = require("citeproc.element")
-  output = require("citeproc.output")
-  util = require("citeproc.util")
-  node_date = require("citeproc.node-date")
+local function requires(modname)
+    for _, modname in ipairs{modname, modname:gsub("%.", "-"), "citeproc." .. modname} do
+      local is_ok, mod = pcall(require, modname)
+      if is_ok then
+        return mod
+      end
+    end
 end
 
+local uca_languages = require("lua-uca.languages")
+local uca_ducet = require("lua-uca.ducet")
+local uca_collator = require("lua-uca.collator")
+local element = require("citeproc.element")
+local output = require("citeproc.output")
+local util = require("citeproc.util")
+local node_date = require("citeproc.node-date")
+
 local Element = element.Element
 local Date = node_date.Date
 local InlineElement = output.InlineElement
]],
      ['fix-luaxml.diff'] = [[
--- old/citeproc/citeproc-node-style.lua
+++ new/citeproc/citeproc-node-style.lua
@@ -6,24 +6,20 @@
 
 local style_module = {}
 
-local dom
-local element
-local node_names
-local util
-
-local using_luatex, kpse = pcall(require, "kpse")
-if using_luatex then
-  dom = require("luaxml-domobject")
-  element = require("citeproc-element")
-  node_names = require("citeproc-node-names")
-  util = require("citeproc-util")
-else
-  dom = require("citeproc.luaxml.domobject")
-  element = require("citeproc.element")
-  node_names = require("citeproc.node-names")
-  util = require("citeproc.util")
+local function requires(modname)
+    for _, modname in ipairs{modname, modname:gsub("%.", "-"), "citeproc." .. modname} do
+      local is_ok, mod = pcall(require, modname)
+      if is_ok then
+        return mod
+      end
+    end
 end
 
+local dom = requires("luaxml.domobject")
+local element = requires("citeproc.element")
+local node_names = requires("citeproc.node-names")
+local util = requires("citeproc.util")
+
 local Element = element.Element
 
 
]],
      ['fix-luaxml2.diff'] = [[
--- old/citeproc/citeproc-engine.lua
+++ new/citeproc/citeproc-engine.lua
@@ -6,36 +6,24 @@
 
 local engine = {}
 
-local dom
-local context
-local element
-local nodes
-local node_locale
-local node_style
-local output
-local util
-
-local using_luatex, _ = pcall(require, "kpse")
-if using_luatex then
-  dom = require("luaxml-domobject")
-  context = require("citeproc-context")
-  element = require("citeproc-element")
-  nodes = require("citeproc-nodes")
-  node_locale = require("citeproc-node-locale")
-  node_style = require("citeproc-node-style")
-  output = require("citeproc-output")
-  util = require("citeproc-util")
-else
-  dom = require("citeproc.luaxml.domobject")
-  context = require("citeproc.context")
-  element = require("citeproc.element")
-  nodes = require("citeproc.nodes")
-  node_locale = require("citeproc.node-locale")
-  node_style = require("citeproc.node-style")
-  output = require("citeproc.output")
-  util = require("citeproc.util")
+local function requires(modname)
+    for _, modname in ipairs{modname, modname:gsub("%.", "-"), "citeproc." .. modname} do
+      local is_ok, mod = pcall(require, modname)
+      if is_ok then
+        return mod
+      end
+    end
 end
 
+local dom = requires("luaxml.domobject")
+local context = requires("citeproc.context")
+local element = requires("citeproc.element")
+local nodes = requires("citeproc.nodes")
+local node_locale = requires("citeproc.node-locale")
+local node_style = requires("citeproc.node-style")
+local output = requires("citeproc.output")
+local util = requires("citeproc.util")
+
 local Element = element.Element
 local Style = node_style.Style
 local Locale = node_locale.Locale
]],
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
