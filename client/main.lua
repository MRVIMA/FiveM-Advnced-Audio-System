local currentTier = "basic"
local currentPlate = nil
local audioEnabled = false
local batteryLevel = 100.0

local function GetTrimmedPlate(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    local plate = GetVehicleNumberPlateText(vehicle)
    return plate and string.gsub(plate, "%s+", ""):upper() or nil
end

-- Installation Logic
RegisterNetEvent("vima_audio:client:installAudio", function(tier, itemName)
    local ped = PlayerPedId()
    local vehicle = lib.getClosestVehicle(GetEntityCoords(ped), 3.0, false)
    
    if vehicle then
        local plate = GetTrimmedPlate(vehicle)
        SetVehicleDoorOpen(vehicle, 5, false, false)
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)

        if lib.progressBar({
            duration = 10000,
            label = "Installing " .. Config.Tiers[tier].name .. " Audio...",
            canCancel = true,
            disable = { car = true, move = true }
        }) then
            ClearPedTasks(ped)
            SetVehicleDoorShut(vehicle, 5, false)
            TriggerServerEvent("vima_audio:server:finishInstall", tier, itemName, plate)
        else
            ClearPedTasks(ped)
            SetVehicleDoorShut(vehicle, 5, false)
        end
    else
        lib.notify({ title = 'Error', description = 'No vehicle nearby.', type = 'error' })
    end
end)

-- UI Control (Unified Callback)
RegisterNUICallback("audioControl", function(data, cb)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 then
        local plate = GetTrimmedPlate(vehicle)
        if data.action == "playUrl" then
            audioEnabled = true
            TriggerServerEvent("vima_audio:server:playSystem", plate, data.url)
        elseif data.action == "stop" then
            audioEnabled = false
            TriggerServerEvent("vima_audio:server:stopSystem", plate)
        end
    end
    cb('ok')
end)

RegisterNUICallback("exit", function(data, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)

-- Main Loop
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        local vehicle = GetVehiclePedIsIn(ped, false)

        if vehicle ~= 0 then
            sleep = 0
            local plate = GetTrimmedPlate(vehicle)

            if plate and currentPlate ~= plate then
                currentPlate = plate
                currentTier = lib.callback.await('vima_audio:server:getVehicleAudio', false, plate)
                print("[VØIDVIMA] Vehicle Tier: " .. currentTier)
                TriggerEvent("vima_audio:applySettings", currentTier)
            end

            -- F2 Key (289)
            if IsControlJustPressed(0, 289) and GetPedInVehicleSeat(vehicle, -1) == ped then
                if currentTier ~= "basic" then
                    -- Ensure engine is on to power the high-end systems
                    if GetIsVehicleEngineRunning(vehicle) then
                        SetNuiFocus(true, true)
                        SendNUIMessage({ type = "ui", display = true, tier = Config.Tiers[currentTier].name })
                    else
                        lib.notify({ title = 'Power Error', description = 'Turn on the engine to power the audio system!', type = 'error' })
                    end
                else
                    lib.notify({ title = 'Stock System', description = 'Upgrade required.', type = 'error' })
                end
            end

            -- Effects
            if audioEnabled and IsVehicleEngineOn(vehicle) then
                local speed = GetEntitySpeed(vehicle)
                if speed > 5.0 and currentTier == "ultimate" then
                    TriggerEvent("vima_audio:playEffects", vehicle, speed)
                end
            end
        else
            currentPlate = nil
            currentTier = "basic"
        end
        Citizen.Wait(sleep)
    end
end)

RegisterNetEvent("vima_audio:syncAudio", function(plate, tier)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 and GetTrimmedPlate(vehicle) == plate then
        currentTier = tier
        exports[GetCurrentResourceName()]:ApplyVehicleProp(vehicle, tier)
    end
end)

-- Force Disable Default GTA Radio
Citizen.CreateThread(function()
    while true do
        local sleep = 1000
        local ped = PlayerPedId()
        
        if IsPedInAnyVehicle(ped, false) then
            sleep = 0
            local vehicle = GetVehiclePedIsIn(ped, false)
            
            -- This native stops the default radio from playing
            SetUserRadioControlEnabled(false)
            HideHudComponentThisFrame(16) -- 16 is the Radio Station HUD component
            
            -- This forces the radio station to "OFF"
            if GetPlayerRadioStationName() ~= nil then
                SetRadioToStationName("OFF")
            end
        else
            -- Re-enable it when they exit so they can hear radios in shops/world
            SetUserRadioControlEnabled(true)
        end
        
        Citizen.Wait(sleep)
    end
end)