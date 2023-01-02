<p align="center">
    <img width="140" src="https://icons.iconarchive.com/icons/iconarchive/red-orb-alphabet/128/Letter-M-icon.png" />  
    <h1 align="center">Hi 👋, I'm MaDHouSe</h1>
    <h3 align="center">A passionate allround developer </h3>    
</p>

<p align="center">
  <a href="https://github.com/MaDHouSe79/mh-scrapyardjob/issues">
    <img src="https://img.shields.io/github/issues/MaDHouSe79/mh-scrapyardjob"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-scrapyardjob/watchers">
    <img src="https://img.shields.io/github/watchers/MaDHouSe79/mh-scrapyardjob"/> 
  </a> 
  <a href="https://github.com/MaDHouSe79/mh-scrapyardjob/network/members">
    <img src="https://img.shields.io/github/forks/MaDHouSe79/mh-scrapyardjob"/> 
  </a>  
  <a href="https://github.com/MaDHouSe79/mh-scrapyardjob/stargazers">
    <img src="https://img.shields.io/github/stars/MaDHouSe79/mh-scrapyardjob?color=white"/> 
  </a>
  <a href="https://github.com/MaDHouSe79/mh-scrapyardjob/blob/main/LICENSE">
    <img src="https://img.shields.io/github/license/MaDHouSe79/mh-scrapyardjob?color=black"/> 
  </a>      
</p>

<p align="center">
  <img alig src="https://github-profile-trophy.vercel.app/?username=MaDHouSe79&margin-w=15&column=6" />
</p>

# MH-Scrapyardjob
- With this script, players can steel any npc vehicle,
- and make this vehicle there own or get row materials or vehicle parts.

