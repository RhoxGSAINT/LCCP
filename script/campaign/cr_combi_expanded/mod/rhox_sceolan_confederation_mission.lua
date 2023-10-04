confed_missions_data["rhox_wef_far_away_forest"] = {
    factions = {"wh_dlc05_wef_wood_elves", "wh_dlc05_wef_argwylon","wh2_dlc16_wef_sisters_of_twilight"},
    target_faction = "rhox_wef_far_away_forest",
    disable_diplomatic_confed = false,
    disable_cai_targeting = false,
    turn_number = 0,
    require_diplomatic_knowledge = false,
    custom_callback = 
        function()
            return confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 4)
        end,
    mission_key = "rhox_sceolan_conderation_mission",
    dilemma_key = "rhox_sceolan_conderation_dilemma",
    confed_choices = {true,false,false,false},
    mission_generated = {},
    dilemma_completed = false,
    force_peace_post_dilemma = true
}
--TODO add ones to the two LC  guys. Maybe for Mixu guys too






--- generic handler for creating missions/dilemmas that allow one faction to confederate another.


rhox_sceolan_wef_confed_missions = {}

rhox_sceolan_wef_confed_missions_data = {

	---WOOD ELVES---
	["wood_elves_talsyn"] = {
		factions = {"rhox_wef_far_away_forest"},
		target_faction = "wh_dlc05_wef_wood_elves",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback = 
			function(faction_key)
				return rhox_sceolan_wef_confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 3, faction_key) or rhox_sceolan_wef_confed_missions:is_any_primary_building_at_level(3,faction_key)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_talsyn",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_talsyn",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_torgovann"] = {
		factions = {"rhox_wef_far_away_forest"},
		target_faction = "wh_dlc05_wef_torgovann",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback =
			function(faction_key)
				return rhox_sceolan_wef_confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 2, faction_key) or rhox_sceolan_wef_confed_missions:is_any_primary_building_at_level(2,faction_key) 
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_torgovann",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_torgovann",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_wydrioth"] = {
		factions = {"rhox_wef_far_away_forest"},
		target_faction = "wh_dlc05_wef_wydrioth",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback =
			function(faction_key)
				return rhox_sceolan_wef_confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 2,faction_key) or rhox_sceolan_wef_confed_missions:is_any_primary_building_at_level(2,faction_key)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_wydrioth",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_wydrioth",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_sisters"] = {
		factions = {"rhox_wef_far_away_forest"}, 
		target_faction = "wh2_dlc16_wef_sisters_of_twilight", 
		disable_diplomatic_confed = false,
		disable_cai_targeting = false, 
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback = 
			function(faction_key)
				if not cm:faction_has_dlc_or_is_ai("TW_WH2_DLC16_TWILIGHT", faction_key) then
					return false
				end
				return rhox_sceolan_wef_confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 3,faction_key) or rhox_sceolan_wef_confed_missions:is_any_primary_building_at_level(3,faction_key)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_sisters", 
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_sisters",
		confed_choices = {true,false,false,false}, 
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_durthu"] = {
		factions = {"rhox_wef_far_away_forest"},
		target_faction = "wh_dlc05_wef_argwylon",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = false,
		custom_callback = 
			function(faction_key)
				return rhox_sceolan_wef_confed_missions:is_settlement_primary_building_at_level("wh3_main_combi_region_the_oak_of_ages", 3,faction_key) or rhox_sceolan_wef_confed_missions:is_any_primary_building_at_level(3,faction_key)
			end,
		mission_key = "wh2_dlc16_wef_confederation_mission_argwylon",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_argwylon",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},
	["durthu_drycha"] = {
		factions = {"rhox_wef_far_away_forest"}, 
		target_faction = "wh2_dlc16_wef_drycha",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 2, 
		require_diplomatic_knowledge = true,
		mission_key = "wh2_dlc16_wef_confederation_mission_drycha", 
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_drycha", 
		confed_choices = {true,false,false,false}, 
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},


	["wood_elves_laurelorn"] = {
		factions = {"rhox_wef_far_away_forest"}, 
		target_faction = "wh3_main_wef_laurelorn",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = true,
		mission_key = "wh2_dlc16_wef_confederation_mission_laurelorn",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_laurelorn", 
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_oreons_camp"] = {
		factions = {"rhox_wef_far_away_forest"},
		target_faction = "wh2_main_wef_bowmen_of_oreon", 
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = true,
		mission_key = "wh2_dlc16_wef_confederation_mission_bowmen_of_oreon",
		dilemma_key = "wh2_dlc16_wef_confederation_dilemma_bowmen_of_oreon",
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	},

	["wood_elves_shanlin"] = {
		factions = {"rhox_wef_far_away_forest"},
		target_faction = "wh3_dlc21_wef_spirits_of_shanlin",
		disable_diplomatic_confed = false,
		disable_cai_targeting = false,
		turn_number = 0,
		require_diplomatic_knowledge = true,
		mission_key = "wh3_dlc21_wef_confederation_mission_shanlin",
		dilemma_key = "wh3_dlc21_wef_confederation_dilemma_shanlin", 
		confed_choices = {true,false,false,false},
		mission_generated = {},
		dilemma_completed = false,
		force_peace_post_dilemma = true
	}
}

