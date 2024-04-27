--[[ ===================================================== ]]--
--[[          MH Scrapyard Job Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()
local PlayerData = {}
local zones = {shops = {}, drops = {}, blips = {}, scraps = {}, garages = {},  base = {}}
local cooldown = false
--
local shopcombo = nil
local scrapcombo = nil
local garagescombo = nil
local basecombo = nil
local dropcombo = nil
--
local enable1 = true
local enable2 = true
local enable3 = true
--
local isInBaseZone = false
local isInGarageZone = false
local isInScrapZone = false
local isInShopZone = false
local isInDropZone = false
--
local isGarageBusy = false
local isScrapBusy = false
local isShopBusy = false
local isStarted = false
-- Mission

local tmpVehicle = nil
local isMissionEnable = false 
local isvehicleDropped = false
local missionFailNotify = false
local missionVehicle = nil
local missionBlip = nil
local missionPlate = nil
local missionAction = nil
local destroyVehicle = nil
local dropLoc = nil
local backLoc = nil
local homeBlip = nil
local returnBackHome = false
local jobvehicleBlip = nil
local bomNotify = false
--
local currentMissionCoords = nil
local currentDropzone = 0
local scrapTime = 0

local currentBase = nil
local currentZone = nil
local currentAction = nil
local lastBase = nil
local lastZone = nil
--
local currentBrokenVehicle = nil
local controllMarker = false
local truck = nil
local spanwdPropAction = nil

local function GetRequiredItems(action)
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:GetMissingItems", function(items)
        QBCore.Functions.Notify(Lang:t('notify.not_enough_items'), "error", 5000)
        TriggerEvent('inventory:client:requiredItems', items, true)
        Citizen.Wait(5000)
        TriggerEvent('inventory:client:requiredItems', items, false)
    end, action)
end

-------------------------------- Functions --------------------------------
local function CreateZones(job)
    for zoneName, allZones in pairs(Config.Zones) do -- Config.Zones['scrapyard']['base']
        for k, z in pairs(allZones) do
            if k == "base" then
                for _, zone in pairs(z) do
                    zones.base[#zones.base + 1] = PolyZone:Create({table.unpack(zone.vectors)}, {name = zone.name, minZ = zone.minZ, maxZ = zone.maxZ})
                end
            elseif k == "shops" then
                for _, zone in pairs(z) do
                    zones.shops[#zones.shops + 1] = PolyZone:Create({table.unpack(zone.vectors)}, {name = zone.name, minZ = zone.minZ, maxZ = zone.maxZ})
                end
            elseif k == "scraps" then
                for _, zone in pairs(z) do    
                    zones.scraps[#zones.scraps + 1] = PolyZone:Create({table.unpack(zone.vectors)}, {name = zone.name, minZ = zone.minZ, maxZ = zone.maxZ})
                end
            elseif k == "garages" then
                for _, zone in pairs(z) do
                    zones.garages[#zones.garages + 1] = PolyZone:Create({table.unpack(zone.vectors)}, {name = zone.name, minZ = zone.minZ, maxZ = zone.maxZ})
                end
            elseif k == "drops" then
                for _, zone in pairs(z) do
                    zones.drops[#zones.drops + 1] = PolyZone:Create({table.unpack(zone.vectors)}, {name = zone.name, minZ = zone.minZ, maxZ = zone.maxZ})
                end
            end
        end
    end
    basecombo = ComboZone:Create(zones.base, { name = "BaseZonesCombo", debugPoly = Config.DebugPoly })
    shopcombo = ComboZone:Create(zones.shops, { name = "ShopZonesCombo", debugPoly = Config.DebugPoly })
    scrapcombo = ComboZone:Create(zones.scraps, { name = "ScrapZonesCombo", debugPoly = Config.DebugPoly })
    garagescombo = ComboZone:Create(zones.garages, { name = "GarageZonesCombo", debugPoly = Config.DebugPoly })
    dropcombo = ComboZone:Create(zones.drops, { name = "DropZonesCombo", debugPoly = Config.DebugPoly })
end

local function VehicleMenu()
    isShopBusy = true
    local menu = {
        {
            header = Lang:t('menu.vehicle_menu.header'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        }
    }
    menu[#menu + 1] = {
        header = Lang:t('menu.vehicle_menu.lock_vehicle'),
        icon = "fa-solid fa-angle-right",
        params = {
            event = 'mh-scrapyardjob:client:attachVehicle',
            args = {}
        },
    }
    menu[#menu + 1] = {
        header = Lang:t('menu.vehicle_menu.unlock_vehicle'),
        icon = "fa-solid fa-angle-right",
        params = {
            event = 'mh-scrapyardjob:client:detachVehicle',
            args = {}
        },
    }
    menu[#menu + 1] = {
        header = Lang:t('menu.menu_close'),
        icon = "fa-solid fa-angle-left",
        params = {event = 'mh-scrapyardjob:client:close'}
    }
    exports['qb-menu']:openMenu(menu)
end

local function DisplayGarageMenu()
    isGarageBusy = true
    local menu = {
        {
            header = Lang:t('job.menu_garage'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        }
    }
    if IsPedInAnyVehicle(PlayerPedId()) then
        menu[#menu + 1] = {
            header =  Lang:t('menu.park_vehicle'),
            icon = "fa-solid fa-angle-right",
            params = {
                event = 'mh-scrapyardjob:client:parknVehicle',
                args = {}
            },
        }
    else  
        menu[#menu + 1] = {
            header = "Flatbed",
            icon = "fa-solid fa-angle-right",
            params = {
                event = 'mh-scrapyardjob:client:spawnVehicle',
                args = {
                    type = 'flatbed'
                }
            },
        }
        menu[#menu + 1] = {
            header = "Towtruck small",
            icon = "fa-solid fa-angle-right",
            params = {
                event = 'mh-scrapyardjob:client:spawnVehicle',
                args = {
                    type = 'towtruck2'
                }
            },
        }
        menu[#menu + 1] = {
            header = "Towtruck big",
            icon = "fa-solid fa-angle-right",
            params = {
                event = 'mh-scrapyardjob:client:spawnVehicle',
                args = {
                    type = 'towtruck'
                }
            },
        }

    end
    menu[#menu + 1] = {
        header = Lang:t('menu.menu_close'),
        icon = "fa-solid fa-angle-left",
        params = {event = 'mh-scrapyardjob:client:close'}
    }
    exports['qb-menu']:openMenu(menu)
end

local function DisplayShopMenu()
    isShopBusy = true
    local menu = {
        {
            header = Lang:t('shop.shop_name'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        }
    }
    menu[#menu + 1] = {
        header =  Lang:t('shop.buy_pars'),
        icon = "fa-solid fa-angle-right",
        params = {
            event = 'mh-scrapyardjob:client:buy',
            args = {type = "parts"}
        },
    }
    menu[#menu + 1] = {
        header =  Lang:t('shop.buy_materials'),
        icon = "fa-solid fa-angle-right",
        params = {
            event = 'mh-scrapyardjob:client:buy',
            args = {type = "materials"}
        },
    }
    menu[#menu + 1] = {
        header = Lang:t('menu.menu_close'),
        icon = "fa-solid fa-angle-left",
        params = {event = 'mh-scrapyardjob:client:close'}
    }
    exports['qb-menu']:openMenu(menu)
end

local function DisplayMainMenu()
    if not cooldown then
        QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
            if data.gang or data.auth or data.job or data.public then
                local menu = {
                    {
                        header = Lang:t('menu.main_header'),
                        isMenuHeader = true,
                        icon = "fa-solid fa-circle-info",
                    }
                }
                menu[#menu + 1] = {
                    header =  Lang:t('menu.main_header2'),
                    icon = "fa-solid fa-angle-right",
                    params = {
                        event = 'mh-scrapyardjob:client:MyVehicleOptions',
                    },
                }
                menu[#menu + 1] = {
                    header = Lang:t('menu.main_header3'),
                    icon = "fa-solid fa-angle-right",
                    params = {
                        event = 'mh-scrapyardjob:client:NPCVehicleOptions',
                    },
                }
                menu[#menu + 1] = {
                    header = Lang:t('menu.menu_close'),
                    icon = "fa-solid fa-angle-left",
                    params = {event = 'mh-scrapyardjob:client:close'}
                }
                exports['qb-menu']:openMenu(menu)
            end
        end)
    else
        QBCore.Functions.Notify(Lang:t('notify.you_must_wait'), "error")
    end
end

local function NPCVehicleOptions()
    local hasPermission = false
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
        if data.gang or data.auth or data.job or data.public then 
            local menu = {
                {
                    header = Lang:t('menu.main_header3'),
                    isMenuHeader = true,
                    icon = "fa-solid fa-circle-info",
                },
                {
                    header = Lang:t('menu.menu_back'),
                    icon = "fa-solid fa-angle-left",
                    params = {
                        event = 'mh-scrapyardjob:client:DisplayMainMenu'
                    }
                }
            }
            if data.gang or data.auth or (data.job and Config.JobCanTapFrameNumbers) or data.public then
                menu[#menu + 1] = {
                    header = Lang:t('menu.menu_title1'),
                    txt = Lang:t('menu.new_plate_and_owner'),
                    icon = "fa-solid fa-angle-right",
                    params = {
                        event = 'mh-scrapyardjob:client:StealNPCVehicle',
                        args = {}
                    },
                }
            end
            if data.job then
                menu[#menu + 1] = {
                    header = Lang:t('menu.menu_title3'),
                    txt = Lang:t('menu.menu_destroy_vehicle_for_parts'),
                    icon = "fa-solid fa-angle-right",
                    params = {
                        event = 'mh-scrapyardjob:client:ScrapNPCVehicle',
                        args = {type = "parts"}
                    },
                }
            end
            if data.gang or data.auth or data.job or data.public then
                menu[#menu + 1] = {
                    header = Lang:t('menu.menu_title2'),
                    txt = Lang:t('menu.menu_destroy_vehicle_for_materials'),
                    icon = "fa-solid fa-angle-right",
                    params = {
                        event = 'mh-scrapyardjob:client:ScrapNPCVehicle',
                        args = {type = "materials"}
                    },
                }
            end
            menu[#menu + 1] = {
                header = Lang:t('menu.menu_close'),
                icon = "fa-solid fa-angle-left",
                params = {event = 'mh-scrapyardjob:client:close'}
            }
            exports['qb-menu']:openMenu(menu)
        end
    end)
end

local function DisplayPlayerMenu()
    local menu = {
        {
            header = Lang:t('menu.main_header2'),
            isMenuHeader = true,
            icon = "fa-solid fa-circle-info",
        },
        {
            header = Lang:t('menu.menu_back'),
            icon = "fa-solid fa-angle-left",
            params = {
                event = 'mh-scrapyardjob:client:DisplayMainMenu'
            }
        }
    }
    menu[#menu + 1] = {
        header = Lang:t('menu.menu_title2'),
        txt = Lang:t('menu.menu_destroy_vehicle_for_materials'),
        icon = "fa-solid fa-angle-right",
        params = {
            event = 'mh-scrapyardjob:client:DeleteMyVehicle',
            args = {}
        },
    }
    menu[#menu + 1] = {
        header = Lang:t('menu.menu_close'),
        icon = "fa-solid fa-angle-left",
        params = {event = 'mh-scrapyardjob:client:close'}
    }
    exports['qb-menu']:openMenu(menu)
end

local function OpenAllDoors(veh)
    for i = 0, 5 do
        SetVehicleDoorOpen(veh, i, false, true)
        Citizen.Wait(100)
    end
end

local function CloseAllDoors(veh)
    for i = 0, 5 do
        SetVehicleDoorShut(veh, i, false)
        Citizen.Wait(100)
    end
end

local function BrakeAllDoorsSlow(veh)
    local countDoors = 0
    for i = 0, 5 do
        if countDoors <= 5 then
            SetVehicleDoorBroken(veh, i, false)
            Citizen.Wait(7000)
            countDoors = countDoors + 1
        end
    end
end

local function BrakeAllWindowsSlow(veh)
    local countWindows = 0
    for i = 0, 7 do
        if countWindows <= 7 then
            SmashVehicleWindow(veh, i, false)
            Citizen.Wait(8000)
            countWindows = countWindows + 1
        end
    end
end

local function BrakeAllWheels(veh)
    local countsWheels = 0
    SetVehicleTyresCanBurst(veh, true)
    for i = 0, 4 do
        if countsWheels <= 4 then
            SetVehicleTyreBurst(veh, i, true, 1000.0)
            Citizen.Wait(6000)
            countsWheels = countsWheels + 1
        end
    end
end

local function IsBlackListedVehicle(class)
    local isBlacklisted = false
    for k, v in pairs(Config.IgnoreVehicleClasses) do
        if v == class then isBlacklisted = true end
    end
    return isBlacklisted    
end

local function ResetMission()
    if destroyVehicle ~= nil and DoesEntityExist(destroyVehicle) then
        DeleteEntity(destroyVehicle)
        DeleteVehicle(destroyVehicle)
        destroyVehicle = nil
    end
    if missionVehicle ~= nil and DoesEntityExist(missionVehicle) then
        DeleteEntity(missionVehicle)
        DeleteVehicle(missionVehicle)
        missionVehicle = nil
    end
    if missionBlip ~= nil then 
        RemoveBlip(missionBlip)
        missionBlip = nil
    end
    if homeBlip ~= nil then 
        RemoveBlip(homeBlip) 
        homeBlip = nil
    end
    if jobvehicleBlip ~= nil then 
        RemoveBlip(jobvehicleBlip) 
        jobvehicleBlip = nil
    end
    isMissionEnable = false
    currentDropzone = 0
    missionPlate = nil
    dropLoc = nil
    backLoc = nil
    returnBackHome = false
    isvehicleDropped = false
    bomNotify = false
    currentMissionCoords = nil
end

local function Reset()
    enable1 = true
    enable2 = true
    enable3 = true
    scraplisten = true
    backLoc = nil
    isScrapBusy = false
    isStarted = false
    bomNotify = false
end

local function getStreetandZone(coords)
	local zone = GetLabelText(GetNameOfZone(coords.x, coords.y, coords.z))
	local currentStreetHash = GetStreetNameAtCoord(coords.x, coords.y, coords.z)
	currentStreetName = GetStreetNameFromHashKey(currentStreetHash)
	playerStreetsLocation = currentStreetName .. ", " .. zone
	return playerStreetsLocation
end

local function CallCops(plate, model)
    local currentPos = GetEntityCoords(PlayerPedId())
    local locationInfo = getStreetandZone(currentPos)
    if Config.UsePsDispatch then
        TriggerServerEvent("dispatch:server:notify",{
            dispatchcodename = "illegaledumping", -- has to match the codes in sv_dispatchcodes.lua so that it generates the right blip
            dispatchCode = "10-90",
            firstStreet = locationInfo,
            gender = 'unknow',
            model = model,
            plate = plate,
            priority = 2, -- priority
            firstColor = nil,
            automaticGunfire = false,
            origin = {
                x = currentPos.x,
                y = currentPos.y,
                z = currentPos.z
            },
            dispatchMessage = Lang:t('police.notify_message'), -- message
            job = {"police"} -- jobs that will get the alerts
        })
    else
        TriggerServerEvent('police:server:policeAlert', Lang:t('police.notify_title') .. " " .. Lang:t('police.notify_message'))
    end
end

local function DetonateVehicle(veh)
    local coords = GetEntityCoords(veh)
    if DoesEntityExist(veh) then
        AddExplosion(coords.x, coords.y, coords.z, 5, 500.0, true, false, true)
        local props = QBCore.Functions.GetVehicleProperties(veh)
        local displaytext = GetDisplayNameFromVehicleModel(props.model)
        CallCops(props.plate, displaytext:lower())
    end
end

local function RunTimer(veh)
    timer = 3000
    if not bomNotify then bomNotify = true end
    while timer > 0 do
        timer = timer - 1000
        Citizen.Wait(1000)
        if timer == 0 then
            DetonateVehicle(veh)
            Citizen.Wait(5000)
            DeleteEntity(veh)
            DeleteVehicle(veh)
            destroyVehicle = nil
            tmpVehicle = nil
        end
    end
end

local function RunCoolDown()
    cooldown = true
    SetTimeout(Config.CoolDownTime * 60, function()
        cooldown = false
    end)
end

-- Draw Drop Location
local function DrawDropLocation(coords)
    for k, v in pairs(Config.Zones[lastBase]['drops']) do
        if #(coords - v.coords) <= 50.0 or #(coords - v.coords) > 2.0 then
            DrawMarker(30, v.coords.x, v.coords.y, v.coords.z - v.ground ,0,0,0,90.0,v.heading,0.0,3.0,1.0,10.0,255,0,0,50,0,0,0,0)
        end
        if #(coords - v.coords) <= 2.0 then
            DrawMarker(30, v.coords.x, v.coords.y, v.coords.z - v.ground ,0,0,0,90.0,v.heading,0.0,3.0,1.0,10.0,26,255,0,50,0,0,0,0)
        end
    end
end

local function CreateMissionBlip(name, coords, sprite)
	blip = AddBlipForCoord(coords)
	SetBlipSprite(blip, sprite)
	SetBlipColour(blip, 5)
    SetBlipScale(blip, 0.5)
	SetBlipAsShortRange(blip, false)
	BeginTextCommandSetBlipName("STRING")
	AddTextComponentString(name)
	EndTextCommandSetBlipName(blip)
	SetBlipRoute(blip, 1)
    isMissionEnable = true
	return blip
end

local function CreateBlips(data)
    blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(blip, data.blip.sprite)
    SetBlipScale(blip, data.blip.scale)
    SetBlipColour(blip, data.blip.color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentString(data.blip.label)
    EndTextCommandSetBlipName(blip)
    zones.blips[#zones.blips + 1] = blip
end

local function TakeOutVehicle(data, warp)    
    QBCore.Functions.SpawnVehicle(data.model, function(vehicle)
        if not warp then 
            missionVehicle = vehicle
            jobvehicleBlip = CreateMissionBlip(Lang:t('blip.job_vehicle'), data.spawnpoint, 477)
        end
        SetVehicleNumberPlateText(vehicle, data.plate)
        SetEntityHeading(vehicle, data.heading)
        SetVehRadioStation(vehicle, 'OFF')
        SetVehicleDirtLevel(vehicle, 0)
        SetVehicleDoorsLocked(vehicle, 0)
        SetEntityAsMissionEntity(vehicle, true, true)
        SetVehicleFuelLevel(vehicle, 100.0)
        DecorSetFloat(vehicle, "_FUEL_LEVEL", GetVehicleFuelLevel(vehicle))
        TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(vehicle))
        if Config.UseMHVehiclekeys then exports['mh-vehiclekeyitem']:CreateTempKey(vehicle) end
        if warp then
            truck = vehicle
            TaskWarpPedIntoVehicle(PlayerPedId(), vehicle, -1)
        else
            missionPlate = QBCore.Functions.GetPlate(vehicle)
            missionFailNotify = false
            QBCore.Functions.Notify(Lang:t('notify.go_to_work_vehicle'), "success", 5000)
        end
        exports['qb-target']:AddTargetEntity(vehicle, {
            options = {
                {
                    type = "client",
                    event = "",
                    icon = 'fa-solid fa-truck',
                    label = Lang:t('menu.vehicle_menu.header'),
                    targeticon = 'fa-solid fa-truck',
                    job = 'scrapyard',
                    action = function(entity)
                        if PlayerData.job.name ~= "scrapyard" then return false end
                        VehicleMenu()
                    end,
                    canInteract = function(entity, distance, data)
                        if PlayerData.job.name ~= "scrapyard" then return false end
                        return true
                    end
                }
            },
            distance = 5.0,
        })
    end, data.spawnpoint, true)
end

local function DropVehicle()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    local plate = QBCore.Functions.GetPlate(vehicle)
    if isMissionEnable and not returnBackHome and destroyVehicle ~= nil then
        isMissionEnable = false
        returnBackHome = true
        DetachEntity(destroyVehicle, true, true)
        Citizen.Wait(100)
        SetEntityCoords(destroyVehicle, dropLoc, false, false, false, true)
        RemoveBlip(missionBlip)
        isvehicleDropped = true
        homeBlip = CreateMissionBlip(Lang:t('blip.go_back'), backLoc, 309)
        QBCore.Functions.Notify(Lang:t('notify.wreck_is_bumped') .. Lang:t('blip.name'), "success", 10000)
    end
end

local function GetClosestPlayer()
    local closestPlayers = GetActivePlayers()
    local closestPlayer = -1
    local closestDistance = -1
    for i = 1, #closestPlayers, 1 do
        if closestPlayers[i] ~= PlayerId() and closestPlayers[i] ~= -1 then
            local pos = GetEntityCoords(GetPlayerPed(closestPlayers[i]))
            local distance = #(pos - coords)
            if closestDistance == -1 or closestDistance > distance then
                closestPlayer = closestPlayers[i]
                closestDistance = distance
            end
        end
    end
    return closestPlayer, closestDistance
end

local function IsAPlayerAround()
    local isAround = false
    local coords = GetEntityCoords(PlayerPedId())
    local closestPlayer, closestDistance = GetClosestPlayer()
    if closestPlayer ~= -1 or closestDistance ~= -1 then isAround = true end
    return isAround
end

local function ScrapNPCVehicle()
    if not IsAPlayerAround() then
        tmpVehicle = nil
        local veh, distance = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
        if veh ~= nil then
            if distance <= Config.InteractDistance then
                if IsBlackListedVehicle(GetVehicleClass(veh)) then 
                    QBCore.Functions.Notify(Lang:t('notify.vehicle_is_blacklisted'), "error", 5000)
                    isScrapBusy = false
                    Reset()
                else
                    local props = QBCore.Functions.GetVehicleProperties(veh)
                    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:hasItems", function(count)
                        if count == #Config.NeededItems['scrapping'] then
                            QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:hasOwner", function(hasOwner)
                                if hasOwner then
                                    QBCore.Functions.Notify(Lang:t('notify.can_not_steel_player_vehicle'), "error", 5000)
                                    isScrapBusy = false
                                else
                                    tmpVehicle = veh
                                    TaskLookAtEntity(veh, PlayerPedId(), -1)
                                    isScrapBusy = true
                                    scrapTime = math.random(Config.DestroyTime, 60000)
                                    OpenAllDoors(veh)
                                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
                                    isStarted = true
                                    QBCore.Functions.Progressbar("scrap_vehicle", Lang:t('progressbar.demolish'), scrapTime, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 10.0, 0)
                                        ClearPedTasks(PlayerPedId())
                                        ClearAllPedProps(PlayerPedId())
                                        SetEntityAsMissionEntity(veh, true, true)
                                        RunCoolDown()
                                        TriggerServerEvent('mh-scrapyardjob:server:RemoveItems', 'scrapping')
                                        currentDropzone = math.random(1, #Config.Zones[currentBase]['drops'])
                                        currentMissionCoords = Config.Zones[currentBase]['drops'][currentDropzone].coords
                                        dropLoc = Config.Zones[currentBase]['drops'][currentDropzone].drop
                                        backLoc = Config.Mission.home.coords
                                        destroyVehicle = veh
                                        local vehicleData = {
                                            model = Config.Mission.vehicle.model,
                                            plate = Config.Mission.vehicle.plate,
                                            spawnpoint = Config.Mission.vehicle.spawnpoint,
                                            heading = Config.Mission.vehicle.heading,
                                        }
                                        TakeOutVehicle(vehicleData, false)
                                        Citizen.Wait(500)
                                        AttachEntityToEntity(veh, missionVehicle, 20, Config.Mission.vehicle.offset.x, Config.Mission.vehicle.offset.y, Config.Mission.vehicle.offset.z, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
                                    end, function() -- Cancel
                                        Reset()
                                        QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                    end)
                                end
                            end, props.plate)
                        else
                            GetRequiredItems("scrapping")
                        end
                    end, 'scrapping')
                end
            end
        end
    else
	Reset()
        ResetMission()
        QBCore.Functions.Notify(Lang:t('notify.player_needby'), "error")
    end
end

local function DeleteMyVehicle()
    if not IsAPlayerAround() then
        tmpVehicle = nil
        local veh, distance = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
        if veh ~= nil then
            if distance <= Config.InteractDistance then
                if IsBlackListedVehicle(GetVehicleClass(veh)) then 
                    QBCore.Functions.Notify(Lang:t('notify.vehicle_is_blacklisted'), "error", 5000)
                    isScrapBusy = false
                    Reset()
                else
                    local props = QBCore.Functions.GetVehicleProperties(veh)
                    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:hasItems", function(count)
                        if count == #Config.NeededItems['deleting'] then
                            QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:isOwner", function(isOwner)
                                if isOwner then
                                    tmpVehicle = veh
                                    scrapTime = math.random(Config.DestroyTime, 60000)   
                                    TaskLookAtEntity(veh, PlayerPedId(), -1)
                                    isScrapBusy = true
                                    OpenAllDoors(veh)
                                    TaskStartScenarioInPlace(PlayerPedId(), "WORLD_HUMAN_WELDING", 0, true)
                                    isStarted = true
                                    QBCore.Functions.Progressbar("delete_vehicle", Lang:t('progressbar.demolish'), scrapTime, false, true, {
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {}, {}, {}, function() -- Done
                                        ClearAreaOfObjects(GetEntityCoords(PlayerPedId()), 10.0, 0)
                                        ClearPedTasks(PlayerPedId())             
                                        ClearAllPedProps(PlayerPedId())
                                        TriggerServerEvent('mh-scrapyardjob:server:RemoveItems', 'deleting')
                                        TriggerServerEvent("mh-scrapyardjob:server:DeleteMyVehicle", veh, props.plate)
                                        SetEntityAsMissionEntity(veh, true, true)
                                        RunCoolDown()
                                        DeleteVehicle(veh)
                                        QBCore.Functions.Notify(Lang:t('notify.vehicle_is_destroyed'), "success")
                                        Reset()
                                    end, function() -- Cancel
                                        Reset()
                                        QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                    end)
                                else
                                    QBCore.Functions.Notify(Lang:t('notify.not_the_owner'), "error")
                                end
                            end, props.plate)
                        else
                            GetRequiredItems("deleting")
                        end
                    end, 'deleting')
                end
            end
        end
    else
	Reset()
        ResetMission()
        QBCore.Functions.Notify(Lang:t('notify.player_needby'), "error")
    end
end

local function StealNPCVehicle()
    if not IsAPlayerAround() then
        local veh, distance = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId()))
        if veh ~= nil then
            if distance <= Config.InteractDistance then
                if IsBlackListedVehicle(GetVehicleClass(veh)) then 
                    QBCore.Functions.Notify(Lang:t('notify.vehicle_is_blacklisted'), "error", 5000)
                    isScrapBusy = false
                    Reset()
                else
                    local props = QBCore.Functions.GetVehicleProperties(veh)
                    local displaytext = exports['mh-vehiclemodels']:GetModelName(veh)
                    local body = GetVehicleBodyHealth(veh)
                    if math.floor(body) < Config.MinDamage then
                        return QBCore.Functions.Notify(Lang:t('notify.to_much_damage'), "error", 5000)
                    end
                    TaskLookAtEntity(veh, PlayerPedId(), -1)
                    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:hasOwner", function(hasOwner)
                        if hasOwner then
                            QBCore.Functions.Notify(Lang:t('notify.can_not_steel_player_vehicle'), "error", 5000)
                            isScrapBusy = false
                        else
                            isScrapBusy = true
                            QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:hasItems", function(count)
                                if count == #Config.NeededItems['steeling'] then
                                    OpenAllDoors(veh)
                                    QBCore.Functions.Progressbar("animation1", Lang:t('progressbar.info1'), Config.SteelTime, false, true,{
                                        disableMovement = true,
                                        disableCarMovement = true,
                                        disableMouse = false,
                                        disableCombat = true,
                                    }, {
                                        animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                                        anim = "weed_spraybottle_crouch_base_inspector"
                                    }, {}, {}, function() -- Done
                                        QBCore.Functions.Progressbar("animation2", Lang:t('progressbar.info2'), Config.SteelTime, false, true,{
                                            disableMovement = true,
                                            disableCarMovement = true,
                                            disableMouse = false,
                                            disableCombat = true,
                                        }, {
                                            animDict = "mini@repair",
                                            anim = "fixing_a_ped"
                                        }, {}, {}, function() -- Done
                                            QBCore.Functions.Progressbar("animation3", Lang:t('progressbar.info3'), Config.SteelTime, false, true,{
                                                disableMovement = true,
                                                disableCarMovement = true,
                                                disableMouse = false,
                                                disableCombat = true,
                                            }, {
                                                animDict = "anim@amb@business@weed@weed_inspecting_lo_med_hi@",
                                                anim = "weed_spraybottle_crouch_base_inspector"
                                            }, {}, {}, function() -- Done
                                                QBCore.Functions.Progressbar("animation4", Lang:t('progressbar.info4'), Config.SteelTime, false, true,{
                                                    disableMovement = true,
                                                    disableCarMovement = true,
                                                    disableMouse = false,
                                                    disableCombat = true,
                                                }, {
                                                    animDict = "mini@repair",
                                                    anim = "fixing_a_ped"
                                                }, {}, {}, function() -- Done
                                                    TaskStartScenarioInPlace(PlayerPedId(), 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                                                    QBCore.Functions.Progressbar("animation5", Lang:t('progressbar.info2'), Config.SteelTime, false, true,{
                                                        disableMovement = true,
                                                        disableCarMovement = true,
                                                        disableMouse = false,
                                                        disableCombat = true,
                                                    }, {}, {}, {}, function() -- Done
                                                        ClearAllPedProps(PlayerPedId())
                                                        ClearPedTasks(PlayerPedId())
                                                        CloseAllDoors(veh)
                                                        TriggerServerEvent('mh-scrapyardjob:server:RemoveItems', 'steeling')
                                                        QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:savenpcvehicle", function(callback)
                                                        end, {props = props, model = props.model, plate = props.plate, modelname = displaytext:lower(), vehicle = veh}) 
                                                        RunCoolDown()
                                                        Reset()
                                                    end, function() -- Cansel
                                                        Reset()
                                                        QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                                    end)
                                                end, function() -- Cansel
                                                    Reset()
                                                    QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                                end)
                                            end, function() -- Cansel
                                                Reset()
                                                QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                            end)
                                        end, function() -- Cansel
                                            Reset()
                                            QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                        end)
                                    end, function() -- Cansel
                                        Reset()
                                        QBCore.Functions.Notify(Lang:t('notify.cancel'), "error")
                                    end)                   
                                else
                                    GetRequiredItems("steeling")
                                    Reset()
                                end
                            end, 'steeling')
                        end
                    end, props.plate)
                end
            end
        end
    else
	Reset()
        ResetMission()
        QBCore.Functions.Notify(Lang:t('notify.player_needby'), "error")
    end
end

-- Display Help Text
local function DisplayHelpText(text)
    SetTextComponentFormat('STRING')
    AddTextComponentString(text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

-- Play Animation
local function playanimation(animDict,name)
	RequestAnimDict(animDict)
	while not HasAnimDictLoaded(animDict) do 
		Citizen.Wait(1)
		RequestAnimDict(animDict)
	end
	TaskPlayAnim(PlayerPedId(), animDict, name, 2.0, 2.0, -1, 47, 0, 0, 0, 0)
end

-- Preload Animation
local function PreloadAnimation(dick)
	RequestAnimDict(dick)
    while not HasAnimDictLoaded(dick) do
        Citizen.Wait(0)
    end
end

-- Spawn Prop Object
local function SpawnPropObject(action)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    isReparePropSpawned = true
    spanwdPropAction = action
    PreloadAnimation("anim@heists@box_carry@")
    if action == "bonnet" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('imp_prop_impexp_bonnet_02a'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), 0.0, 0.75, 0.45, 2.0, 0.0, 0.0, true, true, false, true, 1, true)
    elseif action == "wheel" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('prop_wheel_01'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), -0.08, 0.30, 0.37, 0.0, 0.0, 180.0, true, true, false, true, 1, true)    
    elseif action == "engine" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('prop_car_engine_01'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), 0.025, 0.0, 0.15, 90.0, 0.0, 180.0, true, true, false, true, 1, true)
    elseif action == "tranny" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('imp_prop_impexp_gearbox_01'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), -0.08, 0.30, 0.37, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    elseif action == "exhaust" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('imp_prop_impexp_exhaust_01'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), -0.08, 0.30, 0.37, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    elseif action == "trunk" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('imp_prop_impexp_trunk_01a'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), 0.0, 0.40, 0.1, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    elseif action == "seat" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('prop_car_seat'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), 0.1, 0.40, -0.65, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    elseif action == "door" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('prop_car_door_01'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), 0.1, 0.40, -0.65, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    elseif action == "brake" then
        TaskPlayAnim(ped, "anim@heists@box_carry@" ,"idle", 5.0, -1, -1, 50, 0, false, false, false)
        currentobject = CreateObject(GetHashKey('imp_prop_impexp_brake_caliper_01a'), coords.x, coords.y, coords.z,  true,  true, true)
        AttachEntityToEntity(currentobject, ped, GetPedBoneIndex(ped, 56604), -0.08, 0.30, 0.37, 0.0, 0.0, 180.0, true, true, false, true, 1, true)
    end
