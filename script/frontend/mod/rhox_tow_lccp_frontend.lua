core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            
            mixer_change_lord_name("588790841", "hkrul_zach") 
            mixer_enable_custom_faction("588790841")
            mixer_add_starting_unit_list_for_faction("cr_vmp_the_everliving", {"wh_main_vmp_inf_zombie","wh_main_vmp_inf_skeleton_warriors_0","wh_main_vmp_inf_grave_guard_0","wh_main_vmp_cav_black_knights_0", "rhox_lccp_vmp_giant"})
            mixer_add_faction_to_major_faction_list("cr_vmp_the_everliving")
            
            mixer_change_lord_name("287469190", "hkrul_duriath") 
            mixer_enable_custom_faction("287469190")
            
            mixer_change_lord_name("1589842327", "hkrul_vroth") 
            mixer_enable_custom_faction("1589842327")
            
            mixer_change_lord_name("2014822955", "hkrul_hrothyogg") 
            mixer_change_lord_name("981103236", "hkrul_spew") 
        end        
    end
)



