fx_version 'cerulean'

games {"gta5"}

client_scripts {
    "config.lua",
    "client.lua",
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "config.lua",
    "server.lua",
}

ui_page "html/index.html"

files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css',
    'html/asset/img/*.png'
}


--index.js 裡 keyCode 可調整設定的按鍵