end

-- Delete Car Prop From Ped
local function DeleteCarPropFromPed()
    if currentobject then
        DeleteEntity(currentobject)
        DeleteObject(currentobject)
        ClearPedTasks(PlayerPedId())
        currentobject = nil
    end
end

local function InstallCarPropFromPed()
    if currentobject then
        local vehicle, distance = QBCore.Functions.GetClosestVehicle(GetEntityCoords(PlayerPedId())) 
        if distance <= 5.0 then
            DeleteEntity(currentobject)
            DeleteObject(currentobject)
            playanimation('creatures@rottweiler@tricks@','petting_franklin')
            Wait(5000)
            if spanwdPropAction == "engine" then
                SetVehicleEngineHealth(vehicle, 1000.0)
            end
            SetVehicleOnGroundProperly(vehicle)
            SetVehicleUndriveable(vehicle, false)
            ClearPedTasks(PlayerPedId())
            Wait(200)
        end
        currentobject = nil
    end
end

-- Listen 4 Garage Control
local function Listen4GarageControl()
    CreateThread(function()
        local garagelisten = true
        while garagelisten do
            if IsControlJustPressed(0, Config.InteractButton) and isInGarageZone and not isGarageBusy then -- E
                if IsPedInAnyVehicle(PlayerPedId()) then
                    TriggerEvent('mh-scrapyardjob:client:parknVehicle')
                else
                    DisplayGarageMenu()
                end
                garagelisten = false
                break
            end
            Citizen.Wait(5)
        end
    end)
