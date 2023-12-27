------------------Zach

core:add_listener(
    "Zach_makes_alliance",
    "PositiveDiplomaticEvent",
    function(context)
        return ((context:recipient():name() =="rhox_vmp_the_everliving" and context:proposer():culture() == "wh_main_vmp_vampire_counts") 
        or (context:proposer():name() =="rhox_vmp_the_everliving" and context:recipient():culture() == "wh_main_vmp_vampire_counts")) 
        and (context:is_military_alliance() or context:is_defensive_alliance() or context:is_vassalage())
    end,
    function(context)
        if context:recipient():name() =="rhox_vmp_the_everliving" then
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
        return context:confederation():culture() == "wh_main_vmp_vampire_counts" and context:faction():name() == "rhox_vmp_the_everliving"
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
                if faction:name() ~= "rhox_vmp_the_everliving" then
                    cm:add_event_restricted_unit_record_for_faction("rhox_lccp_vmp_giant", faction:name(), "rhox_lccp_vmp_giant_lock")
                end
            end
        end;
    end
)