local burlok_faction = "cr_dwf_firebeards_excavators"
cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(burlok_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            burlok_faction,
            "wh_main_dwf_inf_dwarf_warrior_0,wh_main_dwf_inf_dwarf_warrior_1",
            "cr_combi_region_elithis_2_1",
            1187,
            321,
            "general",
            "hkrul_burlok",
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
        

        cm:callback(
            function()
                cm:show_message_event(
                    burlok_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. burlok_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_burlok",
                    true,
                    592
                );
            end,
            1
        )
    end
)

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(burlok_faction, "rhox_burlok_faction_trait", true)
		end)
	end
)
	