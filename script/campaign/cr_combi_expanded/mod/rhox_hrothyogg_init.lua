local hrothyogg_faction = "cr_ogr_deathtoll"

cm:add_first_tick_callback_new(
    function()
        local faction = cm:get_faction(hrothyogg_faction);
        local faction_leader_cqi = faction:faction_leader():command_queue_index();
        cm:create_force_with_general(
            -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
            hrothyogg_faction,
            "wh3_main_ogr_inf_gnoblars_0,wh3_main_ogr_inf_gnoblars_1",
            "cr_combi_region_elithis_2_1",
            1116,
            410,
            "general",
            "hkrul_hrothyogg",
            "names_name_6670700833",
            "",
            "names_name_6670700822",
            "",
            true,
            function(cqi)
            end);
            
        if cm:get_faction("ovn_mar_house_fooger"):is_human() == false then --don't kill them if Fooger is human, we need them as one turn punchbag
            cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
            cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
            cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
            cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
        end
        
        
        cm:callback(
            function()
                cm:show_message_event(
                    hrothyogg_faction,
                    "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                    "factions_screen_name_" .. hrothyogg_faction,
                    "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_hrothyogg",
                    true,
                    16
                );
            end,
            1
        )

    end
)

cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(hrothyogg_faction, "rhox_hrothyogg_faction_trait", true)
		end)
	end
)
--------------------------------------------Hrothyogg big names
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_1",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				return character:won_battle() and cm:count_char_army_has_unit(character, {"wh3_main_ogr_inf_maneaters_0", "wh3_main_ogr_inf_maneaters_1", "wh3_main_ogr_inf_maneaters_2", "wh3_main_ogr_inf_maneaters_3"}) > 4;
			end
	}
)
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_2",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				
				return cm:character_won_battle_against_culture(context:character(), "wh2_main_skv_skaven");
			end
	}
)
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_3",
		["event"] = "CharacterTurnEnd",
		["condition"] =
			function(context)
				local character = context:character()
				local region = character:region()
				
				if region:is_null_interface() == false then
					return region:name() == "wh3_main_combi_region_miragliano"
				else
					return false
				end
			end
	}
)
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_hrothyogg_character_character_initiative_ogr_big_name_hrothyogg_4",
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
                local character = context:character();

				if character:won_battle() then
					local character_faction_name = character:faction():name();
					local pb = cm:model():pending_battle();
					
					local defender_char_cqi, defender_mf_cqi, defender_faction_name = cm:pending_battle_cache_get_defender(1);
					local attacker_char_cqi, attacker_mf_cqi, attacker_faction_name = cm:pending_battle_cache_get_attacker(1);
					
					if defender_faction_name == character_faction_name and pb:has_attacker() then
						return pb:attacker_casulaties() > 1000
					elseif attacker_faction_name == character_faction_name and pb:has_defender() then
						return pb:defender_casulaties() > 1000
					end;
				end;
			end
	}
)