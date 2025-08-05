local git_ref = 'v5.1.18'
local _git_ref = git_ref:gsub('^v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = '1'

local repo_url = 'https://github.com/speedata/publisher'

rockspec_format = '3.0'
package = 'publisher'
version = modrev .. '-' .. specrev

description = {
  summary = 'speedata Publisher - a professional database Publishing system',
  detailed =
  [[The speedata Publisher is a full featured and mature database publishing software. It generates PDF files from XML data and XML layout instructions. It is used to make product catalogs and other documents with high demands on the layout.

Its built-in layout description language allows you to create almost arbitrary layouts, while keeping the job as simple as possible.

Think of it as "XSL-FO on steroids" or "server side InDesign".]],
  labels = { 'tex', 'latex' },
  homepage = repo_url,
  license = 'AGPL-3.0'
}

source = {
  url = repo_url .. '/archive/' .. git_ref .. '.zip',
  dir = 'publisher-' .. modrev,
}

build = {
  type = 'command',
   patches = {
      ['make-splib-static.diff'] = [[
--- old/src/go/sphelper/buildlib/buildlib.go
+++ new/src/go/sphelper/buildlib/buildlib.go
@@ -43,16 +43,16 @@
 		case "arm64":
 			triple = "arm64-apple-macos11"
 		}
-		cmd = exec.Command("clang", "-dynamiclib", "-target", triple, "-fPIC", "-undefined", "dynamic_lookup", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/opt/homebrew/opt/lua@5.3/include/lua")
+		cmd = exec.Command("clang", "-dynamiclib", "-target", triple, "-fPIC", "-undefined", "dynamic_lookup", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/opt/homebrew/opt/lua@5.3/include/lua", "-lsplib", "-L"+dylibbuild)
 	case "linux":
 		switch goarch {
 		case "amd64":
-			cmd = exec.Command(ccenv, "-shared", "-fPIC", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/usr/include/lua5.3/")
+			cmd = exec.Command("cc", "-shared", "-fPIC", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/usr/include/lua5.3/", "-lsplib", "-L"+dylibbuild)
 		case "arm64":
-			cmd = exec.Command(ccenv, "-shared", "-fPIC", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/usr/include/lua5.3/")
+			cmd = exec.Command("cc", "-shared", "-fPIC", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/usr/include/lua5.3/", "-lsplib", "-L"+dylibbuild)
 		}
 	case "freebsd":
-		cmd = exec.Command("cc", "-shared", "-fPIC", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/usr/local/include/lua53/")
+		cmd = exec.Command("cc", "-shared", "-fPIC", "-o", filepath.Join(dylibbuild, "luaglue.so"), "luaglue.c", "-I/usr/local/include/lua53/", "-lsplib", "-L"+dylibbuild)
 	case "windows":
 		cmd = exec.Command(ccenv, "-shared", "-o", filepath.Join(dylibbuild, "luaglue.dll"), "luaglue.c", "-I/usr/include/lua5.3/", "-L/luatex-bin/luatex/windows/amd64/default/", "-llua53w64", "-llibsplib", "-L"+dylibbuild)
 	}
@@ -66,22 +66,22 @@
 
 // BuildLib builds the dynamic library
 func BuildLib(cfg *config.Config, goos string, goarch string) error {
-	fmt.Println("Building dynamic library for", goos, goarch)
+	fmt.Println("Building static library for", goos, goarch)
 	srcdir := cfg.Srcdir
 	os.Chdir(filepath.Join(srcdir, "go", "splib"))
-	libraryextension := ".so"
+	libraryextension := ".a"
 	switch goos {
 	case "darwin":
-		libraryextension = ".so"
+		libraryextension = ".a"
 	case "windows":
-		libraryextension = ".dll"
+		libraryextension = ".lib"
 	}
 	dylibbuild := filepath.Join(cfg.Builddir, "dylib")
 	var cmd *exec.Cmd
 	if cfg.IsPro {
-		cmd = exec.Command("go", "build", "-tags", "pro", "-buildmode=c-shared", "-o", filepath.Join(dylibbuild, "libsplib"+libraryextension), "speedatapublisher/splib")
+		cmd = exec.Command("go", "build", "-tags", "pro", "-buildmode=c-archive", "-o", filepath.Join(dylibbuild, "libsplib"+libraryextension), "speedatapublisher/splib")
 	} else {
-		cmd = exec.Command("go", "build", "-buildmode=c-shared", "-o", filepath.Join(dylibbuild, "libsplib"+libraryextension), "speedatapublisher/splib")
+		cmd = exec.Command("go", "build", "-buildmode=c-archive", "-o", filepath.Join(dylibbuild, "libsplib"+libraryextension), "speedatapublisher/splib")
 	}
 	cmd.Env = os.Environ()
 	if goos != runtime.GOOS || goarch != runtime.GOARCH {
]],
      ['remove-load-dll.diff'] = [[
--- old/src/lua/sdini.lua
+++ new/src/lua/sdini.lua
@@ -22,10 +22,10 @@
 end
 
 local ok, msg = package.loadlib(libname,"*")
-if not ok then
-   print(msg)
-   os.exit(0)
-end
+-- if not ok then
+--    print(msg)
+--    os.exit(0)
+-- end
 
 -- the library was formally named splib. luaglue is a layer (see #570).
 local splib = require("luaglue")
]],
      ['change-err-to-warning.diff'] = [[
--- old/src/lua/publisher.lua
+++ new/src/lua/publisher.lua
@@ -1307,7 +1307,7 @@
     --- The `vars` file hold a lua document holding table
     local vars
     local varsfun = loadfile(tex.jobname .. ".vars")
-    if varsfun then vars = varsfun() else err("Could not load .vars file. Something strange is happening.") vars = {} end
+    if varsfun then vars = varsfun() else warning("Could not load .vars file. Something strange is happening.") vars = {} end
 
     for i=4,#arg do
         local k,v = arg[i]:match("^(.+)=(.+)$")
]],
   },
  build_command = [[
  rake buildlib
]],
  copy_directories = { 'fonts' },
  install = {
    lib = {
      luaglue = 'lib/luaglue.so'
    },
    lua = {
      ['barcodes.barcodes'] = 'src/lua/barcodes/barcodes.lua',
      ['barcodes.qrencode'] = 'src/lua/barcodes/qrencode.lua',
      ['box'] = 'src/lua/box.lua',
      ['common.lua-visual-debug'] = 'src/lua/common/lua-visual-debug.lua',
      ['common.sd-callbacks'] = 'src/lua/common/sd-callbacks.lua',
      ['common.sd-debug'] = 'src/lua/common/sd-debug.lua',
      ['css'] = 'src/lua/css.lua',
      ['dimexpr'] = 'src/lua/dimexpr.lua',
      ['fonts.fontloader'] = 'src/lua/fonts/fontloader.lua',
      ['luxor'] = 'src/lua/luxor.lua',
      ['lxpath'] = 'src/lua/lxpath.lua',
      ['par'] = 'src/lua/par.lua',
      ['publisher.commands'] = 'src/lua/publisher/commands.lua',
      ['publisher.fonts'] = 'src/lua/publisher/fonts.lua',
      ['publisher.grid'] = 'src/lua/publisher/grid.lua',
      ['publisher.html'] = 'src/lua/publisher/html.lua',
      ['publisher.layout_functions'] = 'src/lua/publisher/layout_functions.lua',
      ['publisher.layout_functions_lxpath'] = 'src/lua/publisher/layout_functions_lxpath.lua',
      ['publisher.metapost'] = 'src/lua/publisher/metapost.lua',
      ['publisher.page'] = 'src/lua/publisher/page.lua',
      ['publisher.spinit'] = 'src/lua/publisher/spinit.lua',
      ['publisher.tabular'] = 'src/lua/publisher/tabular.lua',
      ['publisher'] = 'src/lua/publisher.lua',
      ['sdini'] = 'src/lua/sdini.lua',
      ['sdscripts'] = 'src/lua/sdscripts.lua',
      ['shalocal'] = 'src/lua/shalocal.lua',
      ['socket_url'] = 'src/lua/socket_url.lua',
      ['spotcolors'] = 'src/lua/spotcolors.lua',
      ['utf8fix'] = 'src/lua/utf8fix.lua',
      ['uuid'] = 'src/lua/uuid.lua',
      ['xpath'] = 'src/lua/xpath.lua',
    },
    conf = {
      ['hyph-bg.pat.txt'] = 'src/hyphenation/hyph-bg.pat.txt',
      ['hyph-ca.pat.txt'] = 'src/hyphenation/hyph-ca.pat.txt',
      ['hyph-cs.pat.txt'] = 'src/hyphenation/hyph-cs.pat.txt',
      ['hyph-cy.pat.txt'] = 'src/hyphenation/hyph-cy.pat.txt',
      ['hyph-da.pat.txt'] = 'src/hyphenation/hyph-da.pat.txt',
      ['hyph-de-1996.pat.txt'] = 'src/hyphenation/hyph-de-1996.pat.txt',
      ['hyph-el-monoton.pat.txt'] = 'src/hyphenation/hyph-el-monoton.pat.txt',
      ['hyph-en-gb.pat.txt'] = 'src/hyphenation/hyph-en-gb.pat.txt',
      ['hyph-en-us.pat.txt'] = 'src/hyphenation/hyph-en-us.pat.txt',
      ['hyph-eo.pat.txt'] = 'src/hyphenation/hyph-eo.pat.txt',
      ['hyph-es.pat.txt'] = 'src/hyphenation/hyph-es.pat.txt',
      ['hyph-et.pat.txt'] = 'src/hyphenation/hyph-et.pat.txt',
      ['hyph-eu.pat.txt'] = 'src/hyphenation/hyph-eu.pat.txt',
      ['hyph-fi.pat.txt'] = 'src/hyphenation/hyph-fi.pat.txt',
      ['hyph-fr.pat.txt'] = 'src/hyphenation/hyph-fr.pat.txt',
      ['hyph-ga.pat.txt'] = 'src/hyphenation/hyph-ga.pat.txt',
      ['hyph-gl.pat.txt'] = 'src/hyphenation/hyph-gl.pat.txt',
      ['hyph-grc.pat.txt'] = 'src/hyphenation/hyph-grc.pat.txt',
      ['hyph-gu.pat.txt'] = 'src/hyphenation/hyph-gu.pat.txt',
      ['hyph-hi.pat.txt'] = 'src/hyphenation/hyph-hi.pat.txt',
      ['hyph-hr.pat.txt'] = 'src/hyphenation/hyph-hr.pat.txt',
      ['hyph-hu.pat.txt'] = 'src/hyphenation/hyph-hu.pat.txt',
      ['hyph-hy.pat.txt'] = 'src/hyphenation/hyph-hy.pat.txt',
      ['hyph-id.pat.txt'] = 'src/hyphenation/hyph-id.pat.txt',
      ['hyph-is.pat.txt'] = 'src/hyphenation/hyph-is.pat.txt',
      ['hyph-it.pat.txt'] = 'src/hyphenation/hyph-it.pat.txt',
      ['hyph-kmr.pat.txt'] = 'src/hyphenation/hyph-kmr.pat.txt',
      ['hyph-kn.pat.txt'] = 'src/hyphenation/hyph-kn.pat.txt',
      ['hyph-lt.pat.txt'] = 'src/hyphenation/hyph-lt.pat.txt',
      ['hyph-lv.pat.txt'] = 'src/hyphenation/hyph-lv.pat.txt',
      ['hyph-ml.pat.txt'] = 'src/hyphenation/hyph-ml.pat.txt',
      ['hyph-nb.pat.txt'] = 'src/hyphenation/hyph-nb.pat.txt',
      ['hyph-nl.pat.txt'] = 'src/hyphenation/hyph-nl.pat.txt',
      ['hyph-nn.pat.txt'] = 'src/hyphenation/hyph-nn.pat.txt',
      ['hyph-pl.pat.txt'] = 'src/hyphenation/hyph-pl.pat.txt',
      ['hyph-pt.pat.txt'] = 'src/hyphenation/hyph-pt.pat.txt',
      ['hyph-ro.pat.txt'] = 'src/hyphenation/hyph-ro.pat.txt',
      ['hyph-ru.pat.txt'] = 'src/hyphenation/hyph-ru.pat.txt',
      ['hyph-sa.pat.txt'] = 'src/hyphenation/hyph-sa.pat.txt',
      ['hyph-sk.pat.txt'] = 'src/hyphenation/hyph-sk.pat.txt',
      ['hyph-sl.pat.txt'] = 'src/hyphenation/hyph-sl.pat.txt',
      ['hyph-sr-cyrl.pat.txt'] = 'src/hyphenation/hyph-sr-cyrl.pat.txt',
      ['hyph-sr.pat.txt'] = 'src/hyphenation/hyph-sr.pat.txt',
      ['hyph-sv.pat.txt'] = 'src/hyphenation/hyph-sv.pat.txt',
      ['hyph-tr.pat.txt'] = 'src/hyphenation/hyph-tr.pat.txt',
      ['hyph-uk.pat.txt'] = 'src/hyphenation/hyph-uk.pat.txt',
    },
  }
}
