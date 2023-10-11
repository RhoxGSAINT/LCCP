core:add_listener(
    "rhox_engra_vassal_turn",
    "FactionTurnStart",
    function(context) 
        local faction = context:faction()
        local engra_faction = cm:get_faction("rhox_chs_the_deathswords")
        return engra_faction and faction:is_vassal_of(engra_faction) and faction:culture() ~= "wh_dlc08_nor_norsca" --non-Norsca condition because of dark fortress
    end,
    function(context) 
        out("Rhox engra: Transferring vassal")
        local faction = context:faction()
        cm:force_make_vassal("wh_main_chs_chaos", faction:name())--okay it did not work
    end,
    true
);