local hrothyogg_faction = "cr_ogr_deathtoll"

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(hrothyogg_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            hrothyogg_faction,
            "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_1",
            "cr_combi_region_elithis_2_1",
            1116,
            410,
            "general",
            "hkrul_hrothyogg",
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
        

    end
)

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(hrothyogg_faction, "rhox_hrothyogg_faction_trait", true)
		end)
	end
)
	