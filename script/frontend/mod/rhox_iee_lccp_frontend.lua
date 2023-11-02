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
            mixer_add_starting_unit_list_for_faction("rhox_vmp_the_everliving", {"wh_main_vmp_inf_zombie","wh_main_vmp_inf_skeleton_warriors_0","wh_main_vmp_inf_grave_guard_0","wh_main_vmp_cav_black_knights_0"})
            mixer_add_faction_to_major_faction_list("rhox_vmp_the_everliving")
            
            
            mixer_change_lord_name("1129830176", "hkrul_volrik") 
            mixer_enable_custom_faction("1129830176")
            mixer_add_starting_unit_list_for_faction("rhox_nor_ravenblessed", {"wh_dlc08_nor_inf_marauder_hunters_1","wh_main_nor_inf_chaos_marauders_0","wh3_dlc20_chs_cav_chaos_chariot_mtze","wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins","wh_dlc08_nor_inf_marauder_spearman_0",})
            mixer_add_faction_to_major_faction_list("rhox_nor_ravenblessed")
            
            mixer_change_lord_name("597789182", "hkrul_spew") 
            mixer_add_starting_unit_list_for_faction("cr_nur_tide_of_pestilence", {"wh3_main_nur_inf_nurglings_0","wh3_dlc20_chs_inf_chaos_marauders_mnur","wh3_main_nur_cav_pox_riders_of_nurgle_0","wh3_main_nur_mon_plague_toads_0"})
            mixer_add_faction_to_major_faction_list("cr_nur_tide_of_pestilence")

            mixer_change_lord_name("17148978", "hkrul_hrothyogg") 
            mixer_add_starting_unit_list_for_faction("cr_ogr_deathtoll", {"wh3_main_ogr_inf_gnoblars_0", "wh3_main_ogr_inf_gnoblars_1"})
            mixer_add_faction_to_major_faction_list("cr_ogr_deathtoll")
            
            mixer_change_lord_name("1342160196", "hkrul_slaurith") 
            mixer_add_starting_unit_list_for_faction("cr_kho_servants_of_the_blood_nagas", {"wh3_main_kho_inf_chaos_warriors_0", "wh3_main_kho_inf_chaos_warriors_1"})
            mixer_add_faction_to_major_faction_list("cr_kho_servants_of_the_blood_nagas")
            
            mixer_change_lord_name("502924806", "hkrul_burlok") 
            mixer_add_starting_unit_list_for_faction("cr_dwf_firebeards_excavators", {"wh_main_dwf_inf_dwarf_warrior_0","wh_main_dwf_inf_thunderers_0","wh_main_dwf_inf_longbeards","wh_main_dwf_art_cannon","wh_main_dwf_inf_dwarf_warrior_1"})
            mixer_add_faction_to_major_faction_list("cr_dwf_firebeards_excavators")

            
            mixer_change_lord_name("220123324", "hkrul_dolmance") 
            mixer_enable_custom_faction("220123324")
            mixer_add_starting_unit_list_for_faction("rhox_brt_reveller_of_domance", {"wh_dlc07_brt_inf_spearmen_at_arms_1","wh3_dlc20_chs_cav_marauder_horsemen_msla_javelins","wh3_dlc20_chs_inf_chaos_marauders_msla","wh_main_brt_cav_mounted_yeomen_0"})
            mixer_add_faction_to_major_faction_list("rhox_brt_reveller_of_domance")
            
            mixer_change_lord_name("2062905973", "hkrul_thorgar") 
            mixer_enable_custom_faction("2062905973")
            mixer_add_starting_unit_list_for_faction("rhox_nor_khazags", {"wh_dlc08_nor_inf_marauder_spearman_0","wh_main_nor_inf_chaos_marauders_0","wh_dlc08_nor_mon_skinwolves_0","wh_main_nor_cav_marauder_horsemen_0","wh_dlc08_nor_mon_war_mammoth_0", "wh_dlc08_nor_inf_marauder_hunters_1"})
            mixer_add_faction_to_major_faction_list("rhox_nor_khazags")

            
            mixer_change_lord_name("1174946007", "hkrul_arbaal_mounted") 
            mixer_enable_custom_faction("1174946007")
            mixer_add_starting_unit_list_for_faction("rhox_kho_destroyers_of_khorne", {"wh3_main_kho_inf_chaos_warriors_0","wh3_main_kho_inf_chaos_warriors_1","wh3_main_kho_inf_flesh_hounds_of_khorne_0","wh3_main_kho_inf_chaos_warhounds_0","wh3_main_kho_mon_spawn_of_khorne_0"})
            mixer_add_faction_to_major_faction_list("rhox_kho_destroyers_of_khorne")
            
            
            mixer_change_lord_name("1316697836", "hkrul_engra") 
            mixer_enable_custom_faction("1316697836")
            mixer_add_starting_unit_list_for_faction("rhox_chs_the_deathswords", {"wh_dlc01_chs_inf_chaos_warriors_2","wh_dlc01_chs_inf_chosen_2"})
            mixer_add_faction_to_major_faction_list("rhox_chs_the_deathswords")
            
            mixer_change_lord_name("1079005981", "hkrul_vroth") 
            mixer_enable_custom_faction("1079005981")
            mixer_add_starting_unit_list_for_faction("cr_nor_tokmars", {"wh_main_nor_inf_chaos_marauders_0","wh_dlc08_nor_inf_marauder_hunters_1","wh_main_nor_cav_chaos_chariot","wh_main_nor_inf_chaos_marauders_1","wh_dlc08_nor_feral_manticore","wh_main_nor_mon_chaos_warhounds_0"})
            mixer_add_faction_to_major_faction_list("cr_nor_tokmars")
            
            mixer_change_lord_name("1723188533", "hkrul_karitamen") 
            mixer_enable_custom_faction("1723188533")
            mixer_add_starting_unit_list_for_faction("cr_tmb_sons_of_ptra", {"wh2_dlc09_tmb_inf_skeleton_spearmen_0","wh2_dlc09_tmb_inf_skeleton_warriors_0"})
            mixer_add_faction_to_major_faction_list("cr_tmb_sons_of_ptra")
            
            mixer_change_lord_name("2066159894", "hkrul_duriath") 
            mixer_enable_custom_faction("2066159894")
            mixer_add_starting_unit_list_for_faction("cr_def_corsairs_of_spite", {"wh2_main_def_inf_bleakswords_0","wh2_main_def_inf_darkshards_1", "wh2_main_def_inf_black_ark_corsairs_0", "wh2_main_def_inf_black_ark_corsairs_1"})
            mixer_add_faction_to_major_faction_list("cr_def_corsairs_of_spite")
        end        
    end
)



