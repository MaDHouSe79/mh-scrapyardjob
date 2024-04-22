--[[ ===================================================== ]]--
--[[          MH Scrapyard Job Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local QBCore = exports['qb-core']:GetCoreObject()

-- Is Authorized
local function IsAuthorized(id)
    local Player = QBCore.Functions.GetPlayer(id)
    local isAllowed = false
    if Player then
        for k, citizenid in pairs(Config.Access['citizenids']) do
            if citizenid == Player.PlayerData.citizenid then
                isAllowed = true
            end
        end      
    end
    return isAllowed
end

-- Is Authorized Gang
local function IsAuthorizedGang(id)
    local Player = QBCore.Functions.GetPlayer(id)
    local isAllowed = false
    if Player then
        for k, gang in pairs(Config.Access['gangs']) do
            for j, rank in pairs(gang.ranks) do
                if k == Player.PlayerData.gang.name and Player.PlayerData.gang.grade.level >= rank then
                    isAllowed = true
                end
            end
        end
    end
    return isAllowed
end

-- Is Authorized Job
local function IsAuthorizedJob(id)
    local Player = QBCore.Functions.GetPlayer(id)
    local isAllowed = false
    if Player then
        for k, job in pairs(Config.Access['jobs']) do
            if k == Player.PlayerData.job.name then
                for j, rank in pairs(job.ranks) do
                    if Player.PlayerData.job.grade.level >= rank and Player.PlayerData.job.onduty then
                        isAllowed = true
                    end
                end
            end
        end
    end
    return isAllowed
end

-- Is Allowed
local function IsAllowed(id)
    local isAllowed = false
    if IsAuthorized(id) then 
        isAllowed = true  
    elseif IsAuthorizedGang(id) then 
        isAllowed = true 
    elseif IsAuthorizedJob(id) then
        isAllowed = true 
    end
    if Config.Access['public'] then isAllowed = true end
    return isAllowed
end

-- Is Vehicle Owner
local function IsVehicleOwner(citizenid, plate)
    local isFound = false
    local retval = false
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE citizenid = ? AND plate = ?', {citizenid, plate})
    if result then retval = true end
    return retval
end

-- Generate Plate
local function GeneratePlate()
    local plate = QBCore.Shared.RandomInt(1) .. QBCore.Shared.RandomStr(2) .. QBCore.Shared.RandomInt(3) .. QBCore.Shared.RandomStr(2)
    local result = MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', {plate})
    if result then return GeneratePlate() else return plate:upper() end
end

-- Has Paid For The Itme
local function HasPaidForTheItme(target, price)
    local hasPaid = false
    if target.Functions.RemoveMoney('cash', price) then
        hasPaid = true
    end
    return hasPaid
end

-- Give Raw Metarials
local function GiveRawMetarials(id)
    local Player = QBCore.Functions.GetPlayer(id)
    if Player then
        for i = 1, math.random(2, 4), 1 do
            local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
            local amount = math.random(Config.MinItems, Config.MaxItems)
            Player.Functions.AddItem(item, amount)
            TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items[item], 'add', amount)
            Citizen.Wait(800)
        end
        if math.random(1, 8) == math.random(1, 8) then
            local random = math.random(10, 20)
            Player.Functions.AddItem("rubber", random)
            TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["rubber"], 'add', random)
        end
    end
end

