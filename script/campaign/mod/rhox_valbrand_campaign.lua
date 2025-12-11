--his innate trait
local function recalculate_mass_bonus_effect(character, faction)
    if character:has_effect_bundle("rhox_valbrand_innate_effect_bundle") then
        cm:remove_effect_bundle_from_character("rhox_valbrand_innate_effect_bundle", character)
    end-- remove the pre-existing one if any
    
    local value = 5;
    local war_faction_number = faction:factions_at_war_with():num_items()
    local valbarand_bundle = cm:create_new_custom_effect_bundle("rhox_valbrand_innate_effect_bundle");
    valbarand_bundle:set_duration(0);
    valbarand_bundle:add_effect("wh3_main_effect_character_stat_unit_mass_percentage_mod", "character_to_character_own", value*war_faction_number);

    cm:apply_custom_effect_bundle_to_character(valbarand_bundle, character)
end

core:add_listener(
    "rhox_valbarand_innate_trait_1",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_valbrand")
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        
        recalculate_mass_bonus_effect(character, faction)
        
    end,
    true
)

core:add_listener(
    "rhox_valbarand_innate_trait_2",
    "FactionLeaderDeclaresWar",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_valbrand")
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        
        recalculate_mass_bonus_effect(character, faction)
        
    end,
    true
)



--unlock techs by sacking instead
------------------------------------------






core:add_listener(
    "rhox_valbrand_tech_check",
    "CharacterPerformsSettlementOccupationDecision",
    function(context)
        local region_key = context:garrison_residence():region():name()
        return context:occupation_decision() == "1197046429" and context:character():faction():name() == "rhox_nor_firebrand_slavers"--raze for hound
    end,
    function(context)
        local faction = context:character():faction()
        local character_faction_name = context:character():faction():name()
        if scripted_technology_tree.region_mapping[region_key] then--tech unlocking thing
            local region_key = context:garrison_residence():region():name()
            local tech_table = scripted_technology_tree.region_mapping[region_key]
            for tech_key, detail in pairs(tech_table) do
                if detail.culture == context:character():faction():culture() then
                    cm:unlock_technology(context:character():faction():name(), tech_key)
                end
            end
        end
        
        --increasing Khorne dedication
        local current_value = cm:get_factions_bonus_value(faction, "nor_progress_hound_count")
        --out("Rhox Valbrand: Current value "..current_value)
        local valbarand_bundle = cm:create_new_custom_effect_bundle("rhox_valbrand_raze_count");
        valbarand_bundle:set_duration(0);
        valbarand_bundle:add_effect("wh3_dlc27_pooled_resource_nor_progress_hound_buildings", "faction_to_faction_own", current_value+1);
        cm:apply_custom_effect_bundle_to_faction(valbarand_bundle, faction)

        norscan_gods:update_allegiance_pooled_resources(character_faction_name)
        norscan_gods:process_allegiance(character_faction_name)
    end,
    true
);

------------------slave thing
rhox_valbrand_slaves = {
	faction_key = "rhox_nor_firebrand_slavers",
	pooled_resource_key = "def_slaves",
	pooled_resource_factor_key = "raiding"
}

