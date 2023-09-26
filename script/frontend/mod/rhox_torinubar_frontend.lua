core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("1551609238", "hef_calith_torinubar")
    
            mixer_add_starting_unit_list_for_faction("cr_hef_gate_guards", {"wh2_main_hef_inf_archers_0","wh2_main_hef_cav_ellyrian_reavers_1","wh2_main_hef_art_eagle_claw_bolt_thrower","wh2_main_hef_inf_lothern_sea_guard_1"})
            mixer_add_faction_to_major_faction_list("cr_hef_gate_guards")    

        end        
    end
)

