local thorgar_faction = "rhox_nor_khazags"


local norsca_ror_table={
    {"wh_dlc08_nor_art_hellcannon_battery", "wh_dlc08_nor_art_hellcannon_battery"},
    {"wh_pro04_nor_mon_war_mammoth_ror_0", "wh_pro04_nor_mon_war_mammoth_ror_0"},
    {"wh_dlc08_nor_mon_frost_wyrm_ror_0", "wh_dlc08_nor_mon_frost_wyrm_ror_0"},
    {"wh_pro04_nor_inf_chaos_marauders_ror_0","wh_pro04_nor_inf_chaos_marauders_ror_0"}, 
    {"wh_pro04_nor_mon_fimir_ror_0", "wh_pro04_nor_mon_fimir_ror_0"},
    {"wh_pro04_nor_mon_marauder_warwolves_ror_0", "wh_pro04_nor_mon_warwolves_ror_0"},
    {"wh_pro04_nor_inf_marauder_berserkers_ror_0","wh_pro04_nor_inf_marauder_berserkers_ror_0"},
    {"wh_pro04_nor_mon_skinwolves_ror_0","wh_pro04_nor_mon_skinwolves_ror_0"}, 
    {"wh_dlc08_nor_mon_war_mammoth_ror_1", "wh_dlc08_nor_mon_war_mammoth_ror_1"}
}

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(thorgar_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        
        cm:transfer_region_to_faction("cr_combi_region_khazags_khural",thorgar_faction)
        
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            thorgar_faction,
            "wh_dlc08_nor_inf_marauder_spearman_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_cav_marauder_horsemen_0,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_mon_war_mammoth_0,",
            "cr_combi_region_khazags_khural",
            1270,
            732,
            "general",
            "hkrul_thorgar",
            "names_name_5670700836",
            "",
            "names_name_5670700835",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        
        for i, ror in pairs(norsca_ror_table) do
            cm:add_unit_to_faction_mercenary_pool(
                faction,
                ror[1],
                "renown",
                1,
                100,
                1,
                0.1,
                "",
                "",
                "",
                true,
                ror[2]
            )
        end
        
        --[[
        local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), 1501, 62, false, 5);
        cm:create_agent(thorgar_faction, "wizard", "wh_dlc05_wef_spellsinger_shadow", agent_x, agent_y);       
        
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
        cm:force_declare_war(thorgar_faction, "cr_hef_tor_elithis", false, false)
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
        --]]
        
        
 
        cm:callback(
            function()
                cm:show_message_event(
                    thorgar_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. thorgar_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_thorgar",
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
			mixer_set_faction_trait(thorgar_faction, "rhox_thorgar_faction_trait", true)
		end)
	end
)
	