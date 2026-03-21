local shopPed = 0

Citizen.CreateThread(function()
    if not Config.Shop.enabled then return end

    -- Load the NPC model
    lib.requestModel(Config.Shop.pedModel)

    -- Spawn the NPC at the coords defined in config
    shopPed = CreatePed(0, Config.Shop.pedModel, Config.Shop.coords.x, Config.Shop.coords.y, Config.Shop.coords.z - 1.0, Config.Shop.coords.w, false, false)
    FreezeEntityPosition(shopPed, true)
    SetEntityInvincible(shopPed, true)
    SetBlockingOfNonTemporaryEvents(shopPed, true)

    -- Add the ox_target interaction
    exports.ox_target:addLocalEntity(shopPed, {
        {
            name = 'vima_audio_shop',
            icon = 'fas fa-music',
            label = 'Browse Audio Systems',
            distance = 2.0,
            onSelect = function()
                OpenAudioShop()
            end
        }
    })
end)

-- Function to build and open the ox_lib context menu
function OpenAudioShop()
    local options = {}

    for i, item in ipairs(Config.Shop.items) do
        table.insert(options, {
            title = item.label,
            description = 'Purchase for $' .. item.price,
            icon = item.icon,
            onSelect = function()
                -- Ping the server to process the payment
                local success = lib.callback.await('vima_audio:server:purchaseItem', false, item)
                
                if success then
                    lib.notify({
                        title = 'Purchase Successful', 
                        description = 'You bought the ' .. item.label .. '.', 
                        type = 'success'
                    })
                else
                    lib.notify({
                        title = 'Transaction Declined', 
                        description = 'You do not have enough money.', 
                        type = 'error'
                    })
                end
            end
        })
    end

    -- Register and show the menu
    lib.registerContext({
        id = 'vima_audio_shop_menu',
        title = 'VØIDVIMA Audio Sales',
        options = options
    })

    lib.showContext('vima_audio_shop_menu')
end

-- Cleanup the ped if the script is restarted
AddEventHandler('onResourceStop', function(resourceName)
    if resourceName == GetCurrentResourceName() then
        if DoesEntityExist(shopPed) then
            DeleteEntity(shopPed)
        end
    end
end)