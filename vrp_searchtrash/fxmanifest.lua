fx_version 'bodacious'
games {'gta5'}

author 'FTDark aka GeorgeAdam, George-Adam'
description 'vRP search the trash cans'
version '0.01'

client_scripts{ 
	"lib/Tunnel.lua",
	"lib/Proxy.lua",
	"c_trash.lua"
}

server_scripts{ 
	"@vrp/lib/utils.lua",
	"s_trash.lua"
}
