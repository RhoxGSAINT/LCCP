core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("1811393516", "hkrul_sceolan") 
            mixer_enable_custom_faction("1811393516")
            mixer_add_starting_unit_list_for_faction("rhox_wef_far_away_forest", {"wh_dlc05_wef_inf_wardancers_0", "wh_dlc05_wef_inf_wardancers_1","wh_dlc05_wef_inf_eternal_guard_1","wh2_dlc16_wef_cav_great_stag_knights_0"})
            mixer_add_faction_to_major_faction_list("rhox_wef_far_away_forest")

        end        
    end
)
