

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction("rhox_nor_firebrand_slavers");
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            "rhox_nor_firebrand_slavers",
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
    end
)

    core:add_listener(
        "hkrul_valbrand_banner_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_valbrand") and character:rank() >= 6 and faction:ancillary_exists("hkrul_valbrand_banner") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_valbrand_banner",
                true,
                false
            )
        end,
        false
    )
    
        core:add_listener(
        "hkrul_valbrand_weaopon_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_valbrand") and character:rank() >= 10 and faction:ancillary_exists("hkrul_valbrand_sword") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_valbrand_sword",
                true,
                false
            )
        end,
        false
    )