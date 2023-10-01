cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "cr_dwf_firebeards_excavators" then --ui things 
            
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_burlok_topbar", "ui/campaign ui/rhox_burlok_topbar.twui.xml", parent_ui)
      
        end
    end
);