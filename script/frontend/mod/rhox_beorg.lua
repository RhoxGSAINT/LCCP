core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("1902922690", "hkrul_beorg")
            mixer_enable_custom_faction("1902922690")
            mixer_add_starting_unit_list_for_faction("mixer_nur_rotbloods", {"hkrul_beorg_brown_feral","wh_main_nor_mon_chaos_warhounds_0","hkrul_bearmen","hkrul_beorg_brown_feral_marked"})
            mixer_add_faction_to_major_faction_list("mixer_nur_rotbloods")    
        end        
    end
)