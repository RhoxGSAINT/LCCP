-----------Beorg
local rhox_beorg_ror_list={
    hkrul_bearmen =true,
    hkrul_beorg_bear_sem =true
}


core:add_listener(
    "Beorg_makes_alliance",
    "PositiveDiplomaticEvent",
    function(context)
        return ((context:recipient():name() =="mixer_nur_rotbloods" and context:proposer():culture() == "wh_dlc08_nor_norsca") 
        or (context:proposer():name() =="mixer_nur_rotbloods" and context:recipient():culture() == "wh_dlc08_nor_norsca")) 
        and (context:is_military_alliance() or context:is_defensive_alliance())
    end,
    function(context)
        if context:recipient():name() =="mixer_nur_rotbloods" then
            for unit_key, _ in pairs(rhox_beorg_ror_list) do
                cm:remove_event_restricted_unit_record_for_faction(unit_key, context:proposer():name())
            end
        else
            for unit_key, _ in pairs(rhox_beorg_ror_list) do
                cm:remove_event_restricted_unit_record_for_faction(unit_key, context:recipient():name())
            end
        end
        
        
    end,
    true
)

core:add_listener(
    "Beorg_confederation",
    "FactionJoinsConfederation",
    function(context)
        return context:confederation():culture() == "wh_dlc08_nor_norsca" and context:faction():name() == "mixer_nur_rotbloods"
    end,
    function(context)
        for unit_key, _ in pairs(rhox_beorg_ror_list) do
            cm:remove_event_restricted_unit_record_for_faction(unit_key, context:confederation():name())
        end
        
        cm:add_unit_to_faction_mercenary_pool(context:confederation(),"hkrul_beorg_brown_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral")
        cm:add_unit_to_faction_mercenary_pool(context:confederation(),"hkrul_beorg_brown_feral_marked","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral_marked")
        cm:add_unit_to_faction_mercenary_pool(context:confederation(),"hkrul_beorg_ice_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_ice_feral")
    end,
    true
)


core:add_listener(
    "rhox_beorg_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        local base_chance =20
        local bonus_chance = character:bonus_values():scripted_value("rhox_beorg_bonus_chance", "value")

        return character:character_subtype_key() == "hkrul_beorg" and pb:has_been_fought() and character:won_battle() and cm:model():random_percent(base_chance+bonus_chance)
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        
        
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_beorg_bear_unit_incident")
            incident_builder:add_target("default", character)
            local payload_builder = cm:create_payload()
            payload_builder:add_mercenary_to_faction_pool("hkrul_beorg_brown_feral", 1)  
            payload_builder:add_mercenary_to_faction_pool("hkrul_beorg_brown_feral_marked", 1)
            payload_builder:add_mercenary_to_faction_pool("hkrul_beorg_ice_feral", 1)
            incident_builder:set_payload(payload_builder)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        else
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "hkrul_beorg_brown_feral", 1)
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "hkrul_beorg_brown_feral_marked", 1)
            cm:add_units_to_faction_mercenary_pool(faction:command_queue_index(), "hkrul_beorg_ice_feral", 1)
        end
    end,
    true
)


------------------Zach

core:add_listener(
    "Zach_makes_alliance",
    "PositiveDiplomaticEvent",
    function(context)
        return ((context:recipient():name() =="cr_vmp_the_everliving" and context:proposer():culture() == "wh_main_vmp_vampire_counts") 
        or (context:proposer():name() =="cr_vmp_the_everliving" and context:recipient():culture() == "wh_main_vmp_vampire_counts")) 
        and (context:is_military_alliance() or context:is_defensive_alliance() or context:is_vassalage())
    end,
    function(context)
        if context:recipient():name() =="cr_vmp_the_everliving" then
            cm:remove_event_restricted_unit_record_for_faction("rhox_lccp_vmp_giant", context:proposer():name())
        else
            cm:remove_event_restricted_unit_record_for_faction("rhox_lccp_vmp_giant", context:recipient():name())
        end
        
        
    end,
    true
)

core:add_listener(
    "Zach_confederation",
    "FactionJoinsConfederation",
    function(context)
        return context:confederation():culture() == "wh_main_vmp_vampire_counts" and context:faction():name() == "cr_vmp_the_everliving"
    end,
    function(context)
        cm:remove_event_restricted_unit_record_for_faction("rhox_lccp_vmp_giant", context:confederation():name())
    end,
    true
)


cm:add_first_tick_callback_new(
    function()
        local all_factions = cm:model():world():faction_list();
        for i = 0, all_factions:num_items()-1 do
            local faction = all_factions:item_at(i);
            if faction:culture() == "wh_main_vmp_vampire_counts" then
                cm:add_unit_to_faction_mercenary_pool(faction, "rhox_lccp_vmp_giant", "renown", 1, 20, 1, 0.1, "", "", "", true, "rhox_lccp_vmp_giant")
                if faction:name() ~= "cr_vmp_the_everliving" then
                    cm:add_event_restricted_unit_record_for_faction("rhox_lccp_vmp_giant", faction:name(), "rhox_lccp_vmp_giant_lock")
                end
            end
            
            if faction:culture() == "wh_dlc08_nor_norsca" then
                for unit_key, _ in pairs(rhox_beorg_ror_list) do
                    cm:add_unit_to_faction_mercenary_pool(faction, unit_key, "renown", 1, 20, 1, 0.1, "", "", "", true, unit_key)
                    if faction:name() ~= "mixer_nur_rotbloods" then
                        cm:add_event_restricted_unit_record_for_faction(unit_key, faction:name(), unit_key.."_lock")
                    end
                end
            end
        end;
    end
)






