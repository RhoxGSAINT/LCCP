
cm:add_first_tick_callback(
    function()
        if cm:is_new_game() then
            cm:spawn_character_to_pool("wh_main_vmp_vampire_counts", "names_name_6670702834", "names_name_6670702833", "", "", 50, true, "general", "hkrul_zach", true, "");
        end;
    end
)

    core:add_listener(
        "hkrul_zach_banner_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_zach") and character:rank() >= 6 and faction:ancillary_exists("hkrul_zach_banner") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_zach_banner",
                true,
                false
            )
        end,
        false
    )
    
    
    core:add_listener(
        "hkrul_zach_follower_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_zach") and character:rank() >= 9 and faction:ancillary_exists("hkrul_zach_holz") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_zach_holz",
                true,
                false
            )
        end,
        false
    )
    
        core:add_listener(
        "hkrul_zach_weaopon_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_zach") and character:rank() >= 13 and faction:ancillary_exists("hkrul_zach_sword") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_zach_sword",
                true,
                false
            )
        end,
        false
    )