function rhox_valbrand_slaves:start_listeners()

	-- set the amount of slaves to provide when raiding for ui display

	if cm:get_faction(self.faction_key):is_human() then
		self:update_all_raiding_armies(cm:get_faction(self.faction_key))
	end
		
	-- set the amonut of slaves to provide when channeling for ui display when an army enters the raiding stance
	core:add_listener(
		"rhox_lccp_valbrand_def_raiding_calculate_slaves",
		"ForceAdoptsStance",
		function(context)
			local faction = context:military_force():faction()
			
			return faction:is_human() and faction:name() == self.faction_key
		end,
		function(context)
			local faction = context:military_force():faction()
			
			self:update_all_raiding_armies(faction)
		end,
		true
	)

	core:add_listener(
		"rhox_lccp_valbrand_def_raiding_calculate_slaves_disband",
		"UnitDisbanded",
		function(context)
			local faction = context:unit():force_commander():faction()
		
			return faction:is_human() and faction:name() == self.faction_key
		end,
		function(context)
			local unit = context:unit()
			mf_cqi = unit:military_force():command_queue_index()

			-- slight callback here so that the unit actually leaves the army before we calculate the new raid value
			cm:callback(function()
				if cm:get_military_force_by_cqi(mf_cqi) ~= false then
					self:update_all_raiding_armies(cm:get_military_force_by_cqi(mf_cqi):faction())
				end
			end, 0.1)
		end,
		true
	)

	-- update the amount of slaves if the character moves in raiding stance
	core:add_listener(
		"rhox_lccp_valbrand_def_raiding_calculate_slaves_post_movement",
		"CharacterFinishedMovingEvent",
		function(context)
			local character = context:character()
			local faction = character:faction()
			
			return faction:is_human() and faction:name() == self.faction_key and cm:char_is_general_with_army(character) and character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID"
		end,
		function(context)
			self:update_all_raiding_armies(context:character():faction())
		end,
		true
	)

	--add the slaves for the armies in raiding stance
	core:add_listener(
		"rhox_lccp_valbrand_def_raiding_add_slaves",
		"FactionTurnStart",
		function(context)	
			return context:faction():name() == self.faction_key
		end,
		function(context)
			local faction = context:faction()
			local mf_list = faction:military_force_list()

			for i =0, mf_list:num_items()- 1 do
				local mf = mf_list:item_at(i)

				if mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
					local slaves_to_add = self:calculate_slaves(mf)

					if slaves_to_add > 0 then
						cm:faction_add_pooled_resource(faction:name(), self.pooled_resource_key, self.pooled_resource_factor_key, slaves_to_add)
					end
				end
			end
		end,
		true
	)
end

function rhox_valbrand_slaves:calculate_slaves(force)
	local value = 0

	if force:has_general() then
		local general = force:general_character()
		local region = general:region()

		if general:faction():name() ~= region:owning_faction():name() then
			local strength = force:strength()
			local gdp = region:gdp()
			local unit_count = force:unit_list():num_items()
			local faction = general:faction()
			local raiding_army_count = self:get_army_count_raiding_region(region, faction)
			
			-- split the gpd value between armies raiding the region
			gdp = gdp / raiding_army_count

			-- gpd*unit_count generates a nice base number for how much labour we'd want to get each turn, however the number is too high so /100 brings it down to the ranges we'd like while making it scale nicely with army size/region wealth.
			-- It felt bad sometimes having a 20 stack in a poor region and only getting 1-2 so I re-add the unit_count to the final value so that the min labour a 20 stack can get is 20, the min labour a 1 stack can get is 1.
			-- It also felt bad for a 20 stack of labourers to get the same raid value as a 20 stack of destroyers, so we then finally add strength/200000 on the end to provide a small amount of scaling based off unit choice.
			value = math.floor((gdp*unit_count/100)+unit_count+(strength/200000))
		end
	end

	return value
end

function rhox_valbrand_slaves:update_all_raiding_armies(faction_interface)
	-- we update all raiding armies each time in-case a new raiding army is raiding the same region as another
	local mf_list = faction_interface:military_force_list()

	for i =0, mf_list:num_items()- 1 do
		local mf = mf_list:item_at(i)

		if mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
			local slaves_to_add = self:calculate_slaves(mf)

			if faction_interface:is_human() then
				common.set_context_value("raiding_slaves_value_" .. mf:command_queue_index(), slaves_to_add)
			end
		else
			if faction_interface:is_human() then
				common.set_context_value("raiding_slaves_value_" .. mf:command_queue_index(), 0)
			end
		end
	end
end

function rhox_valbrand_slaves:get_army_count_raiding_region(region_interface, faction_interface)
	local army_count = 0
	local armies_in_region = region_interface:region_data_interface():characters_of_faction_in_region(faction_interface)

	for i = 0, armies_in_region:num_items() - 1 do
		local army = armies_in_region:item_at(i)

		if army:has_military_force() then
			local mf = army:military_force()

			if mf:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
				army_count = army_count + 1
			end
		end
	end

	return army_count
