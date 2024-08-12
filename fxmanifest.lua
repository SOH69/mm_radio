fx_version 'cerulean'
game "gta5"

author "Master Mind"
version '2.0.7'
description 'A beautiful Radio Resource for FiveM'
repository 'https://github.com/SOH69/mm_radio'

lua54 'yes'

ui_page 'build/index.html'
-- ui_page 'http://localhost:3000/' --for dev

shared_script {
    "@ox_lib/init.lua",
    "shared/**"
}

client_script {
    '@bl_bridge/imports/client.lua',
    'client/interface.lua',
    'client/function.lua',
    'client/event.lua',
    'client/nui.lua'
}

server_script {
    '@bl_bridge/imports/server.lua',
    "server/main.lua",
}

files {
    'build/**',
    'locales/*.json'
}

dependencies {
    'pma-voice',
    'ox_lib',
    '/onesync',
    'bl_bridge'
  }
