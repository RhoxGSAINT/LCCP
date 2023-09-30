local orghotts_faction = "cr_nur_tide_of_pestilence"
cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(orghotts_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            orghotts_faction,
            "wh3_main_nur_inf_nurglings_0,wh3_main_nur_inf_nurglings_0",
            "cr_combi_region_elithis_2_1",
            1522,
            793,
            "general",
            "hkrul_orghotts",
            "names_name_24444424",
            "",
            "names_name_24444423",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        

    end
)

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(orghotts_faction, "rhox_orghotts_faction_trait", true)
		end)
	end
)
	