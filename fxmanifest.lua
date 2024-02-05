fx_version 'cerulean'
game "gta5"

author "Master Mind"
version '1.8.2'

lua54 'yes'

ui_page 'html/index.html'
-- ui_page 'http://localhost:3000/' --for dev

shared_script {
  "@ox_lib/init.lua",
  "shared/**"
}

client_script {
  'client/interface.lua',
  'client/function.lua',
  'client/bridge/*.lua',
  'client/event.lua',
  'client/nui.lua'
}

server_script {
  "server/**",
}

files {
  'html/**',
  'locales/*.json'
}

dependencies {
  'pma-voice',
  'ox_lib'
}
