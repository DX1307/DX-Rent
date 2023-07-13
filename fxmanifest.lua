fx_version 'cerulean'
games { 'gta5' }
lua54 'yes'
author 'DX-HIGH'
description 'easy car rental system nothing complicated'

shared_scripts{
    'shared/*.lua',
    '@ox_lib/init.lua',
}

server_scripts{
'server/*.lua'
}

client_scripts{
'client/*.lua'
}

--# จำเป็น qtarget
-- https://github.com/overextended/qtarget.git


--# จำเป็น ox_lib
-- https://github.com/overextended/ox_lib/releases/tag/v3.6.2