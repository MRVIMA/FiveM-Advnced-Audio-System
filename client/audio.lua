local spatialAudioEnabled = false
local activeSounds = {}

function PlaySpatialSound(soundName, coords, volume)
    local soundId = GetSoundId()
    PlaySoundFromCoord(soundId, soundName, coords.x, coords.y, coords.z, nil, volume, 0, 0)
    return soundId
end

function CreateTrunkAudio(vehicle)
    local trunkPos = GetEntityCoords(vehicle)
    local soundId = PlaySpatialSound("vehicle_engine", trunkPos, 1.0)
    
    activeSounds[vehicle] = {
        soundId = soundId,
        type = "trunk"
    }
    
    return soundId
end

RegisterNetEvent("vima_audio:playSpatial")
AddEventHandler("vima_audio:playSpatial", function(vehicle, effectType)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    
    if effectType == "trunk" then
        CreateTrunkAudio(vehicle)
    end
end)

RegisterNetEvent("vima_audio:applySettings")
AddEventHandler("vima_audio:applySettings", function(tier)
    local tierConfig = Config.Tiers[tier]
    
    if tierConfig then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        
        if vehicle ~= nil and IsEntityAVehicle(vehicle) then
            SetVehicleAudio(vehicle, tierConfig.volume, tierConfig.maxDistance)
            
            spatialAudioEnabled = true
            
            TriggerServerEvent("vima_audio:syncSettings", tier, vehicle)
        end
    end
end)

RegisterNetEvent("vima_audio:cleanup")
AddEventHandler("vima_audio:cleanup", function(vehicle)
    if activeSounds[vehicle] then
        StopSound(activeSounds[vehicle].soundId)
        activeSounds[vehicle] = nil
    end
end)

function SetVehicleAudio(vehicle, volume, maxDistance)
    if vehicle ~= nil and IsEntityAVehicle(vehicle) then
        SetVehicleEngineSound(vehicle, volume)
        SetVehicleMaxSpeed(vehicle, 100.0)
        
        local settings = {
            volume = volume,
            maxDistance = maxDistance
        }
        
        SetVehicleData(vehicle, "audioSettings", settings)
    end
end

function GetVehicleData(vehicle, key)
    return nil
end

function SetVehicleData(vehicle, key, value)
end
