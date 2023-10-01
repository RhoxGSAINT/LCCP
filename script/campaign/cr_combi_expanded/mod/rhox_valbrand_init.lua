local valbrand_faction ="rhox_nor_firebrand_slavers"




local rhox_valbrand_gift_units = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
		{"wh3_main_kho_inf_bloodletters_0", "daemonic_summoning", 1, 0, 4},
		{"wh3_main_kho_mon_bloodthirster_0", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc20_chs_mon_warshrine_mkho", "daemonic_summoning", 0, 0, 2},
		{"wh3_main_kho_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
		{"wh3_main_kho_inf_flesh_hounds_of_khorne_0", "daemonic_summoning", 0, 0, 4},
		{"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
		{"wh3_main_kho_veh_skullcannon_0", "daemonic_summoning", 0, 0, 4}
}
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

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(valbrand_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            valbrand_faction,
            "wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_main_kho_inf_chaos_warriors_0,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh_dlc08_nor_mon_norscan_giant_0,wh3_dlc20_chs_cav_chaos_chariot_mkho",
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
        
        
        rhox_add_units(cm:get_faction(valbrand_faction), rhox_valbrand_gift_units);
        
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
        cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",valbrand_faction, "norsca_monster_hunt_ror_unlock")
		cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", valbrand_faction, "norsca_monster_hunt_ror_unlock")
        
        cm:callback(
            function()
                cm:show_message_event(
                    valbrand_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. valbrand_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_valbrand",
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
			mixer_set_faction_trait(valbrand_faction, "rhox_valbrand_faction_trait", true)
		end)

	end
)
	