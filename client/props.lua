local activeProps = {}

local function GetTrimmedPlate(vehicle)
    if not vehicle or vehicle == 0 then return nil end
    local plate = GetVehicleNumberPlateText(vehicle)
    return plate and string.gsub(plate, "%s+", ""):upper() or nil
end

function ApplyVehicleProp(vehicle, tier)
    local plate = GetTrimmedPlate(vehicle)
    if not plate then return end

    -- Cleanup existing
    if activeProps[plate] then
        if DoesEntityExist(activeProps[plate].ent) then DeleteEntity(activeProps[plate].ent) end
        exports.ox_target:removeByEntity(vehicle, 'vima_trunk_menu')
    end

    local tierConfig = Config.Tiers[tier]
    if not tierConfig or not tierConfig.prop then return end

    -- Spawn Prop
    local model = GetHashKey(tierConfig.prop.model)
    lib.requestModel(model)
    local prop = CreateObject(model, GetEntityCoords(vehicle), false, false, false)
    
    local boneIndex = GetEntityBoneIndexByName(vehicle, tierConfig.prop.bone)
    if boneIndex == -1 then boneIndex = GetEntityBoneIndexByName(vehicle, "chassis") end

    AttachEntityToEntity(prop, vehicle, boneIndex, 
        tierConfig.prop.offset.x, tierConfig.prop.offset.y, tierConfig.prop.offset.z, 
        tierConfig.prop.rot.x, tierConfig.prop.rot.y, tierConfig.prop.rot.z, 
        false, false, false, false, 2, true)

    activeProps[plate] = { ent = prop }

    -- Add the Third-Eye Interaction to the Trunk
    exports.ox_target:addLocalEntity(vehicle, {
        {
            name = 'vima_trunk_menu',
            icon = 'fas fa-compact-disc',
            label = 'Access Audio Interface',
            bone = tierConfig.prop.bone, -- Targets the trunk specifically
            distance = 2.0,
            onSelect = function()
                -- Open the trunk and then the UI
                SetVehicleDoorOpen(vehicle, 5, false, false)
                TriggerEvent("vima_audio:client:openUI") -- We'll define this next
            end
        }
    })
end

exports('ApplyVehicleProp', ApplyVehicleProp)