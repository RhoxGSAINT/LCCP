cm:add_first_tick_callback(
    function()
        if cm:get_local_faction_name(true) == "rhox_kho_destroyers_of_khorne" then --ui things 
            
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_arbaal_resource_bar", "ui/campaign ui/rhox_arbaal_top_bar.twui.xml", parent_ui)
        end
    end
);


local function rhox_arbaal_remove_pooled_resource(character)
    local faction = character:faction()
	
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
	

    if faction:name() == "rhox_kho_destroyers_of_khorne" then
        cm:faction_add_pooled_resource("rhox_kho_destroyers_of_khorne", "rhox_arbaal_resource", "rhox_arbaal_wrath", -100)
    else
        cm:apply_effect_bundle("rhox_arbaal_other_faction_curse", faction:name(), 5)
    end
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
    "rhox_arbaal_battle_lost",
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

core:add_listener(
    "rhox_arbaal_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        
        return character:character_subtype_key() == "hkrul_arbaal" and pb:has_been_fought() --And it doesn't care about faction name as it is could also affect other faction who confed him
        and pb:get_how_many_times_ability_has_been_used_in_battle(faction:command_queue_index(), "rhox_arbaal_spawn_spawn")>0 -- only if you have used it 
    end,
    function(context)
        local faction = context:character():faction()
        if faction:name() == "rhox_kho_destroyers_of_khorne" and character:won_battle() then--only won for Destroyer because otherwise upper listener will take care of it. 
            rhox_arbaal_remove_pooled_resource(context:character())
        elseif faction:name() ~= "rhox_kho_destroyers_of_khorne" then
            rhox_arbaal_remove_pooled_resource(context:character())
        end
    end,
    true
);

core:add_listener(
	"rhox_arbaal_button_clicked",
	"ComponentLClickUp",
	function(context)
        return context.string == "rhox_arbaal_shard_animation"
	end,
	function(context)
        local faction = cm:get_local_faction(true)
        local character_cqi = faction:faction_leader():command_queue_index()
        
        local resource_value = faction:pooled_resource_manager():resource("rhox_arbaal_resource"):value()
        
        if resource_value >= 100 then
            CampaignUI.TriggerCampaignScriptEvent(character_cqi, "rhox_arbaal_perform_ritual")
        end
		
		
		
	end,
	true
);



core:add_listener(
    "rhox_arbaal_perform_ritual",
    "UITrigger",
    function(context)
        return context:trigger() == "rhox_arbaal_perform_ritual"
    end,
    function(context)
        local str = context:trigger()
        local character_cqi = context:faction_cqi() --it says faction but what we passed is character
        cm:faction_add_pooled_resource("rhox_kho_destroyers_of_khorne", "rhox_arbaal_resource", "rituals", -50)
        
        local faction = cm:get_character_by_cqi(character_cqi):faction()
        trigger_tiktaqto_rite(faction);
    end,
    true
)