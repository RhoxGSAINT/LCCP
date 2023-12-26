--Everything is local so I'm just reusing all the numbers

local skull_piles = {};
local skull_pile_base_duration = 15 -- duration of piles if there are no others on the map when spawned
local skull_pile_min_duration = 5
local skull_pile_min_skulls = 50
local skull_pile_max_skulls = 500
local skulls_per_casualty = 0.2
local skull_pile_threshold = 200 -- if combined sum of all modifiers +random roll of 1- skull pile threshold exceeds this, spawn a pile. THis higher this is, the more random the spawns will be
local khorne_corruption_weight = 2 -- multiplier on the value of Khorne corruption in the calculation
local chs_corruption_weight = 1 -- multiplier on the value of generic Chaos corruption in the calculation
local bonus_at_0_piles = 100 -- amount added to roll when there are 0 piles on the map
local modifier_per_active_pile = 10 -- amount to reduce above bonus by per active pile. can go negative.
local vision_bonus = 75 --if battle is visible to any player khorne faction, add this to roll
local kho_player_faction_strings = {"cr_kho_servants_of_the_blood_nagas", "rhox_kho_destroyers_of_khorne"}





function rhox_lccp_setup_khorne_skulls()
	for i = 1, #kho_player_faction_strings do
		if cm:get_faction(kho_player_faction_strings[i]):is_human() and not cm:get_faction(kho_player_faction_strings[i]):pooled_resource_manager():resource("wh3_main_kho_skulls"):is_null_interface() then
			rhox_lccp_start_khorne_skull_listeners();
			return;
		end;
	end;
end;

cm:add_first_tick_callback(
	function()
		rhox_lccp_setup_khorne_skulls()
	end
);


