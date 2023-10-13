cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "cr_dwf_firebeards_excavators" then --ui things 
            
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_burlok_topbar", "ui/campaign ui/rhox_burlok_topbar.twui.xml", parent_ui)
            
            core:add_listener(
                "rhox_burlok_artifact_click",
                "ComponentLClickUp",
                function(context)
                    return string.match(context.string, "rhox_burlok_vault_progression_button")
                end,
                function(context)
                    --crafting_panel_close:SimulateLClick()
                    local craft_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_mortuary_cult");
                    if not craft_button then
                        return
                    end
                    craft_button:SimulateLClick()
                    
                    --[[--it's first tab so we don't need it
                    cm:callback(
                        function()
                            local experiment_tab = find_uicomponent(core:get_ui_root(), "mortuary_cult", "header_list", "rhox_burlok_experiment", "button");
                            if experiment_tab then
                                experiment_tab:SimulateLClick()
                            end
                        end,
                        0.5
                    )
                    --]]
                end,
                true
            )
        end
    end
);