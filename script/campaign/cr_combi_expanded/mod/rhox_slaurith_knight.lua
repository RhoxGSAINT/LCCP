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

rhox_slaurith_book_objective_list_faction = {
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_nippon_3_1"},
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_suryapuri"},
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_gates_of_calith_1"},
    {objective = "CAPTURE_REGIONS", target = "cr_combi_region_elithis_1_2"},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_black_creek_raiders", pos = {x = 1350, y = 147}, patrol = {{x = 1325, y = 128}, {x = 1367, y = 153}, {x = 1350, y = 1147}}},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_eyes_of_the_jungle", pos = {x = 1045, y = 152}, patrol = {{x = 1030, y = 123}, {x = 998, y = 132}, {x = 1045, y = 152}}},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_dwellers_of_zardok", pos = {x = 1270, y = 776}, patrol = {{x = 1272, y = 750}, {x = 1303, y = 782}, {x = 1270, y = 776}}},
    {objective = "ENGAGE_FORCE", target = "wh2_dlc09_rogue_pilgrims_of_myrmidia", pos = {x = 1436, y = 604}, patrol = {{x = 1433, y = 568}, {x = 1407, y = 552}, {x = 1403, y = 595}, {x = 1436, y = 604}}}
};



local function rhox_slaurith_setup_knight_missions(faction_key, spawn_forces, is_mp)
	cm:disable_event_feed_events(true, "", "wh_event_subcategory_faction_missions_objectives", "");

	-- Create the book objectives
	for i = 1, #rhox_slaurith_book_objective_list_faction do
		local mm = mission_manager:new(faction_key, books_mission_prefix .. i);
		
		
		local book_objective = rhox_slaurith_book_objective_list_faction[i];
		
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
            pieces_of_eight_button:SetImagePath("ui/skins/hkrul_slaurith/icon_treasure_hunts.png")
            pieces_of_eight_button:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_slaurith_panel_open_button"),true)
            local treasure_hunt_count_ui = find_uicomponent(pieces_of_eight_button, "label_hunts_count");
            treasure_hunt_count_ui:SetVisible(false)
            
            
            core:add_listener(
                "rhox_slaurith_treasure_panel_open_listener",
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