end

-- Listen 4 Shop Control
local function Listen4ShopControl()
    CreateThread(function()
        local shoplisten = true
        while shoplisten do
            if IsControlJustPressed(0, Config.InteractButton) and isInShopZone and not isShopBusy then -- E
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    DisplayShopMenu()
                    shoplisten = false
                end
                break
            end
            Citizen.Wait(5)
        end
    end)
end

-- Listen 4 Scrap Control
local function Listen4ScrapControl()
    CreateThread(function()
        local scraplisten = true
        while scraplisten do
            if IsControlJustPressed(0, Config.InteractButton) and isInScrapZone and not isScrapBusy then -- E
                if not IsPedInAnyVehicle(PlayerPedId()) then
                    DisplayMainMenu()
                    scraplisten = false
                end
                break
            end
            Citizen.Wait(5)
        end
    end)
end

-- Listen 4 Drop Control
local function Listen4DropControl()
    CreateThread(function()
        local droplisten = true
        while droplisten do
            if IsControlJustPressed(0, Config.InteractButton) and isInDropZone then -- E
                if IsPedInAnyVehicle(PlayerPedId()) then
                    DropVehicle()
                    droplisten = false
                end
                break
            end
            Citizen.Wait(5)
        end
    end)
end

function GetClosestVehicle(coords, ignoreVehicle)
    local ped = PlayerPedId()
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    if coords then
        coords = type(coords) == 'table' and vec3(coords.x, coords.y, coords.z) or coords
    else
        coords = GetEntityCoords(ped)
    end
    for i = 1, #vehicles, 1 do
        local VehicleModel = GetEntityModel(vehicles[i])
        local vehiclename = GetDisplayNameFromVehicleModel(VehicleModel)
        if vehiclename:lower() ~= ignoreVehicle then
            local vehicleCoords = GetEntityCoords(vehicles[i])
            local distance = #(vehicleCoords - coords)
            if distance <= 10 then
                closestVehicle = vehicles[i]
            end
        end
    end
    return closestVehicle
