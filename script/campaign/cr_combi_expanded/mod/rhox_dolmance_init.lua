local dolmance_faction = "rhox_brt_reveller_of_domance"

local brt_ror={
    "wh_pro04_brt_cav_knights_errant_ror_0",
    "wh_pro04_brt_cav_knights_of_the_realm_ror_0",
    "wh_pro04_brt_cav_mounted_yeomen_ror_0",
    "wh_pro04_brt_cav_questing_knights_ror_0",
    "wh_pro04_brt_inf_battle_pilgrims_ror_0",
    "wh_pro04_brt_inf_foot_squires_ror_0"
}
cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(dolmance_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        
        for i = 1, #brt_ror do
            cm:add_unit_to_faction_mercenary_pool(faction, brt_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, brt_ror[i])
        end
        
        cm:transfer_region_to_faction("cr_combi_region_ind_5_2",dolmance_faction)
        local x= 1121
        local y =283
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            dolmance_faction,
            "wh_dlc07_brt_inf_spearmen_at_arms_1,wh_main_brt_cav_mounted_yeomen_0",
            "cr_combi_region_ind_5_2",
            x,
            y,
            "general",
            "hkrul_dolmance",
            "names_name_2670700824",
            "",
            "names_name_2670700823",
            "",
            true,
            function(cqi)
            end);
        cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
        cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
        cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
        cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        
        local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction:name(), x, y, false, 5);
        cm:create_agent(dolmance_faction, "wizard", "wh3_dlc20_chs_sorcerer_slaanesh_msla", agent_x, agent_y);       
        
        cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
        cm:force_declare_war(dolmance_faction, "cr_grn_snakebiter_tribe", false, false)
        cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
    
        local x2,y2 = cm:find_valid_spawn_location_for_character_from_settlement(
            "cr_grn_snakebiter_tribe",
            "cr_combi_region_ind_5_2",
            false,
            true,
            10
        )
        
        cm:create_force_with_general(
        -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
        "cr_grn_snakebiter_tribe",
        "wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_inf_orc_big_uns,wh_main_grn_cav_orc_boar_boyz",
        "cr_combi_region_ind_5_2",
        x2,
        y2,
        "general",
        "wh_main_grn_orc_warboss",
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
                    dolmance_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. dolmance_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_dolmance",
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
			mixer_set_faction_trait(dolmance_faction, "rhox_dolmance_faction_trait", true)
		end)
		if not campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"] then
            campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"] = {}
        end
        table.insert(campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"],dolmance_faction)
	end
)
	