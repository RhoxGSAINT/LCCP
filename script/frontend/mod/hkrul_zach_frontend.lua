core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("1757182270", "hkrul_zach") 
            mixer_enable_custom_faction("1757182270")
            mixer_add_starting_unit_list_for_faction("rhox_vmp_the_everliving", {"wh_main_vmp_inf_zombie"})
            mixer_add_faction_to_major_faction_list("rhox_vmp_the_everliving")

        end        
    end
)