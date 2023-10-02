local volrik_faction ="rhox_nor_ravenblessed"



local rhox_volrik_gift_units = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
		{"wh3_main_tze_mon_flamers_0", "daemonic_summoning", 0, 0, 4},
		{"wh3_main_tze_mon_lord_of_change_0", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc20_chs_mon_warshrine_mtze", "daemonic_summoning", 0, 0, 2},
		{"wh3_main_tze_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
		{"wh3_main_tze_inf_pink_horrors_0", "daemonic_summoning", 1, 0, 4},
		{"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
		{"wh3_main_tze_mon_screamers_0", "daemonic_summoning", 0, 0, 4},
		{"wh3_dlc24_tze_mon_mutalith_vortex_beast", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc24_tze_mon_cockatrice", "daemonic_summoning", 0, 0, 4}
}

local function rhox_add_units (faction_obj, unit_group)
	for i, v in pairs(unit_group) do
		cm:add_unit_to_faction_mercenary_pool(
			faction_obj,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4], --replen chance
			v[5], -- max units
			0, -- max per turn
			"",	--faction restriction
			"",	--subculture restriction
			"",	--tech restriction
			false, --partial
			v[1].."_warriors_faction_pool"
		);
	end	
end

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
        local faction = cm:get_faction(volrik_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:transfer_region_to_faction("cr_combi_region_avags_camp",volrik_faction)
        
        
        cm:apply_effect_bundle("rhox_volrik_cotw_hidden_effect_bundle", volrik_faction, 0)--cotw things
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            volrik_faction,
            "wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh3_dlc20_chs_cav_chaos_chariot_mtze",
            "cr_combi_region_avags_camp",
            1416,
            764,
            "general",
            "hkrul_volrik",
            "names_name_4170700722",
            "",
            "names_name_4170700720",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
        cm:force_declare_war(volrik_faction, "cr_nor_avags", false, false)
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
        
        rhox_add_units(cm:get_faction(volrik_faction), rhox_volrik_gift_units);
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

        cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",volrik_faction, "norsca_monster_hunt_ror_unlock")
		cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", volrik_faction, "norsca_monster_hunt_ror_unlock")
		
		cm:callback(
            function()
                cm:show_message_event(
                    volrik_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. volrik_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_volrik",
                    true,
                    800
                );
            end,
            1
        )
    end
)


cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(volrik_faction, "rhox_volrik_faction_trait", true)
		end)
	end
)
	