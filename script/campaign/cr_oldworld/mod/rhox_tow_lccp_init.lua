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

local rhox_ror_to_remove = {
    ---unit_key, recruitment_source_key, god (removed if it's not the faction's god. nil means only removed for neutral)
    {"wh_pro04_nor_inf_marauder_berserkers_ror_0", "wh3_main_regiments_of_renown_pool", "khorne"},
    {"wh3_dlc27_nor_inf_chaos_marauders_great_weapons_ror", "wh3_main_regiments_of_renown_pool", "nurgle"},
    {"wh3_dlc27_nor_cav_chaos_chariot_ror", "wh3_main_regiments_of_renown_pool", "tzeentch"},
    {"wh3_dlc27_nor_cav_marauder_horsemen_ror", "wh3_main_regiments_of_renown_pool", "slaanesh"},
    {"wh_pro04_nor_mon_fimir_ror_0", "wh3_main_regiments_of_renown_pool", nil},--Fimir
}

local function rhox_remove_ror(faction_obj, faction_key)
    if type(RHOX_LCCP_SPECIAL_FACTIONS) ~= "table" or not RHOX_LCCP_SPECIAL_FACTIONS[faction_key] then
        return
    end
    local god = RHOX_LCCP_SPECIAL_FACTIONS[faction_key]
    for i, v in pairs(rhox_ror_to_remove) do
        if god == "neutral" or (v[3] and v[3] ~= god) then
            cm:add_unit_to_faction_mercenary_pool(
                faction_obj,
                v[1], -- key
                v[2], -- recruitment source
                0, -- count
                0, --replen chance
                0, -- max units
                0, -- max per turn
                "",	--faction restriction
                "",	--subculture restriction
                "",	--tech restriction
                false, --partial
                v[1]
            );
        end
    end
end

