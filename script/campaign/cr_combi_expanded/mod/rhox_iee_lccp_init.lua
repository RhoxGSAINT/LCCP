local norsca_ror_table={
    {"wh_dlc08_nor_art_hellcannon_battery", "wh_dlc08_nor_art_hellcannon_battery"},
    {"wh_pro04_nor_mon_war_mammoth_ror_0", "wh_pro04_nor_mon_war_mammoth_ror_0"},
    {"wh_dlc08_nor_mon_frost_wyrm_ror_0", "wh_dlc08_nor_mon_frost_wyrm_ror_0"},
    {"wh_pro04_nor_inf_chaos_marauders_ror_0","wh_pro04_nor_inf_chaos_marauders_ror_0"}, 
    {"wh_pro04_nor_mon_fimir_ror_0", "wh_pro04_nor_mon_fimir_ror_0"},
    {"wh_pro04_nor_mon_marauder_warwolves_ror_0", "wh_pro04_nor_mon_warwolves_ror_0"},
    {"wh_pro04_nor_inf_marauder_berserkers_ror_0","wh_pro04_nor_inf_marauder_berserkers_ror_0"},
    {"wh_pro04_nor_mon_skinwolves_ror_0","wh_pro04_nor_mon_skinwolves_ror_0"}, 
    {"wh_dlc08_nor_mon_war_mammoth_ror_1", "wh_dlc08_nor_mon_war_mammoth_ror_1"}
}

local function rhox_add_warriors_units (faction_obj, unit_group)
	for i, v in pairs(unit_group) do
		cm:add_unit_to_faction_mercenary_pool(
			faction_obj,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4], --replen chance
			v[5], -- max units
			0, -- max per turn
			"",	--faction restriction
			"",	--subculture restriction
			"",	--tech restriction
			false, --partial
			v[1].."_warriors_faction_pool"
		);
	end	
end

local function rhox_add_faction_pool_units (faction_obj, unit_group)
	for i, v in pairs(unit_group) do
		cm:add_unit_to_faction_mercenary_pool(
			faction_obj,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4], --replen chance
			v[5], -- max units
			0, -- max per turn
			"",	--faction restriction
			"",	--subculture restriction
			"",	--tech restriction
			false, --partial
			v[1].."_faction_pool"
		);
	end	
end

