local torinubar_faction = "cr_hef_gate_guards"

local function rhox_torinubar_init_setting()

	local faction = cm:get_faction(torinubar_faction);
    local faction_leader_cqi = faction:faction_leader():command_queue_index();
    

    cm:add_event_restricted_building_record_for_faction("rhox_torinubar_east_foreign_1",torinubar_faction, "rhox_torunubar_foreign_building_lock")
    cm:add_event_restricted_building_record_for_faction("rhox_torinubar_west_foreign_1",torinubar_faction, "rhox_torunubar_foreign_building_lock")

    local x,y = cm:find_valid_spawn_location_for_character_from_settlement(
        torinubar_faction,
        "cr_combi_region_gates_of_calith_1",
        false,
        true,
        5
    )
    

    cm:create_force_with_general(
    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
    torinubar_faction,
    "wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_archers_0,wh2_main_hef_inf_archers_0,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_art_eagle_claw_bolt_thrower",
    "cr_combi_region_gates_of_calith_1",
    x,
    y,
    "general",
    "hef_calith_torinubar",
    "names_name_9987364589",
    "",
    "",
    "",
    true,
    function(cqi)
    end);
    local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), x, y, false, 5);
    cm:create_agent(torinubar_faction, "runesmith", "wh2_main_hef_loremaster_of_hoeth", agent_x, agent_y);       

    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
    cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
    cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
    
    
    local x2,y2 = cm:find_valid_spawn_location_for_character_from_settlement(
        "cr_skv_clan_rikek",
        "cr_combi_region_gates_of_calith_1",
        false,
        true,
        10
    )
    
    cm:create_force_with_general(
    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
    "cr_skv_clan_rikek",
    "wh2_main_skv_inf_clanrat_spearmen_1,wh2_main_skv_inf_clanrat_spearmen_1,wh2_main_skv_inf_gutter_runner_slingers_0,wh2_main_skv_inf_gutter_runner_slingers_0,wh2_main_skv_inf_skavenslave_slingers_0,wh2_main_skv_inf_skavenslave_slingers_0,wh2_dlc14_skv_inf_eshin_triads_0,wh2_dlc14_skv_inf_eshin_triads_0",
    "cr_combi_region_gates_of_calith_1",
    x2,
    y2,
    "general",
    "wh2_dlc14_skv_master_assassin",
    "",
    "",
    "",
    "",
    false,
    function(cqi)
    end);
    
    cm:force_declare_war("cr_skv_clan_rikek", torinubar_faction, false, false)
    	



end






cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(torinubar_faction, "rhox_torinubar_faction_trait", true)
		end)

		if cm:is_new_game() then
            rhox_torinubar_init_setting()
        end
		
		if cm:get_local_faction_name(true) == torinubar_faction then
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            if not parent_ui then
                return false
            end
            local west = core:get_or_create_component("rhox_torinubar_west_holder", "ui/campaign ui/rhox_torinubar_west_holder.twui.xml", parent_ui)
            local east = core:get_or_create_component("rhox_torinubar_east_holder", "ui/campaign ui/rhox_torinubar_east_holder.twui.xml", parent_ui)
		end
		campaign_traits.legendary_lord_defeated_traits["hef_calith_torinubar"] ="rhox_torinubar_defeated_torinubar"
	end
)

