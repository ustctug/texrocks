---@diagnostic disable: codestyle-check, lowercase-global
rockspec_format = "3.0"
package = "citation-style-language"
version = "scm-1"
source = {
   url = "https://mirrors.ctan.org/install/biblio/citation-style-language.tds.zip",
   dir = '.'
}
description = {
   summary = "Bibliography formatting with Citation Style Language",
   detailed =
   "The Citation Style Language (CSL) is an XML-based language that defines the formats of citations and bibliography. There are currently thousands of styles in CSL including the most widely used APA, Chicago, Vancouver, etc. The citation-style-language package is aimed to provide another reference formatting method for LaTeX that utilizes the CSL styles. It contains a citation processor implemented in pure Lua (citeproc-lua) which reads bibliographic metadata and performs sorting and formatting on both citations and bibliography according to the selected CSL style. A LaTeX package (citation-style-language.sty) is provided to communicate with the processor.",
   homepage = "https://github.com/zepinglee/citeproc-lua",
   license = "MIT"
}
dependencies = {
   "lua >= 5.3",
   "api7-lua-tinyyaml >= 0.4.3",
   "datafile >= 0.8",
   -- "lpeg >= 1.0.2",
   "lua-uca >= 0.1",
   -- "luautf8 >= 0.1"
   "mhluaxml >= 0.1"
}
build = {
   type = "builtin",
   copy_directories = { 'tex', 'doc' },
   patches = {
      ['fix-module-name1.diff'] = [[
--- old/scripts/citation-style-language/citeproc-node-sort.lua
+++ new/scripts/citation-style-language/citeproc-node-sort.lua
@@ -15,11 +15,12 @@
 local util
 local node_date
 
-local using_luatex, kpse = pcall(require, "kpse")
+kpse = nil
+local using_luatex, _kpse = pcall(require, "kpse")
 if using_luatex then
-  uca_languages = require("lua-uca-languages")
-  uca_ducet = require("lua-uca-ducet")
-  uca_collator = require("lua-uca-collator")
+  uca_languages = require("lua-uca.languages")
+  uca_ducet = require("lua-uca.ducet")
+  uca_collator = require("lua-uca.collator")
   element = require("citeproc-element")
   output = require("citeproc-output")
   util = require("citeproc-util")
@@ -33,6 +34,7 @@
   util = require("citeproc.util")
   node_date = require("citeproc.node-date")
 end
+kpse = _kpse
 
 local Element = element.Element
 local Date = node_date.Date
   ]],
      ['fix-module-name2.diff'] = [[
--- old/scripts/citation-style-language/citeproc-node-style.lua
+++ new/scripts/citation-style-language/citeproc-node-style.lua
@@ -13,9 +13,10 @@
 local node_names
 local util
 
-local using_luatex, kpse = pcall(require, "kpse")
+kpse = nil
+local using_luatex, _kpse = pcall(require, "kpse")
 if using_luatex then
-  dom = require("luaxml-domobject")
+  dom = require("luaxml.domobject")
   element = require("citeproc-element")
   ir_node = require("citeproc-ir-node")
   output = require("citeproc-output")
@@ -29,6 +30,7 @@
   node_names = require("citeproc.node-names")
   util = require("citeproc.util")
 end
+kpse = _kpse
 
 local Element = element.Element
 local IrNode = ir_node.IrNode
   ]],
      ['fix-module-name3.diff'] = [[
--- old/scripts/citation-style-language/citeproc-output.lua
+++ new/scripts/citation-style-language/citeproc-output.lua
@@ -13,11 +13,12 @@
 local ir_node
 local util
 
-local using_luatex, kpse = pcall(require, "kpse")
+kpse = nil
+local using_luatex, _kpse = pcall(require, "kpse")
 if using_luatex then
   uni_utf8 = require("unicode").utf8
   unicode = require("citeproc-unicode")
-  dom = require("luaxml-domobject")
+  dom = require("luaxml.domobject")
   ir_node = require("citeproc-ir-node")
   util = require("citeproc-util")
 else
@@ -27,6 +28,7 @@
   ir_node = require("citeproc.ir-node")
   util = require("citeproc.util")
 end
+kpse = _kpse
 
 local GroupVar = ir_node.GroupVar
 
   ]],
      ['fix-module-name4.diff'] = [[
--- old/scripts/citation-style-language/citeproc-engine.lua
+++ new/scripts/citation-style-language/citeproc-engine.lua
@@ -15,9 +15,10 @@
 local output
 local util
 
-local using_luatex, kpse = pcall(require, "kpse")
+kpse = nil
+local using_luatex, _kpse = pcall(require, "kpse")
 if using_luatex then
-  dom = require("luaxml-domobject")
+  dom = require("luaxml.domobject")
   context = require("citeproc-context")
   element = require("citeproc-element")
   nodes = require("citeproc-nodes")
@@ -35,6 +36,7 @@
   output = require("citeproc.output")
   util = require("citeproc.util")
 end
+kpse = _kpse
 
 local Element = element.Element
 local Style = node_style.Style
      ]]
   },
   install = {
      bin = {
         ['citeproc-lua'] = 'scripts/citation-style-language/citeproc-lua.lua',
      }
   },
   modules = {
      ['citeproc-bibtex-data'] = 'scripts/citation-style-language/citeproc-bibtex-data.lua',
      ['citeproc-bibtex-parser'] = 'scripts/citation-style-language/citeproc-bibtex-parser.lua',
      ['citeproc-bibtex2csl'] = 'scripts/citation-style-language/citeproc-bibtex2csl.lua',
      ['citeproc-cli'] = 'scripts/citation-style-language/citeproc-cli.lua',
      ['citeproc-context'] = 'scripts/citation-style-language/citeproc-context.lua',
      ['citeproc-element'] = 'scripts/citation-style-language/citeproc-element.lua',
      ['citeproc-engine'] = 'scripts/citation-style-language/citeproc-engine.lua',
      ['citeproc-ir-node'] = 'scripts/citation-style-language/citeproc-ir-node.lua',
      ['citeproc-journal-data'] = 'scripts/citation-style-language/citeproc-journal-data.lua',
      ['citeproc-latex-data'] = 'scripts/citation-style-language/citeproc-latex-data.lua',
      ['citeproc-latex-parser'] = 'scripts/citation-style-language/citeproc-latex-parser.lua',
      ['citeproc-manager'] = 'scripts/citation-style-language/citeproc-manager.lua',
      ['citeproc-node-bibliography'] = 'scripts/citation-style-language/citeproc-node-bibliography.lua',
      ['citeproc-node-choose'] = 'scripts/citation-style-language/citeproc-node-choose.lua',
      ['citeproc-node-citation'] = 'scripts/citation-style-language/citeproc-node-citation.lua',
      ['citeproc-node-date'] = 'scripts/citation-style-language/citeproc-node-date.lua',
      ['citeproc-node-group'] = 'scripts/citation-style-language/citeproc-node-group.lua',
      ['citeproc-node-label'] = 'scripts/citation-style-language/citeproc-node-label.lua',
      ['citeproc-node-layout'] = 'scripts/citation-style-language/citeproc-node-layout.lua',
      ['citeproc-node-locale'] = 'scripts/citation-style-language/citeproc-node-locale.lua',
      ['citeproc-node-names'] = 'scripts/citation-style-language/citeproc-node-names.lua',
      ['citeproc-node-number'] = 'scripts/citation-style-language/citeproc-node-number.lua',
      ['citeproc-node-sort'] = 'scripts/citation-style-language/citeproc-node-sort.lua',
      ['citeproc-node-style'] = 'scripts/citation-style-language/citeproc-node-style.lua',
      ['citeproc-node-text'] = 'scripts/citation-style-language/citeproc-node-text.lua',
      ['citeproc-nodes'] = 'scripts/citation-style-language/citeproc-nodes.lua',
      ['citeproc-output'] = 'scripts/citation-style-language/citeproc-output.lua',
      ['citeproc-unicode'] = 'scripts/citation-style-language/citeproc-unicode.lua',
      ['citeproc-util'] = 'scripts/citation-style-language/citeproc-util.lua',
      ['citeproc-yaml'] = 'scripts/citation-style-language/citeproc-yaml.lua',
      ['citeproc'] = 'scripts/citation-style-language/citeproc.lua'
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
