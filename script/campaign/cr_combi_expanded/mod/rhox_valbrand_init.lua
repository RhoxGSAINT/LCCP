local valbrand_faction ="rhox_nor_firebrand_slavers"

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(valbrand_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            valbrand_faction,
            "wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_main_kho_inf_chaos_warriors_0,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_main_kho_inf_chaos_warhounds_0,wh_dlc08_nor_mon_norscan_giant_0",
            "cr_combi_region_ihan_3_1",
            1460,
            580,
            "general",
            "hkrul_valbrand",
            "names_name_6330700834",
            "",
            "names_name_6330700833",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
        cm:force_declare_war(valbrand_faction, "cr_cth_the_chosen", false, false)
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
    end
)


cm:add_first_tick_callback(
    function()
        
        if cm:get_local_faction_name(true) == valbrand_faction then
            core:add_listener(
                "rhox_firebrand_disable_vanilla_occu_options",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "settlement_captured"
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "settlement_captured")
                    local kill = find_uicomponent(panel, "1292694896")
                    local maim = find_uicomponent(panel, "1369123792")
                    local burn = find_uicomponent(panel, "1824195232")
                            
                    if kill then 
                        kill:SetVisible(false)
                    end
                    if maim then
                        maim:SetVisible(false)
                    end
                    if burn then
                        burn:SetVisible(false)
                    end  
                end,
                true
            )
            
            local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour", "norsca_gods_frame")
            for i = 0, norsca_gods_frame:ChildCount() - 1 do
                local current_list = UIComponent(norsca_gods_frame:Find(i))
                local current_id = current_list:Id()
                if current_id == "list_eagle" or current_id == "list_serpent" or current_id == "list_crow" then
                    for j = 0, current_list:ChildCount() - 1 do
                        local current_tier = UIComponent(current_list:Find(j))
                        current_tier:SetState("locked")
                    end
                end		
            end
            
            local locked_overlay = find_uicomponent(norsca_gods_frame, "locked_overlay")	
            locked_overlay:SetVisible(true)



        end
        
    end
)


	