end


local function TakeOutStalling(data)
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    local tmpLocation = vector3(coords.x, coords.y, coords.z)
    if tmpLocation then
        if not QBCore.Functions.SpawnClear(tmpLocation, 5.0) then
            QBCore.Functions.Notify(Lang:t('notify.area_is_obstructed'), 'error', 5000)
            return
        else
            QBCore.Functions.SpawnVehicle(data.vehicle, function(veh)
                QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:GetVehicleProperties", function(properties)
                    QBCore.Functions.SetVehicleProperties(veh, properties)
                    SetVehicleNumberPlateText(veh, data.plate)
                    SetEntityHeading(veh, heading)
                    SetVehRadioStation(veh,'OFF')
                    SetVehicleDirtLevel(veh, 0)
                    SetVehicleDoorsLocked(veh, 0)
                    SetEntityAsMissionEntity(veh, true, true)
		    		TaskWarpPedIntoVehicle(playerPed, veh, -1)
                    SetVehicleFuelLevel(veh, 100.0)
                    DecorSetFloat(veh, "_FUEL_LEVEL", GetVehicleFuelLevel(veh))
                    TriggerEvent("vehiclekeys:client:SetOwner", QBCore.Functions.GetPlate(veh))
		   			TriggerServerEvent('mh-scrapyardjob:server:DeleteVehicle', data.plate)
                    if Config.UseMHVehiclekeys then exports['mh-vehiclekeyitem']:CreateTempKey(veh) end
                    exports['qb-menu']:closeMenu()
                end, data.plate)
            end, tmpLocation, true)
        end
    end
