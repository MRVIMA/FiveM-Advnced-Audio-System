fx_version 'cerulean'
game 'gta5'

author 'Void Vima'
description 'Advanced Audio System - Jim Mechanic Edition'
version '2.2.0'

shared_scripts {
    '@qb-core/import.lua',
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
    'html/script.js'
}

ui_page 'html/index.html'

escrow_ignore {
    'config.lua',
    'audio_tiers.sql'
}