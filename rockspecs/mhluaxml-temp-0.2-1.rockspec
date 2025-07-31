local git_ref = 'v0.2'
local _git_ref = git_ref:gsub('^v', '')
local modrev = _git_ref:gsub('[^0-9.]', '')
local specrev = '1'

package = "MHLuaXML-temp"
local repo_url = "https://github.com/michal-h21/LuaXML"
version = modrev .. '-' .. specrev
source = {
  url = repo_url .. "/archive/" .. git_ref .. ".zip",
  dir = 'LuaXML-' .. _git_ref
}

dependencies = {
   "lua >= 5.3",
   -- "lpeg >= 1.0.2"
}
description = {
   summary = "LuaXML is pure lua library for reading and serializing of the XML files.",
   detailed = [[
LuaXML is pure lua library for reading and serializing of the XML files. Current release is aimed mainly as support 
for the odsfile package. The documentation was created by automatic conversion of original documentation in the source code. 
In this version, some files not useful for luaTeX were dropped. ]],
   homepage = repo_url,
   license = "MIT"
}
build = {
   type = "builtin",
   modules = {
      ["luaxml.cssquery"] = "luaxml-cssquery.lua",
      ["luaxml.domobject"] = "luaxml-domobject.lua",
      ["luaxml.encodings"] = "luaxml-encodings.lua",
      ["luaxml.entities"] = "luaxml-entities.lua",
      ["luaxml.mod-handler"] = "luaxml-mod-handler.lua",
      ["luaxml.mod-html"] = "luaxml-mod-html.lua",
      ["luaxml.mod-xml"] = "luaxml-mod-xml.lua",
      -- ["luaxml.namedentities"] = "luaxml-namedentities.lua",
      ["luaxml.parse-query"] = "luaxml-parse-query.lua",
      ["luaxml.pretty"] = "luaxml-pretty.lua",
      ["luaxml.stack"] = "luaxml-stack.lua",
      ["luaxml.testxml"] = "luaxml-testxml.lua",
      ["luaxml.transform"] = "luaxml-transform.lua"
   }
}