end

-----------------------------------spawning challenger army. because vanilla will break

function norscan_gods:rhox_lccp_valbrand_spawning(target_faction_key, chaos_god)
    local invasion_key = "invasion_"..target_faction_key.."_"..chaos_god
	local unit_list = self:create_challenger_force(chaos_god)


	local target_faction = cm:model():world():faction_by_key(target_faction_key)
	local target_faction_leader = target_faction:faction_leader()
	local target_faction_capital_key = "cr_combi_region_ihan_3_1"
	
	if cm:get_campaign_name() == "cr_oldworld" then
        target_faction_capital_key= cr_oldworld_region_monolith_of_valbrand_fireblade
	end

	local x,y
	local challenger_spawn_distance_min = cm:campaign_var_int_value(self.challenger_spawn_distance_min_key)
	local challenger_spawn_distance_max = cm:campaign_var_int_value(self.challenger_spawn_distance_max_key)
	local challenger_spawn_distance = cm:random_number(challenger_spawn_distance_max, challenger_spawn_distance_min)
	if target_faction_leader:is_null_interface() == false and target_faction_leader:has_military_force() == true and target_faction_leader:has_region() then
		x, y = cm:find_valid_spawn_location_for_character_from_character(target_faction_key, cm:char_lookup_str(target_faction_leader), false, challenger_spawn_distance)
	else
		x,y = cm:find_valid_spawn_location_for_character_from_settlement(target_faction_key, target_faction_capital_key, false, true, challenger_spawn_distance)
	end
	local coordinates = {x, y}	
	local challenger_invasion = invasion_manager:new_invasion(invasion_key, self.challenger_faction_prefix..chaos_god, unit_list, coordinates)

	if not cm:is_multiplayer() then
		if target_faction:is_null_interface() == false and target_faction:has_faction_leader() == true then
			if target_faction_leader:is_null_interface() == false and target_faction_leader:has_military_force() == true then
				local target_faction_leader_cqi = target_faction_leader:command_queue_index()
				challenger_invasion:set_target("CHARACTER", target_faction_leader_cqi, target_faction_key)
			else
				challenger_invasion:set_target("NONE", nil, target_faction_key)
			end
		end
		
		-- Add army XP based on difficulty in SP
		local difficulty = cm:model():difficulty_level()
		
		if difficulty == -1 then
			-- Hard
			challenger_invasion:add_unit_experience(1)
		elseif difficulty == -2 then
			-- Very Hard
			challenger_invasion:add_unit_experience(2)
		elseif difficulty == -3 then
			-- Legendary
			challenger_invasion:add_unit_experience(3)
		end
	end
	
	-- Set up the General
	local challenger_details = self.challenger_details
	challenger_invasion:create_general(false, challenger_details[chaos_god].agent_subtype, challenger_details[chaos_god].forename, challenger_details[chaos_god].clan_name, challenger_details[chaos_god].family_name, challenger_details[chaos_god].other_name)
	challenger_invasion:add_character_experience(30, true) -- Level 30
	challenger_invasion:apply_effect(challenger_details[chaos_god].effect_bundle, -1)
	challenger_invasion:start_invasion(true, true, false, false)
end



core:add_listener(
    "RhoxLCCPChampion_DilemmaChoiceMadeEvent_valbrand_reject",
    "DilemmaChoiceMadeEvent",
    function(context)
        return context:dilemma()== norscan_gods.dilemma_key_prefix.."hound" and context:faction():name()=="rhox_nor_firebrand_slavers" and context:choice() == 1
    end,
    function(context)
        out("Rhox Valbrand check 1")
        local faction_name = context:faction():name()
        local dilemma= context:dilemma()
        local choice = context:choice()
        
        for chaos_god, _ in dpairs(norscan_gods.rivalry_conversion_table) do
            norscan_gods:rhox_lccp_valbrand_spawning(faction_name, chaos_god)
        end
        norscan_gods:destroy_challenger_forces_mission(faction_name)
        out("Rhox Valbrand check 2")
    end,
    true
)