end

local function StoreCar()
    local veh = GetVehiclePedIsIn(PlayerPedId())
    local props = QBCore.Functions.GetVehicleProperties(veh)
    local displaytext = GetDisplayNameFromVehicleModel(props.model)
    local data = {mods = props, plate = QBCore.Functions.GetPlate(veh), vehicle = displaytext:lower(), hash = GetHashKey(props.model)}
    SetVehicleEngineOn(veh, false, false, true)
    CheckPlayers(veh)
    Wait(1500)
    RequestAnimSet("anim@mp_player_intmenu@key_fob@")
    TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false)
    Wait(500)
    ClearPedTasks(PlayerPedId())
    SetVehicleLights(veh, 2)
    Wait(150)
    SetVehicleLights(veh, 0)
    Wait(150)
    SetVehicleLights(veh, 2)
    Wait(150)
    SetVehicleLights(veh, 0)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.3)
    Wait(1000)
    TriggerServerEvent('mh-scrapyardjob:server:SaveVehicle', data)
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:SaveVehicle", function(result)
        if result then
            if Config.UseMHVehiclekeys then exports['mh-vehiclekeyitem']:DeleteKey(QBCore.Functions.GetPlate(veh)) end
            QBCore.Functions.DeleteVehicle(veh)
            DeleteVehicle(veh)
        else
            QBCore.Functions.Notify(Lang:t('notify.can_not_steel_player_vehicle'), "error")
        end
    end, data)
end

-------------------------------- Handlers --------------------------------
AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then
        PlayerData = QBCore.Functions.GetPlayerData()
        Reset()
        ResetMission()
        CreateZones()
        if missionVehicle ~= nil then DeleteEntity(missionVehicle) end
        TriggerEvent('mh-scrapyardjob:client:updateBlips')
    end
end)

-------------------------------- Events --------------------------------

-- On Player Loaded
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    PlayerData = QBCore.Functions.GetPlayerData()
    CreateZones()
    TriggerEvent('mh-scrapyardjob:client:updateBlips')
end)

-- Set Player Data
RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
    PlayerData = data
end)

-- On Job Update
RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    PlayerData.job = job
    TriggerEvent('mh-scrapyardjob:client:updateBlips')
end)

-- Togge on/off duty
RegisterNetEvent('mh-scrapyardjob:client:ToggleDuty', function()
    TriggerServerEvent("QBCore:ToggleDuty")
    TriggerEvent('mh-scrapyardjob:client:updateBlips')
end)

-- Delete a vehicle (by server request) 
RegisterNetEvent('mh-scrapyardjob:client:delete', function(vehicle)
    DeleteEntity(vehicle)
end)

-- Close menu 
RegisterNetEvent('mh-scrapyardjob:client:close', function()
    isScrapBusy = false
    isShopBusy = false
    isGarageBusy = false
end)

-- Display main menu
RegisterNetEvent('mh-scrapyardjob:client:DisplayMainMenu', function()
    DisplayMainMenu()
end)

-- Display NPCVehicleOptions
RegisterNetEvent('mh-scrapyardjob:client:NPCVehicleOptions', function()
    NPCVehicleOptions()
end)

-- Display MyVehicleOptions
RegisterNetEvent('mh-scrapyardjob:client:MyVehicleOptions', function()
    DisplayPlayerMenu()
end)

-- Delete My Vehicle function 
RegisterNetEvent('mh-scrapyardjob:client:DeleteMyVehicle', function()
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
        if data.gang or data.auth or data.job or data.public then
            DeleteMyVehicle()
        end
    end)
end)

-- Scrap NPC Vehicle function
RegisterNetEvent('mh-scrapyardjob:client:ScrapNPCVehicle', function(scrap)
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
        if data.gang or data.auth or data.job or data.public then 
            QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:GetOnlineCops", function(count)
                if count >= Config.MinCopsOnline then
                    missionAction = scrap.type
                    ScrapNPCVehicle(scrap.type)
                else
                    QBCore.Functions.Notify(Lang:t('police.not_online'), "error")
                end 
            end)
        end
    end)
end)

-- Steal NPC Vehicle function 
RegisterNetEvent('mh-scrapyardjob:client:StealNPCVehicle', function()
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
        if data.gang or data.auth or data.job or data.public then 
            QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:GetOnlineCops", function(count)
                if count >= Config.MinCopsOnline then
                    StealNPCVehicle()
                else
                    QBCore.Functions.Notify(Lang:t('police.not_online'), "error")
                end 
            end)
        end
    end)
