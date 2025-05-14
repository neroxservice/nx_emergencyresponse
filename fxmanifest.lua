fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'

description 'Emergency Response Script - QBCore'
author 'NeroX Service (Owner: xrealchronosskt) (Invite: https://discord.gg/9aVsQtR8ew)'
version 'v1.4.1'

shared_script {
    'config/config.lua',
}
server_script {
    'server/server.lua',
}
client_script {
    'client/client.lua',
}

escrow_ignore {
    '**/*.*'
}
