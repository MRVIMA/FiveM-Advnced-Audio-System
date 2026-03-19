local audioEnabled = false
local currentTier = "basic"
local batteryLevel = 100.0
local currentPlate = nil

-- Helper to safely get the plate string
local function GetTrimmedPlate(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate then
        return string.gsub(plate, "^%s*(.-)%s*$", "%1")
    end
    return nil
end

-- Installation Event using ox_lib progressbar
RegisterNetEvent("vima_audio:client:installAudio", function(tier, itemName)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local vehicle = lib.getClosestVehicle(coords, 3.0, false)
    
    if vehicle then
        local plate = GetTrimmedPlate(vehicle)
        
        SetVehicleDoorOpen(vehicle, 5, false, false) -- Open Trunk
        TaskStartScenarioInPlace(ped, "PROP_HUMAN_BUM_BIN", 0, true)

        if lib.progressBar({
            duration = 10000,
            label = "Installing " .. Config.Tiers[tier].name .. " Audio...",
            useWhileDead = false,
            canCancel = true,
            disable = {
                car = true,
                move = true,
                combat = true,
                mouse = false
            }
        }) then
            -- Success path
            ClearPedTasks(ped)
            SetVehicleDoorShut(vehicle, 5, false)
            TriggerServerEvent("vima_audio:server:finishInstall", tier, itemName, plate)
        else
            -- Cancel path
            ClearPedTasks(ped)
            SetVehicleDoorShut(vehicle, 5, false)
            lib.notify({
                title = 'Canceled',
                description = 'Audio installation was canceled.',
                type = 'error'
            })
        end
    else
        lib.notify({
            title = 'System Error',
            description = 'No vehicle close enough to modify.',
            type = 'error'
        })
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
    -- Give the server a second to boot up callbacks if the script is live-restarted
    Citizen.Wait(1000) 

    while true do
        Citizen.Wait(0)
        local ped = PlayerPedId()

        -- Check vehicle entry to load tier from database via ox_lib callback
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local plate = GetTrimmedPlate(vehicle)

            if plate and currentPlate ~= plate then
                currentPlate = plate
                
                -- Wrapped in a pcall (protected call) to prevent the script from hard-crashing 
                -- if the server takes too long to register the callback.
                local success, fetchedTier = pcall(function()
                    return lib.callback.await('vima_audio:server:getVehicleAudio', 1000, plate)
                end)

                if success and fetchedTier then
                    currentTier = fetchedTier
                else
                    currentTier = "basic" -- Fallback if the server callback fails
                end
                
                TriggerEvent("vima_audio:applySettings", currentTier)
            end

            -- F2 to open menu
            if IsControlJustPressed(0, 177) then 
                if GetPedInVehicleSeat(vehicle, -1) == ped then
                    if currentTier ~= "basic" then
                        SendNUIMessage({
                            type = "ui",
                            display = true,
                            tier = Config.Tiers[currentTier].name
                        })
                        SetNuiFocus(true, true)
                    else
                        lib.notify({
                            title = 'Stock System',
                            description = 'This vehicle does not have an aftermarket audio interface installed.',
                            type = 'error'
                        })
                    end
                end
            end
            
            -- Battery and Effects Logic
            if audioEnabled and IsVehicleEngineOn(vehicle) then
                if math.random(100) < 5 then
                    batteryLevel = math.max(0, batteryLevel - Config.Tiers[currentTier].batteryDrain)
                    SendNUIMessage({ action = "batteryUpdate", battery = batteryLevel })
                end
                
                local speed = GetEntitySpeed(vehicle)
                if speed > 10.0 and currentTier == "ultimate" then
                    TriggerEvent("vima_audio:playEffects", vehicle, speed)
                end
            end
        else
            -- Left vehicle reset
            if currentPlate ~= nil then
                currentPlate = nil
                audioEnabled = false
            end
        end
    end
end)

RegisterNetEvent("vima_audio:syncAudio", function(plate, tier)
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= 0 and GetTrimmedPlate(vehicle) == plate then
        currentTier = tier
        TriggerEvent("vima_audio:applySettings", tier)
    end
end)