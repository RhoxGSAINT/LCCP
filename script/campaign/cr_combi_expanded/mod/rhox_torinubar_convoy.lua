local torinubar_faction_key = "cr_hef_gate_guards"

local rhox_torinubar_events_cooldown = {}
local rhox_torinubar_event_max_cooldown = 15

local rhox_caravan_exception_list={
    ["wh2_main_hef_cha_prince_0"] =true,
    ["wh2_main_hef_cha_prince_2"] =true,
    ["wh2_main_hef_cha_prince_3"] =true,
    ["wh2_main_hef_cha_prince_4"] =true,
    ["wh2_main_hef_cha_prince_5"] =true,
    ["wh2_dlc15_hef_cha_prince_6"] =true
}






local random_pirate_faction ={
    "wh2_main_def_dark_elves_qb1",
    "wh2_dlc11_cst_vampire_coast_qb1",
    "wh2_dlc13_nor_norsca_invasion"
}

local force_to_faction_name={
    ["rhox_torinubar_def_dark_elves_qb1_low_a"] ="wh2_main_def_dark_elves_qb1",
    ["rhox_torinubar_def_dark_elves_qb1_low_b"] ="wh2_main_def_dark_elves_qb1",
    ["rhox_torinubar_def_dark_elves_qb1_med_a"] ="wh2_main_def_dark_elves_qb1",
    ["rhox_torinubar_def_dark_elves_qb1_med_b"] ="wh2_main_def_dark_elves_qb1",
    ["rhox_torinubar_def_dark_elves_qb1_high_a"] ="wh2_main_def_dark_elves_qb1",
    ["rhox_torinubar_def_dark_elves_qb1_high_b"] ="wh2_main_def_dark_elves_qb1",
    ["rhox_torinubar_cst_vampire_coast_qb1_low_a"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["rhox_torinubar_cst_vampire_coast_qb1_low_b"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["rhox_torinubar_cst_vampire_coast_qb1_med_a"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["rhox_torinubar_cst_vampire_coast_qb1_med_b"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["rhox_torinubar_cst_vampire_coast_qb1_high_a"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["rhox_torinubar_cst_vampire_coast_qb1_high_b"] ="wh2_dlc11_cst_vampire_coast_qb1",
    ["rhox_torinubar_nor_norsca_qb1_low_a"] ="wh2_dlc13_nor_norsca_invasion",
    ["rhox_torinubar_nor_norsca_qb1_low_b"] ="wh2_dlc13_nor_norsca_invasion",
    ["rhox_torinubar_nor_norsca_qb1_med_a"] ="wh2_dlc13_nor_norsca_invasion",
    ["rhox_torinubar_nor_norsca_qb1_med_b"] ="wh2_dlc13_nor_norsca_invasion",
    ["rhox_torinubar_nor_norsca_qb1_high_a"] ="wh2_dlc13_nor_norsca_invasion",
    ["rhox_torinubar_nor_norsca_qb1_high_b"] ="wh2_dlc13_nor_norsca_invasion",
}



local rhox_torinubar_event_tables = {

	["banditExtort"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local bandit_threat = world_conditions["bandit_threat"];
		local probability = math.floor(bandit_threat/10) +3;
		
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();
		
		local enemy_faction_name = enemy_faction:name();
		if enemy_faction_name == "rebels" then
			enemy_faction_name = random_pirate_faction[cm:random_number(#random_pirate_faction)]
		end
		
		local eventname = "banditExtort".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*"
			..tostring(bandit_threat).."*";
		
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
	
		out.design("banditExtort action called")
		local dilemma_list = {"rhox_torinubar_dilemma_cth_caravan_battle_1A", "rhox_torinubar_dilemma_cth_caravan_battle_1B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- read_out_event_params explains encoding
		local decoded_args = caravans:read_out_event_params(event_conditions,3);
		
		local is_ambush = false;
		local target_faction = decoded_args[2];
		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local bandit_threat = tonumber(decoded_args[3]);
        local enemy_faction_name =nil;
		local attacking_force, enemy_faction_name = rhox_torinubar_generate_attackers(bandit_threat, "");
		
		local cargo_amount = caravan_handle:cargo();
		
		--Dilemma option to remove cargo
		function remove_cargo()
			cm:set_caravan_cargo(caravan_handle, cargo_amount - 200)
		end
		
		custom_option = remove_cargo;
		
		--Handles the custom options for the dilemmas, such as battles (only?)
		local enemy_cqi = rhox_torinubar_attach_battle_to_dilemma(
												dilemma_name,
												caravan,
												attacking_force,
												is_ambush,
												target_faction,
												enemy_faction_name,
												target_region,
												custom_option
												);
		out.design(enemy_cqi);
		
		local target_faction_object = cm:get_faction(target_faction);
		
		--Trigger dilemma to be handled by above function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local faction_key = caravan_handle:caravan_force():faction():name();
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
		cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", -200);
		cargo_bundle:set_duration(0);
		
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		local own_faction = caravan_handle:caravan_force():faction();
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
		dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, own_faction);
	end,
	true},
	
	["banditAmbush"] = 
	--returns its probability [1]
	{function(world_conditions)
	
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		local enemy_faction = event_region:owning_faction();
	
		local enemy_faction_name = enemy_faction:name();
		if enemy_faction_name == "rebels" then
			enemy_faction_name = random_pirate_faction[cm:random_number(#random_pirate_faction)]  
		end
		
		local eventname = "banditAmbush".."?"
			..event_region:name().."*"
			..enemy_faction_name.."*"
			..tostring(bandit_threat).."*";
		
		local probability = math.floor(bandit_threat/20) +3;
		
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		--probability = 100; --rhox temp
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("banditAmbush action called")
		local dilemma_list = {"rhox_torinubar_dilemma_cth_caravan_battle_2A", "rhox_torinubar_dilemma_cth_caravan_battle_2B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = caravans:read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction = decoded_args[2];
		local target_region = decoded_args[1];
		local custom_option;
		
        local enemy_faction_name =nil;
		local bandit_threat = tonumber(decoded_args[3]);
		local attacking_force, enemy_faction_name = rhox_torinubar_generate_attackers(bandit_threat)
		
		
		--If anti ambush skill, then roll for detected event, if passed trigger event with battle
		-- else just ambush
		if caravan:caravan_master():character_details():has_skill("wh3_main_skill_cth_caravan_master_scouts") or cm:random_number(1,0) == 1 then --rhox reduced ambush cahnce 75% -> 50%
			local enemy_cqi = rhox_torinubar_attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction_name,
													target_region,
													custom_option
													);
			
			--Trigger dilemma to be handled by aboove function
			local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
			local settlement_target = cm:get_region(target_region):settlement();
			
			out.design("Triggering dilemma:"..dilemma_name)
				
			--Trigger dilemma to be handled by above function
			local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
			local payload_builder = cm:create_payload();
			
			dilemma_builder:add_choice_payload("FIRST", payload_builder);

			payload_builder:treasury_adjustment(-1000);
			
			dilemma_builder:add_choice_payload("SECOND", payload_builder);
			
			dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_cqi));
			dilemma_builder:add_target("target_military_1", caravan_handle:caravan_force());
			
			out.design("Triggering dilemma:"..dilemma_name)
			cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		else
			--Immidiately ambush
			caravans:spawn_caravan_battle_force(caravan, attacking_force, target_region, true, true, enemy_faction_name);
		end;
	end,
	true},
	
	["banditHungryOgres"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local bandit_threat = world_conditions["bandit_threat"];
		local event_region = world_conditions["event_region"];
		local enemy_faction_name = event_region:owning_faction():name();
		
		if enemy_faction_name == "rebels" then
			enemy_faction_name = random_pirate_faction[cm:random_number(#random_pirate_faction)] 
		end
		local enemy_faction = cm:get_faction(enemy_faction_name);
		
		local random_unit ="NONE";
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		if caravan_force_unit_list:num_items() > 1 then
			random_unit = caravan_force_unit_list:item_at(cm:random_number(caravan_force_unit_list:num_items()-1,1)):unit_key();
			
			if rhox_caravan_exception_list[random_unit] then --no caravan master or LHs
				random_unit = "NONE";
			end
			out.design("Random unit to be eaten: "..random_unit);
		end;
		
		--Construct targets
		local eventname = "banditHungryOgres".."?"
			..event_region:name().."*"
			..random_unit.."*"
			..tostring(bandit_threat).."*"
			..enemy_faction_name.."*";
			
		
		--Calculate probability
		local probability = 0;
		
		if random_unit == "NONE" then
			probability = 0;
		else
			probability = math.min(bandit_threat,10);
		end
		local caravan_faction = world_conditions["faction"];
		if enemy_faction:name() == caravan_faction:name() then
			probability = 0;
		end;
		--probability = 100 --rhox temp for test
		return {probability,eventname}
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("banditHungryOgres action called")
		local dilemma_name = "rhox_torinubar_dilemma_cth_caravan_battle_3";
		local caravan = caravan_handle;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		local decoded_args = caravans:read_out_event_params(event_conditions,3);
		
		local is_ambush = true;
		local target_faction = decoded_args[4];

		local target_region = decoded_args[1];
		local custom_option = nil;
		
		local random_unit = decoded_args[2];
		local bandit_threat = tonumber(decoded_args[3]);
        local enemy_faction_name = nil;
		local attacking_force, enemy_faction_name = rhox_torinubar_generate_attackers(bandit_threat,"random")
		out("Enemy faction from outcome: ".. enemy_faction_name)
		
		--Eat unit to option 2
		function eat_unit_outcome()
			if random_unit ~= nil then
				local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
				cm:remove_unit_from_character(
				caravan_master_lookup,
				random_unit);

			else
				out("Script error - should have a unit to eat?")
			end
		end
		
		custom_option = nil; --eat_unit_outcome;
		
		--Battle to option 1, eat unit to 2
		local enemy_force_cqi = rhox_torinubar_attach_battle_to_dilemma(
													dilemma_name,
													caravan,
													attacking_force,
													false,
													target_faction,
													enemy_faction_name,
													target_region,
													custom_option
													);
	
		--Trigger dilemma to be handled by above function
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		local target_faction_object =  cm:get_faction(target_faction);
		local own_faction = caravan_handle:caravan_force():faction();
		payload_builder:remove_unit(caravan:caravan_force(), random_unit);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		out.design("Triggering dilemma:"..dilemma_name)
		dilemma_builder:add_target("default", cm:get_military_force_by_cqi(enemy_force_cqi));
		
		dilemma_builder:add_target("target_military_1", caravan:caravan_force());
		
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	true},
	
	["genericShortcut"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericShortcut".."?";
		local probability = 2;
		--caravan_master is a FAMILY_MEMBER_SCRIPT_INTERFACE
		local has_scouting = world_conditions["caravan_master"]:character_details():has_skill("wh3_main_skill_cth_caravan_master_wheelwright");
		
		if has_scouting == true then
            out("Rhox Torinubar: Waving carrots")
			probability = probability + 6
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericShortcut action called")
		local dilemma_list = {"rhox_torinubar_dilemma_cth_caravan_1A", "rhox_torinubar_dilemma_cth_caravan_1B"}
		local dilemma_name = dilemma_list[cm:random_number(2,1)];
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_key = caravan_handle:caravan_force():faction():name();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		
		function extra_move()
			--check if more than 1 move from the end
			out.design(force_cqi);
			cm:move_caravan(caravan_handle);
		end
		custom_option = extra_move;
		
		rhox_torinubar_attach_battle_to_dilemma(
			dilemma_name,
			caravan_handle,
			nil,
			false,
			nil,
			nil,
			nil,
			custom_option);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local scout_skill = caravan_handle:caravan_master():character_details():character():bonus_values():scripted_value("caravan_scouting", "value");

		if scout_skill < -99 then
            scout_skill = -99 --fail safe you're not going to get money from it
		end
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		payload_builder:treasury_adjustment(math.floor(-500*((100+scout_skill)/100)));
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["genericElite"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericElite".."?";
		
		local probability = 1;
		
		local caravan_force = world_conditions["caravan"]:caravan_force();
		local special_units = {"wh2_main_hef_mon_sun_dragon","wh2_main_hef_art_eagle_claw_bolt_thrower","wh2_main_hef_cav_dragon_princes","wh2_main_hef_mon_phoenix_flamespyre","wh2_main_hef_mon_phoenix_frostheart"}
		
		if not cm:military_force_contains_unit_type_from_list(caravan_force, special_units) then
			out.design("No special units - increase probability")
			probability = 5;
		end
		
		local caravan_force_unit_list = world_conditions["caravan"]:caravan_force():unit_list()
		
		if caravan_force_unit_list:num_items() >= 19 then
			probability = 0;
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericElite action called")
		
		local AorB = {"A","B"};
		local choice = AorB[cm:random_number(#AorB,1)]
		
		local dilemma_name = "rhox_torinubar_dilemma_cth_caravan_3"..choice;
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		local special_units = {"wh2_main_hef_mon_sun_dragon","wh2_main_hef_art_eagle_claw_bolt_thrower","wh2_main_hef_cav_dragon_princes","wh2_main_hef_mon_phoenix_flamespyre","wh2_main_hef_mon_phoenix_frostheart"}
		
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		if choice == "B" then
			payload_builder:treasury_adjustment(-500);
		end
		payload_builder:add_unit(caravan_handle:caravan_force(), special_units[cm:random_number(#special_units,1)], 1, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["genericCargoReplenish"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "genericCargoReplenish".."?";
		local caravan_force = world_conditions["caravan"]:caravan_force();
		
		local probability = 4;
		
		if cm:military_force_average_strength(caravan_force) == 100 and world_conditions["caravan"]:cargo() >= 1000 then
			probability = 0
		end
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("genericCargoReplenish action called")
		local dilemma_name = "rhox_torinubar_dilemma_cth_caravan_2B";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode

		--Trigger dilemma to be handled by aboove function
		local faction_cqi = caravan_handle:caravan_force():faction():command_queue_index();
		local force_cqi = caravan_handle:caravan_force():command_queue_index();
		
		function add_cargo()
			local cargo = caravan_handle:cargo();
			cm:set_caravan_cargo(caravan_handle, cargo+200)
		end
		custom_option = add_cargo;
		
		rhox_torinubar_attach_battle_to_dilemma(
			dilemma_name,
			caravan_handle,
			nil,
			false,
			nil,
			nil,
			nil,
			custom_option);
			
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local replenish = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2");
		replenish:add_effect("wh_main_effect_force_all_campaign_replenishment_rate", "force_to_force_own", 8);
		replenish:add_effect("wh_main_effect_force_army_campaign_enable_replenishment_in_foreign_territory", "force_to_force_own", 1);
		replenish:set_duration(2);
		
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), replenish);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		local cargo_bundle = cm:create_new_custom_effect_bundle("wh3_main_dilemma_cth_caravan_2_b");
		cargo_bundle:add_effect("wh3_main_effect_caravan_cargo_DUMMY", "force_to_force_own", 200);
		cargo_bundle:set_duration(0);
		
		payload_builder:effect_bundle_to_force(caravan_handle:caravan_force(), cargo_bundle);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["recruitmentChoiceA"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "recruitmentChoiceA".."?";
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		
		local probability = math.floor((20 - army_size)/2);
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("recruitmentChoiceA action called")
		local dilemma_name = "rhox_torinubar_dilemma_cth_caravan_4A";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		rhox_torinubar_attach_battle_to_dilemma(
					dilemma_name,
					caravan_handle,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local ranged_list = {"wh2_main_hef_cav_tiranoc_chariot","wh2_dlc10_hef_inf_shadow_walkers_0","wh2_dlc10_hef_inf_shadow_warriors_0","wh2_dlc10_hef_inf_sisters_of_avelorn_0"};
		local melee_list = {"wh2_dlc15_hef_inf_silverin_guard_0","wh2_main_hef_inf_spearmen_0","wh2_main_hef_inf_white_lions_of_chrace_0","wh2_main_hef_cav_silver_helms_1"};
		
		payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 1, 0);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		payload_builder:clear();
		
		payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 2, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false},
	
	["recruitmentChoiceB"] = 
	--returns its probability [1]
	{function(world_conditions)
		
		local eventname = "recruitmentChoiceB".."?";
		local army_size = world_conditions["caravan"]:caravan_force():unit_list():num_items()
		
		local probability = math.floor((20 - army_size)/2);
		
		return {probability,eventname}
		
	end,
	--enacts everything for the event: creates battle, fires dilemma etc. [2]
	function(event_conditions,caravan_handle)
		
		out.design("recruitmentChoiceB action called")
		local dilemma_name = "rhox_torinubar_dilemma_cth_caravan_4B";
		
		--Decode the string into arguments-- Need to specify the argument encoding
		--none to decode
		
		rhox_torinubar_attach_battle_to_dilemma(
					dilemma_name,
					caravan_handle,
					nil,
					false,
					nil,
					nil,
					nil,
					nil);
		
		local dilemma_builder = cm:create_dilemma_builder(dilemma_name);
		local payload_builder = cm:create_payload();
		
		local ranged_list = {"wh2_main_hef_inf_lothern_sea_guard_1","wh2_main_hef_inf_archers_1","wh2_dlc10_hef_inf_shadow_warriors_0"};
		local melee_list = {"wh2_dlc15_hef_inf_silverin_guard_0","wh2_main_hef_inf_phoenix_guard","wh2_main_hef_inf_swordmasters_of_hoeth_0","wh2_main_hef_cav_ithilmar_chariot"};
		
		payload_builder:add_unit(caravan_handle:caravan_force(), ranged_list[cm:random_number(#ranged_list,1)], 2, 0);
		dilemma_builder:add_choice_payload("SECOND", payload_builder);
		payload_builder:clear();
		
		payload_builder:add_unit(caravan_handle:caravan_force(), melee_list[cm:random_number(#melee_list,1)], 1, 0);
		dilemma_builder:add_choice_payload("FIRST", payload_builder);
		
		dilemma_builder:add_target("default", caravan_handle:caravan_force());
		
		out.design("Triggering dilemma:"..dilemma_name)
		cm:launch_custom_dilemma_from_builder(dilemma_builder, caravan_handle:caravan_force():faction());
		
	end,
	false}
	
};

















--------------------------------------------------------------------------------------------------
--Functions

function rhox_torinubar_event_handler(context)
	
	--package up some world state
	--generate an event
	--out("rhox Torinubar: In here")
	local caravan_master = context:caravan_master();
	local faction = context:faction();
	
	if context:from():is_null_interface() or context:to():is_null_interface() then
		return false
	end;
	
	local from_node = context:caravan():position():network():node_for_position(context:from());
	local to_node = context:caravan():position():network():node_for_position(context:to());
	
	local route_segment = context:caravan():position():network():segment_between_nodes(
	from_node, to_node);
	
	if route_segment:is_null_interface() then
		return false
	end
	
	local list_of_regions = route_segment:regions();
	
	local num_regions;
	local event_region;
	--pick a region from the route at random - don't crash the game if empty
	if list_of_regions:is_empty() ~= true then
		num_regions = list_of_regions:num_items()
		event_region = list_of_regions:item_at(cm:random_number(num_regions-1,0)):region();
	else
		out.design("*** No Regions in an Ivory Road segment - Need to fix data in DaVE: campaign_map_route_segments ***")
		out.design("*** Rest of this script will fail ***")
	end;
	
	local bandit_list_of_regions = {};
	
	--override region if one is at war
	for i = 0,num_regions-1 do
		table.insert(bandit_list_of_regions,list_of_regions:item_at(i):region():name())
		
		if list_of_regions:item_at(i):region():owning_faction():at_war_with(context:faction()) then
			event_region=list_of_regions:item_at(i):region()
		end;
	end
	
	
	local bandit_threat = math.floor( cm:model():world():caravans_system():total_banditry_for_regions_by_key(bandit_list_of_regions) / num_regions);	
	local conditions = {
		["caravan"]=context:caravan(),
		["caravan_master"]=caravan_master,
		["list_of_regions"]=list_of_regions,
		["event_region"]=event_region,
		["bandit_threat"]=bandit_threat,
		["faction"]=faction
		};
	
	local contextual_event, is_battle = rhox_torinubar_generate_event(conditions);
	
	out("rhox Torinubar: Chosen event is: ".. tostring(contextual_event))
	--if battle then waylay
	
	if is_battle == true and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
	elseif is_battle == false and contextual_event ~= nil then
		context:flag_for_waylay(contextual_event);
		--needs to survive a save load at this point
	end;
	
end

function rhox_torinubar_generate_event(conditions)

	--look throught the events table and create a table for weighted roll
	--pick one and return the event name
	
	local weighted_random_list = {};
	local total_probability = 0;
	local i = 0;

	local events = rhox_torinubar_event_tables
	
	--build table for weighted roll
	for key, val in pairs(events) do
		
		i = i + 1;
		
		--Returns the probability of the event 
		local args = val[1](conditions)
		local prob = args[1];
		out("rhox Torinubar: Event name is ".. args[2] .. "and probability is ".. args[1])
		total_probability = prob + total_probability;
		--Returns the name and target of the event
		local name_args = args[2];
		
		--Returns if a battle is possible from this event
		--i.e. does it need to waylay
		local is_battle = val[3];
		
		weighted_random_list[i] = {total_probability,name_args,is_battle}

	end
	
	--check all the probabilites until matched
	local no_event_chance = 25;
	local random_int = cm:random_number(total_probability + no_event_chance,1);
	local is_battle = nil;
	local contextual_event_name = nil;

	for j=1,i do
		if weighted_random_list[j][1] >= random_int then
            contextual_event_name = weighted_random_list[j][2];
			is_battle = weighted_random_list[j][3];
			break;
		end
	end
	
	return contextual_event_name, is_battle
end;


function rhox_torinubar_waylaid_caravan_handler(context)
	
	local event_name_formatted = context:context();
	local caravan_handle = context:caravan();
	
	local event_key = caravans:read_out_event_key(event_name_formatted); --use vanilla
	out("rhox Torinubar: rhox_torinubar_waylaid_caravan_handler Going to call event: ".. event_key)
	local events = rhox_torinubar_event_tables
	--call the action side of the event
	events[event_key][2](event_name_formatted,caravan_handle);
	
end





function rhox_torinubar_attach_battle_to_dilemma(
			dilemma_name,
			caravan,
			attacking_force,
			is_ambush,
			target_faction,
			enemy_faction,
			target_region,
			custom_option)
	
	--Create the enemy force
	local enemy_force_cqi = nil;
	local x = nil;
	local y = nil;
	
	if attacking_force ~= nil then
		enemy_force_cqi, x, y = caravans:spawn_caravan_battle_force(caravan, attacking_force, target_region, is_ambush, false, enemy_faction) --we don't need new function for these
	end
	
	function ivory_road_dilemma_choice(context)
		local dilemma = context:dilemma();
		local choice = context:choice();
		local faction = context:faction();
		local faction_key = faction:name();
		
		if dilemma == dilemma_name then
			--if battle option is chosen
			core:remove_listener("rhox_torinubar_cth_DilemmaChoiceMadeEvent_"..faction_key);
			
			if choice == 3 then
				return;
			end

			local choice_zero_dilemmas = 
				{
				};
			local choice_one_dilemmas = 
				{
				};	

			local not_move_dilemmas = 
				{
				};	

			local move_dilemma_one =
				{
				};

			local cargo_dilemmas =
				{
				}

			if choice == 0 and attacking_force ~= nil and not choice_zero_dilemmas[dilemma_name] then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush); --we don't need new functions for these
			elseif attacking_force ~= nil and (choice == 0 and choice_zero_dilemmas[dilemma_name]) then
				caravans:create_caravan_battle(caravan, enemy_force_cqi, x, y, is_ambush);
				custom_option();
			end	
			if (choice ~= 0 and not move_dilemma_one[dilemma_name]) or (choice == 0 and attacking_force == nil and not not_move_dilemmas[dilemma_name]) then
				cm:move_caravan(caravan);
			end	
			
			if (choice == 0 and attacking_force == nil and cargo_dilemmas[dilemma_name]) or (custom_option ~= nil and choice == 1 and not choice_one_dilemmas[dilemma_name]) then
				custom_option();
			end
			
			if choice == 0 and attacking_force == nil and dilemma_name == "rhox_torinubar_dilemma_quick_way_down" then
				cm:move_caravan(caravan);
				cm:move_caravan(caravan);
				custom_option();
			end
		end
	end
	
	local faction_key = caravan:caravan_master():character():faction():name()

	core:add_listener(
		"rhox_torinubar_cth_DilemmaChoiceMadeEvent_"..faction_key,
		"DilemmaChoiceMadeEvent",
		true,
		function(context)
			ivory_road_dilemma_choice(context) 
		end,
		true
	);
	
	return enemy_force_cqi
end;

function rhox_torinubar_adjust_end_node_values_for_demand()

	local temp_end_nodes = rhox_torinubar_safe_get_saved_value_ivory_road_demand()
	
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val.." for passive demand increase.")
		rhox_torinubar_adjust_end_node_value(key, 2, "add")
	end

end



function rhox_torinubar_initalize_end_node_values()

	--randomise the end node values
	local end_nodes = {
        ["cr_combi_region_nippon_3_1"]				=75-cm:random_number(50,0),
        ["cr_combi_region_ind_4_2"]				=75-cm:random_number(50,0),
        ["wh3_main_combi_region_dai_cheng"]				=75-cm:random_number(50,0),
        ["cr_combi_region_ihan_3_1"]				=cm:random_number(150,60),
        ["wh3_main_combi_region_fu_chow"]	=cm:random_number(150,60),
        ["wh3_main_combi_region_beichai"]				=cm:random_number(150,60),
        ["wh3_main_combi_region_haichai"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_barak_varr"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_miragliano"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_lothern"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_bordeleaux"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_marienburg"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_altdorf"]			    	=cm:random_number(150,60),
        ["wh3_main_combi_region_erengrad"]			=cm:random_number(150,60)
        
    };
 
	
	--save them
	cm:set_saved_value("rhox_torinubar_trade_demand", end_nodes);
	local temp_end_nodes = rhox_torinubar_safe_get_saved_value_ivory_road_demand() 
	
	--apply the effect bundles
	for key, val in pairs(temp_end_nodes) do
		out.design("Key: "..key.." and value: "..val)
		rhox_torinubar_adjust_end_node_value(key, val, "replace")
	end
end

function rhox_torinubar_safe_get_saved_value_ivory_road_demand()
	
	return cm:get_saved_value("rhox_torinubar_trade_demand");

end		




function rhox_torinubar_adjust_end_node_value(region_name, value, operation, apply_variance)
	
	local region = cm:get_region(region_name);
	if not region then
		script_error("Could not find region " ..region_name.. " for caravan script")
		return false
	end
	local cargo_value_bundle = cm:create_new_custom_effect_bundle("wh3_main_ivory_road_end_node_value");
	cargo_value_bundle:set_duration(0);


	
	if operation == "replace" then
		local temp_end_nodes = rhox_torinubar_safe_get_saved_value_ivory_road_demand()
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", value);
		
		temp_end_nodes[region_name]=value;
		cm:set_saved_value("rhox_torinubar_trade_demand", temp_end_nodes);
		
	elseif operation == "add" then
		local temp_end_nodes = rhox_torinubar_safe_get_saved_value_ivory_road_demand()
		local old_value = temp_end_nodes;

		if old_value == nil then
			out.design("*******   Error in ivory road script    *********")
			return 0;
		end
		
		old_value = old_value[region_name]

		local new_value = math.min(old_value+value,200)
		new_value = math.max(old_value+value,-60)
		
		cargo_value_bundle:add_effect("wh3_main_effect_caravan_cargo_value_regions", "region_to_region_own", new_value);
		
		temp_end_nodes[region_name]=new_value;
		cm:set_saved_value("rhox_torinubar_trade_demand", temp_end_nodes);
	--elseif operation == "duration" then --not doing duration
	end
	
	if region:has_effect_bundle("wh3_main_ivory_road_end_node_value") then
		cm:remove_effect_bundle_from_region("wh3_main_ivory_road_end_node_value", region_name);
	end;
	
	cm:apply_custom_effect_bundle_to_region(cargo_value_bundle, region);
end

------------------------------listeners

core:add_listener(
    "rhox_torinubar_caravan_finished",
    "CaravanCompleted",
    function(context)
        return context:faction():name() == torinubar_faction_key
    end,
    function(context)
        -- store a total value of goods moved for this faction and then trigger an onwards event, narrative scripts use this
        local node = context:complete_position():node()
        local region_name = node:region_key()
        local region = node:region_data():region()
        local region_owner = region:owning_faction();
        
        out.design("Caravan (player) arrived in: "..region_name)
        
        local faction = context:faction()
        local faction_key = faction:name();
        local prev_total_goods_moved = cm:get_saved_value("caravan_goods_moved_" .. faction_key) or 0;
        local num_caravans_completed = cm:get_saved_value("caravans_completed_" .. faction_key) or 0;
        cm:set_saved_value("caravan_goods_moved_" .. faction_key, prev_total_goods_moved + context:cargo());
        cm:set_saved_value("caravans_completed_" .. faction_key, num_caravans_completed + 1);
        core:trigger_event("ScriptEventCaravanCompleted", context);
        
        if faction:is_human() then
            rhox_torinubar_build_or_upgrade_foreign(region, region_owner)
        end
        --faction has tech that grants extra trade tariffs bonus after every caravan - create scripted bundle
            
        if not region_owner:is_null_interface() then
            local region_owner_key = region_owner:name()
            cm:cai_insert_caravan_diplomatic_event(region_owner_key,faction_key)

            if region_owner:is_human() and faction_key ~= region_owner_key then
                cm:trigger_incident_with_targets(
                    region_owner:command_queue_index(),
                    "wh3_main_cth_caravan_completed_received", --Just use caravan one
                    0,
                    0,
                    0,
                    0,
                    region:cqi(),
                    0
                )
            end
        end
        
        --Reduce demand
        local cargo = context:caravan():cargo()
        local value = math.floor(-cargo/18)
        cm:callback(function()rhox_torinubar_adjust_end_node_value(region_name, value, "add") end, 5);
                    
    end,
    true
);





core:add_listener(
    "rhox_torinubar_caravan_waylay_query",
    "QueryShouldWaylayCaravan",
    function(context)
        return context:faction():is_human() and context:faction():name() == torinubar_faction_key
    end,
    function(context)
        out("rhox Torinubar: In the QueryShouldWaylayCaravan listener")
        local faction_key = context:faction():name()
        if rhox_torinubar_event_handler(context) == false then
            out.design("Caravan not valid for event");
        end
    end,
    true
);


core:add_listener(
    "rhox_torinubar_caravan_waylaid",
    "CaravanWaylaid",
    function(context)
        return context:faction():name() == torinubar_faction_key
    end,
    function(context)
        rhox_torinubar_waylaid_caravan_handler(context);
    end,
    true
);


core:add_listener(
	"rhox_torinubar_add_inital_force",
	"CaravanRecruited",
	function(context)
		return context:faction():name() == torinubar_faction_key
	end,
	function(context)
		out.design("*** Caravan recruited ***");
		if context:caravan():caravan_force():unit_list():num_items() < 2 then
			local caravan = context:caravan();
			rhox_torinubar_add_inital_force(caravan); 
			cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
		end;
	end,
	true
);

function rhox_toribunbar_add_effectbundle(caravan)
	--local force_cqi = caravan:caravan_force():command_queue_index();
	local caravan_master_lookup = cm:char_lookup_str(caravan:caravan_force():general_character():command_queue_index())
	
	cm:force_character_force_into_stance(caravan_master_lookup, "MILITARY_FORCE_ACTIVE_STANCE_TYPE_FIXED_CAMP")
end;

core:add_listener(
	"rhox_torinubar_add_inital_bundles",
	"CaravanSpawned",
	function(context)
		return context:faction():name() == torinubar_faction_key
	end,
	function(context)
		out.design("*** Caravan deployed ***");
		local caravan = context:caravan();
		rhox_toribunbar_add_effectbundle(caravan);--reuse this one
		cm:set_saved_value("caravans_dispatched_" .. context:faction():name(), true);
		cm:set_character_excluded_from_trespassing(context:caravan():caravan_master():character(), true)
	end,
	true
);

core:add_listener(
    "rhox_torinubar_caravans_increase_demand",
    "WorldStartRound",
    true,
    function(context)
        rhox_torinubar_adjust_end_node_values_for_demand();
    end,
    true
);

core:add_listener(
	"rhox_torinubar_caravan_master_heal",
	"CaravanMoved",
	function(context)
		return context:faction():name() == torinubar_faction_key
	end,
	function(context)
		--Heal Lord
		local caravan_force_list = context:caravan_master():character():military_force():unit_list();
		local unit = nil;
		for i=0, caravan_force_list:num_items()-1 do
			unit = caravan_force_list:item_at(i);
			if rhox_caravan_exception_list[unit:unit_key()] then --caravan master or LH
				cm:set_unit_hp_to_unary_of_maximum(unit, 1);
			end
		end
		--Spread out caravans
		local caravan_lookup = cm:char_lookup_str(context:caravan():caravan_force():general_character():command_queue_index())
		local x,y = cm:find_valid_spawn_location_for_character_from_character(
			context:faction():name(),
			caravan_lookup,
			true,
			cm:random_number(15,5)
			)
		cm:teleport_to(caravan_lookup,  x,  y);
	end,
	true
);

function rhox_torinubar_generate_attackers(bandit_threat, force_name)
	
	local difficulty = cm:get_difficulty(false);
	local turn_number = cm:turn_number();
	
	out.design("Generate caravan attackers for banditry: "..bandit_threat)
	
	if force_name == "daemon_incursion" then
		return random_army_manager:generate_force(force_name, 5, false), force_name;
	end
	
	if bandit_threat < 50 then
			force_name = {"rhox_torinubar_def_dark_elves_qb1_low_a","rhox_torinubar_cst_vampire_coast_qb1_low_a", "rhox_torinubar_nor_norsca_qb1_low_a", "rhox_torinubar_def_dark_elves_qb1_low_b", "rhox_torinubar_cst_vampire_coast_qb1_low_b", "rhox_torinubar_nor_norsca_qb1_low_b"}
            local target_force = force_name[cm:random_number(#force_name,1)]
            local enemy_faction_name = force_to_faction_name[target_force]
            out("Rhox force name: "..target_force)
            out("Rhox faction name: "..force_to_faction_name[target_force])
			return random_army_manager:generate_force(target_force, 8, false), enemy_faction_name;
		elseif bandit_threat >= 50 and bandit_threat < 70 then
			force_name = {"rhox_torinubar_def_dark_elves_qb1_med_a","rhox_torinubar_cst_vampire_coast_qb1_med_a", "rhox_torinubar_nor_norsca_qb1_med_a", "rhox_torinubar_def_dark_elves_qb1_med_b", "rhox_torinubar_cst_vampire_coast_qb1_med_b","rhox_torinubar_nor_norsca_qb1_med_b"}
            local target_force = force_name[cm:random_number(#force_name,1)]
            local enemy_faction_name = force_to_faction_name[target_force]
			return random_army_manager:generate_force(target_force, 11, false), enemy_faction_name;
		elseif bandit_threat >= 70 then
			force_name = {"rhox_torinubar_def_dark_elves_qb1_high_a","rhox_torinubar_cst_vampire_coast_qb1_high_a", "rhox_torinubar_nor_norsca_qb1_high_a", "rhox_torinubar_def_dark_elves_qb1_high_b", "rhox_torinubar_cst_vampire_coast_qb1_high_b", "rhox_torinubar_nor_norsca_qb1_high_b"}
            local target_force = force_name[cm:random_number(#force_name,1)]
            local enemy_faction_name = force_to_faction_name[target_force]
			return random_army_manager:generate_force(target_force, 14, false), enemy_faction_name;
	end
end






-- Logic --
--Setup
cm:add_first_tick_callback_new(
	function()
		rhox_torinubar_initalize_end_node_values()
		if cm:get_local_faction_name(true) == torinubar_faction_key then --ui thing and should be local
            cm:set_script_state("caravan_camera_x",1287);
            cm:set_script_state("caravan_camera_y",67);
        end
        
        if cm:get_faction(torinubar_faction_key):is_human() then
            rhox_torinubar_events_cooldown[torinubar_faction_key] = {
                ["rhox_torinubar_dilemma_cathay_caravan"] = 0,
                ["rhox_torinubar_dilemma_dwarfs"] = 0,
                ["rhox_torinubar_dilemma_far_from_home"] = 0,
                ["rhox_torinubar_dilemma_fresh_battlefield"] = 0,
                ["rhox_torinubar_dilemma_hungry_daemons"] = 0,
                ["rhox_torinubar_dilemma_localised_elfs"] = 0,
                ["rhox_torinubar_dilemma_offence_or_defence"] = 0,
                ["rhox_torinubar_dilemma_ogre_mercenaries"] = 0,
                ["rhox_torinubar_dilemma_power_overwhelming"] = 0,
                ["rhox_torinubar_dilemma_quick_way_down"] = 0,
                ["rhox_torinubar_dilemma_rats_in_a_tunnel"] = 0,
                ["rhox_torinubar_dilemma_redeadify"] = 0,
                ["rhox_torinubar_dilemma_the_ambush"] = 0,
                ["rhox_torinubar_dilemma_the_guide"] = 0,
                ["rhox_torinubar_dilemma_trading_dark_elfs"] = 0,
                ["rhox_torinubar_dilemma_training_camp"] = 0,
                ["rhox_torinubar_dilemma_way_of_lava"] = 0
            }
		end
		

		local all_factions = cm:model():world():faction_list();
		local faction = nil;
		for i=0, all_factions:num_items()-1 do
			faction = all_factions:item_at(i)
			if not faction:is_human() and faction:name() == torinubar_faction_key then
				cm:apply_effect_bundle("wh3_main_caravan_AI_threat_reduction", faction:name(),0)
			end
		end
	end
);





--panel ui thing
cm:add_first_tick_callback(
	function ()
        ------rhox-----------------
        if cm:get_local_faction_name(true)== torinubar_faction_key then --ui thing and should be local
            
            core:add_listener(--this is where changing all the localization, resource for Torinubar happens
                "rhox_torinubar_convoy_open_listener",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "military_convoys";
                end,
                function()
                    out("Rhox Torinubar: Opened military convoy panel")
                    local resource_holder = find_uicomponent(core:get_ui_root(), "military_convoys", "left_panel", "content_list", "header_container", "resource_list");
                    if not resource_holder then
                        out("Rhox Torinubar: There was no resource holder, bye")
                        return
                    end
                    local dread_ui = find_uicomponent(resource_holder, "dy_dread");
                    if not dread_ui then
                        out("Rhox Torinubar: There was no dread ui, bye")
                        return
                    end
                    dread_ui:SetVisible(false)
                    
                    
                    local result = core:get_or_create_component("rhox_torinubar_convoy_panel_east.twui.xml", "ui/campaign ui/rhox_torinubar_convoy_panel_east.twui.xml", resource_holder)
                    local result2 = core:get_or_create_component("rhox_torinubar_convoy_panel_west.twui.xml", "ui/campaign ui/rhox_torinubar_convoy_panel_west.twui.xml", resource_holder)
                    
                    
                end,
                true
            )

        end


	end
);
--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_torinubar_events_cooldown", rhox_torinubar_events_cooldown, context);
	end
);

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			rhox_torinubar_events_cooldown = cm:load_named_value("rhox_torinubar_events_cooldown", rhox_torinubar_events_cooldown, context);
		end;
	end
);