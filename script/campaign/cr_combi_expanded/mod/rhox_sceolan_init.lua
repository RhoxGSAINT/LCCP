local sceolan_faction = "rhox_wef_far_away_forest"
cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(sceolan_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
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
        
        cm:transfer_region_to_faction("cr_combi_region_elithis_2_1",sceolan_faction)
        
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
	