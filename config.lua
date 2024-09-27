--[[ ===================================================== ]]--
--[[        QBCore Scrapyard Job Script by MaDHouSe        ]]--
--[[ ===================================================== ]]--

Config = {}
---------------------------------------------------------------

Config.UseMHVehiclekeys = false -- you need mh-vehiclekeys and mh-vehiclekeyitem, this is required if this value is true
Config.UsePsDispatch = true -- you need ps-dispatch for this

-- Use qb-target interactions (don't change this, go to your server.cfg and add setr UseTarget true)
Config.UseTarget = false
---------------------------------------------------------------
Config.CheckForUpdates = false  -- Stay updated.
---------------------------------------------------------------
Config.DebugPoly = false         -- Debug polyzone
---------------------------------------------------------------
Config.MinCopsOnline = 0        -- Default 1, min 1 caps online before you can do the drump/steel vehicle 
---------------------------------------------------------------
Config.DestroyTime = 45000      -- The time what it takes to get a vhicle gets destroyed
Config.SteelTime = 15000        -- Progressbar time
Config.MinDamage = 950.0        -- before a player can use this, the vehicle has to be above a amount of body health. (max health is: 1000.0)
---------------------------------------------------------------
-- a cooldown timer, so players can't use it the hole time. make sure you add at least more than 3600 
-- (3600 * 60) = 1 min, (230000 * 60) = 1 hour
Config.CoolDownTime = 230000    -- 1 min
---------------------------------------------------------------
Config.InteractDistance = 1.7   -- interact distance
Config.InteractButton = 38      -- interact key (E)
---------------------------------------------------------------
Config.PayMoneyToJobCompany  = true -- pay to the company
Config.JobCanTapFrameNumbers = true -- company can tap framenumbers of stolen npc vehicles
---------------------------------------------------------------
Config.DefaultGarage = "legionsquare" -- default garage, when scrapping this is the garage where the vehicle is parked.
---------------------------------------------------------------

Config.Access = {
    ['public'] = false,                    -- this allows all players only to scrap any npc vehicles for materials (public access) (when false, players still crap there own vehicle not npc vehicles)
    ['citizenids'] = {
        ["AAAAAAAAA"] = {ranks = {0}},     -- <- add a player citizenid keep the rank 0
    },
    ['jobs'] = {
        ['scrapyard'] = {ranks = {2,3,4}}, -- stash access
    },
    ['gangs'] = {
        ['lostmc'] = {ranks = {0,1,2,3}},  -- stash access
    }
}
---------------------------------------------------------------

-- Needed Items for the jobs
Config.NeededItems = {
    ['steeling'] = {                                   -- needed items to be able to steel a vehicle
        [1] = {name = "advancedlockpick", needed = 1}, -- basic item (does not remove from inventory)
        [2] = {name = "screwdriverset", needed = 1},   -- basic item (does not remove from inventory)
        [3] = {name = "oxycutter", needed = 1},        -- basic item (does not remove from inventory)
        -- dont change this
        [4] = {name = "oxygen-tank", needed = 1},      -- items that will removed
        [5] = {name = "steel", needed = 5},            -- items that will removed
        [6] = {name = "plastic", needed = 1},          -- items that will removed
        [7] = {name = "ducttape", needed = 1}
        -- you can add more here
    },
    ['scrapping'] = {                                  -- needed items to be able to scrap a vehicle
        [1] = {name = "oxycutter", needed = 1},        -- basic item (does not remove from inventory)
        [2] = {name = "oxygen-tank", needed = 1},      -- items that will removed
        [3] = {name = "steel", needed = 5},            -- items that will removed
        [4] = {name = "plastic", needed = 1},          -- items that will removed
        -- you can add more here
    },
    ['deleting'] = {                                   -- needed items to be able to delete a vehicle
        [1] = {name = "oxycutter", needed = 1},        -- basic item (does not remove from inventory)
        [2] = {name = "oxygen-tank", needed = 1},      -- items that will removed
    },
}
---------------------------------------------------------------

-- items that you get after material scrap
Config.MinItems = 50  -- min total of an item you get returned
Config.MaxItems = 100 -- max total of an item you get returned
Config.ScrapItems = {"metalscrap", "plastic", "copper", "iron", "aluminum", "steel", "glass", "ducttape", "electric_scrap"}
Config.CarItems = {"engine1", "transmission1", "brakes1", "suspension1", "headlights", "hood", "roof", "turbo", "spoiler", "bumper", "skirts", "exhaust", "seat", "rims", "tires", "sparkplugs", "carbattery", "axleparts", "sparetire", "noscan"}
---------------------------------------------------------------

Config.JobVehicle = {
    vehicle = {
        plate = "NPC-C-"..math.random(10, 99),
        model = "flatbed",
        spawnpoint = vector3(2351.6279, 3037.3982, 48.2458),
        heading = 1.8203,
        offset = {
            x = -0.5,--[[left/right]] 
            y = -5.0,--[[front/back]] 
            z = 0.9, --[[up/down]]
        },
    },
}

-- The mission
Config.Mission = {
    vehicle = {
        plate = "NPC-C-"..math.random(10, 99),
        model = "flatbed",
        spawnpoint = vector3(2351.6279, 3037.3982, 48.2458),
        heading = 1.8203,
        offset = {
            x = -0.5,--[[left/right]] 
            y = -5.0,--[[front/back]] 
            z = 0.9, --[[up/down]]
        },
    },
    home = {
        coords = vector3(2351.2749, 3038.9167, 48.1521),
    },
    garage = { -- vehicle garage menu
        coords = vector4(2423.7803, 3131.1799, 48.2632, 68.1987),
        heading = 77.4146,
    },
}

---------------------------------------------------------------
-- Pruducts for each job store. you need to translate this to your own language.
Config.ShopProducts = {
    ['scrapyard'] = {
        -- Car Parts
        ["engine1"]          = {name = "Motor lvl 1",            price = 250,},
        ["transmission1"]    = {name = "Transmissie lvl 1",      price = 250,},
        ["brakes1"]          = {name = "Remmerij lvl 1",         price = 150,},
        ["suspension1"]      = {name = "Ophanging lvl 1",        price = 100,},
        ["headlights"]       = {name = "Koplampen",              price = 80,},
        ["hood"]             = {name = "Motorkap",               price = 50,},
        ["roof"]             = {name = "Dak",                    price = 25,},
        ["turbo"]            = {name = "Turbo",                  price = 100,},
        ["spoiler"]          = {name = "Spoiler",                price = 75,},
        ["bumper"]           = {name = "Bumper",                 price = 50,},
        ["skirts"]           = {name = "Skirts",                 price = 25,},
        ["exhaust"]          = {name = "Uitlaat",                price = 75,},
        ["seat"]             = {name = "Stoel",                  price = 75,},
        ["rims"]             = {name = "Velgen",                 price = 50,},
        ["tires"]            = {name = "Banden",                 price = 25,},
        ["sparkplugs"]       = {name = "Bougies",                price = 15,},
        ["carbattery"]       = {name = "Accu",                   price = 45,},
        ["axleparts"]        = {name = "Aandrijfing Onderdelen", price = 40,},
        ["sparetire"]        = {name = "Reserve Wiel",           price = 25,},
        ["noscan"]           = {name = "Lege Nos Fles",          price = 35,},
        -- Matarials
        ["metalscrap"]       = {name = "metalscrap",             price = 2,},
        ["plastic"]          = {name = "plastic",                price = 2,},
        ["copper"]           = {name = "copper",                 price = 9,},
        ["iron"]             = {name = "iron",                   price = 4,},
        ["aluminum"]         = {name = "aluminum",               price = 6,},
        ["steel"]            = {name = "steel",                  price = 6,},
        ["glass"]            = {name = "glass",                  price = 2,},
        ["ducttape"]         = {name = "ducttape",               price = 1,},
        ["rubber"]           = {name = "rubber",                 price = 9,},
        ["electric_scrap"]   = {name = "electric_scrap",         price = 6,},
    },
}
-- All Zones
Config.Zones = {
    ['scrapyard'] = {
        ['base'] = {
            [1] = {
                name = "scrapyard",
                coords = vector3(2383.3564, 3117.3318, 48.2078),
                vectors = {
                    vector2(2341.3865, 3147.9424),
                    vector2(2374.6897, 3165.4858),
                    vector2(2402.5503, 3161.1707),
                    vector2(2435.6951, 3161.0984),
                    vector2(2435.9031, 3025.9265),
                    vector2(2328.2893, 3025.2878),
                    vector2(2329.0066, 3080.3376),
                    vector2(2336.4141, 3122.1877),
                    vector2(2341.3865, 3147.9424),
                },
                minZ = 40.0,
                maxZ = 50.0,
            },
        },
        ['stash'] = {
            [1] = { --
                coords = vector3(2418.7966, 3118.7078, 48.2265),
                length = 3.5,
                wide = 5.0,
                heading = 2.9870, 
                distance = 1.5,
                blip = {
                    label = Lang:t('shop.shop_stash'),
                    show = true,
                    sprite = 478,
                    scale = 0.5,
                    color = 82,
                },
            },
            [2] = {  
                coords = vector3(2355.8804, 3144.3125, 48.2087),
                length = 3.0,
                wide = 3.5,
                heading = 201.7093,
                distance = 1.5,
                blip = {
                    label = Lang:t('shop.shop_stash'),
                    show = true,
                    sprite = 478,
                    scale = 0.5,
                    color = 82,
                },
            },
            [3] = {
                coords = vector3(2371.6829, 3049.8491, 48.1525),
                length = 1.0,
                wide = 3.0,
                heading = 1.1500,
                distance = 1.5,
                blip = {
                    label = Lang:t('shop.shop_stash'),
                    show = true,
                    sprite = 478,
                    scale = 0.5,
                    color = 82,
                },
            },
        },
        ['duty'] = {
            [1] = {
                coords = vector3(2347.8838, 3113.3203, 48.2087),
                length = 1.0,
                wide = 3.0,
                heading = 170.9951,
                distance = 1.5,
                blip = {
                    label = Lang:t('job.duty_clock'),
                    show = true,
                    sprite = 430,
                    scale = 0.5,
                    color = 2,
                },
            },
        },
        ['garages'] = {
            [1] = {
                name = "scrapyardgarage",
                label = Lang:t('job.garage_label',{ name = "Scrapyard" }),
                coords = vector3(2424.5601, 3131.9182, 48.1916),
                blip = {
                    label = Lang:t('job.menu_garage'),
                    show = true,
                    sprite = 289,
                    scale = 0.5,
                    color = 38,
                },
                vectors = {
                    vector2(2416.4270, 3127.8176),
                    vector2(2421.0850, 3137.6819),
                    vector2(2430.5291, 3135.1877),
                    vector2(2431.9026, 3124.5522),
                    vector2(2416.4270, 3127.8176),
                },
                minZ = 47.0,
                maxZ = 50.0,
            },
        },
        ['shops'] = {
            [1] = {
                name = "shop",
                label = Lang:t('shop.shop_name'),
                targetIcon = "fas fa-shopping-basket",
                products = Config.ShopProducts['scrapyard'],
                coords = vector3(2340.8967, 3127.2046, 49.0574),
                heading = 6.6006,
                minZ = 47.0,
                maxZ = 50.0,
                blip = {
                    label = Lang:t('shop.shop_name'),
                    show = true,
                    sprite = 52,
                    scale = 0.5,
                    color = 2,
                },
                vectors = {
                    vector2(2339.7632, 3128.1333),
                    vector2(2342.1589, 3127.6614),
                    vector2(2342.2144, 3128.6255),
                    vector2(2339.9763, 3129.0283),
                    vector2(2339.7632, 3128.1333),
                },
            }, -- you can add more here
        },
        ['scraps'] = {
            [1] = {
                name = "steelzone1",
                label = "Scrap Point",
                coords = vector3(2409.4343, 3032.7510, 48.1526),
                home = vector3(2351.2749, 3038.9167, 48.1521),
                blip = {
                    label = "Scrap Point",
                    show = true,
                    sprite = 643,
                    scale = 0.5,
                    color = 47,
                },
                vectors = {
                    vector2(2411.3237, 3035.6587),
                    vector2(2411.4390, 3030.3054),
                    vector2(2407.1011, 3030.4822),
                    vector2(2407.0317, 3035.2825),
                    vector2(2411.3237, 3035.6587),
                },
                minZ = 47.0,
                maxZ = 50.0,
            },
        },
        ['drops'] = { -- standalone
            [1] = { -- Dropzone 1
                name = "dropzone1",                             -- polyzone name
                label = "Drop Zone",                            -- polyzone label
                coords = vector3(3862.3276, 4463.6812, 2.7239), -- polyzone center coords
                heading = 90.0,                                 -- polyzone heading
                ground = 0.7,                                   -- ground height for the markers drop location
                drop = vector3(3884.9583, 4463.5283, 4.1911),   -- vehicle drop location
                vectors = {                                     -- polyzone
                    vector2(3856.8682, 4462.0527),
                    vector2(3856.8140, 4465.3994),
                    vector2(3867.9441, 4465.4175),
                    vector2(3868.0125, 4461.9194),
                    vector2(3856.8682, 4462.0527),
                },
                minZ = 1.0,
                maxZ = 4.5,
            },
            [2] = { -- Dropzone 2
                name = "dropzone2",
                label = "Drop Zone",
                coords = vector3(1619.1794, 6662.2104, 24.6602), 
                heading = 202.8390,
                ground = 1.7,
                drop = vector3(1610.4377, 6687.5127, 24.8310),
                vectors = {
                    vector2(1622.9677, 6657.2578),
                    vector2(1619.4430, 6655.9219),
                    vector2(1615.9150, 6666.3521),
                    vector2(1618.9045, 6667.3125),
                    vector2(1622.9677, 6657.2578),
                },
                minZ = 20.0,
                maxZ = 26.0,
            },
            [3] = { -- Dropzone 3
                name = "dropzone3",
                label = "Drop Zone",
                coords = vector3(494.1964, -3384.9648, 6.0702),
                heading = 181.1107,
                ground = 1.0,
                drop = vector3(494.0704, -3401.7634, 9.3570),
                vectors = {
                    vector2(491.7627, -3390.2146),
                    vector2(496.6198, -3390.2104),
                    vector2(496.5208, -3381.8940),
                    vector2(491.9978, -3382.0183),
                    vector2(491.7627, -3390.2146),
                },
                minZ = 5.0,
                maxZ = 8.5,
            }, -- you can add more here
        },
    },
}
---------------------------------------------------------------
-- vehicle classes that will ignored.
Config.IgnoreVehicleClasses = {                    
    --0, --Compacts  
    --1, --Sedans  
    --2, --SUVs  
    --3, --Coupes  
    --4, --Muscle  
    --5, --Sports Classics  
    --6, --Sports  
    --7, --Super  
    --8, --Motorcycles  
    --9, --Off-road  
    --10, --Industrial  
    --11, --Utility
    --12, --Vans  
    --13, --Cycles 
    14, --Boats  
    15, --Helicopters  
    16, --Planes  
    17, --Service  
    18, --Emergency  
    19, --Military  
    --20, --Commercial  
    21, --Trains  
    22, --Open Wheel
}
---------------------------------------------------------------