function rhox_sceolan_wef_confed_missions:setup()
	--validate now
	for mission_ref, mission_info in pairs(rhox_sceolan_wef_confed_missions_data) do
		if not is_string(mission_info.factions) and not is_table(mission_info.factions) then
			script_error("ERROR: trying to generate a confederation mission but faction key [" .. tostring(mission_info.factions) .. "] is not a string or a table");
		end

		if is_string(mission_info.factions) then 
			mission_info.factions = {mission_info.factions}
		end

		if not is_string(mission_info.target_faction) then
			script_error("ERROR: trying to generate a confederation mission for [" .. tostring(mission_info.factions) .. "] but target_faction is not a string");
		end

		if not is_boolean(mission_info.disable_diplomatic_confed) then
			script_error("ERROR: trying to generate a confederation mission for [" .. tostring(mission_info.factions) .. "] but disable_diplomatic confed is not a bool");
		end

		local confed_choices = mission_info.confed_choices

		if #confed_choices ~=4 then
			script_error("ERROR: trying to generate a confederation dilemma for [" .. tostring(mission_info.factions) .. "] but don't have 4 dilemma bools - this might break!");
		end

		for i = 1, #confed_choices do
			if not is_boolean(confed_choices[i]) then
				script_error("ERROR: trying to generate a confederation dilemma for [" .. tostring(mission_info.factions) .. "] but we've found a dilemma choice that's not a boolean!");
			end
		end
	end

	rhox_sceolan_wef_confed_missions:setup_listeners()
end


function rhox_sceolan_wef_confed_missions:setup_listeners()
	core:add_listener(
		"rhox_sceolan_wef_ConfedMissionsWorldStartRound",
		"WorldStartRound",
		true,
		function(context)
			for mission_ref, mission in pairs(rhox_sceolan_wef_confed_missions_data) do
				local is_dead = cm:get_faction(mission.target_faction):is_dead()
				
				for i = 1, #mission.factions do
					if is_dead then
						if mission.mission_generated[mission.factions[i]] then
							cm:cancel_custom_mission(mission.factions[i], mission.mission_key)
						end
					elseif cm:get_faction(mission.factions[i]):is_human() and rhox_sceolan_wef_confed_missions:is_mission_valid_for_faction(mission.factions[i], mission_ref) then
						rhox_sceolan_wef_confed_missions:trigger_mission(mission.factions[i], mission_ref)
					end
				end
			end
		end,
		true
	)

	core:add_listener(
		"rhox_sceolan_wef_ConfedMissionsDilemmaChoiceMadeEvent",
		"DilemmaChoiceMadeEvent",
		function(context)
			local dilemma_key = context:dilemma()
			for mission_ref,mission in pairs(rhox_sceolan_wef_confed_missions_data) do
				if dilemma_key == mission.dilemma_key then
					return true
				end
			end
			return false
		end,
		function(context)
			local dilemma_key = context:dilemma()
			local faction_key = context:faction():name()
			local confed_mission
			for mission_ref,mission in pairs(rhox_sceolan_wef_confed_missions_data) do
				if dilemma_key == mission.dilemma_key then
					confed_mission = mission
				end
			end
            
            --[[
			local choice = context:choice() + 1 -- have to add +1 here as the model starts the choices at 0
			if confed_mission.confed_choices[choice]  == true then 
				cm:force_confederation(faction_key, confed_mission.target_faction)
			end

			---regardless of choice, clean up any restrictions previously imposed
			if confed_mission.disable_cai_targeting then
				self:enable_cai_targeting_against_faction_capital(confed_mission)
			end

			if confed_mission.disable_diplomatic_confed then
				self:enable_diplomatic_confed(confed_mission)
			end
			
			if confed_mission.force_peace_post_dilemma and not cm:get_faction(confed_mission.target_faction):is_dead() then
				cm:force_make_peace(faction_key, confed_mission.target_faction)
			end
			--]] --there will be original listener in the vanilla and let them do the job. just set completed to true to don't trigger again
			confed_mission.dilemma_completed = true
		end,
		true
	)
end

---fire the mission. Can safely be called from other scripts if you want to by-pass the listeners and faction/turn conditions
function rhox_sceolan_wef_confed_missions:trigger_mission(faction_key, confed_mission_ref)
	local mission = rhox_sceolan_wef_confed_missions_data[confed_mission_ref]

	if mission == nil then
		script_error("Confed Missions: trying to force trigger a mission with key"..confed_mission_ref.."but that mission can't be found")
		return
	end

	cm:trigger_mission(faction_key, mission.mission_key, true)
	mission.mission_generated[faction_key] = true
	if mission.disable_diplomatic_confed then
		rhox_sceolan_wef_confed_missions:disable_diplomatic_confed(mission)
	end
	if mission.disable_cai_targeting then
		rhox_sceolan_wef_confed_missions:disable_cai_targeting_against_faction_capital(mission)
	end
