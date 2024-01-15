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
local rhox_norsca_region_to_tech= {
    wh3_main_combi_region_naggarond =  "wh_dlc08_tech_nor_nw_03",
    wh3_main_combi_region_lothern =   "wh_dlc08_tech_nor_nw_05",
    wh3_main_combi_region_hexoatl =   "wh_dlc08_tech_nor_nw_07",
    wh3_main_combi_region_skavenblight =  "wh_dlc08_tech_nor_nw_09",
    wh3_main_combi_region_khemri = "wh_dlc08_tech_nor_nw_11",
    wh3_main_combi_region_the_awakening = "wh_dlc08_tech_nor_nw_21",
    wh3_main_combi_region_couronne =  "wh_dlc08_tech_nor_other_08",
    wh3_main_combi_region_miragliano = "wh_dlc08_tech_nor_other_10",
    wh3_main_combi_region_karaz_a_karak =  "wh_dlc08_tech_nor_other_12",
    wh3_main_combi_region_altdorf = "wh_dlc08_tech_nor_other_15",
    wh3_main_combi_region_castle_drakenhof =  "wh_dlc08_tech_nor_other_17",
    wh3_main_combi_region_black_crag =  "wh_dlc08_tech_nor_other_19",
    wh3_main_combi_region_great_hall_of_greasus = "wh3_main_ie_tech_nor_darklands_ogre_kingdoms_capital",
    wh3_main_combi_region_the_oak_of_ages = "wh_dlc08_tech_nor_other_21",
    wh3_main_combi_region_zharr_naggrund = "wh3_main_ie_tech_nor_darklands_chaos_dwarfs_capital",
    wh3_main_combi_region_kislev = "wh3_main_ie_tech_nor_oldworld_kislev_capital",
    wh3_main_chaos_region_kislev = "wh3_main_ie_tech_nor_oldworld_kislev_capital",
    wh3_main_combi_region_wei_jin =  "wh3_main_ie_tech_nor_darklands_cathay_capital"
}




core:add_listener(
    "rhox_valbrand_tech_check",
    "CharacterPerformsSettlementOccupationDecision",
    function(context)
        local region_key = context:garrison_residence():region():name()
        return context:occupation_decision() == "1963655228" and context:character():faction():name() == "rhox_nor_firebrand_slavers" and rhox_norsca_region_to_tech[region_key]--raze for hound
    end,
    function(context) 
        local region_key = context:garrison_residence():region():name()
        local tech_key = rhox_norsca_region_to_tech[region_key]
        cm:unlock_technology(context:character():faction():name(), tech_key)
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
