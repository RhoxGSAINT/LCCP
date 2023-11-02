local karitamen_region_list={
	wh3_main_combi_region_tobaro = true,
	wh3_main_combi_region_skavenblight = true,
	wh3_main_combi_region_miragliano = true,
	wh3_main_combi_region_riffraffa = true,
	wh3_main_combi_region_luccini = true,
	wh3_main_combi_region_sartosa = true,
	wh3_main_combi_region_argalis = true,
	wh3_main_combi_region_verdanos = true,
	wh3_main_combi_region_myrmidens = true,
	wh3_main_combi_region_zvorak = true,
	wh3_main_combi_region_matorca = true,
	wh3_main_combi_region_karak_angazhar = true,
	wh3_main_combi_region_akendorf = true,
}	






local function rhox_karitamen_set_effects()
	local power = 0
	local full_control = true


    local faction = cm:get_faction("cr_tmb_sons_of_ptra")
	for region_key, _ in pairs(karitamen_region_list) do
		local region =cm:get_region(region_key)
		if region:is_abandoned() == false and region:owning_faction() and region:owning_faction():name() =="cr_tmb_sons_of_ptra" then
			power = power+7--7 is strength per power
		else
			full_control = false
		end
	end
	
	local karitamen_effect_bundle = cm:create_new_custom_effect_bundle("rhox_karitamen_hidden_effect_bundle")
	
	if full_control then
        power = power+9
		cm:set_script_state("rhox_karitamen_complete_bonus", 9)--we can't divide 100 by 13 so add another 7*13= 91 complete bonus 9 it is set to 9 when you have collected everything and 0 otherwise
		karitamen_effect_bundle:add_effect("rhox_karitamen_effect_army_ability_enable_legacy_of_conquest", "faction_to_force_own", 1)
	else
		cm:set_script_state("rhox_karitamen_complete_bonus", 0)--now it will not show the full effect
	end

    

    karitamen_effect_bundle:add_effect("wh_main_effect_force_stat_weapon_strength", "faction_to_force_own", power/4)
	
    karitamen_effect_bundle:set_duration(0)

    if faction:has_effect_bundle(karitamen_effect_bundle:key()) then
        cm:remove_effect_bundle(karitamen_effect_bundle:key(), faction:name())
    end				
    cm:apply_custom_effect_bundle_to_faction(karitamen_effect_bundle, faction)

	
	

	
	
	cm:set_script_state("rhox_karitamen_conquer_meter_change", power/4)--we can use it as a weapon strength meter
	cm:set_script_state("rhox_karitamen_conquer_meter", power/100)
end


cm:add_first_tick_callback(
    function()
		if cm:get_faction("cr_tmb_sons_of_ptra"):is_human() then
			rhox_karitamen_set_effects()
			cm:set_script_state("rhox_karitamen_increase_per_settlement", 7)

			core:add_listener(
				"rhox_karitamen_occupation_listener",
				"CharacterPerformsSettlementOccupationDecision",
				function(context)
					local region_name = context:garrison_residence():region():name()
					
					return karitamen_region_list[region_name]
				end,
				function(context)
					rhox_karitamen_set_effects()
				end,
				true
			)
			core:add_listener(
				"rhox_karitamen_faction_turn_start",
				"FactionTurnStart",
				function(context)
					return context:faction():name() == "cr_tmb_sons_of_ptra"

				end,
				function(context)
					rhox_karitamen_set_effects()
				end,
				true
			)
		end
        if cm:get_local_faction_name(true) == "cr_tmb_sons_of_ptra" then
            --rhox_karitamen_hidden_effect_bundle
            local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar");
            local result = core:get_or_create_component("rhox_karitamen_conquer_bar", "ui/campaign ui/rhox_karitamen_conquer_bar.twui.xml", parent_ui)
        end
    end
);