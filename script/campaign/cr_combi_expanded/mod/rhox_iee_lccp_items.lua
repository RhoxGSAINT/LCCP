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

core:add_listener(
    "hkrul_volrik_banner_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_volrik") and character:rank() >= 8 and faction:ancillary_exists("hkrul_volrik_banner") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_volrik_banner",
            true,
            false
        )
    end,
    false
)
core:add_listener(
    "hkrul_thorgar_weaopon_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_thorgar") and character:rank() >= 13 and faction:ancillary_exists("hkrul_thorgar_sword") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_thorgar_sword",
            true,
            false
        )
    end,
    false
)

core:add_listener(
    "hkrul_thorgar_follower_unlock",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local faction = character:faction()
        return character:character_subtype("hkrul_thorgar") and character:rank() >= 8 and faction:ancillary_exists("hkrul_thorgar_holz") == false
    end,
    function(context)
        cm:force_add_ancillary(
            context:character(),
            "hkrul_thorgar_holz",
            true,
            false
        )
    end,
    false
)
core:add_listener(
        "hkrul_vroth_banner_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_vroth") and character:rank() >= 6 and faction:ancillary_exists("hkrul_vroth_banner") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_vroth_banner",
                true,
                false
            )
        end,
        false
    )
    
    
    core:add_listener(
        "hkrul_vroth_follower_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_vroth") and character:rank() >= 9 and faction:ancillary_exists("hkrul_vroth_holz") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_vroth_holz",
                true,
                false
            )
        end,
        false
    )
    
        core:add_listener(
        "hkrul_vroth_weaopon_unlock",
        "CharacterRankUp",
        function(context)
            local character = context:character()
            local faction = character:faction()
            return character:character_subtype("hkrul_vroth") and character:rank() >= 13 and faction:ancillary_exists("hkrul_vroth_sword") == false
        end,
        function(context)
            cm:force_add_ancillary(
                context:character(),
                "hkrul_vroth_sword",
                true,
                false
            )
        end,
        false
    )