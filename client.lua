local display = false

--ESX
ESX = nil
Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
    end
)

--觸發 DailyReward
RegisterCommand("DailyReward", function(source)
    SetDisplay(not display)
end)

Citizen.CreateThread(function ()
    while true do
        Citizen.Wait(0)
        if IsControlJustReleased(1, Config.key) then
            SetDisplay(not display)
        end
    end
end)

-- NUICallBack 
RegisterNUICallback("exit", function(data)
    --chat("exited", {0,255,0})
    SetDisplay(false)
end)

RegisterNUICallback("error", function(data)
    chat(data.error.."請截圖回報給管理人員", {255,0,0})
    SetDisplay(false)
end)

RegisterNUICallback("sign", function(data)
    TriggerServerEvent("DailyReward:getReward",tonumber(data.day))
end)


Citizen.CreateThread(function()
    while display do
        Citizen.Wait(0)
        -- https://runtime.fivem.net/doc/natives/#_0xFE99B66D079CF6BC
        --[[ 
            inputGroup -- integer , 
	        control --integer , 
            disable -- boolean 
        ]]
        --key https://docs.fivem.net/docs/game-references/controls/#controls
        DisableControlAction(0, 1, display) -- LookLeftRight
        DisableControlAction(0, 2, display) -- LookUpDown
        DisableControlAction(0, 142, display) -- MeleeAttackAlternate
        DisableControlAction(0, 18, display) -- Enter
        DisableControlAction(0, 322, display) -- ESC
        DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
    end
end)


function SetDisplay(bool)
    if bool then
        ESX.TriggerServerCallback("DailyReward:openNUI",function(data)
            TriggerEvent("DailyReward:setNUI",data)
        end)
    end

    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool,
    })
end

RegisterNetEvent("DailyReward:setNUI")
AddEventHandler("DailyReward:setNUI",function(data)
    SendNUIMessage({
        type = "setup",
        items = Config.items,
        lastcollectday = data.lastcollectday,
        today = data.today,
        resign_ticket = data.resign_ticket,
    })
end)


function chat(str, color)
    TriggerEvent(
        'chat:addMessage',
        {
            color = color,
            multiline = true,
            args = {str}
        }
    )
end

