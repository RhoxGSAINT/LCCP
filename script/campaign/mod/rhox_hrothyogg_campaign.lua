--------------------------------------------Hrothyogg big names
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_1",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and cm:count_char_army_has_unit(character, {"wh3_main_ogr_inf_maneaters_0", "wh3_main_ogr_inf_maneaters_1", "wh3_main_ogr_inf_maneaters_2", "wh3_main_ogr_inf_maneaters_3", "wh3_twa06_ogr_inf_maneaters_ror_0", "wh3_dlc26_ogr_inf_eshin_maneater_ror", "wh3_dlc26_ogr_inf_golgfags_maneaters"}) > 3;
				
				
			end
	}
)
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_2",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				return cm:character_won_battle_against_culture(context:character(), "wh2_main_skv_skaven");
			end
	}
)
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_3",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local region = character:region()
				
				if region:is_null_interface() == false then
					return region:name() == "wh3_main_combi_region_miragliano"
				else
					return false
				end
			end
	}
)
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_4",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
                local character = context:character();

				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker_casulaties() > 1000
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender_casulaties() > 1000
					end;
				end;
			end
	}
)

------------------------mercenary_branch







core:add_listener(
    "rhox_hrothyogg_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        local base_chance =5
        local bonus_chance = character:bonus_values():scripted_value("rhox_hrothyogg_recruiter_gain_chance", "value")

        return character:character_subtype_key() == "hkrul_hrothyogg" and faction:name() == "cr_ogr_deathtoll" and pb:has_been_fought() and character:won_battle() and cm:model():random_percent(base_chance+bonus_chance)
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        
        local x, y = cm:find_valid_spawn_location_for_character_from_character(faction:name(), cm:char_lookup_str(character), true, 5)
        
        if x == -1 or y == -1 then
            out("Rhox LCCP: invalid spawn position, returning")
            return
        end
        local created_character = cm:create_agent(faction:name(), "wizard", "rhox_hrothyogg_recruiter", x, y);       
        
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_hrothyogg_mercenary_recruiter")
            incident_builder:add_target("default", created_character)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        end
    end,
    true
)

core:add_listener(
    "rhox_hrothyogg_region_turn_start",
    "FactionTurnStart",
    function (context)
        return context:faction():name()=="cr_ogr_deathtoll"
    end,
    function(context)
        local faction = cm:get_faction("cr_ogr_deathtoll")
        local fsm = faction:foreign_slot_managers();
        for i=0,fsm:num_items()-1 do
            local region_fsm = fsm:item_at(i)
            local region_name = region_fsm:region():name()
            local region = cm:get_region(region_name)
            if region:owning_faction() and region:owning_faction():at_war_with(faction) then
                out("Rhox Hrothyogg: region ".. region_name .. " was owned by the faction who is at war with Hrothyogg. Destroying the slot")
                local settlement = region:settlement()
                local settlement_x = settlement:logical_position_x();
                local settlement_y = settlement:logical_position_y();
                cm:show_message_event_located(
                    "cr_ogr_deathtoll",
                    "rhox_hrothyogg_branch_destroyed_title",
                    "regions_onscreen_" .. region_name,
                    "rhox_hrothyogg_branch_destroyed_description",
                    settlement_x,
                    settlement_y,
                    true,
                    1803
                );
                core:get_tm():real_callback(function()
                    cm:remove_faction_foreign_slots_from_region(cm:get_faction("cr_ogr_deathtoll"):command_queue_index(),region:cqi())
                end, 100)		
            end
        end
    end,
    true
)

local ogre_maneater_list={
    "rhox_hrothyogg_ogr_inf_maneaters_0",
    "rhox_hrothyogg_ogr_inf_maneaters_1",
    "rhox_hrothyogg_ogr_inf_maneaters_2",
    "rhox_hrothyogg_ogr_inf_maneaters_3"
}

local rhox_hrothyogg_mercenary_factions={}

