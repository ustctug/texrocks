-- luacheck: ignore 111 113
---@diagnostic disable: undefined-global
-- ~/.config/texmf/init.lua
local home = os.getenv('HOME')
loadfile(home .. '/.config/texmf/init.lua')()
local c = config or {}
config = nil
c.rocks_path = c.rocks_path or home .. '/.local/share/texmf'
c.luarocks_config_path = c.luarocks_config_path or home .. '/.luarocks/config-5.3.lua'
c.luarocks_binary = c.luarocks_binary or 'luarocks'
return c
