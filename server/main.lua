local QBCore = exports['qb-core']:GetCoreObject()

-- Create Usable Items for Mechanics
for tier, itemName in pairs(Config.Items) do
    QBCore.Functions.CreateUseableItem(itemName, function(source, item)
        local src = source
        local Player = QBCore.Functions.GetPlayer(src)
        
         if Player.PlayerData.job.name ~= "mechanic" then
            TriggerClientEvent('QBCore:Notify', src, "Only mechanics can install this!", "error")
           return
         end

        TriggerClientEvent("vima_audio:client:installAudio", src, tier, itemName)
    end)
end

RegisterNetEvent("vima_audio:server:finishInstall", function(tier, itemName, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player.Functions.RemoveItem(itemName, 1) then
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[itemName], "remove")
        
        MySQL.Async.execute('INSERT INTO vehicle_audio_tiers (plate, tier) VALUES (?, ?) ON DUPLICATE KEY UPDATE tier = ?', 
        {plate, tier, tier})

        TriggerClientEvent('QBCore:Notify', src, "Audio System Installed!", "success")
        TriggerClientEvent("vima_audio:syncAudio", -1, plate, tier)
    end
end)

-- Fetch Audio settings when player enters a car
QBCore.Functions.CreateCallback('vima_audio:server:getVehicleAudio', function(source, cb, plate)
    MySQL.Async.fetchAll('SELECT tier FROM vehicle_audio_tiers WHERE plate = ?', {plate}, function(result)
        if result[1] then
            cb(result[1].tier)
        else
            cb("basic") -- Default stock audio
        end
    end)
end)

RegisterServerEvent("vima_audio:startAudio")
AddEventHandler("vima_audio:startAudio", function()
    local src = source
    TriggerClientEvent("vima_audio:start", src)
end)

RegisterServerEvent("vima_audio:stopAudio")
AddEventHandler("vima_audio:stopAudio", function()
    local src = source
    TriggerClientEvent("vima_audio:stop", src)
end)