core:add_listener(
    "rhox_hrothyogg_mercenary_branch_building_completed",
    "BuildingCompleted",
    function(context)    
        return context:building():name() == "rhox_hrothyogg_mercenary_branch"
    end,
    function(context)
        local building = context:building()
        local region = building:region()
        local owner_faction = region:owning_faction()

        if not owner_faction then
            return
        end

        if not rhox_hrothyogg_mercenary_factions[owner_faction:name()] then
            rhox_hrothyogg_mercenary_factions[owner_faction:name()] = true
            for i = 1, #ogre_maneater_list do
                cm:add_unit_to_faction_mercenary_pool(owner_faction, ogre_maneater_list[i], "renown", 0, 0, 10, 0, "", "", "", true, ogre_maneater_list[i])
            end
        end--add initial mercenary if they haven't got one


        if owner_faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_hrothyogg_mercenary_branch_established")
            incident_builder:add_target("default", region)
            local payload_builder = cm:create_payload()
            payload_builder:add_mercenary_to_faction_pool(ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)  
            payload_builder:add_mercenary_to_faction_pool(ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)  
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, owner_faction)
        else
            cm:add_units_to_faction_mercenary_pool(owner_faction:command_queue_index(), ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)
            cm:add_units_to_faction_mercenary_pool(owner_faction:command_queue_index(), ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)
        end
        
    end,
    true
)

