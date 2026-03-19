local QBCore = exports['qb-core']:GetCoreObject()
local audioEnabled = false
local currentTier = "basic"
local batteryLevel = 100.0
local currentPlate = nil

-- Installation Event for Jim-Mechanic Vibe
RegisterNetEvent("vima_audio:client:installAudio", function(tier, itemName)
    local ped = PlayerPedId()
    local vehicle = QBCore.Functions.GetClosestVehicle()
    
    if vehicle ~= 0 and vehicle ~= nil then
        local pos = GetEntityCoords(ped)
        local vehPos = GetEntityCoords(vehicle)
        if #(pos - vehPos) < 3.0 then
            local plate = QBCore.Functions.GetPlate(vehicle)
            
            SetVehicleDoorOpen(vehicle, 5, false, false) -- Open Trunk
            TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)

            QBCore.Functions.Progressbar("install_audio", "Installing " .. Config.Tiers[tier].name .. " Audio...", 10000, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function() -- Done
                ClearPedTasks(ped)
                SetVehicleDoorShut(vehicle, 5, false)
                TriggerServerEvent("vima_audio:server:finishInstall", tier, itemName, plate)
            end, function() -- Cancel
                ClearPedTasks(ped)
                SetVehicleDoorShut(vehicle, 5, false)
                QBCore.Functions.Notify("Installation Canceled", "error")
            end)
        else
            QBCore.Functions.Notify("You are not close enough to a vehicle.", "error")
        end
    else
        QBCore.Functions.Notify("No vehicle nearby.", "error")
    end
end)

RegisterNUICallback("audioControl", function(data, cb)
    if data.action == "start" then
        TriggerServerEvent("vima_audio:startAudio")
        audioEnabled = true
    elseif data.action == "stop" then
        TriggerServerEvent("vima_audio:stopAudio")
        audioEnabled = false
    end
    -- Removed the changeTier NUI callback since mechanics do it now
    cb({status = "ok"})
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
    SendNUIMessage({
        type = "ui",
        display = false
    })
    cb("ok")
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()

        -- Check vehicle entry to load tier from database
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = QBCore.Functions.GetPlate(vehicle)

            if currentPlate ~= plate then
                currentPlate = plate
                QBCore.Functions.TriggerCallback('vima_audio:server:getVehicleAudio', function(tier)
                    currentTier = tier
                    TriggerEvent("vima_audio:applySettings", tier)
                end, plate)
            end

            -- F2 to open menu (Only if they have an upgraded tier)
            if IsControlJustPressed(0, 177) and currentTier ~= "basic" then 
                if GetPedInVehicleSeat(vehicle, -1) == ped then
                    SendNUIMessage({
                        type = "ui",
                        display = true,
                        tier = Config.Tiers[currentTier].name
                    })
                    SetNuiFocus(true, true)
                end
            elseif IsControlJustPressed(0, 177) and currentTier == "basic" then
                QBCore.Functions.Notify("This vehicle doesn't have an aftermarket audio system installed.", "error")
            end
            
            -- Battery and Effects Logic
            if audioEnabled and IsVehicleEngineOn(vehicle) then
                if math.random(100) < 5 then
                    batteryLevel = math.max(0, batteryLevel - Config.Tiers[currentTier].batteryDrain)
                    SendNUIMessage({ action = "batteryUpdate", battery = batteryLevel })
                end
                
                local speed = GetEntitySpeed(vehicle)
                if speed > 10.0 and currentTier == "ultimate" then -- Example of restricting effects to high tiers
                    TriggerEvent("vima_audio:playEffects", vehicle, speed)
                end
            end
        else
            -- Left vehicle
            if currentPlate ~= nil then
                currentPlate = nil
                audioEnabled = false
            end
        end
    end
end)

RegisterNetEvent("vima_audio:syncAudio", function(plate, tier)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 and QBCore.Functions.GetPlate(vehicle) == plate then
        currentTier = tier
        TriggerEvent("vima_audio:applySettings", tier)
    end
end)