local rhox_tow_list={
    cr_vmp_the_everliving ={
        leader={
            subtype="hkrul_zach",
            unit_list="wh_main_vmp_inf_zombie,wh_main_vmp_inf_zombie,wh_main_vmp_inf_skeleton_warriors_1,wh_main_vmp_inf_skeleton_warriors_0,wh_main_vmp_inf_skeleton_warriors_0,wh_main_vmp_inf_grave_guard_0,wh_main_vmp_cav_black_knights_0,wh_dlc04_vmp_veh_mortis_engine_0,rhox_lccp_vmp_giant",
            forename ="names_name_6670702834",
            familiyname ="names_name_6670702833",
        },
        agent={
            type="spy",
            subtype="wh_main_vmp_banshee"
        },
        region="cr_oldworld_region_roezfels",
        how_they_play="rhox_iee_lccp_how_they_play_zach",
        pic=594,
        faction_trait="rhox_zach_faction_trait",
        
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    cr_def_corsairs_of_spite ={
        leader={
            subtype="hkrul_duriath",
            unit_list="wh2_main_def_inf_bleakswords_0,wh2_main_def_inf_darkshards_1,wh2_main_def_inf_black_ark_corsairs_1,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0,wh2_main_def_inf_black_ark_corsairs_0",
            forename ="names_name_1369138461",
            familiyname ="names_name_1369138462",
        },
        agent={
            type="wizard",
            subtype="wh2_dlc10_def_sorceress_death"
        },
        hand_over_region=nil,
        region="cr_oldworld_region_se_athil",
        how_they_play="rhox_iee_lccp_how_they_play_duriath",
        pic=782,
        faction_trait="rhox_duriath_faction_trait",
        additional = function(faction, faction_key) 
            cm:add_building_to_force(faction:faction_leader():military_force():command_queue_index(), "rhox_duriath_black_ark_special_1")
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    cr_nor_tokmars ={
        leader={
            subtype="hkrul_vroth",
            unit_list="wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_feral_manticore,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_inf_marauder_hunters_1,wh_main_nor_cav_chaos_chariot,wh_main_nor_inf_chaos_marauders_1,wh_main_nor_mon_chaos_warhounds_0",
            forename ="names_name_5670700722",
            familiyname ="names_name_5670700719",
        },
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_metal"
        },
        hand_over_region=nil,
        region="cr_oldworld_region_tokmars_camp",
        how_they_play="rhox_iee_lccp_how_they_play_vroth",
        pic=800,
        faction_trait="rhox_vroth_faction_trait",
        additional = function(faction, faction_key) 
            for i, v in pairs(LenkBeastHunts.ai_units) do
                cm:add_unit_to_faction_mercenary_pool(
                    faction,
                    v[1], -- key
                    v[2], -- recruitment source
                    0, -- count
                    0, --replen chance
                    v[5], -- max units
                    0, -- max per turn
                    "",
                    "",
                    "",
                    false,
                    v[6] -- merc unit group
                )
            end	
        end,
        first_tick = function(faction, faction_key) 
            LenkBeastHunts:setup_lenk_listeners()
        end
    },
    cr_ogr_deathtoll ={
        leader={
            subtype="hkrul_hrothyogg",
            unit_list="wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_maneaters_0,wh3_main_ogr_inf_maneaters_1",
            forename ="names_name_1369138460",
            familiyname ="",
        },
        agent={
            type="wizard",
            subtype="wh3_main_ogr_butcher_great_maw"
        },
        hand_over_region=nil,
        region="cr_oldworld_region_deathtoll_hold",
        how_they_play="rhox_iee_lccp_how_they_play_hrothyogg",
        pic=16,
        faction_trait="rhox_hrothyogg_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_nor_khazags ={
        leader={
            subtype="hkrul_thorgar",
            unit_list="wh_dlc08_nor_inf_marauder_spearman_0,wh_main_nor_mon_chaos_warhounds_0,wh_main_nor_inf_chaos_marauders_0,wh_main_nor_inf_chaos_marauders_0,wh_dlc08_nor_mon_skinwolves_0,wh_main_nor_cav_marauder_horsemen_0,wh_dlc08_nor_inf_marauder_hunters_1,wh_dlc08_nor_mon_war_mammoth_0,",
            x=1963,
            y=1374,
            forename ="names_name_5670700836",
            familiyname ="names_name_5670700835",
        },
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_metal"
        },
        hand_over_region="cr_oldworld_region_khazags_camp",
        region="cr_oldworld_region_khazags_camp",
        how_they_play="rhox_iee_lccp_how_they_play_thorgar",
        pic=800,
        faction_trait="rhox_thorgar_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key)
		    cm:add_event_restricted_building_record_for_faction("rhox_thorgar_dae_advanced_1", faction_key, "rhox_thorgar_building_lock")
        end,
        first_tick = function(faction, faction_key) 
        end
    },
    rhox_chs_the_deathswords ={
        leader={
            subtype="hkrul_engra",
            unit_list="wh_dlc01_chs_inf_chaos_warriors_2,wh_dlc01_chs_inf_chosen_2,wh_dlc01_chs_inf_chaos_warriors_2,wh_main_chs_mon_giant,wh_main_chs_cav_chaos_knights_0",
            x=1478,
            y=1544,
            forename ="names_name_5670700325",
            familiyname ="names_name_5670700324",
        },
        agent={
            type="wizard",
            subtype="wh_main_chs_chaos_sorcerer_death"
        },
        hand_over_region="cr_oldworld_region_monolith_of_merroc",
        region="cr_oldworld_region_monolith_of_merroc",
        how_they_play="rhox_iee_lccp_how_they_play_engra",
        pic=595,
        faction_trait="rhox_engra_faction_trait",
        enemy={
            key="cr_nor_schwarzvolf",
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
                    {"wh3_main_dae_inf_chaos_furies_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_dlc24_tze_mon_flamers_changebringers", "daemonic_summoning", 0, 0, 2},
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
                cm:add_unit_to_faction_mercenary_pool(faction, chs_ror[i], "wh3_main_regiments_of_renown_pool", 1, 100, 1, 0.1, "", "", "", true, chs_ror[i])
            end
            rhox_add_warriors_units(cm:get_faction(faction_key), rhox_engra_gift_units);
            rhox_add_faction_pool_units(cm:get_faction(faction_key), rhox_engra_faction_pool_units);
            if faction:is_human() then
                cm:force_diplomacy("faction:"..faction_key, "faction:wh_main_chs_chaos", "war", false, false, true);
                cm:force_diplomacy("faction:"..faction_key, "faction:wh_main_chs_chaos", "vassal", false, false, true);
                cm:make_diplomacy_available("wh_main_chs_chaos", faction_key)
                cm:make_diplomacy_available(faction_key, "wh_main_chs_chaos")
                cm:faction_add_pooled_resource(faction_key, "rhox_engra_hidden_block_ai", "other", 100)
                --cm:force_grant_military_access(faction_key, "wh_main_chs_chaos", false)
                --cm:force_grant_military_access("wh_main_chs_chaos", faction_key, false)
                
                
            else
                --[[
                cm:force_make_vassal("wh_main_chs_chaos", faction_key)
                cm:disable_event_feed_events(true, "wh_event_category_diplomacy", "", "")
                cm:force_declare_war("wh_main_chs_chaos", "cr_chs_po_hai", true, true)
                cm:callback(function() cm:disable_event_feed_events(false, "wh_event_category_diplomacy", "", "") end, 0.5)
                --]]
            end
            
            local rhox_province_chaos_units={--dogs only as I don't know other thing's requirement
                wh_main_chs_mon_chaos_warhounds_0= {1, 20, 1},
                wh_main_chs_mon_chaos_warhounds_1= {0, 20, 1},
            }
            
            local region_list = cm:model():world():region_manager():region_list()
            for i=0,region_list:num_items()-1 do
                local region= region_list:item_at(i)
                for key, unit in pairs(rhox_province_chaos_units) do
                    cm:add_unit_to_province_mercenary_pool(region, key, "wh3_dlc20_chs_province_pool", unit[1], unit[2], unit[3], 1, "", "wh_main_sc_chs_chaos", "", false, key.."_province_pool")
                end
            end--it has to be a subculture since one province can have only one main unit per region
        end,
        first_tick = function(faction, faction_key) 
            cm:add_pooled_resource_changed_listener_by_faction(
                "rhox_engra_PooledResourceChangedSouls",
                faction_key,
                function(context)
                    local amount = context:amount()
                    if context:resource():key() == "wh3_dlc20_chs_souls" and amount > 0 then
                        cm:faction_add_pooled_resource(context:faction():name(), "rhox_engra_campaign_progress", "souls_gain", amount)
                    end
                end,
                true
            )
            cm:force_diplomacy("faction:"..faction_key, "faction:wh_main_chs_chaos", "vassal", false, false, true);--because it does not work when he does not have settlement
        end
    },
    rhox_nor_firebrand_slavers ={
        leader={
            subtype="hkrul_valbrand",
            unit_list="wh_dlc08_nor_inf_marauder_spearman_0,wh_dlc08_nor_inf_marauder_hunters_1,wh3_main_kho_inf_chaos_warriors_0,wh3_main_kho_inf_chaos_warriors_0,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh3_dlc20_chs_inf_chaos_marauders_mkho,wh_dlc08_nor_mon_norscan_giant_0,wh3_dlc20_chs_cav_chaos_chariot_mkho,wh3_dlc20_chs_cav_chaos_chariot_mkho",
            x=558,
            y=1623,
            forename ="names_name_6330700834",
            familiyname ="names_name_6330700833",
        },
        agent={
            type="wizard",
            subtype="wh_dlc08_nor_shaman_sorcerer_fire"
        },
        hand_over_region=nil,
        region="cr_oldworld_region_monolith_of_valbrand_fireblade",
        how_they_play="rhox_iee_lccp_how_they_play_valbrand",
        pic=800,
        faction_trait="rhox_valbrand_faction_trait",
        enemy=nil,--because they don't spawn enemy force for it
        additional = function(faction, faction_key)            
            cm:add_unit_to_faction_mercenary_pool(faction,"wh3_dlc26_kho_inf_wrathmongers_ror", "wh3_main_regiments_of_renown_pool", 1, 20, 1, 0.1, "", "", "", true,"wh3_dlc26_kho_inf_wrathmongers_ror")
            local rhox_valbrand_gift_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_main_kho_inf_bloodletters_0", "daemonic_summoning", 1, 0, 4},
                    {"wh3_main_kho_mon_bloodthirster_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_kho_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
                    {"wh3_main_kho_inf_flesh_hounds_of_khorne_0", "daemonic_summoning", 0, 0, 4},
                    {"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
                    {"wh3_main_kho_veh_skullcannon_0", "daemonic_summoning", 0, 0, 4},
                    {"wh3_dlc26_kho_mon_bloodbeast_of_khorne", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc26_kho_mon_slaughterbrute", "daemonic_summoning", 0, 0, 2}
            }
            local rhox_valbrand_faction_units = {
                ---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
                    {"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
                    {"wh3_dlc20_chs_mon_warshrine_mkho", "daemonic_summoning", 0, 0, 2},
            }
            rhox_add_warriors_units(cm:get_faction(faction_key), rhox_valbrand_gift_units);
            rhox_add_faction_pool_units(cm:get_faction(faction_key), rhox_valbrand_faction_units);
            
            if faction:is_human() then                
                cm:trigger_mission(faction_key, "wh3_dlc26_kho_exiles_of_khorne_skarr_bloodwrath_unlock_1", true)--because the normal building completed listener doesn't work
            end
            
            cm:instantly_research_technology(faction_key, "wh3_dlc20_chs_und_shared_chariots", false)
            cm:instantly_research_technology(faction_key, "wh3_dlc20_chs_und_shared_knights", false)

        end,
        first_tick = function(faction, faction_key) 
            rhox_valbrand_slaves:start_listeners()
        end
    },
}




cm:add_first_tick_callback_new(
    function()
        if cm:is_multiplayer() then
            mixer_disable_starting_zoom = true
        end

        for faction_key, faction_info in pairs(rhox_tow_list) do
            out("lccp error finder"..faction_key)
			local faction = cm:get_faction(faction_key);
            local faction_leader_cqi = faction:faction_leader():command_queue_index();

            if faction_info.hand_over_region then
                cm:transfer_region_to_faction(faction_info.hand_over_region,faction_key)
                local target_region_cqi = cm:get_region(faction_info.hand_over_region):cqi()
                cm:heal_garrison(target_region_cqi)
            end
            
            if not faction_info.region then
                faction_info.region = faction:home_region():name()
            end

            if not faction_info.leader.x or not faction_info.leader.y then
                faction_info.leader.x, faction_info.leader.y = cm:find_valid_spawn_location_for_character_from_settlement(
                    faction_key,
                    faction_info.region,
                    false,
                    true,
                    5
                )
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
                    cm:set_character_unique(cm:char_lookup_str(cqi),true)
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
                
                
                if faction_info.enemy.subtype and cm:get_faction(faction_info.enemy.key):is_human() == false then
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
            rhox_remove_ror(faction, faction_key)
            faction_info.additional(faction, faction_key)
		end
    end
)

local turn2_incidents={
    rhox_chs_the_deathswords="rhox_lccp_turn_two_incident_engra",
}

cm:add_first_tick_callback(
	function()
        for faction_key, faction_info in pairs(rhox_tow_list) do
            pcall(function()
                mixer_set_faction_trait(faction_key, faction_info.faction_trait, true)
            end)
            faction_info.first_tick(cm:get_faction(faction_key), faction_key)
        end

	end
)