core:add_listener(
    "rhox_hrothyogg_region_turn_start",
    "RegionTurnStart",
    function(context)
        local bonus_value = context:region():bonus_values():scripted_value("rhox_hrothyogg_mercenary_chance", "value")
        return cm:model():random_percent(bonus_value);
    end,
    function(context)
        local region = context:region()
        local owner_faction = region:owning_faction()
        if not rhox_hrothyogg_mercenary_factions[owner_faction:name()] then
            rhox_hrothyogg_mercenary_factions[owner_faction:name()] = true
            for i = 1, #ogre_maneater_list do
                cm:add_unit_to_faction_mercenary_pool(owner_faction, unit, "renown", 0, 0, 10, 0, "", "", "", true, ogre_maneater_list[i])
            end
        end--add initial mercenary if they haven't got one. Owners might change, so have to do it here also

        if owner_faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_hrothyogg_mercenary_recieved")
            incident_builder:add_target("default", region)
            local payload_builder = cm:create_payload()
            payload_builder:add_mercenary_to_faction_pool(ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)  
            payload_builder:add_mercenary_to_faction_pool(ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)  
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, owner_faction)
        else
            cm:add_units_to_faction_mercenary_pool(owner_faction:command_queue_index(), ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)
            cm:add_units_to_faction_mercenary_pool(owner_faction:command_queue_index(), ogre_maneater_list[cm:random_number(#ogre_maneater_list)], 1)
        end
    end,
    true
);


-------------------------------hrothyogg toll


local function rhox_hrothyogg_trigger_incident(hrothyogg_character, hrothyogg_faction, character_list, candidate_faction)
    --out("Rhox Hrothyogg: Checking faction: ".. candidate_faction:name())
	local target = nil
	for i=0, character_list:num_items()-1 do
		local candidate = character_list:item_at(i)
		if candidate:character_type_key() == "general" then
            target = candidate
			break
		end
	end

	if not target then
		return
	end
	
	out("Rhox Hrothyogg: Found a target!")

	if hrothyogg_faction:is_human() then
		local incident_builder = cm:create_incident_builder("rhox_hrothyogg_toll_collected")
		incident_builder:add_target("default", target:military_force())
		local payload_builder = cm:create_payload()
        payload_builder:treasury_adjustment(1000)
        incident_builder:set_payload(payload_builder)
		cm:launch_custom_incident_from_builder(incident_builder, hrothyogg_faction)
	else
		cm:treasury_mod(hrothyogg_faction:name(), 1000)
	end

	if target:faction():is_human() then
		local incident_builder = cm:create_incident_builder("rhox_hrothyogg_toll_gang")
		incident_builder:add_target("default", hrothyogg_character:military_force())
		local payload_builder = cm:create_payload()
        payload_builder:treasury_adjustment(-1000)
        incident_builder:set_payload(payload_builder)
		cm:launch_custom_incident_from_builder(incident_builder, target:faction())
	else
		cm:treasury_mod(target:faction():name(), -1000)
	end
end



core:add_listener(--this is too expensive should I keep doing it
    "rhox_hrothyogg_character_turn_start",
    "CharacterTurnStart",
    function (context)
        local character = context:character()
        return character:character_subtype_key() == "hkrul_hrothyogg" and character:region() and character:region():is_null_interface()==false and character:region():owning_faction() and character:region():owning_faction():name() == character:faction():name()
		--character has to be hrothyogg, the region he is standing is owned by him
    end,
    function(context)
        out("Rhox Hrothyogg: Start!")
        local character = context:character()
		local region = character:region()
		local region_data = region:region_data_interface()
		local hrothyogg_faction = character:faction()

		local all_factions = cm:model():world():faction_list();
		local faction = nil;
		for i=0, all_factions:num_items()-1 do
			faction = all_factions:item_at(i)
			if faction:name() ~= hrothyogg_faction:name() and not hrothyogg_faction:at_war_with(faction) and not hrothyogg_faction:allied_with(faction) then --the faction is not hrothy faction, is not at war, is not allied with
                --out("Rhox Hrothyogg: Checking faction: ".. faction:name())
				local character_list= region_data:characters_of_faction_in_region(faction)
				if character_list and character_list:num_items()>=1 then --check whether there is a character in the region
					rhox_hrothyogg_trigger_incident(character, hrothyogg_faction, character_list, faction)
				end
			end 
		end
    end,
    true
)


--------------------------------------------Mercenary contract

if common.get_context_value("CcoOwnershipProductRecord", "TW_WH3_OMENS_OF_DESTRUCTION_OGR", "IsOwned") then
    if merc_contracts then
        merc_contracts.mercenary_factions["cr_ogr_deathtoll"]=true
    end
    cm:add_first_tick_callback(
        function()
            if cm:get_local_faction_name(true) == "cr_ogr_deathtoll" then --ui things 
                local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management");
                local panel = core:get_or_create_component("rhox_hrothyogg_mercenary_contract", "ui/campaign ui/rhox_hrothyogg_mercenary_contract.twui.xml", parent_ui)
                
                core:add_listener(
                    "rhox_hrotythyogg_panel_open_button_leftclick",
                    "ComponentLClickUp",
                    function (context)
                        return context.string == "rhox_hrothyogg_mercenary_contract"
                    end,
                    function ()
                        local existing_panel = find_uicomponent(core:get_ui_root(), "rhox_hrothyogg_mercenary_contract_panel");
                        if existing_panel then
                        existing_panel:Destroy() 
                        else
                            core:get_or_create_component("rhox_hrothyogg_mercenary_contract_panel", "ui/campaign ui/dlc26_ogre_war_contracts.twui.xml", core:get_ui_root())
                        end
                    end,
                    true
                )
                core:add_listener(
                    "rhox_hrotythyogg_panel_close_button_leftclick",
                    "ComponentLClickUp",
                    function (context)
                        return context.string == "button_close"
                    end,
                    function ()
                        local panel = find_uicomponent(core:get_ui_root(), "rhox_hrothyogg_mercenary_contract_panel")
                        if panel then
                            panel:Destroy()
                        end
                    end,
                    true
                )
                core:add_listener(
                    "rhox_hrotythyogg_MercContractAccepted",
                    "WarContractAcceptedEvent",
                    true,
                    function(context)
                        local panel = find_uicomponent(core:get_ui_root(), "rhox_hrothyogg_mercenary_contract_panel")
                        if panel then
                            panel:Destroy()
                        end
                    end,
                    true
                )
                
                core:add_listener(
                    "rhox_hrotythyogg_MercContractSuccess",
                    "WarContractSuccessEvent",
                    true,
                    function(context)
                        local panel = find_uicomponent(core:get_ui_root(), "rhox_hrothyogg_mercenary_contract_panel")
                        if panel then
                            panel:Destroy()
                        end
                    end,
                    true
                )

            end
        end
    );
    
    

end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_hrothyogg_mercenary_factions", rhox_hrothyogg_mercenary_factions, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if cm:is_new_game() == false then
			rhox_hrothyogg_mercenary_factions = cm:load_named_value("rhox_hrothyogg_mercenary_factions", rhox_hrothyogg_mercenary_factions, context)
		end
	end
)