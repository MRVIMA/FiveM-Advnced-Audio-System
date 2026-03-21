-- Register Usable Items using qbx_core
for tier, itemName in pairs(Config.Items) do
    exports.qbx_core:CreateUseableItem(itemName, function(source, item)
        TriggerClientEvent("vima_audio:client:installAudio", source, tier, itemName)
    end)
end

RegisterNetEvent("vima_audio:server:finishInstall", function(tier, itemName, plate)
    local src = source
    local cleanPlate = string.gsub(plate, "%s+", ""):upper()
    
    local removed = exports.ox_inventory:RemoveItem(src, itemName, 1)

    if removed then
        MySQL.insert('INSERT INTO vehicle_audio_tiers (plate, tier) VALUES (?, ?) ON DUPLICATE KEY UPDATE tier = ?', 
        {cleanPlate, tier, tier}, function(id)
            print("^2[VØIDVIMA] Saved Tier: " .. tier .. " to Clean Plate: " .. cleanPlate .. "^7")
            
            TriggerClientEvent('ox_lib:notify', src, {
                title = 'Success',
                description = 'Audio System Installed!',
                type = 'success'
            })
            TriggerClientEvent("vima_audio:syncAudio", -1, cleanPlate, tier)
        end)
    end
end)

-- Fetch Audio settings
lib.callback.register('vima_audio:server:getVehicleAudio', function(source, plate)
    local tier = MySQL.scalar.await('SELECT tier FROM vehicle_audio_tiers WHERE plate = ?', {plate})
    return tier or "basic"
end)

RegisterNetEvent("vima_audio:server:playSystem", function(plate, url)
    local src = source
    local soundID = "vima_" .. plate
    
    -- Find the vehicle on the server
    local vehicle = 0
    for _, veh in ipairs(GetAllVehicles()) do
        local vPlate = GetVehicleNumberPlateText(veh)
        if vPlate and vPlate:gsub("%s+", ""):upper() == plate then
            vehicle = veh
            break
        end
    end

    if vehicle ~= 0 then
        -- Wait for the entity to be networked if it's new
        local timeout = 0
        while not NetworkGetEntityIsNetworked(vehicle) and timeout < 20 do
            Wait(10)
            timeout = timeout + 1
        end

        local netId = NetworkGetNetworkIdFromEntity(vehicle)
        
        -- Use PlayRemote with 'onEntity' set to true
        -- We set volume to 0.8 (louder) and distance to 50.0
        exports.xsound:PlayRemote(-1, soundID, url, 0.8, false, {
            onEntity = true,
            entityId = netId,
            distance = 50.0,
        })
        
        print("^2[VØIDVIMA] AUDIO STARTED: " .. url .. " on Plate: " .. plate .. "^7")
    else
        print("^1[VØIDVIMA ERROR] Could not find vehicle with plate: " .. plate .. "^7")
    end
end)

RegisterNetEvent("vima_audio:server:stopSystem", function(plate)
    exports.xsound:Destroy(-1, "vima_" .. plate)
end)