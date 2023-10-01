burlok = {}
burlok.artifact_parts = {
	--- artifact pooled resource key = region key, bundle key
	rhox_burlok_artifact_part_1a = {region = "wh3_main_combi_region_the_golden_tower", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_1a"},
	rhox_burlok_artifact_part_1b = {region = "wh3_main_combi_region_karag_orrud", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_1b"},
	rhox_burlok_artifact_part_2a = {region = "wh3_main_combi_region_lahmia", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_2a"},
	rhox_burlok_artifact_part_2b = {region = "wh3_main_combi_region_mount_gunbad", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_2b"},
	rhox_burlok_artifact_part_3a = {region = "wh3_main_combi_region_misty_mountain", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_3a"},
	rhox_burlok_artifact_part_3b = {region = "wh3_main_combi_region_karak_azgal", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_3b"},
	rhox_burlok_artifact_part_4a = {region = "wh3_main_combi_region_black_crag", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_4a"},
	rhox_burlok_artifact_part_4b = {region = "wh3_main_combi_region_mount_silverspear", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_4b"},
	rhox_burlok_artifact_part_5a = {region = "wh3_main_combi_region_silver_pinnacle", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_5a"},
	rhox_burlok_artifact_part_5b = {region = "wh3_main_combi_region_karak_azgaraz", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_5b"},
	rhox_burlok_artifact_part_6a = {region = "wh3_main_combi_region_vulture_mountain", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_6a"},
	rhox_burlok_artifact_part_6b = {region = "wh3_main_combi_region_galbaraz", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_6b"},
	rhox_burlok_artifact_part_7a = {region = "wh3_main_combi_region_karag_dromar", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_7a"},
	rhox_burlok_artifact_part_7b = {region = "wh3_main_combi_region_valayas_sorrow", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_7b"},
	rhox_burlok_artifact_part_8a = {region = "wh3_main_combi_region_kraka_drak", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_8a"},
	rhox_burlok_artifact_part_8b = {region = "wh3_main_combi_region_karak_ungor", bundle = "rhox_burlok_effect_bundle_burlok_artifact_part_8b"}
}
burlok.already_looted = {}
burlok.artifact_piece_vfx_key = "scripted_effect18"
burlok.burlok_faction_key = "cr_dwf_firebeards_excavators"
burlok.artifact_base_string = "rhox_burlok_artifact_part_*" --- db keys for burlok's artifact part pooled resources need to follow this format
burlok.artifact_resource_factor = "missions"
burlok.rituals_completed = 0
burlok.ritual_prefix = "rhox_burlok_ritual_burlok_artifact_" -- any rituals beginning with this prefix will be considered a burlok artifact ritual.
burlok.ghost_thane_ritual = burlok.ritual_prefix .. "2"


function burlok:initialise()
	local burlok_interface = cm:get_faction(self.burlok_faction_key)
	
	if not burlok_interface or not burlok_interface:is_human() then
		return
	end
	
	out("###Setting up burlok Listeners###")
	
	if cm:is_new_game() then
		for artifact_key, artifact_part_info in pairs(self.artifact_parts) do
			local region_key = artifact_part_info.region
			
			cm:add_garrison_residence_vfx(cm:get_region(region_key):garrison_residence():command_queue_index(), self.artifact_piece_vfx_key, true)
			-- also applys effect bundle to display artefact part icon on region
			cm:apply_effect_bundle_to_region(artifact_part_info.bundle, region_key, 0)
		end
	end
	
	core:add_listener(
		"CharacterPerformsSettlementOccupationDecisionburlok",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			return context:character():faction():name() == self.burlok_faction_key and context:occupation_decision() ~= "596"
		end,
		function(context)
			local artifact_part_key = self:get_artifact_part_from_region(context:garrison_residence():region():name())
			
			if artifact_part_key then
				self:award_artifact_part(artifact_part_key, 1)
				
				cm:remove_garrison_residence_vfx(context:garrison_residence():command_queue_index(), self.artifact_piece_vfx_key)
			end
		end,
		true
	)
	
	core:add_listener(
		"burlokArtifactPieceLClickUp",
		"ComponentLClickUp",
		function(context)
			return string.match(context.string, self.artifact_base_string)
		end,
		function(context)
			local crafting_panel_close = find_uicomponent("mortuary_cult", "button_ok")
			
			if crafting_panel_close then
				crafting_panel_close:SimulateLClick()
			else
				script_error("burlok:setup_resource_click_listener() is trying to close the crafting panel when it's not open, how has this happened?")
			end
			
			local region_interface = cm:get_region(self.artifact_parts[context.string].region)
			
			if region_interface then
				cm:scroll_camera_from_current(true, 3, {region_interface:settlement():display_position_x(), region_interface:settlement():display_position_y(), 10.5, 0.0, 6.8})
			end
			
		end,
		true
	)
	
	core:add_listener(
		"burlok_PositiveDiplomaticEvent",
		"PositiveDiplomaticEvent",
		function(context)
			return (context:recipient():name() == self.burlok_faction_key or context:proposer():name() == self.burlok_faction_key) and (context:is_military_alliance() or context:is_vassalage())
		end,
		function(context)
			local other_faction = false
			
			if context:proposer():name() == self.burlok_faction_key then
				other_faction = context:recipient():name()
			else
				other_faction = context:proposer():name()	
			end
			
			-- Nakai specific fix, alliance with Nakai also does a check for their vassal
			local is_nakai = other_faction == "wh2_dlc13_lzd_spirits_of_the_jungle"
			
			for k, v in pairs(self.artifact_parts) do
				if cm:is_region_owned_by_faction(v.region, other_faction) or (is_nakai and cm:is_region_owned_by_faction(v.region, "wh2_dlc13_lzd_defenders_of_the_great_plan")) then
					self:award_artifact_part(k, 1)
					cm:remove_garrison_residence_vfx(cm:get_region(v.region):garrison_residence():command_queue_index(), self.artifact_piece_vfx_key)
				end	
			end
		end,
		true
	)
	
	core:add_listener(
		"burlok_RegionFactionChangeEvent",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region()
			local region_key = region:name()
			local artifact_part_key = self:get_artifact_part_from_region(region_key)
			
			if artifact_part_key then
				local owner = region:owning_faction()
				if owner:name() == self.burlok_faction_key or owner:is_ally_vassal_or_client_state_of(cm:get_faction(self.burlok_faction_key)) then
					self:award_artifact_part(artifact_part_key, 1)
					
					cm:remove_garrison_residence_vfx(region:garrison_residence():command_queue_index(), self.artifact_piece_vfx_key)
				end
				
				if not self.already_looted[artifact_part_key] then
					cm:apply_effect_bundle_to_region(self.artifact_parts[artifact_part_key].bundle, region_key, 0)
				end
			end
		end,
		true
	)
	
	core:add_listener(
		"burlok_crafting_ritual",
		"RitualCompletedEvent",
		function(context)
			local ritual = context:ritual()
			return ritual:ritual_category() == "CRAFTING_RITUAL" and ritual:ritual_key():starts_with(burlok.ritual_prefix)
		end,
		function(context)
			local faction = context:performing_faction()
			
			burlok.rituals_completed = burlok.rituals_completed + 1

			
			if context:ritual():ritual_key() == burlok.ghost_thane_ritual then
				cm:spawn_unique_agent(faction:command_queue_index(), "wh2_dlc17_dwf_thane_ghost_artifact", true)
			end
			
			if burlok.rituals_completed == 8 then
				core:trigger_event("ScriptEventArtefactsForgedAll")
			elseif burlok.rituals_completed >= 3 then
				core:trigger_event("ScriptEventArtefactsForgedThree")
			else
				core:trigger_event("ScriptEventArtefactsForgedOne")
			end
		end,
		true
	)
end

function burlok:get_artifact_part_from_region(region_key)
	for artifact_part_key, artifact_part_info in pairs(self.artifact_parts) do
		if artifact_part_info.region == region_key then
			return artifact_part_key
		end
	end
end

function burlok:award_artifact_part(artifact_part_key, amount)
	if not self.already_looted[artifact_part_key] then
		cm:faction_add_pooled_resource(self.burlok_faction_key, artifact_part_key, self.artifact_resource_factor, amount)
		self.already_looted[artifact_part_key] = true
		
		local artifact = self.artifact_parts[artifact_part_key]
		cm:remove_effect_bundle_from_region(artifact.bundle, artifact.region)
		
		cm:show_message_event(
			self.burlok_faction_key,
			"event_feed_strings_text_wh2_dlc17_event_feed_string_burlok_artifact_found_title",
			"pooled_resources_display_name_" .. artifact_part_key,
			"event_feed_strings_text_wh2_dlc17_event_feed_string_burlok_artifact_found_secondary_detail",
			true,
			1701
		)
		
		--trigger event for artefact part being awarded
		core:trigger_event("ScriptEventForgeArtefactPartReceived")
		
		local artifact_part_pair_key = string.sub(artifact_part_key, 1, string.len(artifact_part_key) - 1)
		if self.already_looted[artifact_part_pair_key .. "a"] and self.already_looted[artifact_part_pair_key .. "b"] then
			core:trigger_event("ScriptEventForgeArtefactPair")
		end
	end
end

--------------------------------------------------------------
----------------------- SAVING / LOADING ---------------------
--------------------------------------------------------------
cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("rhox_burlok_artifact_objectives", burlok.rituals_completed, context)
		cm:save_named_value("rhox_burlok_already_looted", burlok.already_looted, context)
	end
)

cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			burlok.rituals_completed = cm:load_named_value("rhox_burlok_artifact_objectives", burlok.rituals_completed, context)
			burlok.already_looted = cm:load_named_value("rhox_burlok_already_looted", burlok.already_looted, context)
		end
	end
)