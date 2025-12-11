local function rhox_thorgar_get_enemy_subtypes()--changeling one except for the heroes one and the agent_subtype
	local pb = cm:model():pending_battle()
	local attacker_subtypes = {}
	local defender_subtypes = {}
	local was_attacker = false

	local num_attackers = cm:pending_battle_cache_num_attackers()
	local num_defenders = cm:pending_battle_cache_num_defenders()

	if pb:night_battle() == true or pb:ambush_battle() == true then
		num_attackers = 1
		num_defenders = 1
	end
	
	for i = 1, num_attackers do
		local char_subtype = cm:pending_battle_cache_get_attacker_subtype(i)
		
		if char_subtype == "hkrul_thorgar" then
			was_attacker = true
			break
		end

		if not was_attacker then
			table.insert(attacker_subtypes, char_subtype)
		
		--[[
			local embedded_attacker_subtypes = cm:pending_battle_cache_get_attacker_embedded_character_subtypes(i)
			
			for j = 1, #embedded_attacker_subtypes do
				table.insert(attacker_subtypes, embedded_attacker_subtypes[j])
			end
			]]
		end
	end
	
	if was_attacker == false then
		return attacker_subtypes
	end
	
	for i = 1, num_defenders do
		local char_subtype = cm:pending_battle_cache_get_defender_subtype(i)
		
		table.insert(defender_subtypes, char_subtype)
		
		--[[
		local embedded_defender_subtypes = cm:pending_battle_cache_get_defender_embedded_character_subtypes(i)
		
		for j = 1, #embedded_defender_subtypes do
			table.insert(defender_subtypes, embedded_defender_subtypes[j])
		end
		]]
	end

	return defender_subtypes
end


--------------------------------------------Thorgar Initiatives
initiative_cultures["wh_dlc08_nor_norsca"]=true
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_01",--win 5 battles against LL
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				if not character:won_battle() then
                    return false
				end
				
				local enemy_agent_subtype = rhox_thorgar_get_enemy_subtypes()
                for i = 1, #enemy_agent_subtype do
                    --out("Rhox Thorgar: Looking at: ".. enemy_agent_subtype[i])
                    if cm:is_agent_transformation_available(enemy_agent_subtype[i]) then
                        --out("Rhox Thorgar: It's a LL")
                        if not cm:get_saved_value("rhox_thorgar_ll_number") then
                            cm:set_saved_value("rhox_thorgar_ll_number", 0)
                        end
                        cm:set_saved_value("rhox_thorgar_ll_number", cm:get_saved_value("rhox_thorgar_ll_number")+1)
                    end
                end
				
				return cm:get_saved_value("rhox_thorgar_ll_number") and cm:get_saved_value("rhox_thorgar_ll_number")>=5;
			end
	}
)


table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_02",--10 regions
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				local faction = character:faction()
				return faction and faction:region_list():num_items()>=10;
			end
	}
)

table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_03",--level 30
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 30;
			end
	}
)

table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_04",--20 offensive battle win
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:offensive_battles_won() >= 20
			end
	}
)


table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_ascend",
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
                local character = context:character();
				local faction = character:faction()
				return cm:get_saved_value("rhox_thorgar_ll_number") and cm:get_saved_value("rhox_thorgar_ll_number")>=5 and
				faction and faction:region_list():num_items()>=10 and
				character:rank() >= 30 and character:offensive_battles_won() >= 20
			end
	}
)


core:add_listener(
	"rhox_thorgar_upgrade_initiative_activated",
	"CharacterInitiativeActivationChangedEvent",
	function(context)
		return context:initiative():record_key() == "rhox_thorgar_ascend"
	end,
	function(context)
		local character = context:character()
		local old_char_details = {
			mf = character:military_force(),
			rank = character:rank(),
			fm_cqi = character:family_member():command_queue_index(),
			character_details = character:character_details(),
			faction_key = character:faction():name(),
			character_forename = character:get_forename(),
			character_surname = character:get_surname(),
			parent_force = character:embedded_in_military_force(),
			subtype = character:character_subtype_key(),
			traits = character:all_traits(),
			ap = character:action_points_remaining_percent()
		}
		local faction = context:character():faction()
		local character_cqi = character:command_queue_index();
		local faction_key = faction:name()

		local x, y = cm:find_valid_spawn_location_for_character_from_character(faction_key, cm:char_lookup_str(character), true, 5)
		local new_char_interface = nil
		local is_leader = false
		if character:faction():name() == "rhox_nor_khazags" then
           is_leader = true 
		end
		cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            faction_key,
            "",
            "cr_combi_region_tokmars_encampment",--doesn't matter
            x,
            y,
            "general",
            "hkrul_thorgar_daemon_prince",
            "names_name_5670700836",
            "",
            "names_name_5670700835",
            "",
            is_leader,
            function(cqi)
                new_char_interface = cm:get_character_by_cqi(cqi)
				local new_char_lookup = cm:char_lookup_str(cqi)
				cm:reassign_ancillaries_to_character_of_same_faction(old_char_details.character_details, new_char_interface:character_details())
				
                cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
                cm:suppress_immortality(character:family_member():command_queue_index() ,true)
                
                --cm:kill_character(cm:char_lookup_str(character_cqi), true)
                cm:callback(function() cm:kill_character_and_commanded_unit(cm:char_lookup_str(character_cqi), true) end, 0.1);
                cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);

                local composite_scene = "wh3_campaign_chaos_upgrade_daemons"
                x = new_char_interface:logical_position_x();
                y = new_char_interface:logical_position_y();
                cm:add_scripted_composite_scene_to_logical_position(composite_scene, composite_scene, x, y, x, y + 1, true, false, false);

				if old_char_details.traits then
					for i =1, #old_char_details.traits do
						local trait_to_copy = old_char_details.traits[i]
						cm:force_add_trait(new_char_lookup, trait_to_copy)
					end
				end
				cm:replenish_action_points(new_char_lookup, 100)
				cm:add_agent_experience(new_char_lookup, old_char_details.rank, true)
				cm:remove_event_restricted_building_record_for_faction("rhox_thorgar_dae_advanced_1",faction_key)
				cm:set_character_unique(cm:char_lookup_str(cqi),true)
            end
        );
	end,
	true
)



cm:add_first_tick_callback(
	function()
        if cm:model():turn_number() < 3 then
            core:add_listener(
                "rhox_thorgar_olaf_RoundStart",
                "FactionRoundStart",
                function(context)
                    return context:faction():is_human() and context:faction():name() =="rhox_nor_khazags" and cm:model():turn_number() == 2
                end,
                function(context)
                    local faction_key = context:faction():name()
                    local mm = mission_manager:new(faction_key, "rhox_thorgar_olaf_mission")
                    mm:add_new_objective("DEFEAT_N_ARMIES_OF_FACTION");
                    mm:add_condition("subculture wh3_main_sc_cth_cathay");
                    mm:add_condition("total 5");
                    mm:add_payload("add_ancillary_to_faction_pool{ancillary_key hkrul_thorgar_olaf;}");
                    mm:trigger()
                end,
                false
            )
        end
	end
)

		

--[[
--we can't use this way to a faction leader
CUS.initiative_to_agent_junctions["rhox_thorgar_ascend"] = {
    type = "general",
    subtype = "hkrul_thorgar_daemon_prince",
}
--]]
