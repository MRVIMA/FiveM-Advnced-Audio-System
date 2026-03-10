fx_version 'cerulean'
game 'gta5'

author 'MR.Vima'
description 'Advanced Audio System for Vehicles'
version '2.1.8'

client_script 'client/main.lua'
client_script 'client/audio.lua'
client_script 'client/effects.lua'
server_script 'server/main.lua'
server_script 'server/battery.lua'
shared_script 'config.lua'

files {
    'html/index.html',
    'html/script.js'
}

ui_page 'html/index.html'

escrow_ignore {
    'config.lua',
    'audio_tiers.sql'
}
