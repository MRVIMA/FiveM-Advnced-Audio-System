Config = Config or {}

-- Set to true if using QBCore
Config.UseQBCore = false

Config.Shop = {
    enabled = true,
    pedModel = `mp_m_securoguard_01`, 
    
    -- Main Los Santos Customs (Burton)
    coords = vec4(-346.3, -133.3, 39.0, 71.0), 
    
    items = {
        { id = 'audio_standard', price = 2500, label = 'Standard Audio System', icon = 'volume-low' },
        { id = 'audio_premium', price = 5000, label = 'Premium Audio System', icon = 'volume-high' },
        { id = 'audio_ultimate', price = 10000, label = 'VoidVima Ultimate Setup', icon = 'bolt' }
    }
}

-- Jim-Mechanic Integration Items
Config.Items = {
    ["standard"] = "audio_standard",
    ["premium"]  = "audio_premium",
    ["ultimate"] = "audio_ultimate"
}

Config.Tiers = {
    ["basic"] = {
        name = "Basic (Stock)",
        price = 0,
        batteryDrain = 0.05,
        maxDistance = 20.0,
        minDistance = 1.0,
        volume = 0.8
        -- No prop for stock
    },
    ["standard"] = {
        name = "Standard",
        price = 2500,
        batteryDrain = 0.2,
        maxDistance = 75.0,
        minDistance = 1.5,
        volume = 1.2,
        prop = {
            model = "prop_amplifier_01",
            bone = "boot", -- Attaches to the trunk
            offset = vec3(0.0, 0.2, 0.0), -- Adjust these to center it
            rot = vec3(0.0, 0.0, 0.0)
        }
    },
    ["premium"] = {
        name = "Premium",
        price = 5000,
        batteryDrain = 0.3,
        maxDistance = 100.0,
        minDistance = 2.0,
        volume = 1.5,
        prop = {
            model = "prop_speaker_06",
            bone = "boot",
            offset = vec3(0.0, 0.1, 0.0),
            rot = vec3(0.0, 0.0, 90.0)
        }
    },
    ["ultimate"] = {
        name = "Ultimate",
        price = 10000,
        batteryDrain = 0.4,
        maxDistance = 150.0,
        minDistance = 3.0,
        volume = 2.0,
        prop = {
            model = "prop_speaker_07", -- Massive speaker setup
            bone = "boot",
            offset = vec3(0.0, 0.0, 0.0),
            rot = vec3(0.0, 0.0, 180.0)
        }
    }
}

Config.Battery = {
    drainRate = 0.01,
    rechargeRate = 0.02,
    maxBattery = 100.0
}

Config.Effects = {
    screenShake = { intensity = 0.5, duration = 500 },
    plateRattle = { intensity = 0.3, frequency = 2000 }
}