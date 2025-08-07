local git_ref = 'e2bb80a58a41234e5e81a28250bc583422c02157'
local modrev = '0.0.1'
local specrev = '1'

local repo_url = 'https://github.com/icedman/nvim-textmate'

rockspec_format = '3.0'
package = 'nvim-textmate'
version = modrev .. '-' .. specrev

description = {
  summary = 'A textmate-based syntax highlighter for neovim - compatible with VScode',
  detailed =
  [[A textmate-based syntax highlighter to nvim, compatible with VScode themes and grammars]],
  labels = { },
  homepage = repo_url,
  license = 'GPL-2.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = package .. '-' .. git_ref,
}

build = {
  type = 'make',
   patches = {
      ['fix-build.diff'] = [[
--- old/Makefile
+++ new/Makefile
@@ -3,16 +3,17 @@ all: prebuild build install
 .PHONY: prebuild build install
 
 prebuild:
+	cd libs/jsoncpp && ./amalgamate.py
 	cd libs/Onigmo && ./autogen.sh && ./configure
 
 build:
 	mkdir -p build
-	cd build && cmake ../cmake && make
-	cp build/textmate.so ./lua/nvim-textmate/
+	cd build && cmake ../cmake && cmake --build .
+	# cp build/textmate.so ./lua/nvim-textmate/
 
 install:
-	mkdir -p ~/.config/nvim/lua/
-	cp -R ./lua/nvim-textmate ~/.config/nvim/lua/
+	# mkdir -p ~/.config/nvim/lua/
+	# cp -R ./lua/nvim-textmate ~/.config/nvim/lua/
 
 uninstall:
 	rm -rf ~/.config/nvim/lua/nvim-textmate
]],
      ['fix-skip-parse.diff'] = [[
--- old/libs/tm-parser/textmate/textmate.cpp
+++ new/libs/tm-parser/textmate/textmate.cpp
@@ -529,9 +529,9 @@ Textmate::run_highlighter(char *_text, language_info_ptr lang, theme_ptr theme,
 
   std::vector<textstyle_t> textstyle_buffer;
 
-  if (strlen(_text) > SKIP_PARSE_THRESHOLD) {
-    return textstyle_buffer;
-  }
+  // if (strlen(_text) > SKIP_PARSE_THRESHOLD) {
+  //   return textstyle_buffer;
+  // }
 
   // printf("hl %x %s\n", block, _text);
 
]],
   },
   install = {
     lib = {
       textmate = 'build/textmate.so',
     },
     lua = {
       ['nvim-textmate.colormap'] = 'lua/nvim-textmate/colormap.lua',
       ['nvim-textmate.init'] = 'lua/nvim-textmate/init.lua',
     }
   }
}
