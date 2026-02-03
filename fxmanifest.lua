fx_version 'cerulean'

game 'gta5'

lua54 'yes'

name 'ultimate_admin_menu'
author 'OpenAI Codex'
version '1.0.0'

ui_page 'web/index.html'

shared_scripts {
  'config.lua'
}

client_scripts {
  'client.lua'
}

server_scripts {
  'server.lua'
}

files {
  'web/index.html',
  'web/src/main.js',
  'web/src/App.svelte'
}
