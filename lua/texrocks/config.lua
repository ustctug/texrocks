-- ~/.config/texmf/init.lua
local home = os.getenv('HOME')
local config = {
    rocks_path = home .. '/.local/share/texmf',
    luarocks_config_path = home .. '/.luarocks/config-5.3.lua',
    luarocks_binary = 'luarocks'
}
loadfile(home .. '/.config/texmf/init.lua', 't', config)()
return config
