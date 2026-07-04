fx_version 'cerulean'
game 'gta5'
lua54 'yes'

description 'Bank Robbery'
version '1.2.1'
author 'https://sidequest.host'

client_scripts {
    'client/client.lua',
}

server_scripts {
    'server/server.lua'
}

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua',    
    'locales/en.lua',  
}

dependencies {
	'ox_lib',
    'glitch-minigames'
}