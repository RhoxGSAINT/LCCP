local zach_faction = "rhox_vmp_the_everliving"  

local function rhox_zach_init_setting()    
    
	local faction = cm:get_faction(zach_faction);
    local faction_leader_cqi = faction:faction_leader():command_queue_index();

    local x = 1259
    local y = 313
    

    cm:create_force_with_general(
    -- faction_key, unit_list, region_key, x, y, agent_type, agent_subtype, forename, clan_name, family_name, other_name, id, make_faction_leader, success_callback
    zach_faction,
    "wh_main_vmp_inf_zombie",
    "cr_combi_region_khuresh_1_2",
    x,
    y,
    "general",
    "hkrul_zach",
    "names_name_6670702834",
    "",
    "names_name_6670702833",
    "",
    true,
    function(cqi) 
    end);
    
    cm:transfer_region_to_faction("cr_combi_region_khuresh_1_2",zach_faction)
    
    cm:disable_event_feed_events(true, "wh_event_category_character", "", "")
    cm:set_character_immortality(cm:char_lookup_str(faction_leader_cqi), false);          
    cm:kill_character_and_commanded_unit(cm:char_lookup_str(faction_leader_cqi), true)
    cm:callback(function() cm:disable_event_feed_events(false, "", "", "wh_event_category_character") end, 0.2);
    
    cm:callback(
        function()
            cm:show_message_event(
                zach_faction,
                "event_feed_strings_text_wh2_scripted_event_how_they_play_title",
                "factions_screen_name_" .. zach_faction,
                "event_feed_strings_text_".. "rhox_iee_lccp_how_they_play_zach",
                true,
                594
            );
        end,
        1
    )
end





cm:add_first_tick_callback(
	function()
		pcall(function()
			mixer_set_faction_trait(zach_faction, "rhox_zach_faction_trait", true)
		end)
        
		if cm:is_new_game() then
            rhox_zach_init_setting()
        end
	end
)