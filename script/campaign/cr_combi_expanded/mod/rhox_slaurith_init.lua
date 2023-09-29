local slaurith_faction = "cr_kho_servants_of_the_blood_nagas"
cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(slaurith_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            slaurith_faction,
            "wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warriors_1",
            "cr_combi_region_elithis_2_1",
            1250,
            183,
            "general",
            "hkrul_lord_slaurith",
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
			mixer_set_faction_trait(slaurith_faction, "rhox_lord_slaurith_faction_trait", true)
		end)
	end
)
	