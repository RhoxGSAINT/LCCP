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

core:add_listener(
    "rhox_spew_MissionSucceeded",
    "MissionSucceeded",
    function(context)
        local mission_key = context:mission():mission_record_key();
        return mission_key == "rhox_spew_tow_survival_mission" and context:faction():name() == "cr_nur_tide_of_pestilence"
    end,
    function(context)
        cm:trigger_mission("cr_nur_tide_of_pestilence", "rhox_spew_tow_survival_mission", true)
    end,
    true
);