end)

RegisterNetEvent('mh-scrapyardjob:client:attachVehicle', function()
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
        if data.job then 
            truck = GetVehiclePedIsIn(PlayerPedId())
            local VehicleModel = GetEntityModel(truck)
            local truckname = GetDisplayNameFromVehicleModel(VehicleModel)
            local PlayerCoords = GetEntityCoords(PlayerPedId())
            local vehicle, distance = GetClosestVehicle(PlayerCoords, truckname:lower())
            local vehname = GetDisplayNameFromVehicleModel(vehicle)
            currentBrokenVehicle = vehicle 
            AttachEntityToEntity(vehicle, truck, 20, Config.JobVehicle.vehicle.offset.x, Config.JobVehicle.vehicle.offset.y, Config.JobVehicle.vehicle.offset.z, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        end
    end)
end)

RegisterNetEvent('mh-scrapyardjob:client:detachVehicle', function()
    local offset = GetOffsetFromEntityInWorldCoords(truck, 0.0, - 10.0 , -1.0)
    DetachEntity(currentBrokenVehicle, false, false)
    Citizen.Wait(100)
    SetEntityCoords(currentBrokenVehicle, offset, false, false, false, true)
    Citizen.Wait(100)
    currentBrokenVehicle = nil
    if controllMarker then controllMarker = false end
end)

RegisterNetEvent('mh-scrapyardjob:client:parknVehicle', function()
    local vehicle = GetVehiclePedIsIn(PlayerPedId())
    if vehicle == truck then truck = nil end
    SetVehicleEngineOn(vehicle, false, false, true)
    Citizen.Wait(1500)
    TaskLeaveVehicle(PlayerPedId(), vehicle)
    Citizen.Wait(1500)
    RequestAnimSet("anim@mp_player_intmenu@key_fob@")
    TaskPlayAnim(PlayerPedId(), 'anim@mp_player_intmenu@key_fob@', 'fob_click', 3.0, 3.0, -1, 49, 0, false, false)
    Citizen.Wait(2000)
    ClearPedTasks(PlayerPedId())
    SetVehicleLights(vehicle, 2)
    Citizen.Wait(150)
    SetVehicleLights(vehicle, 0)
    Citizen.Wait(150)
    SetVehicleLights(vehicle, 2)
    Citizen.Wait(150)
    SetVehicleLights(vehicle, 0)
    TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 5, "lock", 0.2)
    Citizen.Wait(1500)
    DeleteEntity(vehicle)
    isGarageBusy = false
end)

-- Spawn vehicle from garage menu
RegisterNetEvent('mh-scrapyardjob:client:spawnVehicle', function(args)
    local vehicleData = {model = args.type, plate = Config.Mission.vehicle.plate, spawnpoint = Config.Mission.garage.coords, heading = Config.Mission.garage.heading}
    TakeOutVehicle(vehicleData, true)
end)

local function GetZoneImNowIn(coords)
    local zone = {}
    for i = 0, #Config.Zones[currentBase]['stash'] do
        if Config.Zones[currentBase]['stash'][i] then
            local zone = Config.Zones[currentBase]['stash'][i]
            local myCoords = vector3(coords.x, coords.y, coords.z)
            local zoneCoords = vector3(zone.coords.x, zone.coords.y, zone.coords.z)
            if #(myCoords - zoneCoords) <= 2.0 then zone = {id = i, stash = zone.stash, base = currentBase} end
        end
    end
    return zone
end

-- Open Stash
RegisterNetEvent('mh-scrapyardjob:client:OpenStash', function()
    if PlayerData.job.name == "scrapyard" and PlayerData.job.name == currentBase then
        if PlayerData.job.onduty then
            TriggerServerEvent("inventory:server:OpenInventory", "stash", currentBase)
            TriggerEvent("inventory:client:SetCurrentStash", currentBase)
        else
            QBCore.Functions.Notify(Lang:t('job.not_onduty'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t('notify.no_permission'), "error")
    end
end)

-- Buy items menu from the scrapyard shop 
RegisterNetEvent('mh-scrapyardjob:client:buy', function(args)
    QBCore.Functions.TriggerCallback('mh-scrapyardjob:server:getStashItems', function(stashItems, total)
        if total >= 1 then
            local itemlist = {}
            for _, item in pairs(stashItems) do
                if QBCore.Shared.Items[item.name] then
                    if Config.Zones[currentBase][currentZone][1].products[item.name] then
                        if item.amount >= 1 then
                            itemlist[#itemlist + 1] = {
                                text = item.label.." "..Lang:t('shop.in_stock', {amount = item.amount, price = Config.Zones[currentBase][currentZone][1].products[item.name].price}),
                                value = item.name, 
                                amount = item.amount
                            }
                        end
                    end
                end
            end
            local menu = exports["qb-input"]:ShowInput({
                header = Lang:t('blip.name'),
                submitText = Lang:t('shop.buying'),
                inputs = {
                    {
                        type = "select",
                        text = Lang:t('shop.select_part'),
                        name = "item",
                        options = itemlist,
                        isRequired = true
                    },
                    {
                        type = "number",
                        text = Lang:t('shop.amount'),
                        name = "amount",
                        isRequired = true
                    },
                }
            })
            if menu then
                if not menu.item and not menu.amount then
                    return
                else
                    if menu.item and tonumber(menu.amount) > 0 then
                        TriggerServerEvent('mh-scrapyardjob:server:buyStashItem', menu.item, tonumber(menu.amount), currentBase, currentZone)
                    else
                        return
                    end
                end
            end
        else
            QBCore.Functions.Notify(Lang:t('shop.sold_out'), "error", 5000)
        end
    end, currentBase, args.type)
end)

-- Blips updater
RegisterNetEvent('mh-scrapyardjob:client:updateBlips', function()
    if zones.blips then
        for _, v in pairs(zones.blips) do
            RemoveBlip(v)
        end
    end
    zones.blips = {}
    QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
        for ZoneName, allZones in pairs(Config.Zones) do
            for k, z in pairs(allZones) do
                if data.gang or data.auth or data.job or data.public then
                    if k == "scraps" then
                        for _, scraps in pairs(Config.Zones[ZoneName][k]) do
                            if scraps.blip.show then
                                CreateBlips(scraps)
                            end
                        end
                    end
                end
                if data.job then
                    if k == "stash" then
                        for _, stash in pairs(Config.Zones[ZoneName][k]) do
                            if stash.blip.show then
                                CreateBlips(stash)
                            end
                        end
                    end
                    if k == "garages" then
                        for _, garage in pairs(Config.Zones[ZoneName][k]) do
                            if garage.blip.show then
                                CreateBlips(garage)
                            end
                        end
                    end
                end
            end
        end
    end)
end)

-------------------------------- Threads --------------------------------
-- If player is in laststand or dead the mission fails
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if isMissionEnable then
                -- check if this player has permission.
                QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
                    if data.gang or data.auth or data.job or data.public then 
                        if PlayerData.metadata["inlaststand"] or PlayerData.metadata["isdead"] then 
                            if not missionFailNotify then
                                missionFailNotify = true
                                ResetMission()
                                PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 0)
                                QBCore.Functions.Notify(Lang:t('notify.job_failed'), "error", 10000)
                            end
                        end
                    end
                end)
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Notify almost at dump location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if currentMissionCoords ~= nil and not notifyMissionCoords and destroyVehicle ~= nil then
                if #(GetEntityCoords(PlayerPedId()) - currentMissionCoords) <= 50.0 then
                    notifyMissionCoords = true
                    QBCore.Functions.Notify(Lang:t('notify.almost_on_dump_location'), "success", 15000)
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

-- If vehicle is dropped at drop location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if isvehicleDropped then RunTimer(destroyVehicle) end
        end
        Citizen.Wait(1000)
    end
end)