end


function rhox_sceolan_wef_confed_missions:is_mission_valid_for_faction(faction_key, mission_key)
	local mission_is_valid = false
	local mission = rhox_sceolan_wef_confed_missions_data[mission_key]
	if mission == nil then
		return false
	end
	for index, valid_faction_key in ipairs(mission.factions) do
		if valid_faction_key == faction_key then 
			mission_is_valid = true
		end
	end

	if mission.mission_generated[faction_key] then 
		return false
	end

	local target_faction = cm:get_faction(mission.target_faction)
	if target_faction == false or target_faction:is_null_interface() or target_faction:is_human() or target_faction:is_dead() then
		return false
	end

	local current_turn = cm:turn_number()
	if mission.turn_number ~= nil and mission.turn_number > current_turn then
		return false
	end

	if is_function(mission.custom_callback) and mission.custom_callback(faction_key) == false then
		return false
	end

	if mission.require_diplomatic_knowledge then
		local faction_list = cm:get_faction(faction_key):factions_met();
		local faction_is_known = false
		for i = 0, faction_list:num_items() - 1 do
			local current_faction = faction_list:item_at(i);
			
			if current_faction:name() == mission.target_faction then
				faction_is_known = true
				break
			end;
		end

		if faction_is_known == false then
			return false
		end
	end
		
	return mission_is_valid
end 

function rhox_sceolan_wef_confed_missions:disable_cai_targeting_against_faction_capital(confed_mission)
	local target_faction_key =  confed_mission.target_faction
	local target_faction_interface = cm:get_faction(target_faction_key)
	
	if not target_faction_interface:is_dead() and not target_faction_interface:home_region():is_null_interface() and not confed_mission.dilemma_completed then
		local target_faction_home_region = target_faction_interface:home_region():name()
		cm:cai_disable_targeting_against_settlement("settlement:"..target_faction_home_region);
	end
end

function rhox_sceolan_wef_confed_missions:enable_cai_targeting_against_faction_capital(confed_mission)
	local target_faction_key =  confed_mission.target_faction
	local target_faction_interface = cm:get_faction(target_faction_key)
	if not target_faction_interface:is_dead() and not target_faction_interface:home_region():is_null_interface() then
		local target_faction_home_region = target_faction_interface:home_region():name()
		cm:cai_enable_targeting_against_settlement("settlement:"..target_faction_home_region);
	end
end

function rhox_sceolan_wef_confed_missions:disable_diplomatic_confed(confed_mission)
	if not confed_mission.dilemma_completed then
		local target_faction_key =  confed_mission.target_faction
		cm:force_diplomacy("faction:"..target_faction_key, "all", "form confederation", false, false, true)
	end
end

function rhox_sceolan_wef_confed_missions:enable_diplomatic_confed(confed_mission)
	local target_faction_key =  confed_mission.target_faction
	cm:force_diplomacy("faction:"..target_faction_key, "all","form confederation", true, true, true)
end

function rhox_sceolan_wef_confed_missions:is_settlement_primary_building_at_level(region_key, building_level, faction_key)
	local region_interface = cm:get_region(region_key)
	out("Rhox wef: Looking for building level: "..building_level)
	if region_interface == false then
		return false
	end
	
    
	if region_interface:owning_faction() and region_interface:owning_faction():name() == faction_key and region_interface:settlement():primary_slot():building():building_level() >= building_level then --at least check ownership of the oak
        return true;
	end
    out("Rhox wef: Oak condition failed")

	return false;
end


function rhox_sceolan_wef_confed_missions:is_any_primary_building_at_level(building_level, faction_key)
	out("Rhox wef: Looking for building level: "..building_level)
	local owned_regions = cm:get_faction(faction_key):region_list()
	
	
	--look into every region
	for i = 0, owned_regions:num_items() - 1 do
		local region = owned_regions:item_at(i)
		out("Rhox Wef: Looking at: "..region:name())
		out("Rhox Wef: building level: "..region:settlement():primary_slot():building():building_level())
        if region:settlement():primary_slot():building():building_level() >= building_level then
            out("Rhox Wef: You passed the test")
            return true;
        end
	end;


	return false;
end

cm:add_first_tick_callback(
    function()
        if cm:get_faction("rhox_wef_far_away_forest"):is_human() then
            rhox_sceolan_wef_confed_missions:setup()
        end
    end
);


--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		for key, mission in pairs(rhox_sceolan_wef_confed_missions_data) do
			cm:save_named_value("rhox_sceolan_wef_"..key, {mission.mission_generated, mission.dilemma_completed}, context);
		end
	end
);

cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			for key, mission in pairs(rhox_sceolan_wef_confed_missions_data) do
				local saved_mission_data = cm:load_named_value("rhox_sceolan_wef_"..key, {}, context);
				if saved_mission_data[1] ~= nil then
					mission.mission_generated = saved_mission_data[1]
				end
				if saved_mission_data[2] ~= nil then
					mission.dilemma_completed = saved_mission_data[2]
				end
			end
		end
	end
);