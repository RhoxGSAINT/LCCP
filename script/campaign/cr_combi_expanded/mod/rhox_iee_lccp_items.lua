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