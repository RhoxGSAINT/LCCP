local torinubar_faction = "cr_hef_gate_guards"

local order_cultures={
	wh2_main_hef_high_elves =true,
	wh2_main_lzd_lizardmen =true,
	wh3_main_cth_cathay =true,
	wh3_main_ksl_kislev =true,
	wh_dlc05_wef_wood_elves =true,
	wh_main_brt_bretonnia =true,
	wh_main_dwf_dwarfs =true,
	wh_main_emp_empire =true,
	mixer_teb_southern_realms =true,
	ovn_albion =true,
	ovn_amazon =true,
	ovn_halflings =true,
	mixer_nip_nippon =true
}



local eastern_regions={
	["cr_combi_region_nippon_3_1"]				= true,
	["cr_combi_region_somnagiri"]					= true,
	["wh3_main_combi_region_dai_cheng"]			= true,
	["cr_combi_region_ihan_3_1"]				= true,
	["wh3_main_combi_region_fu_chow"]			= true,
	["wh3_main_combi_region_beichai"]			= true,
	["wh3_main_combi_region_haichai"]			= true
}
local western_regions={
	["wh3_main_combi_region_barak_varr"]		= true,
	["wh3_main_combi_region_miragliano"]		= true,
	["wh3_main_combi_region_lothern"]			= true,
	["wh3_main_combi_region_bordeleaux"]		= true,
	["wh3_main_combi_region_marienburg"]		= true,
	["wh3_main_combi_region_altdorf"]			= true,
	["wh3_main_combi_region_erengrad"]			= true
}

function rhox_torinubar_build_or_upgrade_foreign(region, region_owner)
	local faction = cm:get_faction("cr_hef_gate_guards")
	
	if not region or not region_owner then
        out("Rhox Torinubar: There was no region or region owner: "..region:name())
		return false
	end
	if region_owner == torinubar_faction then
        out("Rhox Torinubar: Region owner was the Torinubar himself")
		return false--you can't build foreign in your own city
	end

	local region_name = region:name()

	if not order_cultures[region_owner:culture()] then
        out("Rhox Torinubar: It was owned by non-order culture")
		return
	end
	if not eastern_regions[region_name] and not western_regions[region_name] then --I don't know when this can happen, but just in case
        out("Rhox Torinubar: The region name is wrong "..region_name)
		return
	end

	


	local region_has_slot =false
	local fsm = faction:foreign_slot_managers();
	for i=0,fsm:num_items()-1 do
		local region_fsm = fsm:item_at(i)
		if region_fsm:region():name() == region_name then
			region_has_slot = true
			out("Rhox Torinubar: There was already a foreign slot there")
            
			return; --don't have to look for other slots
		end
	end
	if not region_has_slot then
        out("Rhox Torinubar: Let's make a new slot")
		local region_fsm = cm:add_foreign_slot_set_to_region_for_faction(faction:command_queue_index(), region:cqi(), "rhox_torinubar_foreign_slot_set");
		local slots = region_fsm:slots()
		if eastern_regions[region_name] then
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(0), "rhox_torinubar_east_foreign_1");
		elseif western_regions[region_name] then
			cm:foreign_slot_instantly_upgrade_building(slots:item_at(0), "rhox_torinubar_west_foreign_1");
		end
	end

end










----------------------------things for cove visibility 



local function coven_visibility()
    --- get UI components
    local settlement_list = find_uicomponent(core:get_ui_root(), "settlement_panel", "settlement_list")
    if not settlement_list then
        return
    end
    local childCount = settlement_list:ChildCount()
    
    --- Turn on visibility in every settlement
    for i=1, childCount - 1  do
        local child = UIComponent(settlement_list:Find(i))
        if not child then
            return
        end
        local foreign_building = find_uicomponent(child, "settlement_view", "hostile_views", "wh3_daemon_factions")
		if foreign_building then
        	foreign_building:SetVisible(true)
		end
    end
end


