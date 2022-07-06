fx_version 'cerulean'

games {"gta5"}

client_scripts {
    "client.lua",
    "config.lua",
}

server_scripts {
    "server.lua",
    "config.lua",
    "@mysql-async/lib/MySQL.lua",
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