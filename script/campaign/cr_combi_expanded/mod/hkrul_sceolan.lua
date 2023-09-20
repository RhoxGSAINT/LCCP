--
cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction("rhox_wef_far_away_forest");
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            "rhox_wef_far_away_forest",
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
        
        cm:transfer_region_to_faction("cr_combi_region_elithis_2_1","rhox_wef_far_away_forest")
    end
)

    core:add_listener(
        "hkrul_sceolan_banner_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_sceolan") and character:rank() >= 6 and faction:ancillary_exists("hkrul_sceolan_banner") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_sceolan_banner",
                true,
                false
            )
        end,
        false
    )
    
    
    core:add_listener(
        "hkrul_sceolan_follower_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_sceolan") and character:rank() >= 9 and faction:ancillary_exists("hkrul_sceolan_holz") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_sceolan_holz",
                true,
                false
            )
        end,
        false
    )
    
        core:add_listener(
        "hkrul_sceolan_weaopon_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_sceolan") and character:rank() >= 13 and faction:ancillary_exists("hkrul_sceolan_sword") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_sceolan_sword",
                true,
                false
            )
        end,
        false
    )