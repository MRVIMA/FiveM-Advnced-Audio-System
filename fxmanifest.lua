fx_version 'cerulean'
game 'gta5'

author 'VØIDVIMA'
description 'Advanced Audio System - QBX Edition'
version '3.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/audio.lua',
    'client/effects.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/battery.lua'
}

files {
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

ui_page 'html/index.html'

escrow_ignore {
    'config.lua',
    'audio_tiers.sql'
}