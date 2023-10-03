local dolmance_faction = "rhox_brt_reveller_of_domance"


local function rhox_diktat_button_visibility()
    local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "info_panel_holder", "primary_info_panel_holder", "info_panel_background", "ProvinceInfoPopup", "script_hider_parent", "panel") 
    if parent_ui then
        local diktat_panel = find_child_uicomponent(parent_ui, "frame_devotees")
        if diktat_panel then
            diktat_panel:SetVisible(true)
        end
    end
end

local function rhox_dolmance_set_diktat_listeners()
        
    --- Trigger check for visibility when settlement is selected
    core:add_listener(
        "rhox_dolmance_diktat_trigger",
        "SettlementSelected",
        true,
        function(context)
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 1)
                
            
        end,
        true
    )
    
    core:add_listener(
        "rhox_dolmance_performed_slave_diktats",
        "ComponentLClickUp",
        function(context)
            return string.find(context.string, "wh3_main_ritual_sla_pleasure_")
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )


    --- Trigger whenever vampire coven slot is pressed
    core:add_listener(
        "rhox_dolmance_diktat_click_trigger_1",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_expand_slot"
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )


    --- Trigger whenever vampire coven slot is pressed
    core:add_listener(
        "rhox_dolmance_diktat_click_trigger_2",
        "ComponentLClickUp",
        function (context)
            return context.string == "square_building_button"
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )
    
    core:add_listener(
        "rhox_dolmance_diktat_click_trigger_3",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_raze"
        end,
        function()
            core:get_tm():real_callback(function()
                rhox_diktat_button_visibility()
            end, 100)
        end,
        true
    )
end


cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name(true) == dolmance_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_dolmance_devotee_holder", "ui/campaign ui/rhox_dolmance_devotee_holder.twui.xml", parent_ui)
            rhox_dolmance_set_diktat_listeners()
        end
	end
)
	