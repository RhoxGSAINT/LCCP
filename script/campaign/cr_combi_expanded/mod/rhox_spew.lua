


cm:add_first_tick_callback(
    function()
        if cm:get_faction("cr_nur_tide_of_pestilence"):is_human() then
            if cm:is_new_game() == true then
               cm:trigger_mission("cr_nur_tide_of_pestilence", "rhox_spew_survival_mission", true)
            end
        end
    end
);