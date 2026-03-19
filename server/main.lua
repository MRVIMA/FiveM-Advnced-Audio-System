-- No need to import QBCore anymore; we use ox_inventory and ox_lib directly.

-- Register Usable Items using ox_inventory natively
for tier, itemName in pairs(Config.Items) do
    exports.ox_inventory:RegisterUsableItem(itemName, function(playerId, _, item)
        TriggerClientEvent("vima_audio:client:installAudio", playerId, tier, itemName)
    end)
end

RegisterNetEvent("vima_audio:server:finishInstall", function(tier, itemName, plate)
    local src = source
    
    -- Native ox_inventory item removal
    local removed = exports.ox_inventory:RemoveItem(src, itemName, 1)

    -- Only proceed with database updates if the item was successfully removed
    if removed then
        MySQL.Async.execute('INSERT INTO vehicle_audio_tiers (plate, tier) VALUES (?, ?) ON DUPLICATE KEY UPDATE tier = ?', 
        {plate, tier, tier})

        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Success',
            description = 'VØIDVIMA Audio System Installed!',
            type = 'success'
        })
        TriggerClientEvent("vima_audio:syncAudio", -1, plate, tier)
    else
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = 'Installation failed. Item missing from inventory.',
            type = 'error'
        })
    end
end)

-- Fetch Audio settings using ox_lib callbacks
lib.callback.register('vima_audio:server:getVehicleAudio', function(source, plate)
    -- Using Sync here is perfectly fine within an ox_lib callback thread
    local result = MySQL.Sync.fetchAll('SELECT tier FROM vehicle_audio_tiers WHERE plate = ?', {plate})
    
    if result and result[1] then
        return result[1].tier
    else
        return "basic" -- Default stock audio
    end
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