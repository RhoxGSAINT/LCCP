local books_mission_prefix = "wh2_dlc09_books_of_nagash_"
local books_mission_regions = {};
local books_mission_characters = {};
local books_mission_factions = {};
local books_vfx_key = "scripted_effect3";

local book_objective_overrides = {
	["CAPTURE_REGIONS"] = "wh2_dlc09_objective_override_occupy_settlement",
	["ENGAGE_FORCE"] = "wh2_dlc09_objective_override_defeat_rogue_army"
};

local function rhox_zach_nagash_remove_book_region_vfx(mission_key)
	if books_mission_regions[mission_key] ~= nil then
		local region_key = books_mission_regions[mission_key];
		local region = cm:model():world():region_manager():region_by_key(region_key);
		local garrison_residence = region:garrison_residence();
		local garrison_residence_CQI = garrison_residence:command_queue_index();
		cm:remove_garrison_residence_vfx(garrison_residence_CQI, books_vfx_key);
	end
end

local function rhox_zach_nagash_remove_book_character_vfx(mission_key)
	if books_mission_characters[mission_key] ~= nil then
		local character_cqi = books_mission_characters[mission_key];
		cm:remove_character_vfx(character_cqi, books_vfx_key);
	end
end

rhox_zach_book_objective_list_faction = {
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_nippon_3_1"},
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_ind_5_1"},
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_gates_of_calith_1"},
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_elithis_1_2"},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 1345, y = 156}, patrol = {{x = 1339, y = 188}, {x = 1355, y = 219}, {x = 1345, y = 156}}},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 1045, y = 152}, patrol = {{x = 1030, y = 123}, {x = 998, y = 132}, {x = 1045, y = 152}}},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 1271, y = 791}, patrol = {{x = 1266, y = 753}, {x = 1319, y = 737}, {x = 1271, y = 791}}},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 1436, y = 604}, patrol = {{x = 1461, y = 656}, {x = 1411, y = 634}, {x = 158, y = 572}, {x = 1436, y = 604}}}
};



