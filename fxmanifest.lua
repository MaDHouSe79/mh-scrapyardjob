--[[ ===================================================== ]]--
--[[          MH Scrapyard Job Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

fx_version 'cerulean'
games { 'gta5' }

author 'MaDHouSe'
description 'MH Scrapyardjob - Use or steel npc vehicle and scrap it for parts or materials. Gang can tap frame numbers.'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'locales/nl.lua', -- change nl to your language
    'config.lua',
}

client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/main.lua',
    'client/truck.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua',
    'server/update.lua',
}

dependencies {
    'oxmysql',
    'qb-core',
    'PolyZone',
    'mh-modelnames',
}

lua54 'yes'
