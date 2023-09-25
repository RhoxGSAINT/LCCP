core:add_ui_created_callback(
    function(context)
        if vfs.exists("script/frontend/mod/mixer_frontend.lua")then
        
            mixer_change_lord_name("540999972", "hkrul_valbrand") 
            mixer_enable_custom_faction("540999972")
            mixer_add_starting_unit_list_for_faction("rhox_nor_firebrand_slavers", {"wh_dlc08_nor_inf_marauder_spearman_0", "wh_dlc08_nor_inf_marauder_hunters_1","wh3_main_kho_inf_chaos_warriors_0","wh3_main_kho_inf_chaos_warhounds_0","wh3_dlc20_chs_inf_chaos_marauders_mkho","wh_dlc08_nor_mon_norscan_giant_0"})
            mixer_add_faction_to_major_faction_list("rhox_nor_firebrand_slavers")

        end        
    end
)

