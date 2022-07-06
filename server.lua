ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


ESX.RegisterServerCallback("DailyReward:openNUI", function(source,cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    local data = {}
    local month = tonumber(os.date("%m",os.time()))

    if xPlayer ~= nil then
        local identifier = xPlayer.getIdentifier()
		MySQL.Async.fetchAll('SELECT * FROM `customdb`.`dailyreward` WHERE `identifier`=@identifier;', {['@identifier'] = identifier}, function(collect)
            if collect[1] then 
                --讀取舊資料
                data = collect[1]
                if data.month ~= month then
                   --月份不符 更新資料
                    data.month = month
                    data.lastcollectday = 0
                    data.today = 0
		            MySQL.Async.execute('UPDATE `customdb`.`dailyreward` SET `id`=@id, `month`=@month, `lastcollectday`=0 WHERE `identifier`=@identifier', {["@identifier"] = identifier, ["@id"] = source,["month"] = month}, nil)    
                end
            else
                --新增資料
                data.month = month
                data.lastcollectday = 0
                data.today = 0
                data.resign_ticket = 0
		        MySQL.Async.execute('INSERT INTO `customdb`.`dailyreward` (`id`,`identifier`,`month`, `lastcollectday`, `today`, `resign_ticket`) VALUES (@id,@identifier,@month,0,0,0);', {['id'] = source,['@identifier'] = identifier,['month'] = month}, nil)
            end

            MySQL.Async.execute('UPDATE `customdb`.`dailyreward` SET `id`=@id WHERE `identifier`=@identifier', {["@identifier"] = identifier, ["@id"] = source}, nil)    
            cb(data)
        end)
    else
        print("DailyReward:open --XPlayer error")
    end
end)

RegisterNetEvent("DailyReward:getReward")
AddEventHandler("DailyReward:getReward",function(day)
    for i,value in ipairs(Config.items) do
        if value.day == day then
            local d = tonumber(os.date("%d",os.time()))
            local data = {}
            local _source = source
            local xPlayer = ESX.GetPlayerFromId(_source)
            local identifier = xPlayer.getIdentifier()
		    MySQL.Async.fetchAll('SELECT * FROM `customdb`.`dailyreward` WHERE `identifier`=@identifier;', {['@identifier'] = identifier}, function(collect)
                data = collect[1]
                if data.today == d then
                    if data.resign_ticket > 0 then
                        data.resign_ticket = data.resign_ticket - 1
                    else
                        goto error
                    end
                else
                    data.today = d
                end
                data.lastcollectday = data.lastcollectday + 1
                TriggerClientEvent("DailyReward:setNUI", _source, data)
                MySQL.Async.execute('UPDATE `customdb`.`dailyreward` SET `lastcollectday`=@lastcollectday, `today`=@today, `resign_ticket`=@resign_ticket WHERE `identifier`=@identifier', {["@identifier"] = identifier, ["@lastcollectday"] = data.lastcollectday,["@today"] = data.today,["@resign_ticket"] = data.resign_ticket}, nil)    
                giveItem(xPlayer,value)
                ::error::
            end)

        end
    end
end)


function giveItem(xPlayer,item)
    if not item or not xPlayer then return end
	if item.type=='cash' and item.value then
		xPlayer.addMoney(item.value)
	elseif item.type=='item' and item.name and item.value then
		xPlayer.addInventoryItem(item.name,item.value)
	elseif item.type=='weapon' and item.name and item.value then
		xPlayer.addWeapon(item.name, item.value)
	end
end