function rhox_lccp_start_khorne_skull_listeners()
	skull_piles = cm:get_saved_value("rhox_lccp_skull_piles") or {};
	
	for k, v in pairs(skull_piles) do
		common.set_context_value(k, v);
	end;
	
	core:add_listener(
		"rhox_lccp_khorne_skull_pile",
		"BattleCompleted",
		function()
			local pb = cm:model():pending_battle();
			local region = cm:get_region(pb:region_data():key());
			if not region then
				return false
			end

			return pb:has_been_fought() and not cm:pending_battle_cache_human_culture_is_involved("wh3_main_kho_khorne")
		end,
		function()
			local pb = cm:model():pending_battle();
			
			local pos_x = nil;
			local pos_y = nil;
			local winner_cqi = nil;
			local winner_interface = nil
			local winner_faction = nil;
			
			if pb:has_attacker() then
				local attacker = pb:attacker();
				
				if attacker:won_battle() then
					pos_x = attacker:logical_position_x();
					pos_y = attacker:logical_position_y();
					winner_interface = attacker
					winner_cqi = attacker:command_queue_index();
					winner_faction = attacker:faction():name();
				end;
			end;
			
			if pb:has_defender() then
				local defender = pb:defender();
				
				if defender:won_battle() then
					pos_x = defender:logical_position_x();
					pos_y = defender:logical_position_y();
					winner_interface = defender
					winner_cqi = defender:command_queue_index();
					winner_faction = defender:faction():name();
				end;
			end;
			
			if not winner_cqi then
				return false;
			end;
			
			local id = "skull_pile_" .. winner_cqi .. "_" .. cm:model():turn_number().."_rhox_lccp";
			
			if not skull_piles[id] then
				local distance = 5;
				
				-- ensure the skull pile doesn't spawn inside the settlement's zoc
				if pb:siege_battle() then
					local settlement = pb:region_data():region():settlement();
					
					pos_x = settlement:logical_position_x();
					pos_y = settlement:logical_position_y();
					distance = 10;
				end;
				
				pos_x, pos_y = cm:find_valid_spawn_location_for_character_from_position(winner_faction, pos_x, pos_y, true, distance);
				
				if pos_x > 0 then
					local region = cm:get_region(pb:region_data():key());
					local corruption_mod = cm:get_corruption_value_in_region(region, khorne_corruption_string)*khorne_corruption_weight + cm:get_corruption_value_in_region(region, chaos_corruption_string)*chs_corruption_weight
					local skulls = math.clamp(math.floor((pb:attacker_casulaties() + pb:defender_casulaties())*skulls_per_casualty + 1), skull_pile_min_skulls, skull_pile_max_skulls)
					local active_piles = cm:get_saved_value("rhox_lccp_active_piles") or 0
					local active_piles_mod = bonus_at_0_piles - modifier_per_active_pile * active_piles
					local vision_mod = 0

					for i=1, #kho_player_faction_strings do
						if winner_interface:is_visible_to_faction(kho_player_faction_strings[i]) then
							vision_mod = vision_bonus
							break
						end
					end

					if cm:random_number(skull_pile_threshold, 1) + active_piles_mod + vision_mod < skull_pile_threshold then --adjusted by Rhox. Not doing corruption since it's already taken into account by vanilla script
						return 
					end
					out("Rhox LCCP: Skull made: "..pos_x .. "/" ..pos_y)
					
				 	cm:add_interactable_campaign_marker(id, "wh3_main_kho_skull_pile", pos_x, pos_y, 2);
										
					local a_cqi, af_cqi, attacker_faction = cm:pending_battle_cache_get_attacker(1);
					local d_cqi, df_cqi, defender_faction = cm:pending_battle_cache_get_defender(1);

					local adjusted_duration = math.clamp(skull_pile_base_duration - active_piles, skull_pile_min_duration, skull_pile_base_duration)
					
					skull_piles[id] = {
						["kills"] = skulls,
						["turns_remaining"] = adjusted_duration,
						["attacker_faction"] = attacker_faction,
						["defender_faction"] = defender_faction
					};
					
					common.set_context_value(id, skull_piles[id]);
					
					cm:add_turn_countdown_event(cm:get_local_faction_name(true), adjusted_duration, "ScriptEventKhorneSkullPileExpires", id);
					
					cm:set_saved_value("rhox_lccp_skull_piles", skull_piles);
					cm:set_saved_value ("rhox_lccp_active_piles", active_piles + 1)

					core:trigger_custom_event("ScriptEventSkullPileCreated", {region = region, pending_battle = pb, logical_position_x = pos_x, logical_position_y = pos_y});
				end;
			end;
		end,
		true
	);
	
	core:add_listener(
		"rhox_lccp_khorne_skull_piled_collected",
		"AreaEntered",
		function(context)
			local character = context:family_member():character();
			if not character:is_null_interface() then
				local faction = character:faction();
				return skull_piles[context:area_key()] and faction:is_human() and faction:culture() == "wh3_main_kho_khorne";
			end;
		end,
		function(context)
			local character = context:family_member():character();
			if not character:is_null_interface() then

				local id = context:area_key();
				local mod = 1 + (character:bonus_values():scripted_value("skull_piles_modifier", "value") / 100);
				
				cm:trigger_custom_incident_with_targets(character:faction():command_queue_index(), "wh3_main_incident_kho_skull_pile_collected", true, "payload{faction_pooled_resource_transaction{resource wh3_main_kho_skulls;factor collected_from_skull_piles;amount " .. math.round(skull_piles[id]["kills"] * mod) .. ";context absolute;};}", 0, 0, character:command_queue_index(), 0, 0, 0);
				
				rhox_lccp_remove_skull_pile(id);
			end;
		end,
		true
	);
	
	core:add_listener(
		"rhox_lccp_khorne_skull_pile_expires",
		"ScriptEventKhorneSkullPileExpires",
		true,
		function(context)
			rhox_lccp_remove_skull_pile(context.string);
		end,
		true
	);
	
	-- update the context value each turn in order to display the turns remaining in the skull pile tooltips
	core:add_listener(
		"rhox_lccp_khorne_skull_pile_update_turn_timers",
		"FactionTurnStart",
		function(context)
			local faction = context:faction();
			
			return faction:is_human() and faction:culture() == "wh3_main_kho_khorne";
		end,
		function()
			for id, v in pairs(skull_piles) do
				local turns_remaining, a, e, c = cm:report_turns_until_countdown_event(cm:get_local_faction_name(true), "ScriptEventKhorneSkullPileExpires", id);
				
				if turns_remaining then
					skull_piles[id]["turns_remaining"] = turns_remaining;
					
					common.set_context_value(id, skull_piles[id]);
				end;
			end;
			
			cm:set_saved_value("rhox_lccp_skull_piles", skull_piles);
		end,
		true
	);
end;

function rhox_lccp_remove_skull_pile(id)
	cm:remove_interactable_campaign_marker(id);
	
	skull_piles[id] = nil;

	active_piles = cm:get_saved_value("rhox_lccp_active_piles")
	cm:set_saved_value("rhox_lccp_active_piles", active_piles -1)
	cm:set_saved_value("rhox_lccp_skull_piles", skull_piles);
end;


