local playerBatteries = {}

RegisterServerEvent("vima_audio:drainBattery")
AddEventHandler("vima_audio:drainBattery", function(vehicle)
    local src = source
    
    if playerBatteries[src] then
        playerBatteries[src].battery = math.max(0, playerBatteries[src].battery - Config.Battery.drainRate)
        
        TriggerClientEvent("vima_audio:syncBattery", src, playerBatteries[src].battery)
    end
end)

RegisterServerEvent("vima_audio:rechargeBattery")
AddEventHandler("vima_audio:rechargeBattery", function(vehicle)
    local src = source
    
    if playerBatteries[src] then
        playerBatteries[src].battery = math.min(Config.Battery.maxBattery, 
            playerBatteries[src].battery + Config.Battery.rechargeRate)
        
        TriggerClientEvent("vima_audio:syncBattery", src, playerBatteries[src].battery)
    end
end)

RegisterServerEvent("vima_audio:syncBattery")
AddEventHandler("vima_audio:syncBattery", function(batteryLevel)
    local src = source
    
    if not playerBatteries[src] then
        playerBatteries[src] = {
            battery = batteryLevel,
            lastUpdate = GetGameTimer()
        }
    else
        playerBatteries[src].battery = batteryLevel
        playerBatteries[src].lastUpdate = GetGameTimer()
    end
    
    TriggerClientEvent("vima_audio:syncBattery", src, batteryLevel)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5000) -- Check every 5 seconds
        
        for playerId, data in pairs(playerBatteries) do
            if GetGameTimer() - data.lastUpdate > 10000 then
                if data.battery < Config.Battery.maxBattery then
                    data.battery = math.min(Config.Battery.maxBattery, 
                        data.battery + Config.Battery.rechargeRate * 2)
                    
                    TriggerClientEvent("vima_audio:syncBattery", playerId, data.battery)
                end
            end
        end
    end
end)

RegisterServerEvent("vima_audio:checkBattery")
AddEventHandler("vima_audio:checkBattery", function(vehicle)
    local src = source
    
    if playerBatteries[src] and playerBatteries[src].battery <= 0 then
        TriggerClientEvent("vima_audio:notify", src, "Vehicle battery is dead!")
        return false
    else
        return true
    end
end)

RegisterServerEvent("vima_audio:monitorBattery")
AddEventHandler("vima_audio:monitorBattery", function(vehicle)
    local src = source
    
    if playerBatteries[src] and playerBatteries[src].battery < 20 then
        TriggerClientEvent("vima_audio:notify", src, "Low battery warning!")
    end
end)