-- Give Car Parts
local function GiveCarParts(id)
    local Player = QBCore.Functions.GetPlayer(id)
    if Player then
        Player.Functions.AddItem("rims", 4)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["rims"], 'add', 4)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("tires", 4)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["tires"], 'add', 4)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("transmission1", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["transmission1"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("engine1", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["engine1"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("brakes1", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["brakes1"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("suspension1", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["suspension1"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("headlights", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["headlights"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("hood", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["hood"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("roof", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["roof"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("spoiler", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["spoiler"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("bumper", 2)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["bumper"], 'add', 2)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("skirts", 2)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["skirts"], 'add', 2)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("exhaust", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["exhaust"], 'add', 1)
        Citizen.Wait(500)
        --
        Player.Functions.AddItem("seat", 2)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["seat"], 'add', 2)
        Citizen.Wait(500)
         --
        Player.Functions.AddItem("sparkplugs", 4)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["sparkplugs"], 'add', 4)
        Citizen.Wait(500)
         --
        Player.Functions.AddItem("carbattery", 1)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["carbattery"], 'add', 1)
        Citizen.Wait(500)
         --
        Player.Functions.AddItem("axleparts", 2)
        TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["axleparts"], 'add', 2)
        Citizen.Wait(500)
         --

        if math.random(1, 8) == math.random(1, 10) then
            Player.Functions.AddItem("turbo", 1)
            TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items["turbo"], 'add', 1)
        end
        
        for i = 1, math.random(2, 4), 1 do
            local item = Config.ScrapItems[math.random(1, #Config.ScrapItems)]
            local amount = math.random(Config.MinItems, Config.MaxItems)
            Player.Functions.AddItem(item, amount)
            TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items[item], 'add', amount)
            Citizen.Wait(800)
        end
    end
end

local function UpdateStash(id, stashId, item, amount, price)
    local Player = QBCore.Functions.GetPlayer(id)
    local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
	if result then
		local stashItems = json.decode(result)
		if stashItems then
			for i, v in pairs(stashItems) do
                if v.name == item then
                    if stashItems[i].amount >= amount then
                        if HasPaidForTheItme(Player, price) then
                            stashItems[i].amount = stashItems[i].amount - amount
                            if stashItems[i].amount <= 0 then stashItems[i] = nil end
                            MySQL.insert('INSERT INTO stashitems (stash, items) VALUES (:stash, :items) ON DUPLICATE KEY UPDATE items = :items', {
                                ['stash'] = stashId,
                                ['items'] = json.encode(stashItems)
                            })
                            Player.Functions.AddItem(item, amount)
                            TriggerClientEvent('inventory:client:ItemBox', id, QBCore.Shared.Items[item], "add", amount)
                            if Config.PayMoneyToJobCompany then exports['qb-management']:AddMoney(stashId, price) end
                        else
                            TriggerClientEvent('QBCore:Notify', id, Lang:t('notify.not_enough_money'), 'error')
                        end
                    else
                        TriggerClientEvent('QBCore:Notify', id, Lang:t('notify.not_enough_items'), 'error')
                    end
                    TriggerClientEvent('mh-scrapyardjob:client:close', id)
                end
            end
        end
    end
end

local function tableLength(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

-- Get Stash Items for shop
local function GetStashItems(stashId, action)
	local items = {}
	local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {stashId})
	if result then
		local stashItems = json.decode(result)
		if stashItems then
			for _, item in pairs(stashItems) do
                if item ~= nil then
                    local tmpData = {}
                    local isFound = false
                    if action == "parts" then
                        tmpData = Config.CarItems
                    elseif action == "materials" then
                        tmpData = Config.ScrapItems
                    end
                    for _, v in pairs(tmpData) do
                        if v ~= nil then
                            if v == item.name then 
                                isFound = true
                                break 
                            end
                        end
                    end
                    if isFound then
                        local itemInfo = QBCore.Shared.Items[item.name:lower()]
                        if itemInfo then
                            items[item.slot] = {
                                name = itemInfo["name"],
                                amount = tonumber(item.amount),
                                info = item.info or "",
                                label = itemInfo["label"],
                                description = itemInfo["description"] or "",
                                weight = itemInfo["weight"],
                                type = itemInfo["type"],
                                unique = itemInfo["unique"],
                                useable = itemInfo["useable"],
                                image = itemInfo["image"],
                                slot = item.slot,
                            }
                        end
                    end
                end
			end
		end
	end
	return items, tableLength(items)
end


-- Callback Is Allowed
QBCore.Functions.CreateCallback("mh-scrapyardjob:server:IsAllowed", function(source, cb)
    local src = source
    local data = { 
        job = IsAuthorizedJob(src), 
        auth = IsAuthorized(src), 
        gang = IsAuthorizedGang(src), 
        public = Config.Access['public']
    }
    cb(data)
end)

-- Callback has Items
QBCore.Functions.CreateCallback("mh-scrapyardjob:server:hasItems", function(source, cb, actionType)
    local src = source
    if not IsAllowed(src) then 
        TriggerClientEvent('mh-scrapyardjob:client:close', src)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.no_permission'), 'error')
    else  
        local Player = QBCore.Functions.GetPlayer(src)
        local hasItems = 0
        local deleteItems = false
        if Player then
            local tmpData = {}
            if actionType == 'steeling' then
                tmpData = Config.NeededItems['steeling']
            elseif actionType == 'scrapping' then
                tmpData = Config.NeededItems['scrapping']
            elseif actionType == 'deleting' then
                tmpData = Config.NeededItems['deleting']
            end
            for i = 1, #tmpData do
                if Player.Functions.GetItemByName(tmpData[i].name) then
                    if Player.Functions.GetItemByName(tmpData[i].name).amount >= tmpData[i].needed then
                        hasItems = hasItems + 1
                    end
                else
                    hasItems = hasItems - 1
                end
            end
        end
        if hasItems <= 0 then hasItems = 0 end
        cb(hasItems)
    end
end)

QBCore.Functions.CreateCallback("mh-scrapyardjob:server:GetMissingItems", function(source, cb, action)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tmpData = nil
    if action == "steeling" then
        tmpData = Config.NeededItems['steeling']
    elseif action == "scrapping" then
        tmpData = Config.NeededItems['scrapping']
    elseif action == "deleting" then
        tmpData = Config.NeededItems['deleting']
    end
    local items = {}
    for k, item in pairs(tmpData) do
        if not Player.Functions.GetItemByName(item.name) then
            items[#items + 1] = {name = item.name, image = QBCore.Shared.Items[item.name].image}
        end
    end
    cb(items)
end)

-- Callback is Owner
QBCore.Functions.CreateCallback("mh-scrapyardjob:server:isOwner", function(source, cb, plate)
    local src = source
    local founded = false
    local pData = QBCore.Functions.GetPlayer(src)
    MySQL.Async.fetchAll("SELECT * FROM player_vehicles WHERE citizenid = ?", {pData.PlayerData.citizenid}, function(vehicles)
        for k, v in pairs(vehicles) do
            if v.plate == plate then founded = true end
        end
        cb(founded)
    end)
end)

-- Callback has Owner
QBCore.Functions.CreateCallback("mh-scrapyardjob:server:hasOwner", function(source, cb, plate)
    local founded = false
    MySQL.Async.fetchAll("SELECT * FROM player_vehicles", {}, function(vehicles)
        for k, v in pairs(vehicles) do
            if v.plate == plate then founded = true end
        end
        cb(founded)
    end)
end)

-- Callback save npc vehicle
QBCore.Functions.CreateCallback("mh-scrapyardjob:server:savenpcvehicle", function(source, cb, data)
    local src = source
    if not IsAllowed(src) then 
        TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.no_permission'), 'error') 
    else   
        local Player = QBCore.Functions.GetPlayer(src)
        Citizen.Wait(500)
        local plate = GeneratePlate()
        data.props.plate = plate
        MySQL.Async.insert('INSERT INTO player_vehicles (license, citizenid, vehicle, hash, mods, plate, state, garage) VALUES (?, ?, ?, ?, ?, ?, ?, ?)', {
            Player.PlayerData.license, Player.PlayerData.citizenid, data.modelname, GetHashKey(data.model), json.encode(data.props), plate, 1, 'pillboxgarage'
        })
        Citizen.Wait(20)
        if IsVehicleOwner(Player.PlayerData.citizenid, plate) then
            MySQL.update('UPDATE player_vehicles SET mods = ? WHERE plate = ?', {json.encode(data.props), plate})
        end
        Citizen.Wait(50)
        TriggerClientEvent('mh-scrapyardjob:client:delete', -1, data.vehicle)
        TriggerClientEvent('mh-scrapyardjob:client:close', src)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.own_the_vehicle'), 'success')
    end
end)

-- Callback get Stash Items
QBCore.Functions.CreateCallback("mh-scrapyardjob:server:getStashItems", function(source, cb, job, action)
    local itemsFound, count = GetStashItems(job, action)
    cb(itemsFound, count)
end)

QBCore.Functions.CreateCallback('mh-scrapyardjob:server:GetOnlineCops', function(source, cb)
    local result = QBCore.Functions.GetDutyCount('police')
    if result ~= nil or result >= 0 then cb(result) else cb(0) end
end)

QBCore.Functions.CreateCallback("mh-scrapyardjob:server:GetVehicleProperties", function(source, cb, plate)
    local properties = {}
    local result = MySQL.query.await('SELECT mods FROM scrapyard_vehicles WHERE plate = ? LIMIT 1', {plate})
    if result[1] ~= nil then
        properties = json.decode(result[1].mods)
    end
    cb(properties)
end)

QBCore.Functions.CreateCallback("mh-scrapyardjob:server:SaveVehicle", function(source, cb, data)
    local src = source
    local founded = false
    MySQL.Async.fetchAll("SELECT * FROM player_vehicles", {}, function(vehicles)
        for k, v in pairs(vehicles) do
            if v.plate == data.plate then 
                founded = true 
            end
        end
        if not founded then
            Player = QBCore.Functions.GetPlayer(src)
            MySQL.Async.execute("INSERT INTO scrapyard_vehicles (plate, citizenid, vehicle, hash, mods) VALUES (?, ?, ?, ?, ?)", {
                data.plate, 
                Player.PlayerData.citizenid, 
                data.vehicle, 
                data.hash, 
                json.encode(data.mods)
            })
            cb(true)
        else
            cb(false)
        end
    end)
end)

RegisterServerEvent('mh-scrapyardjob:server:DeleteVehicle', function(plate)
    MySQL.Async.execute('DELETE FROM scrapyard_vehicles WHERE plate = ? LIMIT 1', {plate})
end)

QBCore.Functions.CreateCallback("mh-scrapyardjob:server:GetVehicles", function(source, cb)
    MySQL.Async.fetchAll('SELECT * FROM scrapyard_vehicles', {}, function(result)
		if result[1] ~= nil then
			cb(result)
		else
			cb(nil)
		end
    end)
end)

-- Event Delete My Vehicle
RegisterNetEvent('mh-scrapyardjob:server:DeleteMyVehicle', function(vehicle, plate)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not IsVehicleOwner(Player.PlayerData.citizenid, plate) then
        TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.not_the_owner'), 'error')
    else
        MySQL.Async.execute('DELETE FROM player_vehicles WHERE plate = ? AND citizenid = ?', {plate, Player.PlayerData.citizenid})
        GiveRawMetarials(src)
    end
end)

-- Event Get Items
RegisterNetEvent('mh-scrapyardjob:server:GetItems', function(scrapType)
    local src = source
    if scrapType == "materials" then GiveRawMetarials(src) end
    if scrapType == "parts" then GiveCarParts(src) end
    TriggerClientEvent('mh-scrapyardjob:client:close', src)
end)

-- Event Get Items
RegisterNetEvent('mh-scrapyardjob:server:RemoveItems', function(action)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tmpData = Config.NeededItems[action]
    for i = 1, #tmpData do
        if tmpData[i] then
            if tmpData[i].name ~= "oxycutter" or tmpData[i].name ~= "screwdriverset" or tmpData[i].name ~= "advancedlockpick" then
                Player.Functions.RemoveItem(tmpData[i].name, tmpData[i].needed)
                TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[tmpData[i].name], "remove", tmpData[i].needed)
                Citizen.Wait(500)
            end
        end
    end
    TriggerClientEvent('mh-scrapyardjob:client:close', src)
end)

-- Buy Stash Item
RegisterNetEvent('mh-scrapyardjob:server:buyStashItem', function(item, amount, currentBase, currentZone)
    local src = source
    local result = MySQL.scalar.await('SELECT items FROM stashitems WHERE stash = ?', {currentBase})
    if result then
        local topay = 0
        for k, shops in pairs(Config.Zones[currentBase][currentZone]) do
            for k, v in pairs(shops.products) do
                if v.name == item then
                    topay = v.price * amount
                    break
                end
            end
        end
        UpdateStash(src, currentBase, item, amount, topay)
    else
        TriggerClientEvent('mh-scrapyardjob:client:close', src)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('notify.not_in_stock'), 'error', 5000)
    end
end)

Citizen.CreateThread(function()
    Wait(5000)
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS `scrapyard_vehicles` (
        `id` int(10) NOT NULL AUTO_INCREMENT,
        `citizenid` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        `plate` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        `vehicle` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        `hash` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
        `mods` longtext COLLATE utf8mb4_unicode_ci DEFAULT NULL,
        PRIMARY KEY (`id`) USING BTREE
        ) ENGINE=InnoDB AUTO_INCREMENT=1 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci ROW_FORMAT=DYNAMIC;
    ]])
end)