function rhox_torinubar_set_coven_listeners()
    core:add_listener(
        "rhox_torinubar_settlement_panel",
        "SettlementSelected",
        true,
        function(context)
            core:get_tm():real_callback(function()
                coven_visibility()
            end, 1)
                
            
        end,
        true
    )
    
    core:add_listener(
        "rhox_torinubar_expand_slot",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_expand_slot"
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
            end, 100)
        end,
        true
    )
    core:add_listener(
        "rhox_torinubar_building",
        "ComponentLClickUp",
        function (context)
            return context.string == "square_building_button"
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
            end, 100)
        end,
        true
    )
    
    core:add_listener(
        "rhox_torinubar_razing",
        "ComponentLClickUp",
        function (context)
            return context.string == "button_raze"
        end,
        function()
            core:get_tm():real_callback(function()
                coven_visibility()
            end, 100)
        end,
        true
    )
end





cm:add_first_tick_callback(
	function()		
		if cm:get_local_faction_name(true) == torinubar_faction then
            rhox_torinubar_set_coven_listeners()
            core:add_listener(
				"rhox_lccp_CharacterSelected_scrap_upgrade_button_shower",
				"CharacterSelected",
				function(context)
					return context:character():faction():name() == torinubar_faction and context:character():character_type_key()=="general";
				end,
				function(context)
                    cm:callback(
                        function()
                            local upgrade_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "button_purchase_unit_upgrades");
                            if upgrade_button then
                                upgrade_button:SetVisible(true)
                            end
                        end,
                        0.1
                    )
				end,
				true
            )
            
            core:add_listener(
				"rhox_lccp_CharacterMoved_scrap_upgrade_shower",
				"CharacterFinishedMovingEvent",
				function(context)
					return context:character():faction():name() == torinubar_faction and context:character():character_type_key()=="general";
				end,
				function(context)
                    cm:callback(
                        function()
                            local upgrade_button = find_uicomponent(core:get_ui_root(), "hud_campaign", "hud_center_docker", "hud_center", "button_purchase_unit_upgrades");
                            if upgrade_button then
                                upgrade_button:SetVisible(true)
                            end
                        end,
                        0.1
                    )
				end,
				true
            )

            core:add_listener(
                'rhox_lccp_torinubar_clicked_upgrade_button',
                'ComponentLClickUp',
                function(context)
                    return context.string == "button_purchase_unit_upgrades" 
                end,
                function(context)
                    
                    cm:callback(
                        function()
                            local upgrade_button = find_uicomponent(core:get_ui_root(), "units_panel_scrap_upgrades", "button_upgrade");
                            if upgrade_button then
                                upgrade_button:SetVisible(true)
                                upgrade_button:SetState("active")
                            end
                        end,
                        0.1
                    )
                end,
                true
            )
		end
		if cm:get_faction(torinubar_faction):is_human() then
			core:add_listener(
				"rhox_torinubar_region_turn_start",
				"FactionTurnStart",
				function (context)
					return context:faction():name()==torinubar_faction
				end,
				function(context)
					local faction = cm:get_faction(torinubar_faction)
					local fsm = faction:foreign_slot_managers();
					for i=0,fsm:num_items()-1 do
						local region_fsm = fsm:item_at(i)
						local region_name = region_fsm:region():name()
						local region = cm:get_region(region_name)
						if region:owning_faction() and not order_cultures[region:owning_faction():culture()] then
							out("Rhox Torinubar: region ".. region_name .. " was owned by non-order faction. Removing the foreign slot and showing the message")
							local settlement = region:settlement()
							local settlement_x = settlement:logical_position_x();
							local settlement_y = settlement:logical_position_y();
							cm:show_message_event_located(
								torinubar_faction,
								"rhox_torinubar_evil_taken_title",
								"regions_onscreen_" .. region_name,
								"rhox_torinubar_evil_taken_description",
								settlement_x,
								settlement_y,
								true,
								1803
							);
							core:get_tm():real_callback(function()
								cm:remove_faction_foreign_slots_from_region(cm:get_faction(torinubar_faction):command_queue_index(),region:cqi())
							end, 100)		
						end
					end
				end,
				true
			)
		end
	end
)


cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name(true) == torinubar_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            if not parent_ui then
                return false
            end
            local west = core:get_or_create_component("rhox_torinubar_west_holder", "ui/campaign ui/rhox_torinubar_west_holder.twui.xml", parent_ui)
            local east = core:get_or_create_component("rhox_torinubar_east_holder", "ui/campaign ui/rhox_torinubar_east_holder.twui.xml", parent_ui)
		end
	end
)
    
    