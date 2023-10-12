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
        engra_bundle:set_duration(0);
        engra_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "faction_to_force_own", bonus_value);
        
        
        local resource_value = faction:pooled_resource_manager():resource("rhox_engra_campaign_progress"):value()
        if resource_value > 10000 then
            engra_bundle:add_effect("wh_main_effect_force_stat_melee_attack", "faction_to_force_own", 1);
        end
        if resource_value > 30000 then
            engra_bundle:add_effect("wh_main_effect_force_stat_melee_defence", "faction_to_force_own", 2);
        end
        if resource_value > 50000 then
            engra_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "faction_to_force_own", 3);
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

