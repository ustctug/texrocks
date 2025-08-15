local M = {}
local fs = require("luarocks.fs")
local path = require("luarocks.path")
local dir = require("luarocks.dir")

---get config
---@return table<string, any> config
function M.get_config()
   local config = {
      type = type,
      string = string,
      status = { banner = '' },
   }
   loadfile('build.lua', "t", config)()
   local pth = package.searchpath('l3build-variables', package.path)
   loadfile(pth, "t", config)()
   return config
end

---core function
---@return true | nil, nil | string
function M.run(rockspec, no_install)
   local config = M.get_config()
   local build = rockspec.build
   io.popen([[l3build install --texmfhome .]])
   table.insert(build.copy_directories, 'tex')

   local parent = dir.path("scripts", config.module)
   local dir_sep = package.config:sub(1, 1)
   if fs.is_dir(parent) then
      fs.change_dir(parent)
      local prefix = parent .. dir_sep
      for _, file in ipairs(fs.find()) do
         local luamod = file:match("(.*)%.lua$") or file:match("(.*)%.tlu$")
         if luamod then
            build.modules[path.path_to_module(file)] = prefix .. file
         end
      end
      fs.pop_dir()
   end

   local luadir = path.lua_dir(rockspec.name, rockspec.version)
   local lua_modules = {}
   for name, info in pairs(build.modules) do
      local moddir = path.module_to_path(name)
      if type(info) == "string" then
         local ext = info:match("%.([^.]+)$")
         if ext == "lua" or ext == "tlu" then
            local filename = dir.base_name(info)
            if filename == "init.lua" and not name:match("%.init$") then
               moddir = path.module_to_path(name .. ".init")
            else
               local basename = name:match("([^.]+)$")
               filename = basename .. ".lua"
            end
            local dest = dir.path(luadir, moddir, filename)
            lua_modules[info] = dest
         end
      end
   end

   if not no_install then
      for _, mods in ipairs({ { tbl = lua_modules, perms = "read" }, { tbl = {}, perms = "exec" } }) do
         for name, dest in pairs(mods.tbl) do
            local ok, err = fs.copy(name, dest, mods.perms)
            if not ok then
               return nil, "Failed installing " .. name .. " in " .. dest .. ": " .. err
            end
         end
      end
   end

   return true
end

M.run()
return M
