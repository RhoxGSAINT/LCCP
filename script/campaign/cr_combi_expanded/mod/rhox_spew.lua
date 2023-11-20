core:add_listener(
    "rhox_spew_MissionSucceeded",
    "MissionSucceeded",
    function(context)
        local mission_key = context:mission():mission_record_key();
        return mission_key == "rhox_spew_survival_mission" and context:faction():name() == "cr_nur_tide_of_pestilence"
    end,
    function(context)
        cm:trigger_mission("cr_nur_tide_of_pestilence", "rhox_spew_survival_mission", true)
    end,
    true
);


cm:add_first_tick_callback(
    function()
        if cm:get_faction("cr_nur_tide_of_pestilence"):is_human() then
            if cm:is_new_game() == true then
               cm:trigger_mission("cr_nur_tide_of_pestilence", "rhox_spew_survival_mission", true)
            end
        end
    end
);