-- No need to import QBCore anymore; we use ox_inventory and ox_lib directly.

-- Register Usable Items using qbx_core
for tier, itemName in pairs(Config.Items) do
    exports.qbx_core:CreateUseableItem(itemName, function(source, item)
        -- In qbx_core, the callback passes 'source' and the 'item' data table
        TriggerClientEvent("vima_audio:client:installAudio", source, tier, itemName)
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

-- Fetch Audio settings using modern oxmysql scalar await
lib.callback.register('vima_audio:server:getVehicleAudio', function(source, plate)
    -- scalar.await fetches a single column value from the first row it finds
    local tier = MySQL.scalar.await('SELECT tier FROM vehicle_audio_tiers WHERE plate = ?', {plate})
    
    if tier then
        return tier
    else
        return "basic" -- Default stock audio if nothing is in the database
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