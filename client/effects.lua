local effectsActive = false

function PlayScreenShake(intensity, duration)
    local cam = GetRenderingCam()
    
    if cam ~= nil then
        ShakeGameplayCam("DEFAULT_SCRIPTED_SHAKE", intensity)
        
        Citizen.CreateThread(function()
            Wait(duration)
            StopGameplayCamShaking(true)
        end)
    end
end

function PlayPlateRattle(intensity, frequency)
    
    Citizen.CreateThread(function()
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        
        if vehicle ~= nil and IsEntityAVehicle(vehicle) then
            while effectsActive do
                local pos = GetEntityCoords(vehicle)
                
                local offset = vector3(
                    math.random(-0.1, 0.1),
                    math.random(-0.1, 0.1),
                    math.random(-0.05, 0.05)
                )
                
                SetEntityCoords(vehicle, pos + offset)
                Wait(50)
            end
            
            SetEntityCoords(vehicle, pos)
        end
    end)
end

RegisterNetEvent("vima_audio:playEffects")
AddEventHandler("vima_audio:playEffects", function(vehicle, speed)
    if not effectsActive then return end
    
    local ped = PlayerPedId()
    
    if speed > 20.0 then
        PlayScreenShake(Config.Effects.screenShake.intensity, Config.Effects.screenShake.duration)
    end
    
    if speed > 15.0 then
        PlayPlateRattle(Config.Effects.plateRattle.intensity, Config.Effects.plateRattle.frequency)
    end
end)

RegisterNetEvent("vima_audio:toggleEffects")
AddEventHandler("vima_audio:toggleEffects", function(enabled)
    effectsActive = enabled
    
    if not enabled then
        StopGameplayCamShaking(true)
        
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        if vehicle ~= nil then
            SetEntityCoords(vehicle, GetEntityCoords(vehicle))
        end
    end
end)

RegisterNetEvent("vima_audio:vehicleExit")
AddEventHandler("vima_audio:vehicleExit", function()
    effectsActive = false
    StopGameplayCamShaking(true)
    
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil then
        SetEntityCoords(vehicle, GetEntityCoords(vehicle))
    end
end)
