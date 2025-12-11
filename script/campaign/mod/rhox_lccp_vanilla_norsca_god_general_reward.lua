local rhox_lccp_norscans={
    cr_nor_tokmars=true,
    rhox_nor_firebrand_slavers=true,
    rhox_nor_ravenblessed=true,
    rhox_nor_khazags=true,
}


core:add_listener(
    "RhoxLCCPChampion_DilemmaChoiceMadeEvent",
    "DilemmaChoiceMadeEvent",
    function(context)
        return string.find(context:dilemma(), norscan_gods.dilemma_key_prefix) and rhox_lccp_norscans[context:faction():name()] and context:choice() == 0
    end,
    function(context)
        local faction_key = context:faction():name()
        local dilemma= context:dilemma()
        local choice = context:choice()
        
        if dilemma == norscan_gods.dilemma_key_prefix.."eagle" then
            cm:spawn_character_to_pool(faction_key, "names_name_1240287927", "", "", "", 30, true, "general", "wh_dlc08_nor_arzik", true, "")
        else if dilemma == norscan_gods.dilemma_key_prefix.."crow" then
            cm:spawn_character_to_pool(faction_key, "names_name_2063127767", "names_name_603789142", "", "", 30, true, "general", "wh3_main_ie_nor_burplesmirk_spewpit", true, "")
        end
    end,
    true
)



