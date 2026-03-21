-- Secure server-side callback to handle the purchase
lib.callback.register('vima_audio:server:purchaseItem', function(source, itemData)
    -- Get the QBX player object
    local Player = exports.qbx_core:GetPlayer(source)
    if not Player then return false end

    local price = itemData.price
    local itemName = itemData.id

    -- 1. Try to take from Cash first
    if Player.Functions.RemoveMoney('cash', price, "vima-audio-shop") then
        exports.ox_inventory:AddItem(source, itemName, 1)
        return true
        
    -- 2. If not enough cash, try taking from the Bank
    elseif Player.Functions.RemoveMoney('bank', price, "vima-audio-shop") then
        exports.ox_inventory:AddItem(source, itemName, 1)
        return true
        
    -- 3. Not enough money anywhere
    else
        return false
    end
end)