### Dependencies
- [oxmysql](https://github.com/overextended/oxmysql/releases/tag/v1.9.3) (Required)
- [qb-core](https://github.com/qbcore-framework/qb-core) (Required)
- [qb-inventory](https://github.com/qbcore-framework/qb-inventory) (Required)
- [PolyZone](https://github.com/mkafrin/PolyZone) (Required)


### Screenshot
![foto1](https://www.madirc.nl/fivem/npccarsteel/Schermafbeelding%202022-10-04%20163803.png)
![foto2](https://www.madirc.nl/fivem/npccarsteel/Schermafbeelding%202022-10-04%20163826.png)
![foto4](https://www.madirc.nl/fivem/npccarsteel/Schermafbeelding%202022-10-04%20163843.png)
![foto5](https://www.madirc.nl/fivem/npccarsteel/Schermafbeelding%202022-10-03%20174955.png)
![foto6](https://www.madirc.nl/fivem/npccarsteel/Schermafbeelding%202022-10-04%20142635.png)
![foto7](https://www.madirc.nl/fivem/npccarsteel/Schermafbeelding%202022-10-04%20163554.png)


### 🎥 Video 👊😁👍
[Video](https://www.youtube.com/c/MaDHouSe79)


### public or authorizion access
- you can set `Config.Access['public']` to `true` if players are allowed to use the scrapyard menu
- players can scrap there own vehicle for items, only if `Config.Access['public']` is `true`, 
- but thay can't use/steel npc vehicles, they have to go to tha gangs of ask the scrapyard job to do this,
- if you want to allow jobs to Tap Number Plates set `Config.JobCanTapFrameNumbers` to `true` 
- you can steel vehicles with the jobs, gangs and citizenid's authorizion inside `Config.Access`


### How it works (don't forget the `Config.Access`)
- You can steel any npc vehicle, but you can't steel player vehicles.
- You need to steel a npc vehicle, when you get the vehicle, you drive to the scrapyard location.
- When you at the scrapyard, you get out of your vehicle, and you can press [E] to open the scrapyard menu.
- You see in the menu what you can to do.


### Mission for NPC Vehicle Parts or Raw Materials. (don't forget the `Config.Access`)
- When you scrap a npc vehicle for part or materials, you have to drive the vehicle to a location on the map.
- After you dump the vehicle frame, you drive back to tha location on the map.
- When you get back to the home location, you get youre parts or materials.
- There is a cooldown so you can;t use it over and over again ;)


### Required Items for the scrap jobs.
- 1x advancedlockpick
- 1x screwdriverset
- 1x oxycutter
- 1x oxygen-tank
- 5x steel
- 1x plastic


### What if a mission fails.
- When a player is in last stand or dead, the mission fails, you dont get any items.
- if the job vehicle has to many damage, the mission fails,
- when a mission fails, also all the vehicles that you need in the job wil despawn, 
- and you can try it again after the cooldown.


### Build in Scrapyard Shop
- All the items you get from scapping vehicle you have to but in your shop stash,
- we need this, so players can buy stuff from you, don't worry the can't get in to your stash.
- i used a other menu for it so players still can buy stuff, even if you are off line.
- But if a item is not there anymore than players can't buy it, and you must add more in your shop stash.


## If you don't have this then add this in 
- `qb-management/server/sv_boss.lua` at around line 36 
- NOTE: below the AddMoney function.
```lua
exports('AddMoney', AddMoney)
```

## Add in 
- qb-core shared items, so we can sell items to other players
```lua
	-- mh-scrapyardjob items
	["engine1"]=            {["name"] = "engine1",			["label"] = "Niveau 1 Motor",	    	["weight"] = 0, ["type"] = "item",  ["image"] = "engine1.png",          ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["transmission1"]=      {["name"] = "transmission1",    ["label"] = "Niveau 1 Versnellingsbak",	["weight"] = 0, ["type"] = "item",  ["image"] = "transmission1.png",    ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["brakes1"]=            {["name"] = "brakes1",			["label"] = "Niveau 1 Remmerij",		["weight"] = 0, ["type"] = "item",        ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["suspension1"]=        {["name"] = "suspension1",		["label"] = "Niveau 1 Ophanging",	    ["weight"] = 0, ["type"] = "item",  ["image"] = "suspension1.png",      ["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["headlights"]=         {["name"] = "headlights",       ["label"] = "Xenon Koplampen",		    ["weight"] = 0, ["type"] = "item",  ["image"] = "headlights.png",           ["unique"] = false, 	["useable"] = true, ["shouldClose"] = true, ["description"] = "8k HID koplampen"},
	["hood"]=               {["name"] = "hood",             ["label"] = "Motorkap",		    	["weight"] = 0, ["type"] = "item",  ["image"] = "hood.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["roof"]=               {["name"] = "roof",             ["label"] = "Voertuigdak",			["weight"] = 0, ["type"] = "item",  ["image"] = "roof.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["spoiler"]=            {["name"] = "spoiler",          ["label"] = "Voertuigspoiler",		["weight"] = 0, ["type"] = "item",  ["image"] = "spoiler.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["bumper"]=             {["name"] = "bumper",           ["label"] = "Voertuigbumper",		["weight"] = 0, ["type"] = "item",  ["image"] = "bumper.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["skirts"]=             {["name"] = "skirts",           ["label"] = "Voertuig Skirts",		["weight"] = 0, ["type"] = "item",  ["image"] = "skirts.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["exhaust"]=            {["name"] = "exhaust",          ["label"] = "Uitlaat Voertuig",		["weight"] = 0, ["type"] = "item",  ["image"] = "exhaust.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["seat"]=               {["name"] = "seat",             ["label"] = "Stoelcosmetica",		["weight"] = 0, ["type"] = "item",  ["image"] = "seat.png", 			["unique"] = false,  ["useable"] = true, ["shouldClose"] = true, ["description"] = ""},
	["sparkplugs"]=         {["name"] = "sparkplugs",       ["label"] = "Bougies",		    	["weight"] = 0, ["type"] = "item",  ["image"] = "sparkplugs.png",       ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["carbattery"]=         {["name"] = "carbattery",       ["label"] = "Auto Accu",			["weight"] = 0, ["type"] = "item",  ["image"] = "carbattery.png",       ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	["axleparts"]=          {["name"] = "axleparts",        ["label"] = "As Onderdelen",		["weight"] = 0, ["type"] = "item",  ["image"] = "axleparts.png",        ["unique"] = false, ["useable"] = false,["shouldClose"] = false,["description"] = ""},
	['electric_scrap']=     {['name'] = 'electric_scrap', 				['label'] = 'Electric Scrap', 			['weight'] = 0, 		['type'] = 'item', 		['image'] = 'electric_scrap.png',         		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Electric Scrap'},
	['oxycutter']       			= {['name'] = 'oxycutter',          			['label'] = 'Zuurstofsnijder',      	['weight'] = 1500,		['type'] = 'item', 		['image'] = 'oxycutter.png', 	          		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Oxygen cutter, for cutting hard steel'},
	['oxygen-tank']     			= {['name'] = 'oxygen-tank', 					['label'] = 'Oxygen Tank', 				['weight'] = 500, 		['type'] = 'item', 		['image'] = 'oxygen-tank.png', 	        		['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Oxygen Tank'},
	['turbo']           			= {['name'] = 'turbo', 					    	['label'] = 'Turbo', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'turbo.png', 			        	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'Turbo'},
	['tire'] 						= {['name'] = 'tire', 							['label'] = 'tire', 					['weight'] = 100, 		['type'] = 'item', 		['image'] = 'tire.png', 			        	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'A car tire'},
	['stockrim'] 					= {['name'] = 'stockrim', 						['label'] = 'stockrim', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'stockrim.png', 		        	['unique'] = false, 	['useable'] = false, 	['shouldClose'] = false, 	['combinable'] = nil, 	['description'] = 'A Stock rim'},

```

# MISSING ITEMS NOTE 
- if there are any items missing, just add it your self.
- find a image if needed, and add a this item to shared items.
- i took this one from a live server, and in this state it works just fine with no issues.
- also check `Config.ScrapItems` / `Config.CarItems` and `Config.ShopProducts` if you have added all the items you want.

### Add in database
```sql
INSERT INTO 
- `management_funds` (`job_name`, `amount`, `type`) VALUES ('scrapyard', '0', 'boss');
```

### Add in 
- `resources/[qb]/qb-management/client/cl_config.lua` in `Config.BossMenus`
```lua
['scrapyard'] = {
    vector3(2338.6497, 3125.4343, 48.2087),
},
```

### Add in 
- `resources/[qb]/qb-management/client/cl_config.lua` in `Config.BossMenuZones`
```lua
['scrapyard'] = {
    { coords = vector3(2338.6497, 3125.4343, 48.2087), length = 1.15, width = 2.6, heading = 84.9378, minZ = 47.0, maxZ = 50.0 },
},
```

### Shared 
- `resources/[qb]/qb-core/shared/jobs.lua`
```lua
['scrapyard'] = {
	label = 'Scrapyard',
	defaultDuty = true,
	offDutyPay = false,
	grades = {
        ['0'] = {
            name = 'Recruit',
            payment = 50
        },
		['1'] = {
            name = 'Novice',
            payment = 75
        },
		['2'] = {
            name = 'Experienced',
            payment = 100
        },
		['3'] = {
            name = 'Advanced',
            payment = 125
        },
		['4'] = {
            name = 'Manager',
			isboss = true,
            payment = 150
        },
    },
},
```

### Add in 
- `resources/[qb]/qb-radialmenu/config.lua` in `Config.JobInteractions`
- So we can use the F1 menu
```lua
    ['scrapyard'] = {
        {
            id = 'scrapyardinteraction1',
            title = 'Scrapyard Garage',
            icon = 'list-check',
            items = {
                { -- 
                    id = 'smenu0001',
                    title = 'Take from garage',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:getVehicles',
                    shouldClose = true,
                },

                {
                    id = 'smenu0002',
                    title = 'PArk in garage',
                    icon = 'circle-info',
                    type = 'client',
                    event = "mh-scrapyardjob:client:storeVehicle",
                    shouldClose = true,
                },
            }
        },
        {
            id = 'scrapyardinteraction2',
            title = 'Scrapyard Actions',
            icon = 'list-check',
            items = {
                { -- 
                    id = 'smenu0',
                    title = 'Toggle Marker',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:toggleMarker',
                    shouldClose = true,
                },{ 
                    id = 'smenu000',
                    title = 'Attach Vehicle',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:attachVehicle',
                    shouldClose = true,
                },{ 
                    id = 'smenu00',
                    title = 'Detach Vehicle',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:detachVehicle',
                    shouldClose = true,
                },
            }
        },{
            id = 'scrapyardobjects',
            title = 'Onderdelen',
            icon = 'road',
            items = {
                {
                    id = 'smenu2',
                    title = 'Door',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawndoor',
                    shouldClose = true,
                },{
                    id = 'smenu3',
                    title = 'Brake',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawnbrake',
                    shouldClose = true,
                },{
                    id = 'smenu4',
                    title = 'Engine',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawnengine',
                    shouldClose = true,
                },{
                    id = 'smenu5',
                    title = 'Wheel',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawnwheel',
                    shouldClose = true,
                },{
                    id = 'smenu5',
                    title = 'Seat',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawnseat',
                    shouldClose = true,
                },{
                    id = 'smenu5',
                    title = 'Trunk',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawntrunk',
                    shouldClose = true,
                },{
                    id = 'smenu5',
                    title = 'Exhaust',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawnexhaust',
                    shouldClose = true,
                },{
                    id = 'smenu5',
                    title = 'Tranny',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawntranny',
                    shouldClose = true,
                },{
                    id = 'smenu5',
                    title = 'Bonnet',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:spawnbonnet',
                    shouldClose = true,
                },{
                    id = 'smenu10',
                    title = 'Delete Props',
                    icon = 'circle-info',
                    type = 'client',
                    event = 'mh-scrapyardjob:client:deleteall',
                    shouldClose = true,
                },
            },
        },{
            {
                id = 'scrapyardobjects09',
                title = 'Facturen',
                icon = 'road',
                items = {
                    {
                        id = 'smenu0',
                        title = 'Create Bill',
                        icon = 'circle-info',
                        type = 'client',
                        event = 'mh-scrapyardjob:client:createbill',
                        shouldClose = true,
                    }
                }
            },
        }
    }
```

### 🐞 Any bugs issues or suggestions, let my know. 👊😎

### 🙈 Youtube & Discord
- [Youtube](https://www.youtube.com/c/MaDHouSe79)
- [Discord](https://discord.gg/cEMSeE9dgS)

# LICENSE
[GPL LICENSE](./LICENSE)<br />
&copy; [MaDHouSe79](https://www.youtube.com/@MaDHouSe79)
