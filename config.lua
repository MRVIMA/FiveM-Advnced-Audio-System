-- Audio Tier Configuration
Config = {
    Tiers = {
        ["basic"] = {
            name = "Basic",
            price = 0,
            batteryDrain = 0.1,
            maxDistance = 50.0,
            minDistance = 1.0,
            volume = 1.0
        },
        ["standard"] = {
            name = "Standard",
            price = 2500,
            batteryDrain = 0.2,
            maxDistance = 75.0,
            minDistance = 1.5,
            volume = 1.2
        },
        ["premium"] = {
            name = "Premium",
            price = 5000,
            batteryDrain = 0.3,
            maxDistance = 100.0,
            minDistance = 2.0,
            volume = 1.5
        },
        ["ultimate"] = {
            name = "Ultimate",
            price = 10000,
            batteryDrain = 0.4,
            maxDistance = 150.0,
            minDistance = 3.0,
            volume = 2.0
        }
    },
    
    -- Battery settings
    Battery = {
        drainRate = 0.01,
        rechargeRate = 0.02,
        maxBattery = 100.0
    },

    -- Audio effects
    Effects = {
        screenShake = {
            intensity = 0.5,
            duration = 500
        },
        plateRattle = {
            intensity = 0.3,
            frequency = 2000
        }
    }
}
