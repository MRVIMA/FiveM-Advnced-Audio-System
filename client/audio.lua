local spatialAudioEnabled = false
local activeSounds = {}
local vehicleAudioSettings = {}

-- Helper to safely get the plate string
local function GetTrimmedPlate(vehicle)
    local plate = GetVehicleNumberPlateText(vehicle)
    if plate then
        return string.gsub(plate, "^%s*(.-)%s*$", "%1")
    end
    return nil
end

-- Fixed Native: PlaySoundFromCoord signature
function PlaySpatialSound(soundName, soundDict, coords)
    local soundId = GetSoundId()
    -- Proper FiveM Native usage for 3D spatial sounds
    PlaySoundFromCoord(soundId, soundName, coords.x, coords.y, coords.z, soundDict, false, 0, false)
    return soundId
end

function CreateTrunkAudio(vehicle)
    local soundId = GetSoundId()
    -- Attaches the sound specifically to the vehicle entity
    PlaySoundFromEntity(soundId, "Car_Alarm", vehicle, "Alarm_Horn_Soundset", false, 0)
    
    activeSounds[vehicle] = {
        soundId = soundId,
        type = "trunk"
    }
    
    return soundId
end

-- Event to trigger specific built-in audio effects
RegisterNetEvent("vima_audio:playSpatial")
AddEventHandler("vima_audio:playSpatial", function(vehicle, effectType)
    if effectType == "trunk" then
        CreateTrunkAudio(vehicle)
    end
end)

-- This is where the crash was happening. It is now fixed.
RegisterNetEvent("vima_audio:applySettings")
AddEventHandler("vima_audio:applySettings", function(tier)
    local tierConfig = Config.Tiers[tier]
    
    if tierConfig then
        local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
        
        if vehicle ~= 0 and IsEntityAVehicle(vehicle) then
            local plate = GetTrimmedPlate(vehicle)
            
            -- Store the settings locally so the script knows the max volume/distance
            if plate then
                vehicleAudioSettings[plate] = {
                    volume = tierConfig.volume,
                    maxDistance = tierConfig.maxDistance
                }
            end
            
            spatialAudioEnabled = true
            
            -- Send the new volume limits to the NUI (HTML/JS)
            SendNUIMessage({
                action = "updateLimits",
                maxVolume = tierConfig.volume
            })
        end
    end
end)

RegisterNetEvent("vima_audio:cleanup")
AddEventHandler("vima_audio:cleanup", function(vehicle)
    if activeSounds[vehicle] then
        -- Properly stop and release the sound ID to prevent memory leaks
        StopSound(activeSounds[vehicle].soundId)
        ReleaseSoundId(activeSounds[vehicle].soundId)
        activeSounds[vehicle] = nil
    end
end)

-- Safe getters for the rest of the script to use
function GetVehicleAudioSettings(vehicle)
    if vehicle ~= 0 then
        local plate = GetTrimmedPlate(vehicle)
        if plate and vehicleAudioSettings[plate] then
            return vehicleAudioSettings[plate]
        end
    end
    return nil
end