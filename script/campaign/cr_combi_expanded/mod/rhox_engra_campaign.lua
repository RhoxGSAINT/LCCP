core:add_listener(
    "rhox_engra_turn_start",
    "FactionTurnStart",
    function(context)
        return context:faction():name() =="rhox_chs_the_deathswords"
    end,
    function(context)
        local faction = context:faction()
        local bonus_value = context:faction():bonus_values():scripted_value("rhox_engra_vassal_effect_script_value", "value")
        
        local archaon_faction = cm:get_faction("wh_main_chs_chaos")
        
        if not archaon_faction or archaon_faction:is_dead() then 
            return
        end
        
        cm:remove_effect_bundle("rhox_engra_engra_support", "wh_main_chs_chaos")
        
        local engra_bundle = cm:create_new_custom_effect_bundle("rhox_valbrand_innate_effect_bundle");
        engra_bundle:set_duration(2); --so Archaon should not get it when Engra faction is dead
        engra_bundle:add_effect("wh_main_effect_force_stat_ward_save", "faction_to_faction_leader", 5); --base value. Human will only get this for most of the time
        if bonus_value > 0 then
            engra_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "faction_to_force_own", bonus_value);
        end
        
        
        local resource_value = faction:pooled_resource_manager():resource("rhox_engra_campaign_progress"):value()
        if resource_value > 10000 then
            engra_bundle:add_effect("wh_main_effect_force_stat_melee_attack", "faction_to_force_own", 5);
            engra_bundle:add_effect("wh_main_effect_force_stat_leadership", "faction_to_force_own", 10);
        end
        if resource_value > 30000 then
            engra_bundle:add_effect("wh_main_effect_force_stat_melee_defence", "faction_to_force_own", 5);
            engra_bundle:add_effect("wh_main_effect_character_stat_unit_health", "faction_to_character_own", 10);
        end
        if resource_value > 50000 then
            engra_bundle:add_effect("wh_main_effect_force_stat_ward_save", "faction_to_force_own", 10);
        end
        cm:apply_custom_effect_bundle_to_faction(engra_bundle, archaon_faction)
        --TODO change effects to the one made by HKrul
    end,
    true
);




	


cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "rhox_chs_the_deathswords" then --ui things 
            
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_engra_progress_bar", "ui/campaign ui/rhox_engra_progress_bar.twui.xml", parent_ui)
      
        end
    end
);

