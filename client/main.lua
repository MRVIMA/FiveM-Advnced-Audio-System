local audioEnabled = false
local currentTier = "basic"
local batteryLevel = 100.0
local vehicleAudio = nil

RegisterNUICallback("audioControl", function(data, cb)
    if data.action == "start" then
        TriggerServerEvent("vima_audio:startAudio")
        audioEnabled = true
    elseif data.action == "stop" then
        TriggerServerEvent("vima_audio:stopAudio")
        audioEnabled = false
    elseif data.action == "changeTier" then
        currentTier = data.tier
        TriggerServerEvent("vima_audio:changeTier", data.tier)
    end
    cb({status = "ok"})
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        if IsControlJustPressed(0, 177) then -- F2 key
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
                if vehicle ~= nil and GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
                    SendNUIMessage({
                        action = "open",
                        tier = currentTier,
                        battery = batteryLevel
                    })
                    SetNuiFocus(true, true)
                end
            end
        end
        
        if audioEnabled and IsPedInAnyVehicle(PlayerPedId(), false) then
            if math.random(100) < 5 then
                batteryLevel = math.max(0, batteryLevel - Config.Battery.drainRate)
                SendNUIMessage({
                    action = "batteryUpdate",
                    battery = batteryLevel
                })
            end
            
            local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
            if vehicle ~= nil then
                if not IsEntityPlayingAnim(vehicle, "anim@mp_player_intincar@base", "idle_a", 3) then
                    if IsVehicleEngineOn(vehicle) then
                        local pos = GetEntityCoords(vehicle)
                        local speed = GetEntitySpeed(vehicle)
                        
                        if speed > 10.0 then
                            TriggerEvent("vima_audio:playEffects", vehicle, speed)
                        end
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("vima_audio:syncAudio")
AddEventHandler("vima_audio:syncAudio", function(vehicle, tier)
    if IsPedInAnyVehicle(PlayerPedId(), false) then
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)
        
        if vehicle == vehicle then
            currentTier = tier
            audioEnabled = true
            
            TriggerEvent("vima_audio:applySettings", tier)
        end
    end
end)

RegisterNetEvent("vima_audio:init")
AddEventHandler("vima_audio:init", function()
    SendNUIMessage({
        action = "init",
        battery = batteryLevel,
        tier = currentTier
    })
end)
