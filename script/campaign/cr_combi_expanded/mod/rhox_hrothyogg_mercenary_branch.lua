local base_chance =5




core:add_listener(
    "rhox_hrothyogg_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();

        return character:character_subtype_key() == "hkrul_hrothyogg" and faction:name() == "cr_ogr_deathtoll" and pb:has_been_fought() and character:won_battle() and cm:model():random_percent(base_chance)
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