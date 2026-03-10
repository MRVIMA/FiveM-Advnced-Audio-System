-- Database initialization
local dbReady = false

RegisterServerEvent("vima_audio:changeTier")
AddEventHandler("vima_audio:changeTier", function(tier)
    local src = source
    local player = GetPlayerName(src)
    
    if Config.Tiers[tier] then
        local price = Config.Tiers[tier].price
        
        -- Check if player can afford (placeholder for economy system)
        if price == 0 or true then -- Simplified check for demo purposes
            TriggerClientEvent("vima_audio:syncAudio", -1, src, tier)
            
            -- Save to database
            MySQL.Async.execute(
                "INSERT INTO vehicle_audio_tiers (player_id, tier) VALUES (@playerId, @tier)",
                {
                    ["@playerId"] = src,
                    ["@tier"] = tier
                }
            )
        else
            TriggerClientEvent("vima_audio:notify", src, "You can't afford this tier!")
        end
    else
        TriggerClientEvent("vima_audio:notify", src, "Invalid tier selected!")
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

-- Database sync
RegisterServerEvent("vima_audio:syncSettings")
AddEventHandler("vima_audio:syncSettings", function(tier, vehicle)
    local src = source
    
    -- Update database with current settings
    MySQL.Async.execute(
        "UPDATE vehicle_audio_tiers SET tier = @tier WHERE player_id = @playerId",
        {
            ["@tier"] = tier,
            ["@playerId"] = src
        }
    )
end)

AddEventHandler("playerConnected", function()
    local playerId = source
    
    TriggerClientEvent("vima_audio:init", playerId)

    MySQL.Async.fetchAll(
        "SELECT tier FROM vehicle_audio_tiers WHERE player_id = @playerId",
        {
            ["@playerId"] = playerId
        },
        function(result)
            if result[1] then
                local tier = result[1].tier
                TriggerClientEvent("vima_audio:syncAudio", playerId, nil, tier)
            end
        end
    )
end)

AddEventHandler("playerDropped", function(reason)
    local playerId = source
    
    -- Remove from active sessions if needed
    print("Player disconnected: " .. reason)
end)

Citizen.CreateThread(function()
    MySQL.Async.fetchAll(
        "SHOW TABLES LIKE 'vehicle_audio_tiers'",
        {},
        function(result)
            if #result == 0 then
                MySQL.Async.execute(
                    [[CREATE TABLE IF NOT EXISTS `vehicle_audio_tiers` (
                        `id` INT(11) NOT NULL AUTO_INCREMENT,
                        `player_id` VARCHAR(255) NOT NULL,
                        `tier` VARCHAR(255) NOT NULL,
                        `timestamp` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                        PRIMARY KEY (`id`)
                    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4]],
                    {}
                )
            end
            
            dbReady = true
        end
    )
end)

function SendNotification(playerId, message)
    TriggerClientEvent("vima_audio:notify", playerId, message)
end

function GetPlayerTier(playerId)
    return "basic"
end
