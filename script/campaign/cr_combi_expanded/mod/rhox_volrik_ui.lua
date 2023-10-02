local volrik_faction ="rhox_nor_ravenblessed"


local function rhox_volrik_god_bar_ui()
    local norsca_gods_frame = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar", "norsca_favour", "norsca_gods_frame")
    if not norsca_gods_frame then
        return
    end
    norsca_gods_frame:SetImagePath("ui/skins/default/nor_gods_bg_volrik.png")
    for i = 0, norsca_gods_frame:ChildCount() - 1 do
        local current_list = UIComponent(norsca_gods_frame:Find(i))
        if not current_list then
            return
        end
        local current_id = current_list:Id()
        if current_id == "list_hound" or current_id == "list_serpent" or current_id == "list_crow" then
            for j = 0, current_list:ChildCount() - 1 do
                local current_tier = UIComponent(current_list:Find(j))
                if not current_tier then
                    return
                end
                current_tier:SetVisible(false)
            end
        end		
    end
    
    
end


cm:add_first_tick_callback(
    function()
    
        if cm:get_local_faction_name(true) == volrik_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_volrik_grimoire_holder", "ui/campaign ui/rhox_volrik_grimoire_holder.twui.xml", parent_ui)
            
            core:add_listener(
                "rhox_volrik_disable_occupation_options",
                "PanelOpenedCampaign",
                function(context)
                    return context.string == "settlement_captured"
                end,
                function(context)
                    local panel = find_uicomponent(core:get_ui_root(), "settlement_captured")
                    local kill = find_uicomponent(panel, "1963655228")
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
            
            rhox_volrik_god_bar_ui()
            
            

            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management");
            --local result = core:get_or_create_component("rhox_button_ogre_contracts", "ui/campaign ui/rhox_grudge_contract.twui.xml", parent_ui)
            local result = UIComponent(parent_ui:CreateComponent("rhox_volrik_chaos_gift", "ui/campaign ui/rhox_volrik_chaos_gift_button.twui.xml"))
            
            
            core:add_listener(
                "rhox_volrik_panel_open_button_leftclick",
                "ComponentLClickUp",
                function (context)
                    return context.string == "rhox_volrik_chaos_gift"
                end,
                function ()
                    
                    local panel = core:get_or_create_component("rhox_volrik_chaos_gift_panel", "ui/campaign ui/rhox_volrik_chaos_gift_panel.twui.xml", core:get_ui_root())
                end,
                true
            )
            
            
            
            core:add_listener(
                "rhox_volrik_panel_close_button_leftclick",
                "ComponentLClickUp",
                function (context)
                    return context.string == "rhox_volrik_button_ok"
                end,
                function ()
                    local panel = find_uicomponent(core:get_ui_root(), "rhox_volrik_chaos_gift_panel")
                    if panel then
                        panel:Destroy()
                    end
                end,
                true
            )
        end
        
    end
)