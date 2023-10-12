local books_mission_prefix = "rhox_slaurith_knight_"
local books_mission_regions = {};
local books_mission_characters = {};
local books_mission_factions = {};
local books_vfx_key = "scripted_effect3";

local book_objective_overrides = {
	["CAPTURE_REGIONS"] = "rhox_slaurith_objective_override_occupy_settlement",
	["ENGAGE_FORCE"] = "rhox_slaurith_objective_override_defeat_army"
};

local function rhox_slaurith_nagash_remove_book_region_vfx(mission_key)
	if books_mission_regions[mission_key] ~= nil then
		local region_key = books_mission_regions[mission_key];
		local region = cm:model():world():region_manager():region_by_key(region_key);
		local garrison_residence = region:garrison_residence();
		local garrison_residence_CQI = garrison_residence:command_queue_index();
		cm:remove_garrison_residence_vfx(garrison_residence_CQI, books_vfx_key);
	end
end

local function rhox_slaurith_nagash_remove_book_character_vfx(mission_key)
	if books_mission_characters[mission_key] ~= nil then
		local character_cqi = books_mission_characters[mission_key];
		cm:remove_character_vfx(character_cqi, books_vfx_key);
	end
end

book_objective_list_faction = {
	["cr_kho_servants_of_the_blood_nagas"] = {
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_lahmia"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_skavenblight"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_karak_eight_peaks"},
		{objective = "CAPTURE_REGIONS", target = "wh3_main_combi_region_white_tower_of_hoeth"},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 191, y = 275}, patrol = {{x = 177, y = 283}, {x = 201, y = 298}, {x = 214, y = 282}}},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 500, y = 255}, patrol = {{x = 568, y = 291}, {x = 534, y = 304}, {x = 500, y = 255}}},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 698, y = 611}, patrol = {{x = 676, y = 655}, {x = 623, y = 612}, {x = 659, y = 574}}},
		{objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 276, y = 679}, patrol = {{x = 363, y = 574}, {x = 259, y = 468}, {x = 158, y = 572}, {x = 276, y = 679}}}
	},
};



local function rhox_slaurith_setup_knight_missions(faction_key, spawn_forces, is_mp)
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");
	
    local faction_table_to_use = "cr_kho_servants_of_the_blood_nagas"
    if book_objective_list_faction[faction_table_to_use] ~= nil then
        book_objective_list = book_objective_list_faction[faction_table_to_use];
    end
	
	-- Create the book objectives
	local book_objective_count = #book_objective_list;
	for i = 1, book_objective_count do
		local mm = mission_manager:new(faction_key, books_mission_prefix .. i);
		
		local book_objective_number = cm:random_number(#book_objective_list);
		
		
		local book_objective = book_objective_list[book_objective_number];
		
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
		

        mm:add_payload("effect_bundle{bundle_key rhox_slaurith_reward_" .. i .. ";turns 0;}"); 

		mm:set_should_whitelist(false);
		mm:trigger();
		
        table.remove(book_objective_list, book_objective_number);
	end
	
	cm:callback(function() cm:disable_event_feed_events(false, "", "wh_event_subcategory_faction_missions_objectives", "") end, 1);
end

cm:add_first_tick_callback(
    function()
        if cm:get_faction("cr_kho_servants_of_the_blood_nagas"):is_human() then
            if cm:is_new_game() == true then
                rhox_slaurith_setup_knight_missions("cr_kho_servants_of_the_blood_nagas", true, false);
            end

            core:add_listener(
                "rhox_slaurith_nagash_NagashBooks_MissionSucceeded",
                "MissionSucceeded",
                true,
                function(context)
                    local mission_key = context:mission():mission_record_key();
                    if string.find(mission_key, books_mission_prefix) then
                        local faction = context:faction();
                        rhox_slaurith_nagash_remove_book_region_vfx(mission_key);
                        rhox_slaurith_nagash_remove_book_character_vfx(mission_key);
                    end
                end,
                true
            );
        end
        if cm:get_local_faction_name(true) == "cr_kho_servants_of_the_blood_nagas" then
            
        end
    end
);

cm:add_first_tick_callback(
	function()
        if cm:get_local_faction_name(true) == "cr_kho_servants_of_the_blood_nagas" then  --ui thing and should be local
            local pieces_of_eight_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", "button_treasure_hunts");
            pieces_of_eight_button:SetVisible(true)
            pieces_of_eight_button:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_slaurith_panel_open_button"),true)
            local treasure_hunt_count_ui = find_uicomponent(pieces_of_eight_button, "label_hunts_count");
            treasure_hunt_count_ui:SetVisible(false)
            
            
            core:add_listener(
                "rhox_dauphine_treasure_panel_open_listener",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "treasure_hunts";
                end,
                function()
                    local pieces_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "pieces");
                    pieces_tab:SimulateLClick();
                    
                    local pieces_text = find_uicomponent(pieces_tab, "tx");
                    pieces_text:SetText(common.get_localised_string("campaign_localised_strings_string_rhox_slaurith_piece_tab"))
                    
                    
                    
                    
                    local treasure_tab = find_uicomponent(core:get_ui_root(), "treasure_hunts", "TabGroup", "hunts");
                    treasure_tab:SetVisible(false) --we're not using this button and should disable it. 
                end,
                true
            )
        end
	end
);





cm:add_saving_game_callback(
	function(context)
        cm:save_named_value("rhox_slaurith_books_mission_regions", books_mission_regions, context);
		cm:save_named_value("rhox_slaurith_books_mission_characters", books_mission_characters, context);
		cm:save_named_value("rhox_slaurith_books_mission_factions", books_mission_factions, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		books_mission_regions = cm:load_named_value("rhox_slaurith_books_mission_regions", books_mission_regions, context);
		books_mission_characters = cm:load_named_value("rhox_slaurith_books_mission_characters", books_mission_characters, context);
		books_mission_factions = cm:load_named_value("rhox_slaurith_books_mission_factions", books_mission_factions, context);
	end
);
