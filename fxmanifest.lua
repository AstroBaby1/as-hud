fx_version 'adamant'

game 'gta5'

author 'Astro'
version '1.0'

ui_page 'web/ui.html'

client_script 'client.lua'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua'
}



files {
	'web/*.*'
}
lua54 'yes'
use_experimental_fxv2_oal 'yes'
