local valbrand_faction ="rhox_nor_firebrand_slavers"

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(valbrand_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            valbrand_faction,
            "wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_main_kho_inf_chaos_warriors_0,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_main_kho_inf_chaos_warhounds_0,wh_dlc08_nor_mon_norscan_giant_0",
            "cr_combi_region_ihan_3_1",
            1460,
            580,
            "general",
            "hkrul_valbrand",
            "names_name_6330700834",
            "",
            "names_name_6330700833",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
        cm:force_declare_war(valbrand_faction, "cr_cth_the_chosen", false, false)
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
    end
)



cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(valbrand_faction, "rhox_valbrand_faction_trait", true)
		end)

	end
)
	