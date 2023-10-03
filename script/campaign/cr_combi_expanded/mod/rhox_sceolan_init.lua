local sceolan_faction = "rhox_wef_far_away_forest"

local wef_ror={
    "wh2_dlc16_wef_cav_great_stag_knights_ror_0",
    "wh2_dlc16_wef_inf_dryads_ror_0",
    "wh2_dlc16_wef_mon_zoats_ror_0",
    "wh_pro04_wef_cav_wild_riders_ror_0",
    "wh_pro04_wef_inf_eternal_guard_ror_0",
    "wh_pro04_wef_inf_wardancers_ror_0",
    "wh_pro04_wef_inf_waywatchers_ror_0",
    "wh_pro04_wef_inf_wildwood_rangers_ror_0",
    "wh_pro04_wef_mon_treekin_ror_0"
}

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(sceolan_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        
        for i = 1, #wef_ror do
            cm:add_unit_to_faction_mercenary_pool(faction, wef_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, wef_ror[i])
        end
        
        cm:transfer_region_to_faction("cr_combi_region_elithis_2_1",sceolan_faction)
        
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            sceolan_faction,
            "wh_dlc05_wef_inf_wardancers_0,wh_dlc05_wef_inf_wardancers_1,wh_dlc05_wef_inf_eternal_guard_1,wh_dlc05_wef_inf_eternal_guard_1,wh2_dlc16_wef_cav_great_stag_knights_0",
            "cr_combi_region_elithis_2_1",
            1501,
            62,
            "general",
            "hkrul_sceolan",
            "names_name_6670700833",
            "",
            "names_name_6670700822",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        
        local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), 1501, 62, false, 5);
        cm:create_agent(sceolan_faction, "wizard", "wh_dlc05_wef_spellsinger_shadow", agent_x, agent_y);       
        
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
        cm:force_declare_war(sceolan_faction, "cr_hef_tor_elithis", false, false)
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
        
        
        
        
        local x2,y2 = cm:find_valid_spawn_location_for_character_from_settlement(
            "cr_hef_tor_elithis",
            "cr_combi_region_elithis_2_1",
            false,
            true,
            10
        )
        
        cm:create_force_with_general(
        -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
        "cr_hef_tor_elithis",
        "wh2_main_hef_inf_archers_0,wh2_main_hef_inf_archers_0,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_art_eagle_claw_bolt_thrower",
        "cr_combi_region_elithis_2_1",
        x2,
        y2,
        "general",
        "wh2_main_hef_prince",
        "",
        "",
        "",
        "",
        false,
        function(cqi)
        end);
        
        cm:callback(
            function()
                cm:show_message_event(
                    sceolan_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. sceolan_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_sceolan",
                    true,
                    605
                );
            end,
            1
        )
    end
)

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(sceolan_faction, "rhox_sceolan_faction_trait", true)
		end)
	end
)
	