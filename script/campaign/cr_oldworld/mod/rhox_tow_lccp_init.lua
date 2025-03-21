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
    cr_nur_tide_of_pestilence ={
        leader={
            subtype="hkrul_orghotts",
            unit_list="wh3_main_nur_inf_nurglings_0,wh3_main_nur_inf_nurglings_0,wh3_dlc20_chs_inf_chaos_marauders_mnur,wh3_dlc20_chs_inf_chaos_marauders_mnur,wh3_main_nur_cav_pox_riders_of_nurgle_0,wh3_main_nur_mon_plague_toads_0",
            forename ="names_name_24444424",
            familiyname ="names_name_24444423",
        },
        agent={
            type="spy",
            subtype="wh3_main_nur_plagueridden_nurgle"
        },
        hand_over_region=nil,
        region="cr_oldworld_region_valley_of_locust",
        how_they_play="rhox_iee_lccp_how_they_play_orghotts",
        pic=12,
        faction_trait="rhox_orghotts_faction_trait",
        enemy=nil,
        additional = function(faction, faction_key) 
            if faction:is_human() then
                cm:trigger_mission(faction_key, "rhox_spew_tow_survival_mission", true)
            end
        end,
        first_tick = function(faction, faction_key) 
        end
    },
}




cm:add_first_tick_callback_new(
    function()
        if cm:is_multiplayer() then
            mixer_disable_starting_zoom = true
        end

        for faction_key, faction_info in pairs(rhox_tow_list) do
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
            faction_info.additional(faction, faction_key)
		end
    end
)




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