local rhox_iee_list={
    cr_dwf_firebeards_excavators ={
        leader={
            subtype="hkrul_burlok",
            unit_list="wh_main_dwf_inf_dwarf_warrior_0,wh_main_dwf_inf_dwarf_warrior_1",
            x=1187,
            y=321,
            forename ="names_name_6670700833",
            familiyname ="names_name_6670700822",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_ind_4_1",
        how_they_play="rhox_iee_lccp_how_they_play_burlok",
        pic=592,
        faction_trait="rhox_burlok_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
            if faction:is_human() then
                local grudge_list={
                    "rhox_burlok_ritual_burlok_artifact_1",
                    "rhox_burlok_ritual_burlok_artifact_2",
                    "rhox_burlok_ritual_burlok_artifact_3",
                    "rhox_burlok_ritual_burlok_artifact_4",
                    "rhox_burlok_ritual_burlok_artifact_5",
                    "rhox_burlok_ritual_burlok_artifact_6",
                    "rhox_burlok_ritual_burlok_artifact_7",
                    "rhox_burlok_ritual_burlok_artifact_8"
                }
                for i = 1, #grudge_list do
                    cm:trigger_mission(faction_key, grudge_list[i], true)
                end
            end
        end,
        first_tick = function(faction, faction_key) 
            burlok:initialise()
        end
    },
    rhox_brt_reveller_of_domance ={
        leader={
            subtype="hkrul_dolmance",
            unit_list="wh_dlc07_brt_inf_spearmen_at_arms_1,wh_main_brt_cav_mounted_yeomen_0",
            x=1121,
            y=283,
            forename ="names_name_2670700824",
            familiyname ="names_name_2670700823",
        },
        agent={
            type="wizard",
            subtype="wh3_dlc20_chs_sorcerer_slaanesh_msla"
        },
        hand_over_region="cr_combi_region_ind_5_2",
        region="cr_combi_region_ind_5_2",
        how_they_play="rhox_iee_lccp_how_they_play_dolmance",
        pic=605,
        faction_trait="rhox_dolmance_faction_trait",
        enemy={
            key="cr_grn_snakebiter_tribe",
            subtype="wh_main_grn_orc_warboss",
            unit_list="wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_inf_orc_arrer_boyz,wh_main_grn_inf_orc_big_uns,wh_main_grn_cav_orc_boar_boyz"
        },
        additional = function(faction, faction_key) 
            local brt_ror={
                "wh_pro04_brt_cav_knights_errant_ror_0",
                "wh_pro04_brt_cav_knights_of_the_realm_ror_0",
                "wh_pro04_brt_cav_mounted_yeomen_ror_0",
                "wh_pro04_brt_cav_questing_knights_ror_0",
                "wh_pro04_brt_inf_battle_pilgrims_ror_0",
                "wh_pro04_brt_inf_foot_squires_ror_0"
            }
            for i = 1, #brt_ror do
                cm:add_unit_to_faction_mercenary_pool(faction, brt_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, brt_ror[i])
            end

            if faction:is_human() then
                local mm = mission_manager:new(faction_key, "rhox_dolmance_init_mission")
                if mm then
                    mm:add_new_objective("OWN_N_REGIONS_INCLUDING");
                    mm:add_condition("region cr_combi_region_elithis_1_1");
                    mm:add_condition("region cr_combi_region_nippon_3_3");
                    mm:add_condition("region wh3_main_combi_region_bordeleaux");
                    mm:add_condition("region wh3_main_combi_region_pfeildorf");
                    mm:add_condition("total 4");
                    mm:add_payload("money 1000");
                    mm:trigger()
                end
            end
        end,
        first_tick = function(faction, faction_key) 
            if not campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"] then
                campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"] = {}
            end
            table.insert(campaign_traits.trait_exclusions["faction"]["wh3_main_trait_corrupted_slaanesh"],faction_key)
        end
    },
    cr_ogr_deathtoll ={
        leader={
            subtype="hkrul_hrothyogg",
            unit_list="wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_1",
            x=1116,
            y=410,
            forename ="names_name_6670700833",
            familiyname ="names_name_6670700822",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_ind_1_2",
        how_they_play="rhox_iee_lccp_how_they_play_hrothyogg",
        pic=16,
        faction_trait="rhox_hrothyogg_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
            if faction:is_human() and vfs.exists("script/frontend/mod/hkrul_fooger_frontend.lua") then --fooger exists
                cm:transfer_region_to_faction("cr_combi_region_ind_2_1","ovn_mar_house_fooger")
                local transferred_region = cm:get_region("cr_combi_region_ind_2_1")
                local transferred_region_cqi = transferred_region:cqi()
                cm:heal_garrison(transferred_region_cqi)
            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    cr_nur_tide_of_pestilence ={
        leader={
            subtype="hkrul_orghotts",
            unit_list="wh3_main_nur_inf_nurglings_0,wh3_main_nur_inf_nurglings_0,wh3_dlc20_chs_inf_chaos_marauders_mnur,wh3_dlc20_chs_inf_chaos_marauders_mnur,wh3_main_nur_cav_pox_riders_of_nurgle_0,wh3_main_nur_mon_plague_toads_0",
            x=1522,
            y=793,
            forename ="names_name_24444424",
            familiyname ="names_name_24444423",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_seagrave_port",
        how_they_play="rhox_iee_lccp_how_they_play_orghotts",
        pic=12,
        faction_trait="rhox_orghotts_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_wef_far_away_forest ={
        leader={
            subtype="hkrul_sceolan",
            unit_list="wh_dlc05_wef_inf_wardancers_0,wh_dlc05_wef_inf_wardancers_1,wh_dlc05_wef_inf_eternal_guard_1,wh_dlc05_wef_inf_eternal_guard_1,wh2_dlc16_wef_cav_great_stag_knights_0",
            x=1501,
            y=62,
            forename ="names_name_6670700833",
            familiyname ="names_name_6670700822",
        },
        agent={
            type="wizard",
            subtype="wh_dlc05_wef_spellsinger_shadow"
        },
        hand_over_region="cr_combi_region_elithis_2_1",
        region="cr_combi_region_elithis_2_1",
        how_they_play="rhox_iee_lccp_how_they_play_sceolan",
        pic=605,
        faction_trait="rhox_sceolan_faction_trait",
        enemy={
            key="cr_hef_tor_elithis",
            subtype="wh2_main_hef_prince",
            unit_list="wh2_main_hef_inf_archers_0,wh2_main_hef_inf_archers_0,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_art_eagle_claw_bolt_thrower"
        },
        additional = function(faction, faction_key) 
            local wef_ror={
                "wh2_dlc16_wef_cav_great_stag_knights_ror_0",
                "wh2_dlc16_wef_inf_dryads_ror_0",
                "wh2_dlc16_wef_mon_zoats_ror_0",
                "wh_pro04_wef_cav_wild_riders_ror_0",
                "wh_pro04_wef_inf_eternal_guard_ror_0",
                "wh_pro04_wef_inf_wardancers_ror_0",
                "wh_pro04_wef_inf_waywatchers_ror_0",
                "wh_pro04_wef_inf_wildwood_rangers_ror_0",
                "wh_pro04_wef_mon_treekin_ror_0"
            }
            for i = 1, #wef_ror do
                cm:add_unit_to_faction_mercenary_pool(faction, wef_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, wef_ror[i])
            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    cr_kho_servants_of_the_blood_nagas ={
        leader={
            subtype="hkrul_slaurith",
            unit_list="wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warriors_1",
            x=1250,
            y=183,
            forename ="names_name_466124000",
            familiyname ="",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_khuresh_4_3",
        how_they_play="rhox_iee_lccp_how_they_play_slaurith",
        pic=11,
        faction_trait="rhox_slaurith_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_nor_khazags ={
        leader={
            subtype="hkrul_thorgar",
            unit_list="wh_dlc08_nor_inf_marauder_spearman_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_cav_marauder_horsemen_0,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_mon_war_mammoth_0,",
            x=1270,
            y=732,
            forename ="names_name_5670700836",
            familiyname ="names_name_5670700835",
        },
        agent=nil,
        hand_over_region="cr_combi_region_khazags_khural",
        region="cr_combi_region_khazags_khural",
        how_they_play="rhox_iee_lccp_how_they_play_thorgar",
        pic=800,
        faction_trait="rhox_thorgar_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key)
            for i, ror in pairs(norsca_ror_table) do
                cm:add_unit_to_faction_mercenary_pool(faction,ror[1],"renown",1,100,1,0.1,"","","",true,ror[2])
            end 
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    cr_hef_gate_guards ={
        leader={
            subtype="hef_calith_torinubar",
            unit_list="wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_lothern_sea_guard_1,wh2_main_hef_inf_archers_0,wh2_main_hef_inf_archers_0,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_cav_ellyrian_reavers_1,wh2_main_hef_art_eagle_claw_bolt_thrower",
            x=1297,
            y=68,
            forename ="names_name_9987364589",
            familiyname ="",
        },
        agent={
            type="runesmith",
            subtype="wh2_main_hef_loremaster_of_hoeth"
        },
        hand_over_region=nil,
        region="cr_combi_region_gates_of_calith_1",
        how_they_play="rhox_iee_lccp_how_they_play_torinubar",
        pic=771,
        faction_trait="rhox_torinubar_faction_trait",
        enemy={
            key="cr_skv_clan_rikek",
            subtype="wh2_dlc14_skv_master_assassin",
            unit_list="wh2_main_skv_inf_clanrat_spearmen_1,wh2_main_skv_inf_clanrat_spearmen_1,wh2_main_skv_inf_gutter_runner_slingers_0,wh2_main_skv_inf_gutter_runner_slingers_0,wh2_main_skv_inf_skavenslave_slingers_0,wh2_main_skv_inf_skavenslave_slingers_0,wh2_dlc14_skv_inf_eshin_triads_0,wh2_dlc14_skv_inf_eshin_triads_0"
        },
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_nor_firebrand_slavers ={
        leader={
            subtype="hkrul_valbrand",
            unit_list="wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_main_kho_inf_chaos_warriors_0,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh_dlc08_nor_mon_norscan_giant_0,wh3_dlc20_chs_cav_chaos_chariot_mkho",
            x=1460,
            y=580,
            forename ="names_name_6330700834",
            familiyname ="names_name_6330700833",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_ihan_3_1",
        how_they_play="rhox_iee_lccp_how_they_play_valbrand",
        pic=800,
        faction_trait="rhox_valbrand_faction_trait",
        enemy=nil,--because they don't spawn enemy force for it
        additional = function(faction, faction_key)
            cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
            cm:force_declare_war(faction_key, "cr_cth_the_chosen", false, false)
            cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
            
            for i, ror in pairs(norsca_ror_table) do
                cm:add_unit_to_faction_mercenary_pool(faction,ror[1],"renown",1,100,1,0.1,"","","",true,ror[2])
            end
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            local rhox_valbrand_gift_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_main_kho_inf_bloodletters_0", "daemonic_summoning", 1, 0, 4},
                    {"wh3_main_kho_mon_bloodthirster_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mkho", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_kho_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_kho_inf_flesh_hounds_of_khorne_0", "daemonic_summoning", 0, 0, 4},
                    {"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_kho_veh_skullcannon_0", "daemonic_summoning", 0, 0, 4}
            }
            rhox_add_warriors_units(cm:get_faction(faction_key), rhox_valbrand_gift_units);
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_nor_ravenblessed ={
        leader={
            subtype="hkrul_volrik",
            unit_list="wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins,wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins,wh3_dlc20_chs_cav_marauder_horsemen_mtze_javelins,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh3_dlc20_chs_cav_chaos_chariot_mtze,wh3_dlc20_chs_cav_chaos_chariot_mtze",
            x=1416,
            y=784,
            forename ="names_name_4170700722",
            familiyname ="names_name_4170700720",
        },
        agent=nil,
        hand_over_region="cr_combi_region_avags_camp",
        region="cr_combi_region_avags_camp",
        how_they_play="rhox_iee_lccp_how_they_play_volrik",
        pic=800,
        faction_trait="rhox_volrik_faction_trait",
        enemy={
            key="cr_nor_avags",
            subtype="wh_main_nor_marauder_chieftain",
            unit_list="wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1"
        },
        additional = function(faction, faction_key)
            
            for i, ror in pairs(norsca_ror_table) do
                cm:add_unit_to_faction_mercenary_pool(faction,ror[1],"renown",1,100,1,0.1,"","","",true,ror[2])
            end
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
            local rhox_volrik_gift_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_main_tze_mon_flamers_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_tze_mon_lord_of_change_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mtze", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_tze_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_tze_inf_pink_horrors_0", "daemonic_summoning", 1, 0, 4},
                    {"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_tze_mon_screamers_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_dlc24_tze_mon_mutalith_vortex_beast", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc24_tze_mon_cockatrice", "daemonic_summoning", 0, 0, 4}
            }
            rhox_add_warriors_units(cm:get_faction(faction_key), rhox_volrik_gift_units);
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_vmp_the_everliving ={
        leader={
            subtype="hkrul_zach",
            unit_list="wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie",
            x=1259,
            y=313,
            forename ="names_name_6670702834",
            familiyname ="names_name_6670702833",
        },
        agent=nil,
        hand_over_region="cr_combi_region_khuresh_1_2",
        region="cr_combi_region_khuresh_1_2",
        how_they_play="rhox_iee_lccp_how_they_play_zach",
        pic=594,
        faction_trait="rhox_zach_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
            local vmp_ror ={
                "wh_dlc04_vmp_cav_chillgheists_0",
                "wh_dlc04_vmp_cav_vereks_reavers_0",
                "wh_dlc04_vmp_inf_feasters_in_the_dusk_0",
                "wh_dlc04_vmp_inf_konigstein_stalkers_0",
                "wh_dlc04_vmp_inf_sternsmen_0",
                "wh_dlc04_vmp_inf_tithe_0",
                "wh_dlc04_vmp_mon_devils_swartzhafen_0",
                "wh_dlc04_vmp_veh_claw_of_nagash_0",
                "wh_dlc04_vmp_mon_direpack_0"
            }
            for i = 1, #vmp_ror do
                cm:add_unit_to_faction_mercenary_pool(faction, vmp_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, vmp_ror[i])
            end
            cm:add_unit_to_faction_mercenary_pool(faction, "wh2_dlc11_vmp_inf_crossbowmen", "renown", 0, 100, 6, 0, "", "", "", true, "wh2_dlc11_vmp_inf_crossbowmen")
            cm:add_unit_to_faction_mercenary_pool(faction, "wh2_dlc11_vmp_inf_handgunners", "renown", 0, 100, 1, 0, "", "", "", true, "wh2_dlc11_vmp_inf_handgunners")
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_kho_destroyers_of_khorne ={
        leader={
            subtype="hkrul_arbaal",
            unit_list="wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warriors_1,wh3_main_kho_inf_flesh_hounds_of_khorne_0,wh3_main_kho_inf_chaos_warhounds_0,wh3_main_kho_mon_spawn_of_khorne_0",
            x=1060,
            y=217,
            forename ="names_name_6670702834",
            familiyname ="names_name_6670702833",
        },
        agent=nil,
        hand_over_region="cr_combi_region_ind_6_2",
        region="cr_combi_region_ind_6_2",
        how_they_play="rhox_iee_lccp_how_they_play_arbaal",
        pic=11,
        faction_trait="rhox_arbaal_faction_trait",
        enemy={
            key="cr_chs_the_scourgeborn",
        },
        additional = function(faction, faction_key) 
            local kho_ror ={
                "wh3_dlc20_kho_cav_skullcrushers_mkho_ror",
                "wh3_twa06_kho_inf_bloodletters_ror_0",
                "wh3_twa07_kho_cav_bloodcrushers_ror_0",
                "wh3_twa08_kho_mon_bloodthirster_0_ror",
                "wh3_twa10_kho_inf_flesh_hounds_of_khorne_ror",
                "wh_pro04_nor_inf_marauder_berserkers_ror_0"
            }
            for i = 1, #kho_ror do
                cm:add_unit_to_faction_mercenary_pool(faction, kho_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, kho_ror[i])
            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    
    rhox_chs_the_deathswords ={
        leader={
            subtype="hkrul_engra",
            unit_list="wh_dlc01_chs_inf_chaos_warriors_2,wh_dlc01_chs_inf_chosen_2,",
            x=1388,
            y=695,
            forename ="names_name_5670700325",
            familiyname ="names_name_5670700324",
        },
        agent=nil,
        hand_over_region="cr_combi_region_ihan_1_1",
        region="cr_combi_region_ihan_1_1",
        how_they_play="rhox_iee_lccp_how_they_play_engra",
        pic=595,
        faction_trait="rhox_engra_faction_trait",
        enemy={
            key="cr_chs_po_hai",
        },
        additional = function(faction, faction_key) 
            local rhox_engra_gift_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh_main_chs_art_hellcannon", "daemonic_summoning", 1, 0, 4},
                    {"wh3_main_kho_inf_bloodletters_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_sla_inf_daemonette_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_nur_inf_plaguebearers_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_nur_inf_nurglings_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_tze_inf_pink_horrors_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_sla_veh_seeker_chariot_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_nur_mon_great_unclean_one_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_kho_mon_bloodthirster_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_nur_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_tze_mon_lord_of_change_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_kho_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_sla_mon_keeper_of_secrets_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_sla_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_tze_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh_dlc01_chs_mon_dragon_ogre_shaggoth", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mkho", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_sla_mon_fiends_of_slaanesh_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_tze_mon_flamers_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_tze_mon_screamers_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_kho_inf_flesh_hounds_of_khorne_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_nur_cav_plague_drones_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_nur_mon_beast_of_nurgle_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_kho_veh_skullcannon_0", "daemonic_summoning", 0, 0, 4}
            }
            
            local rhox_engra_faction_pool_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mkho", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_msla", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mtze", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mnur", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc24_tze_mon_cockatrice", "daemonic_summoning", 0, 0, 4},
                    {"wh3_dlc24_tze_mon_mutalith_vortex_beast", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_dae_inf_chaos_furies_0", "daemonic_summoning", 0, 0, 4}
            }
            local chs_ror ={
                "wh3_dlc20_chs_cav_chaos_chariot_msla_ror",
                "wh3_dlc20_chs_inf_aspiring_champions_mtze_ror",
                "wh3_dlc20_chs_mon_giant_mnur_ror",
                "wh3_dlc20_kho_cav_skullcrushers_mkho_ror",
                "wh3_twa07_tze_cav_doom_knights_ror_0",
                "wh3_twa08_kho_mon_bloodthirster_0_ror",
                "wh3_twa08_nur_mon_great_unclean_one_0_ror",
                "wh3_twa08_sla_mon_keeper_of_secrets_0_ror",
                "wh3_twa08_tze_mon_lord_of_change_0_ror",
                "wh3_twa10_kho_inf_flesh_hounds_of_khorne_ror",
                "wh3_twa10_nur_inf_nurglings_ror",
                "wh3_twa10_tze_inf_blue_horrors_ror",
                "wh_pro04_chs_art_hellcannon_ror_0",
                "wh_pro04_chs_cav_chaos_knights_ror_0",
                "wh_pro04_chs_inf_chaos_warriors_ror_0",
                "wh_pro04_chs_inf_forsaken_ror_0",
                "wh_pro04_chs_mon_chaos_spawn_ror_0",
                "wh_pro04_chs_mon_dragon_ogre_ror_0"
            }
            for i = 1, #chs_ror do
                cm:add_unit_to_faction_mercenary_pool(faction, chs_ror[i], "renown", 1, 100, 1, 0.1, "", "", "", true, chs_ror[i])
            end
            rhox_add_warriors_units(cm:get_faction(faction_key), rhox_engra_gift_units);
            rhox_add_faction_pool_units(cm:get_faction(faction_key), rhox_engra_faction_pool_units);
            if faction:is_human() then
                cm:force_alliance(faction_key, "wh_main_chs_chaos", true)
                cm:force_diplomacy("faction:"..faction_key, "faction:wh_main_chs_chaos", "war", false, false, true);
                cm:force_grant_military_access(faction_key, "wh_main_chs_chaos", true)
                cm:force_grant_military_access("wh_main_chs_chaos", faction_key, true)
            else
                cm:force_make_vassal("wh_main_chs_chaos", faction_key)
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                cm:force_declare_war("wh_main_chs_chaos", "cr_chs_po_hai", true, true)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
            end
        end,
        first_tick = function(faction, faction_key) 
            
        end
    },
    cr_nor_tokmars ={
        leader={
            subtype="hkrul_vroth",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_cav_chaos_chariot,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_mon_chaos_warhounds_0",
            x=1206,
            y=820,
            forename ="names_name_5670700722",
            familiyname ="names_name_5670700719",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_tokmars_encampment",
        how_they_play="rhox_iee_lccp_how_they_play_vroth",
        pic=800,
        faction_trait="rhox_vroth_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    
    cr_tmb_sons_of_ptra ={
        leader={
            subtype="hkrul_karitamen",
            unit_list="wh2_dlc09_tmb_inf_skeleton_spearmen_0,wh2_dlc09_tmb_inf_skeleton_warriors_0",
            x=1531,
            y=256,
            forename ="names_name_5670700722",
            familiyname ="names_name_5670700719",
        },
        agent=nil,
        hand_over_region=nil,
        region="cr_combi_region_nippon_5_2",
        how_they_play="rhox_iee_lccp_how_they_play_karitamen",
        pic=606,
        faction_trait="rhox_karitamen_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
}





cm:add_first_tick_callback_new(
    function()
        for faction_key, faction_info in pairs(rhox_iee_list) do
			local faction = cm:get_faction(faction_key);
            local faction_leader_cqi = faction:faction_leader():command_queue_index();

            if faction_info.hand_over_region then
                cm:transfer_region_to_faction(faction_info.hand_over_region,faction_key)
                local target_region_cqi = cm:get_region(faction_info.hand_over_region):cqi()
                cm:heal_garrison(target_region_cqi)
            end

            cm:create_force_with_general(
                -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                faction_key,
                faction_info.leader.unit_list,
                faction_info.region,
                faction_info.leader.x,
                faction_info.leader.y,
                "general",
                faction_info.leader.subtype,
                faction_info.leader.forename,
                "",
                faction_info.leader.familiyname,
                "",
                true,
                function(cqi)
                end
            );
            cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
            cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
            cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
            cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);

            if faction_info.agent then
                local agent_x, agent_y = cm:find_valid_spawn_location_for_character_from_position(faction_key, faction_info.leader.x, faction_info.leader.y, false, 5);
                cm:create_agent(faction_key, faction_info.agent.type, faction_info.agent.subtype, agent_x, agent_y);       
            end

            if faction_info.enemy then
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                cm:force_declare_war(faction_key, faction_info.enemy.key, false, false)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
                
                
                if faction_info.enemy.subtype then
                    local x2=nil
                    local y2=nil
                    if faction_info.enemy.x and faction_info.enemy.y then
                        x2= faction_info.enemy.x
                        y2 = faction_info.enemy.y
                    else
                        x2,y2 = cm:find_valid_spawn_location_for_character_from_settlement(
                            faction_info.enemy.key,
                            faction_info.region,
                            false,
                            true,
                            20
                        )
                    end
                    
                    
                    cm:create_force_with_general(
                    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
                    faction_info.enemy.key,
                    faction_info.enemy.unit_list,
                    faction_info.region,
                    x2,
                    y2,
                    "general",
                    faction_info.enemy.subtype,
                    "",
                    "",
                    "",
                    "",
                    false,
                    function(cqi)
                    end);
                end
            end


            cm:callback(
                function()
                    cm:show_message_event(
                        faction_key,
                        "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                        "factions_screen_name_" .. faction_key,
                        "event_feed_strings_text_".. faction_info.how_they_play,
                        true,
                        faction_info.pic
                    );
                end,
                1
            )
            faction_info.additional(faction, faction_key)
		end
    end
)


cm:add_first_tick_callback(
	function()
        for faction_key, faction_info in pairs(rhox_iee_list) do
            pcall(function()
                mixer_set_faction_trait(faction_key, faction_info.faction_trait, true)
            end)
            faction_info.first_tick(cm:get_faction(faction_key), faction_key)
        end
	end
)