-- check the vehicle im in
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if IsPedInAnyVehicle(PlayerPedId()) and Config.Access['jobs'][PlayerData.job.name] and PlayerData.job.onduty and not isMissionEnable and truck == nil then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                if vehicle then
                    local props = QBCore.Functions.GetVehicleProperties(vehicle)
                    if props then
                        local displaytext = GetDisplayNameFromVehicleModel(props.model)
                        local carModelName = GetLabelText(displaytext)
                        if carModelName:lower() == "flatbed" then
                            truck = vehicle
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Go to dump location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            -- needed to check mission
            if isMissionEnable then
                local vehicle = GetVehiclePedIsIn(PlayerPedId())
                local plate = QBCore.Functions.GetPlate(vehicle)
                if plate == missionPlate and jobvehicleBlip ~= nil then
                    missionBlip = CreateMissionBlip(Config.Zones[lastBase]['drops'][currentDropzone].name, Config.Zones[lastBase]['drops'][currentDropzone].coords, 527)
                    QBCore.Functions.Notify(Lang:t('notify.go_to_dupm_location'), "success", 10000)
                    RemoveBlip(jobvehicleBlip)
                    jobvehicleBlip = nil 
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Return to home
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local vehicle = GetVehiclePedIsIn(PlayerPedId())
            local plate = QBCore.Functions.GetPlate(vehicle)
            local coords = GetEntityCoords(PlayerPedId())
            if returnBackHome then
                if #(coords - backLoc) <= 5.0 then
                    returnBackHome = false
                    if plate == missionPlate and vehicle == missionVehicle then
                        PlaySoundFrontend(-1, "PROPERTY_PURCHASE", "HUD_AWARDS", 0)
                        RemoveBlip(homeBlip)
                        DeleteEntity(missionVehicle)
                        DeleteVehicle(missionVehicle)

                        TriggerServerEvent("mh-scrapyardjob:server:GetItems", missionAction)
                        Citizen.Wait(500)
                        missionAction = nil
                        ResetMission()
                        Reset()
                        QBCore.Functions.Notify(Lang:t('notify.job_done_good_work'), "success", 10000)
                    else
                        Reset()
                        ResetMission()
                        PlaySoundFrontend(-1, "LOSER", "HUD_AWARDS", 0)
                        QBCore.Functions.Notify(Lang:t('notify.wrong_vehicle'), "error", 10000)
                    end
                end 
            end
        end
        Citizen.Wait(1000)
    end
end)

-- Draw drop location
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            if isMissionEnable and destroyVehicle ~= nil then
                DrawDropLocation(GetEntityCoords(PlayerPedId()))
            end
        end
        Citizen.Wait(0)
    end
end)

-- Brake vehicle windows 
CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isScrapBusy and scrapTime > 0 and isStarted and tmpVehicle ~= nil and enable1 and isInScrapZone then
            enable1 = false
            BrakeAllWindowsSlow(tmpVehicle)
        end
    end
end)

-- Brake vehicle wheels 
CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isScrapBusy and scrapTime > 0 and isStarted and tmpVehicle ~= nil and enable2 and isInScrapZone then
            enable2 = false
            BrakeAllWheels(tmpVehicle)
        end
    end
end)

-- Brake vehicle doors 
CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isScrapBusy and scrapTime > 0 and isStarted and tmpVehicle ~= nil and enable3 and isInScrapZone then
            enable3 = false
            BrakeAllDoorsSlow(tmpVehicle)
        end
    end
end)

-- Toggle duty (target)
CreateThread(function()
    for zoneName, allZones in pairs(Config.Zones) do -- Config.Zones['scrapyard']['base']
        for k, z in pairs(allZones) do
            for _, zone in pairs(z) do
                if zone and zone.vectors then
                    if k == "duty" then
                        exports["qb-target"]:RemoveZone("scrapyardjob_"..k)
                        exports['qb-target']:AddBoxZone("scrapyardjob_"..k, v, 1, 1, {
                            name = "scrapyardjob_"..k,
                            heading = 11,
                            debugPoly = Config.DebugPoly,
                            minZ = v.z - 1,
                            maxZ = v.z + 1,
                        }, {
                            options = {
                                {
                                    type = "client",
                                    event = "mh-scrapyardjob:client:ToggleDuty",
                                    icon = "fas fa-sign-in-alt",
                                    label = Lang:t('job.onduty'),
                                    job = "scrapyard",
                                },
                            },
                            distance = 1.5
                        })
                    end
                end
            end
        end
    end
end)

-- Open Shop Stash (target)
CreateThread(function()
    for zoneName, allZones in pairs(Config.Zones) do -- Config.Zones['scrapyard']['base']
        for k, z in pairs(allZones) do
            for _, zone in pairs(z) do
                if zone and zone.vectors then
                    if k == "stash" then
                        exports["qb-target"]:RemoveZone("scrapyardstash_"..k)
                        exports['qb-target']:AddBoxZone("scrapyardstash_"..k, v.coords, v.length, v.wide, {
                            name = "scrapyardstash_"..k,
                            heading = v.heading,
                            debugPoly = Config.DebugPoly,
                            minZ = v.coords.z - 1,
                            maxZ = v.coords.z + 1,
                        }, {
                            options = {
                                {
                                    type = "client",
                                    event = "mh-scrapyardjob:client:OpenStash",
                                    icon = "fas fa-sign-in-alt",
                                    label = Lang:t('notify.open_stash'),
                                    job = "scrapyard",
                                },
                            },
                            distance = v.distance
                        })
                    end
                end
            end
        end
    end
end)

-- Shops Blips 
CreateThread(function()
    for zoneName, allZones in pairs(Config.Zones) do -- Config.Zones['scrapyard']['base']
        for k, z in pairs(allZones) do
            if k == "shops" then
                for _, zone in pairs(z) do
                    if zone and zone.vectors and zone.blip.show then
                        local blip = AddBlipForCoord(zone.coords.x, zone.coords.y, zone.coords.z)
                        SetBlipSprite(blip, zone.blip.sprite)
                        SetBlipScale(blip, zone.blip.scale)
                        SetBlipColour(blip, zone.blip.color)
                        SetBlipAsShortRange(blip, true)
                        BeginTextCommandSetBlipName('STRING')
                        AddTextComponentString(zone.blip.label)
                        EndTextCommandSetBlipName(blip)
                    end
                end
            end
        end
    end
end)

-- Zone Checker
CreateThread(function()
    while true do
        if LocalPlayer.state.isLoggedIn then
            local pos = GetEntityCoords(PlayerPedId())
            local isPointInsideBass = basecombo:isPointInside(pos)
            --
            if isPointInsideBass then
                for k, v in pairs(basecombo.zones) do 
                    currentBase = v.name 
                end
                lastBase = currentBase
                isInBaseZone = true
            else
                if isInBaseZone then 
                    lastBase = currentBase
                    currentBase = nil 
                end
                isInBaseZone = false
            end

            -- Shop Combo Check
            if shopcombo:isPointInside(pos) then 
                currentZone = "shops"
                if isShopBusy then exports['qb-core']:HideText() end
                if not isShopBusy then
                    exports['qb-core']:DrawText(Lang:t('notify.open_shop'))
                    Listen4ShopControl()
                end
                isInShopZone = true 
            else
                if isInShopZone then
                    lastZone = currentZone
                    currentZone = nil
                    exports['qb-core']:HideText() 
                end
                isShopBusy = false
                isInShopZone = false
            end

            -- Scraps Combo Check
            if scrapcombo:isPointInside(pos) then 
                currentZone = "scraps"
                local hasPermission = false
                QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
                    if data.gang or data.auth or data.job or data.public then 
                        if isScrapBusy then exports['qb-core']:HideText() end
                        if IsPedInAnyVehicle(PlayerPedId()) and not isScrapBusy then
                            if not cooldown then
                                exports['qb-core']:DrawText(Lang:t('notify.get_out_vehicle'))
                            end
                        else
                            local _, distance = QBCore.Functions.GetClosestVehicle(pos) 
                            if distance <= Config.InteractDistance then
                                if not IsPedInAnyVehicle(PlayerPedId()) and not isScrapBusy then
                                    if not cooldown then 
                                        exports['qb-core']:DrawText(Lang:t('menu.menu_popup'))
                                        Listen4ScrapControl()
                                    end
                                end
                            else
                                if isInScrapZone then
                                    exports['qb-core']:HideText() 
                                end
                            end
                        end
                    end
                end)
                isInScrapZone = true
            else 
                if isInScrapZone then
                    isInScrapZone = false
                    lastZone = currentZone
                    currentZone = nil
                    exports['qb-core']:HideText() 
                end
                isScrapBusy = false
            end

            -- Garages Combo Check
            if garagescombo:isPointInside(pos) then 
                currentZone = "garages"
                if isGarageBusy then exports['qb-core']:HideText() end
                if not isGarageBusy then
                    if IsPedInAnyVehicle(PlayerPedId()) then
                        exports['qb-core']:DrawText(Lang:t('notify.park_garage'))
                    else
                        exports['qb-core']:DrawText(Lang:t('notify.open_garage'))
                    end
                    Listen4GarageControl()
                end
                isInGarageZone = true
            else 
                if isInGarageZone then
                    lastZone = currentZone
                    currentZone = nil
                    exports['qb-core']:HideText() 
                end
                isGarageBusy = false
                isInGarageZone = false
            end

            -- Drop Combo Check
            if dropcombo:isPointInside(pos) then
                currentZone = "drops"
                isInDropZone = true
                local hasPermission = false
                QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:IsAllowed", function(data)
                    if data.gang or data.auth or data.job or data.public then hasPermission = true end
                    if hasPermission then
                        if IsPedInAnyVehicle(PlayerPedId()) and currentDropzone and destroyVehicle ~= nil then
                            if not homeBlip then
                                exports['qb-core']:DrawText(Lang:t('notify.drop_vehicle'))
                                Listen4DropControl()
                            end
                        end
                    end
                end)
            else
                if isInDropZone then
                    lastZone = currentZone
                    currentZone = nil 
                    exports['qb-core']:HideText() 
                end
                isInDropZone = false
            end
            -- print(currentBase, currentZone)
        end
        Citizen.Wait(1000)
    end
