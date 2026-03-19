local vehicleBatteries = {}

RegisterServerEvent("vima_audio:drainBattery")
AddEventHandler("vima_audio:drainBattery", function(plate)
    if vehicleBatteries[plate] then
        vehicleBatteries[plate].battery = math.max(0, vehicleBatteries[plate].battery - Config.Battery.drainRate)
        TriggerClientEvent("vima_audio:syncBattery", -1, plate, vehicleBatteries[plate].battery)
    end
end)

RegisterServerEvent("vima_audio:syncBattery")
AddEventHandler("vima_audio:syncBattery", function(plate, batteryLevel)
    if not vehicleBatteries[plate] then
        vehicleBatteries[plate] = { battery = batteryLevel, lastUpdate = GetGameTimer() }
    else
        vehicleBatteries[plate].battery = batteryLevel
        vehicleBatteries[plate].lastUpdate = GetGameTimer()
    end
    TriggerClientEvent("vima_audio:syncBattery", -1, plate, batteryLevel)
end)

-- Background thread to recharge batteries slowly
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(10000) 
        for plate, data in pairs(vehicleBatteries) do
            if GetGameTimer() - data.lastUpdate > 15000 then
                if data.battery < Config.Battery.maxBattery then
                    data.battery = math.min(Config.Battery.maxBattery, data.battery + Config.Battery.rechargeRate)
                end
            end
        end
    end
end)