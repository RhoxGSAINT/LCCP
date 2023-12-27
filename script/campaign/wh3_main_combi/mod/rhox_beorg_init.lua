
--mixer_disable_starting_zoom= true--some say zoom is the cause of the MP desync disable it to do something

local norsca_ror_table={
    {"wh_dlc08_nor_art_hellcannon_battery", "wh_dlc08_nor_art_hellcannon_battery"},
    {"wh_pro04_nor_mon_war_mammoth_ror_0", "wh_pro04_nor_mon_war_mammoth_ror_0"},
    {"wh_dlc08_nor_mon_frost_wyrm_ror_0", "wh_dlc08_nor_mon_frost_wyrm_ror_0"},
    {"wh_pro04_nor_inf_chaos_marauders_ror_0","wh_pro04_nor_inf_chaos_marauders_ror_0"}, 
    {"wh_pro04_nor_mon_fimir_ror_0", "wh_pro04_nor_mon_fimir_ror_0"},
    {"wh_pro04_nor_mon_marauder_warwolves_ror_0", "wh_pro04_nor_mon_warwolves_ror_0"},
    {"wh_pro04_nor_inf_marauder_berserkers_ror_0","wh_pro04_nor_inf_marauder_berserkers_ror_0"},
    {"wh_pro04_nor_mon_skinwolves_ror_0","wh_pro04_nor_mon_skinwolves_ror_0"}, 
    {"wh_dlc08_nor_mon_war_mammoth_ror_1", "wh_dlc08_nor_mon_war_mammoth_ror_1"},
}

local rhox_iee_list={
    mixer_nur_rotbloods ={
        leader={
            subtype="hkrul_beorg",
            unit_list="wh_main_nor_mon_chaos_warhounds_0,hkrul_bearmen,hkrul_beorg_brown_feral,hkrul_beorg_brown_feral,hkrul_beorg_brown_feral_marked",
            x=746,
            y=794,
            forename ="names_name_5677700722",
            familiyname ="names_name_5677700721",
        },
        hand_over_region="wh3_main_combi_region_yetchitch",
        region="wh3_main_combi_region_yetchitch",
        how_they_play="rhox_iee_lccp_how_they_play_beorg",
        pic=800,
        faction_trait="rhox_beorg_faction_trait",
        enemy={
            key="wh3_main_ksl_ropsmenn_clan",
            subtype="wh3_main_ksl_boyar",
            unit_list="wh3_main_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_0,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_inf_kossars_1,wh3_main_ksl_cav_horse_raiders_0",
            x=746,
            y=789
        },
        additional = function(faction, faction_key)
            for i, ror in pairs(norsca_ror_table) do
                cm:add_unit_to_faction_mercenary_pool(faction,ror[1],"renown",1,100,1,0.1,"","","",true,ror[2])
            end 
            cm:add_unit_to_faction_mercenary_pool(faction,"hkrul_beorg_brown_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral")
            cm:add_unit_to_faction_mercenary_pool(faction,"hkrul_beorg_brown_feral_marked","renown",0,100,20,0,"","","",true,"hkrul_beorg_brown_feral_marked")
            cm:add_unit_to_faction_mercenary_pool(faction,"hkrul_beorg_ice_feral","renown",0,100,20,0,"","","",true,"hkrul_beorg_ice_feral")
            
            cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_war_mammoth_ror_1",faction_key, "norsca_monster_hunt_ror_unlock")
		    cm:add_event_restricted_unit_record_for_faction("wh_dlc08_nor_mon_frost_wyrm_ror_0", faction_key, "norsca_monster_hunt_ror_unlock") 
		    cm:spawn_unique_agent(faction:command_queue_index(), "hkrul_oerl", true)
		    
		    local target_region = cm:get_region("wh3_main_combi_region_yetchitch")
		    if faction:is_human() ==false then
                cm:instantly_set_settlement_primary_slot_level(target_region:settlement(), 2)
                local target_slot = target_region:slot_list():item_at(1)
                cm:instantly_upgrade_building_in_region(target_slot, "wh_main_nor_garrison_2")
            else                
                cm:instantly_set_settlement_primary_slot_level(target_region:settlement(), 1)
            end
            cm:heal_garrison(target_region:cqi())

        end,
        first_tick = function(faction, faction_key) 
        end
    }
}

cm:add_first_tick_callback_new(
    function()
        if cm:is_multiplayer() then
            mixer_disable_starting_zoom = true
        end


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
        for faction_key, faction_info in pairs(rhox_iee_list) do
            pcall(function()
                mixer_set_faction_trait(faction_key, faction_info.faction_trait, true)
            end)
            faction_info.first_tick(cm:get_faction(faction_key), faction_key)
        end
	end
)