end)

CreateThread(function()
    while true do
        if currentobject then
            DisplayHelpText("Druk op [E] om het onderdeel te intalleren")
            if IsControlJustReleased(0, Config.InteractButton) then
                isUsingCommand = true
            end
        end
        if isUsingCommand then
            isUsingCommand = false
            InstallCarPropFromPed()
        end
        Wait(0)
    end
end)

if Config.UseTarget then
    CreateThread(function()
        for job, allZones in pairs(Config.Zones) do
            for name, z in pairs(allZones) do
                if name == "duty" then
                    for zone, v in pairs(z) do
                        exports["qb-target"]:RemoveZone("scrapyardjob_"..name)
                        exports['qb-target']:AddBoxZone("scrapyardjob_"..name, v.coords, v.length, v.wide, {
                            name = "scrapyardjob_"..name,
                            heading = 11,
                            debugPoly = Config.DebugPoly,
                            minZ = v.coords.z - 1,
                            maxZ = v.coords.z + 1,
                        }, {
                            options = {
                                {
                                    type = "client",
                                    event = "mh-scrapyardjob:client:ToggleDuty",
                                    icon = "fas fa-sign-in-alt",
                                    label = Lang:t('job.target_onduty'),
                                    job = "scrapyard",
                                },
                                {
                                    type = "client",
                                    event = "mh-scrapyardjob:client:ToggleDuty",
                                    icon = "fas fa-sign-out-alt",
                                    label = Lang:t('job.target_offduty'),
                                    job = "scrapyard",
                                },
                            },
                            distance = v.distance
                        })
                    end
                end
                -- Open Shop Stash (target)
                if name == "stash" then
                    for zone, v in pairs(z) do
                        exports["qb-target"]:RemoveZone("scrapyardstash_"..name)
                        exports['qb-target']:AddBoxZone("scrapyardstash_"..name, v.coords, v.length, v.wide, {
                            name = "scrapyardstash_"..name,
                            heading = v.heading,
                            debugPoly = Config.DebugPoly,
                            minZ = v.coords.z - 1,
                            maxZ = v.coords.z + 1,
                        }, {
                            options = {
                                {
                                    type = "client",
                                    event = "mh-scrapyardjob:client:OpenStash",
                                    icon = "fas fa-sign-in-alt",
                                    label = Lang:t('notify.open_stash'),
                                    job = "scrapyard",
                                },
                            },
                            distance = v.distance
                        })
                    end
                end
            end
        end
    end)
else
    -- Toggle Duty
    local dutyZones = {}
    local inDuty = false
    for job, allZones in pairs(Config.Zones) do
        for name, z in pairs(allZones) do
            if name == "duty" then
                for zone, v in pairs(z) do
                    local box = BoxZone:Create(vector3(vector3(v.coords.x, v.coords.y, v.coords.z)), v.length, v.wide, {name="box_zone", debugPoly = Config.DebugPoly, minZ = v.coords.z - 1, maxZ = v.coords.z + 1})
                    dutyZones[#dutyZones+1] = box
                end
            end
        end
    end
    local dutyCombo = ComboZone:Create(dutyZones, {name = "dutyCombo", debugPoly = Config.DebugPoly})
    dutyCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            inDuty = true
            if not PlayerData.job.onduty then
                exports['qb-core']:DrawText(Lang:t('job.onduty'),'left')
            else
                exports['qb-core']:DrawText(Lang:t('job.offduty'),'left')
            end
        else
            inDuty = false
            exports['qb-core']:HideText()
        end
    end)
    CreateThread(function ()
        Citizen.Wait(1000)
        while true do
            local sleep = 1000
            if inDuty and PlayerData.job.name == "scrapyard" then
                sleep = 5
                if IsControlJustReleased(0, 38) then 
                    TriggerEvent("mh-scrapyardjob:client:ToggleDuty")
                    exports['qb-core']:HideText() 
                end
            end
            Citizen.Wait(sleep)
        end
    end)
    -- Stash Interact Zones 
    local stashZones = {}
    local isInStash = false
    local isStashBusy = false
    for job, allZones in pairs(Config.Zones) do
        for name, z in pairs(allZones) do
            if name == "stash" then
                for zone, v in pairs(z) do
                    local box = BoxZone:Create(vector3(vector3(v.coords.x, v.coords.y, v.coords.z)), v.length, v.wide, {name="box_zone", debugPoly = Config.DebugPoly, minZ = v.coords.z - 1, maxZ = v.coords.z + 1})
                    stashZones[#stashZones+1] = box
                end
            end
        end
    end
    local stashCombo = ComboZone:Create(stashZones, {name = "stashCombo", debugPoly = Config.DebugPoly})
    stashCombo:onPlayerInOut(function(isPointInside)
        if isPointInside then
            isInStash = true
            if not isStashBusy then
                if PlayerData.job.name == "scrapyard" then
                    if PlayerData.job.onduty then
                        isStashBusy = true
                        TriggerServerEvent("inventory:server:OpenInventory", "stash", currentBase)
                        TriggerEvent("inventory:client:SetCurrentStash", currentBase)
                    else
                        QBCore.Functions.Notify(Lang:t('job.not_onduty'), "error")
                    end
                else
                    QBCore.Functions.Notify(Lang:t('notify.no_permission'), "error")
                end
            end
        else
            if isInStash then
                exports['qb-core']:HideText()
            end
            isStashBusy = false
            isInStash = false
        end
    end)
end

RegisterNetEvent('mh-scrapyardjob:client:takeOutVehicle', function(data)
    if currentBase == "scrapyard" then
        if not IsPedInAnyVehicle(PlayerPedId()) then
            TakeOutStalling(data)
        else
            QBCore.Functions.Notify(Lang:t('notify.is_in_vehicle'), "error")
        end
    else
        QBCore.Functions.Notify(Lang:t('notify.only_remove_on_own_property'), "error")
    end
end)

RegisterNetEvent('mh-scrapyardjob:client:storeVehicle', function(data)
    if currentBase == "scrapyard" then
        StoreCar()
    else
        QBCore.Functions.Notify(Lang:t('notify.not_your_own_property'), "error")
    end
end)

RegisterNetEvent('mh-scrapyardjob:client:getVehicles', function()
    if LocalPlayer.state.isLoggedIn then
        if PlayerData ~= nil and PlayerData.job.name == "scrapyard" and PlayerData.job.onduty then
            QBCore.Functions.TriggerCallback("mh-scrapyardjob:server:GetVehicles", function(vehicles)
                local categoryMenu = {
                    {
                        header = "Scrapyard Stalling",
                        isMenuHeader = true
                    }
                }
                if vehicles ~= nil then
                    for k, vehicle in pairs(vehicles) do
                        categoryMenu[#categoryMenu + 1] = {
                            header = vehicle.vehicle,
                            txt = "",
                            params = {
                                event = 'mh-scrapyardjob:client:takeOutVehicle',
                                args = {
                                    vehicle = vehicle.vehicle,
                                    plate = vehicle.plate,
                                    fuel = vehicle.fuel,
                                    body = vehicle.body,
                                    engine = vehicle.engine,
                                }
                            },
                        }
                    end
                end
                if IsPedInAnyVehicle(PlayerPedId()) then
                    categoryMenu[#categoryMenu + 1] = {
                        header = Lang:t('menu.store'),
                            params = {
                            event = 'mh-scrapyardjob:client:storeVehicle',
                            args = {}
                        },
                    }
                end
                categoryMenu[#categoryMenu + 1] = {
                    header = "Sluit",
                    params = {event = ''}
                }
                exports['qb-menu']:openMenu(categoryMenu)
            end)
        else
            QBCore.Functions.Notify("Geen toegang", "error")
        end
    end
end)
