local agent_subtype_to_level_and_mission={
    hkrul_engra={
        level= 19,
        mission= "hkrul_engra_praag"
    },
}

core:add_listener(
    "hkrul_lccp_qb_issuer",
    "CharacterRankUp",
    function(context)
        local character = context:character()
        local subtype = character:character_subtype_key()
        local faction = character:faction()
        return faction:is_human() and agent_subtype_to_level_and_mission[subtype] and character:rank() >= agent_subtype_to_level_and_mission[subtype].level and cm:get_saved_value("hkrul_lccp_mission_checker_"..subtype.."_"..agent_subtype_to_level_and_mission[subtype].mission) ~= true
    end,
    function(context)
        local character = context:character()
        local subtype = character:character_subtype_key()
        local faction = character:faction()
        
        cm:set_saved_value("hkrul_lccp_mission_checker_"..subtype.."_"..agent_subtype_to_level_and_mission[subtype].mission,true)
        cm:trigger_mission(faction:name(), agent_subtype_to_level_and_mission[subtype].mission, true)
    end,
    true
)
    