local function rhox_zach_setup_nagash_book_missions(faction_key, spawn_forces, is_mp)
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");

	-- Create the book objectives

    local book_list = rhox_zach_book_objective_list_faction
	for i = 1, #rhox_zach_book_objective_list_faction do
		local mm = mission_manager:new(faction_key, books_mission_prefix .. i);
		
		
        local book_objective_number = cm:random_number(#book_list);
		
		if is_mp then
			book_objective_number = i;
		end
		
		local book_objective = book_list[book_objective_number];
		
		mm:add_new_objective(book_objective.objective);
		--mm:set_mission_issuer("BOOK_NAGASH");
		
		if book_objective.objective == "CAPTURE_REGIONS" then
			mm:add_condition("region " .. book_objective.target);
			mm:add_condition("ignore_allies");
			
			books_mission_regions[books_mission_prefix .. i] = book_objective.target;
			
			local region = cm:get_region(book_objective.target);
			
			if region then
				local garrison_residence = region:garrison_residence();
				local garrison_residence_CQI = garrison_residence:command_queue_index();
				cm:add_garrison_residence_vfx(garrison_residence_CQI, books_vfx_key, true);
				out("Adding Books of Nagash scripted VFX to garrison...\n\tGarrison CQI: " .. garrison_residence_CQI .. "\n\tVFX: " .. books_vfx_key);
			else
				script_error("Could not find region with key [" .. book_objective.target .. "] to apply a Books of Nagash scripted VFX to");
				return;
			end
		elseif book_objective.objective == "ENGAGE_FORCE" then
			if spawn_forces then
				cm:spawn_rogue_army(book_objective.target, book_objective.pos.x, book_objective.pos.y);
				cm:force_diplomacy("all", "faction:" .. book_objective.target, "all", false, false, true);
				
				if book_objective.patrol ~= nil then
					out("Setting Books of Nagash rogue army patrol path for " .. book_objective.target);
					local im = invasion_manager;
					local rogue_force = cm:get_faction(book_objective.target):faction_leader():military_force();
					local book_patrol = im:new_invasion_from_existing_force("BOOK_PATROL_" .. book_objective.target, rogue_force);
					book_patrol:set_target("PATROL", book_objective.patrol);
					book_patrol:apply_effect("wh2_dlc09_bundle_book_rogue_army", -1);
					book_patrol:start_invasion();
				end
			end
			
			cm:force_diplomacy("faction:" .. faction_key, "faction:" .. book_objective.target, "war", true, true, false);
			
			local force_cqi = cm:get_faction(book_objective.target):faction_leader():military_force():command_queue_index();
			mm:add_condition("cqi " .. force_cqi);
			mm:add_condition("requires_victory");
			
			local leader_cqi = cm:get_faction(book_objective.target):faction_leader():command_queue_index();
			out("Adding Books of Nagash scripted VFX to character...\n\tCharacter CQI: " .. leader_cqi .. "\n\tVFX: " .. books_vfx_key);
			cm:add_character_vfx(leader_cqi, books_vfx_key, true);
			
			books_mission_characters[books_mission_prefix .. i] = leader_cqi;
			books_mission_factions[books_mission_prefix .. i] = book_objective.target;
		end
		
		if book_objective_overrides[book_objective.objective] ~= nil then
			mm:add_condition("override_text mission_text_text_" .. book_objective_overrides[book_objective.objective]);
		end
		

        mm:add_payload("effect_bundle{bundle_key wh3_main_books_of_nagash_zach_reward_" .. i .. ";turns 0;}");

		mm:set_should_whitelist(false);
		mm:trigger();

        if not is_mp then
			table.remove(book_list, book_objective_number);
		end

	end
	
	local mm2 = mission_manager:new(faction_key, "wh2_dlc09_books_of_nagash_9");
    mm2:add_new_objective("SCRIPTED");
    mm2:add_condition("script_key arkhan_book_mission_" .. faction_key);
    mm2:add_condition("override_text mission_text_text_wh2_dlc09_objective_override_arkhan_book");
    mm2:add_payload("effect_bundle{bundle_key wh2_dlc09_books_of_nagash_reward_9;turns 0;}");
    mm2:set_should_whitelist(false);
    mm2:trigger();
    cm:complete_scripted_mission_objective(faction_key, "wh2_dlc09_books_of_nagash_9", "arkhan_book_mission_" .. faction_key, false);
	
	cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
end

local resource_locations = {
	["res_gold"] = {},
	["res_gems"] = {},
	["res_rom_marble"] = {}
};

local function rhox_zach_add_nagash_books_effects_listeners()
	local all_regions = cm:model():world():region_manager():region_list();
	
	for i = 0, all_regions:num_items() - 1 do
		local current_region = all_regions:item_at(i);
		local current_region_resource = "";
		
		for j = 0, current_region:slot_list():num_items() - 1 do
			local current_slot = current_region:slot_list():item_at(j);
		
			if current_slot:resource_key() ~= "" then
				current_region_resource = current_slot:resource_key();
				break;
			end
		end
		
		if current_region_resource ~= "" then
			for resource, v in pairs(resource_locations) do
				if resource == current_region_resource then
					table.insert(resource_locations[resource], current_region:name());
				end
			end
		end
	end
end

cm:add_first_tick_callback(
    function()
        if cm:get_faction("rhox_vmp_the_everliving"):is_human() then
            if cm:is_new_game() == true then
                rhox_zach_setup_nagash_book_missions("rhox_vmp_the_everliving", true, false);
                rhox_zach_add_nagash_books_effects_listeners()
            end
            
            core:add_listener(
                "rhox_zach_nagash_NagashBooks_MissionSucceeded",
                "MissionSucceeded",
                true,
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    if string.find(mission_key, books_mission_prefix) then
                        rhox_zach_nagash_remove_book_region_vfx(mission_key);
                        rhox_zach_nagash_remove_book_character_vfx(mission_key);
                    end
                end,
                true
            );
        end
    end
);




local zach_faction_key = "rhox_vmp_the_everliving"
local malevolent_museum_key = "rhox_zach_malevolent_museum"


core:add_listener(
	"rhox_zach_faction_turn_start_tmb_lift_shroud_resource_locations",
	"FactionTurnStart",
	function(context)
		local faction = context:faction();
		if(faction:is_human()) then
			return faction:has_effect_bundle("wh3_main_books_of_nagash_zach_reward_2") or
				faction:has_effect_bundle("wh3_main_books_of_nagash_zach_studied_reward_2");
		end
	end,
	function(context)
		for k, regions in pairs(resource_locations) do
			for i = 1, #regions do
				cm:make_region_visible_in_shroud(context:faction():name(), regions[i]);
			end
		end
	end,
	true
);


function rhox_zach_books_of_nagash_3_replenishment(context, effect)
	local character = context:character();
	local char_cqi = character:command_queue_index();
	local duration = 10;
	
	cm:remove_effect_bundle_from_characters_force("wh2_dlc09_books_of_nagash_reward_3_army", char_cqi);
	cm:remove_effect_bundle_from_characters_force("wh3_main_books_of_nagash_zach_studied_reward_3_army", char_cqi);
	cm:remove_effect_bundle_from_characters_force("wh3_main_books_of_nagash_zach_reward_3_army", char_cqi);

	cm:apply_effect_bundle_to_characters_force(effect, char_cqi, duration);
	cm:trigger_incident(character:faction():name(),"wh2_dlc09_incident_tmb_sand_storm_spawned", true);
	cm:create_storm_for_region(character:region():name(), 1, duration, "land_storm");
end


core:add_listener(
	"rhox_zach_character_sacked_settlement_tmb_create_storm_for_region",
	"CharacterSackedSettlement",
	true,
	function(context)
		local faction = context:character():faction();
		
		if faction:name()== zach_faction_key then
			if(faction:has_effect_bundle("wh3_main_books_of_nagash_zach_studied_reward_3")) then
				rhox_zach_books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_zach_studied_reward_3_army")
			elseif(faction:has_effect_bundle("wh3_main_books_of_nagash_zach_reward_3")) then
				rhox_zach_books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_zach_reward_3_army")
			end	
		end
	end,
	true
);


core:add_listener(
	"rhox_zach_garrison_occupied_event_tmb_create_storm_for_region",
	"GarrisonOccupiedEvent",
	true,
	function(context)
		local faction = context:character():faction();
		if faction:name()== zach_faction_key then
			if(faction:has_effect_bundle("wh3_main_books_of_nagash_zach_studied_reward_3")) then
				rhox_zach_books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_zach_studied_reward_3_army")
			elseif(faction:has_effect_bundle("wh3_main_books_of_nagash_zach_reward_3")) then
				rhox_zach_books_of_nagash_3_replenishment(context, "wh3_main_books_of_nagash_zach_reward_3_army")
			end	
		end
	end,
	true
);


core:add_listener(
	"rhox_zach_mission_succeeded_tmb_lift_shroud",
	"MissionSucceeded",
	true,
	function(context)
		local mission_key = context:mission():mission_record_key();
		
		if mission_key == "wh2_dlc09_books_of_nagash_2" then
			local faction_name = context:faction():name();

			for k, regions in pairs(resource_locations) do
				for i = 1, #regions do
					cm:make_region_visible_in_shroud(faction_name, regions[i]);
				end
			end
		end
	end,
	true
);

function zach_malevolant_museum_effect_update()
	local region = cm:get_region("wh3_main_combi_region_wolfenburg")
	local owner = region:owning_faction()

	if owner:name() == zach_faction_key and region:building_exists(malevolent_museum_key) then
		-- apply studied effects
		for i = 1, 8 do
			if owner:has_effect_bundle("wh3_main_books_of_nagash_zach_reward_"..i) then
				cm:remove_effect_bundle("wh3_main_books_of_nagash_zach_reward_"..i, zach_faction_key)
				cm:apply_effect_bundle("wh3_main_books_of_nagash_zach_studied_reward_"..i, zach_faction_key, 0)
			end
		end
	else
		-- apply base effects
		for i = 1, 8 do
			if owner:has_effect_bundle("wh3_main_books_of_nagash_zach_studied_reward_"..i) then
				cm:remove_effect_bundle("wh3_main_books_of_nagash_zach_studied_reward_"..i, zach_faction_key)
				cm:apply_effect_bundle("wh3_main_books_of_nagash_zach_reward_"..i, zach_faction_key, 0)
			end
		end
	end
end

core:add_listener(
	"zachBooksOfNagashStudiedBuilding",
	"BuildingCompleted",
	function(context)
		return context:building():name() == malevolent_museum_key 
	end,
	function(context)
		zach_malevolant_museum_effect_update()
	end,
	true
)

core:add_listener(
	"zachBooksOfNagashStudiedMission",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == zach_faction_key and context:mission():mission_issuer_record_key() == "BOOK_NAGASH"
	end,
	function(context)
		cm:callback(function()
			-- MissionSucceeded is triggering before rewards are granted, which is resulting in effects not being doubled until the following turn. 
			-- This second delay ensures new effects granted by the mission are also doubled straight away.
			zach_malevolant_museum_effect_update()
		end,
		1)
	end,
	true
)

core:add_listener(
	"zachBooksOfNagashBloodKiss",
	"MissionSucceeded",
	function(context)
		return context:faction():name() == zach_faction_key and context:mission():mission_record_key() == "wh2_dlc09_books_of_nagash_7"
	end,
	function(context)
		-- one time bonus when mission first completed, grant 3 blood kisses
		cm:faction_add_pooled_resource(zach_faction_key, "vmp_blood_kiss", "other", 3);
	end,
	false
)

core:add_listener(
	"zachBooksOfNagashStudiedRoundStart",
	"FactionRoundStart",
	function(context)
		return context:faction():name() == zach_faction_key
	end,
	function(context)
		zach_malevolant_museum_effect_update()
	end,
	true
)





cm:add_saving_game_callback(
	function(context)
        cm:save_named_value("rhox_zach_books_mission_regions", books_mission_regions, context);
		cm:save_named_value("rhox_zach_books_mission_characters", books_mission_characters, context);
		cm:save_named_value("rhox_zach_books_mission_factions", books_mission_factions, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		books_mission_regions = cm:load_named_value("rhox_zach_books_mission_regions", books_mission_regions, context);
		books_mission_characters = cm:load_named_value("rhox_zach_books_mission_characters", books_mission_characters, context);
		books_mission_factions = cm:load_named_value("rhox_zach_books_mission_factions", books_mission_factions, context);
	end
);
