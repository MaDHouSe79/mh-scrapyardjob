--[[ ===================================================== ]]--
--[[          MH Scrapyard Job Script by MaDHouSe          ]]--
--[[ ===================================================== ]]--

local Translations = {
    job = {
        ['garage_label'] = "Scrapyard Garage",
        ['menu_garage'] = "Job Garage",
        ['onduty'] = "Sign In",
        ['offduty'] = "Sign Out",
        ['open_shop_stash'] = "Open Shop Stock",
        ['not_onduty'] = "You are not onduty",
        ['duty_clock'] = "Duty Clock",
    },
    blip = {
        ['name'] = "Scrapyard",
        ['scrap'] = "Scrap Point",
        ['go_back'] = "Go Back",
        ['job_vehicle'] = "Job Vehicle",
    },
    shop = {
        ['shop_name'] = "Scrapyard Shop",
        ['shop_stash'] = "Shop Stash",
        ['buy_materials'] = "Buy Materials",
        ['buy_pars'] = "Buy Parts",
        ['buying'] = "Buying",
        ['amount'] = "Aantal",
        ['select_material'] = "Select Material",
        ['select_part'] = "Selecteer Part",
        ['in_stock'] = " Stock %{amount}x $%{price}",
        ['sold_out'] = "All used parts are sold out",
    },
    menu = {
        ['main_header'] = "Scrap Options",
        ['main_header2'] = "My Vehicle Options",
        ['main_header3'] = "NPC Vehicle Options",
        ['main_header4'] = "Job Options",
        ['menu_title1'] = "Overwrite plate",
        ['menu_title2'] = "Demolish vehicle (Materials)",
        ['menu_title3'] = "Demolish vehicle (Parts)",
        ['menu_close'] = "Close",
        ['menu_popup'] = "[E] - Vehicle Options",
        ['menu_back'] = "Back",
        ['menu_destroy_vehicle_for_materials'] = "Demolish vehicle for materials",
        ['menu_destroy_vehicle_for_parts'] = "Demolish vehicle for car parts",
        ['new_plate_and_owner'] = "Create a new plate for a new owner",
        ['take_vehicle'] = "Take the flatbed",
        ['park_vehicle'] = "Park the flatbed",
        ['vehicle_menu'] = {
            ['header'] = "Flatbed Menu",
            ['lock_vehicle'] = "Secure vehicle",
            ['unlock_vehicle'] = "Detach vehicle",
        },
    },
    notify = {
        ['open_garage'] = "[E] - Open Garage",
        ['park_garage'] = "[E] - Park Vehicle",
        ['open_shop'] = "[E] - Open Shop",
        ['drop_vehicle'] = "[E] - To bump the vehicle",
        ['open_stash'] = "Open Stash",
        ['not_onduty'] = "You are not onduty.",
        ['system_offline'] = "You cannot demolish your car, this option is disabled",
        ['get_out_vehicle'] = "Get out the vehicle",
        ['own_the_vehicle'] = "Congratulations this stolen vehicle has been tipped over and is now yours!",
        ['no_permission'] = "You do not have access!",
        ['can_not_steel_player_vehicle'] = "You can't steel other player vehicles!",
        ['not_enough_items'] = "You don't have enough items or the right items with you",
        ['not_enough_money'] = "You don't have enough money",
        ['not_in_stock'] = "The company no longer has this item in stock!",
        ['cancel'] = "Canceled...",
        ['vehicle_removed'] = "Vehicle has been removed.",
        ['you_must_wait'] = "You have to wait until you can demolish another vehicle",
        ['vehicle_is_destroyed'] = "The vehicle is destroyed",
        ['to_much_damage'] = "The vehicle must not have too much damage, The vehicle is too damaged.",
        ['not_the_owner'] = "You do not own this vehicle",
        ['job_done_good_work'] = "Good job, everything went according to plan!",
        ['wreck_is_bumped'] = "The wreck is bumped, drive back to the ",
        ['go_to_work_vehicle'] = "Go to the yellow truck on your map!",
        ['go_to_dupm_location'] = "Drive this wreck to the designated point on the map",
        ['almost_on_dump_location'] = "You're almost there, orient your vehicle with the rear to the location",
        ['job_failed'] = "The job has failed, how could you screw it up!",
        ['vehicle_is_blacklisted'] = "You can't use this vehicle..",
        ['wrong_vehicle'] = "You didn't come back with the right vehicle.",
        ['not_your_own_property'] = "You can only park the vehicle on your own property!",
        ['only_remove_on_own_property'] = "You can only remove the vehicle from the storage on your own property",
        ['player_needby'] = "You cannot start scrapping because a player is too close to you",
    },
    police = {
        ['notify_title'] = "Large Waste Dumping",
        ['notify_message'] = "A stolen vehicle has been dumped in the water",
        ['not_online'] = "There are not enough cops online.",
    },
    progressbar = {
        ['info1'] = "File away frame number....",
        ['info2'] = "Cleaning frame....",
        ['info3'] = "Tap frame number....",
        ['info4'] = "Creating a new plate....",
        ['demolish'] = "Demolish Vehicle",
    },
}

Lang = Locale:new({
    phrases = Translations, 
    warnOnMissing = true
})
