cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "rhox_kho_destroyers_of_khorne" then --ui things 
            
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_arbaal_resource_bar", "ui/campaign ui/rhox_arbaal_top_bar.twui.xml", parent_ui)
      
        end
    end
);


local function rhox_arbaal_remove_pooled_resource(character)

	
	if character:faction():is_human() then
        local force_X = character:logical_position_x();
        local force_Y = character:logical_position_y();
        
        cm:show_message_event_located(
            character:faction():name(),
            "event_feed_strings_text_rhox_arbaal_punishment_title",
            "event_feed_strings_text_rhox_arbaal_punishment_primary_detail",
            "event_feed_strings_text_rhox_arbaal_punishment_secondary_detail",
            force_X,
            force_Y,
            false,
            711
        );
	end;
	


	cm:faction_add_pooled_resource("rhox_kho_destroyers_of_khorne", "rhox_arbaal_resource", "battles", -100)
	--cm:remove_character_vfx(character:command_queue_index(), "scripted_effect"); --Should I add this to this guy?
end

core:add_listener(
    "rhox_arbaal_withdraw_from_battle",
    "CharacterWithdrewFromBattle",
    function(context)
        local character = context:character();
        local faction = character:faction()
        local pb = cm:model():pending_battle();
        --out("Rhox Arbaal:Checking")
        return not character:is_null_interface() and character:character_subtype_key() == "hkrul_arbaal" and faction:name() == "rhox_kho_destroyers_of_khorne";
    end,
    function(context) 
        --out("Rhox Arbaal:Checking2")
        rhox_arbaal_remove_pooled_resource(context:character()) 
    end,
    true
);

core:add_listener(
    "rhox_arbaal_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();

        return character:character_subtype_key() == "hkrul_arbaal" and faction:name() == "rhox_kho_destroyers_of_khorne" and pb:has_been_fought() and not character:won_battle()
    end,
    function(context)
        rhox_arbaal_remove_pooled_resource(context:character())
    end,
    true
)