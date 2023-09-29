core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("1551609238", "hef_calith_torinubar")
            mixer_add_starting_unit_list_for_faction("cr_hef_gate_guards", {"wh2_main_hef_inf_archers_0","wh2_main_hef_cav_ellyrian_reavers_1","wh2_main_hef_art_eagle_claw_bolt_thrower","wh2_main_hef_inf_lothern_sea_guard_1"})
            mixer_add_faction_to_major_faction_list("cr_hef_gate_guards")    
        
        
            mixer_change_lord_name("1811393516", "hkrul_sceolan") 
            mixer_enable_custom_faction("1811393516")
            mixer_add_starting_unit_list_for_faction("rhox_wef_far_away_forest", {"wh_dlc05_wef_inf_wardancers_0", "wh_dlc05_wef_inf_wardancers_1","wh_dlc05_wef_inf_eternal_guard_1","wh2_dlc16_wef_cav_great_stag_knights_0"})
            mixer_add_faction_to_major_faction_list("rhox_wef_far_away_forest")

            
            mixer_change_lord_name("540999972", "hkrul_valbrand") 
            mixer_enable_custom_faction("540999972")
            mixer_add_starting_unit_list_for_faction("rhox_nor_firebrand_slavers", {"wh_dlc08_nor_inf_marauder_spearman_0", "wh_dlc08_nor_inf_marauder_hunters_1","wh3_main_kho_inf_chaos_warriors_0","wh3_dlc20_chs_inf_chaos_marauders_mkho","wh_dlc08_nor_mon_norscan_giant_0", "wh3_dlc20_chs_cav_chaos_chariot_mkho"})
            mixer_add_faction_to_major_faction_list("rhox_nor_firebrand_slavers")

            
            mixer_change_lord_name("1757182270", "hkrul_zach") 
            mixer_enable_custom_faction("1757182270")
            mixer_add_starting_unit_list_for_faction("rhox_vmp_the_everliving", {"wh_main_vmp_inf_zombie"})
            mixer_add_faction_to_major_faction_list("rhox_vmp_the_everliving")
            
            
            mixer_change_lord_name("2018282170", "hkrul_volrik") 
            mixer_enable_custom_faction("2018282170")
            mixer_add_starting_unit_list_for_faction("cr_nor_avags", {"wh_dlc08_nor_inf_marauder_hunters_1","wh_main_nor_inf_chaos_marauders_0","wh3_dlc20_chs_cav_chaos_chariot_mtze","wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins","wh_dlc08_nor_inf_marauder_spearman_0",})
            mixer_add_faction_to_major_faction_list("cr_nor_avags")
            
            mixer_change_lord_name("597789182", "hkrul_orghotts") 
            mixer_enable_custom_faction("597789182")
            mixer_add_starting_unit_list_for_faction("cr_nur_tide_of_pestilence", {"wh3_main_nur_inf_nurglings_0"})
            mixer_add_faction_to_major_faction_list("cr_nur_tide_of_pestilence")

        end        
    end
)
