LenkBeastHunts = {
	lenk_faction_key = "cr_nor_tokmars",
	underway_cultures = {["wh_main_grn_greenskins"] = true,["wh_main_dwf_dwarfs"] = true,["wh2_main_skv_skaven"] = true},
	occupation_do_nothing = "occupation_decision_do_nothing", -- Since even 'doing nothing' on a razed settlement counts as a settlement option, we need to exclude this option when rewarding beasts.
	settlements_beast_raided_this_turn = {},	-- Cache of the keys of all settlements from which beasts have been earned this turn. Used to avoid double-dipping for beasts by sacking and then razing.
	lenk_skill_key="hkrul_vroth_special_1_4",
	----variables
	lenk_skill_bonus_chance = 15,
	bad_luck_modifier_increment = 10,-- bad luck modifier for a specific incident goes up by this value every time an incident is not generated
	bad_luck_modifiers = {["raiding"] = 100, ["settlement_occupation"] = 100 , ["post_battle"] = 100}, --- these are set to 100 so the first time you do each in a campaign it's a guaranteed succss
	bad_luck_modifier_max = 30, -- bad luck modifier cannot exceed this value
	bad_luck_modifier_min = -100, -- bad luck modifier cannot go below this value
	bad_luck_modifier_soft_min = 0, -- bad luck modifier will correct to this value at start of turn if below this
	streak_prevention_value = -75, -- amount the bad luck modifier for a specific incident type goes down to following a successful roll
	chaos_corruption_min_threshold = 20, -- The percentage of corruption at which dice rolls for chaos beasts begin when raiding
	chaos_corruption_max_threshold = 80, -- The percentage of corruption after which only chaos beasts can be obtained via raiding
	chaos_corruption_increased_luck = 25,	-- The increased chance of getting a monster gained when raiding in a fully-chaotic province.
	chaos_corruption_types = {
		"wh3_main_corruption_chaos",
		"wh3_main_corruption_khorne",
		"wh3_main_corruption_nurgle",
		"wh3_main_corruption_slaanesh",
		"wh3_main_corruption_tzeentch",
	},	-- Types of corruption considered to increase the likelihood of chaos monsters (Manticores)
	province_capital_modifier = 10, -- for settlement occupation events, apply this bonus to roll if province capital

	lenk_incident_key = "rhox_tokmar_captured_beast",
	lenk_incidents =
	{
		raiding = {
			climate_mountain =
			{
				{ unit_key = "wh2_main_def_mon_war_hydra", amount =1, chance = 20},
				{ unit_key = "wh3_main_ogr_mon_sabretusk_pack_0", amount =2, chance = 30},
			},
			climate_temperate =
			{
				{ unit_key = "rhox_lenk_nor_mon_warwolves_0", amount =2, chance = 25},
				{ unit_key = "wh3_main_monster_feral_bears", amount =2, chance = 25},
			},
			climate_island =
			{
				{ unit_key = "wh2_main_def_inf_harpies", amount =2, chance = 50},
			},
			climate_frozen =
			{
				{ unit_key = "wh3_main_monster_feral_ice_bears", amount =1, chance = 35},
			},
			climate_desert =
			{
				{ unit_key = "wh2_twa03_grn_mon_wyvern_0", amount =1, chance = 35},
			},
			climate_jungle =
			{
				{ unit_key = "wh2_main_lzd_mon_stegadon_0", amount =1, chance = 20},
				{ unit_key = "wh2_main_lzd_cav_cold_ones_feral_0", amount =2, chance = 30}
			},
			climate_savannah =
			{
				{ unit_key = "wh2_main_lzd_cav_cold_ones_feral_0", amount =2, chance = 50},
			},
			climate_wasteland =
			{
				{ unit_key = "wh_twa03_def_inf_squig_explosive_0", amount =3, chance = 30},
				{ unit_key = "wh2_twa03_grn_mon_wyvern_0", amount =1, chance = 20},
			},
			climate_chaotic =
			{
				{ unit_key = "rhox_lenk_nor_feral_manticore", amount =1, chance = 50},
			},
			chaos_corrupted =
			{
				{ unit_key = "rhox_lenk_nor_feral_manticore", amount =1, chance = 30},
			},
			climate_magicforest =
			{
				{ unit_key = "wh2_dlc16_wef_mon_giant_spiders_0", amount =2, chance = 50},
			},
		},
		settlement_occupation = {
			wh2_main_hef_high_elves =
			{
				{ unit_key = "wh2_main_def_mon_black_dragon", amount =1, chance = 10}
			},
			wh2_main_def_dark_elves =
			{
				{ unit_key = "wh2_main_def_mon_black_dragon", amount =1, chance = 10},
				{ unit_key = "wh2_dlc14_def_mon_bloodwrack_medusa_0", amount =2, chance = 15, dlc = "TW_WH2_DLC14_SHADOW"}
			},
			wh_main_grn_greenskins =
			{
				{ unit_key = "wh_twa03_def_inf_squig_explosive_0", amount =3, chance = 10},
				{ unit_key = "wh2_twa03_grn_mon_wyvern_0", amount =1, chance = 15}
			},
			wh2_main_lzd_lizardmen =
			{
				{ unit_key = "wh2_main_lzd_mon_carnosaur_0", amount =1, chance = 15},
				{ unit_key = "wh2_main_lzd_mon_stegadon_0", amount =1, chance = 10},
			},
			wh_dlc08_nor_norsca =
			{
				{ unit_key = "rhox_lenk_nor_mon_war_mammoth_0", amount =1, chance = 15},
				{ unit_key = "rhox_lenk_nor_mon_warwolves_0", amount =2, chance = 10}
			},
			wh3_main_ksl_kislev =
			{
				{ unit_key = "wh3_main_monster_feral_bears", amount =1, chance = 10},
				{ unit_key = "wh3_main_monster_feral_ice_bears", amount =2, chance = 15}
			},
			wh_dlc05_wef_wood_elves =
			{
				{ unit_key = "wh2_dlc16_wef_mon_giant_spiders_0", amount =2, chance = 30},
			},
			wh3_main_ogr_ogre_kingdoms =
			{
				{ unit_key = "wh3_main_ogr_mon_sabretusk_pack_0", amount =2, chance = 30},
			},
			wh_main_chs_chaos =
			{
				{ unit_key = "rhox_lenk_nor_feral_manticore", amount =1, chance = 25},
			}
		},
		post_battle = {
			naval =
			{
				{ unit_key = "wh2_dlc10_def_mon_kharibdyss_0", amount =1, chance = 10, dlc = "TW_WH2_DLC10_QUEEN_CRONE"},
				{ unit_key = "wh2_main_def_inf_harpies", amount =1, chance = 20},
			},
			underway =
			{
				{ unit_key = "wh_twa03_def_inf_squig_explosive_0", amount =1, chance = 30},
				{ unit_key = "wh2_dlc16_wef_mon_giant_spiders_0", amount =2, chance = 30},
			},
			land =
			{
				{ unit_key = "wh2_main_def_inf_harpies", amount =2, chance = 15},
			},
		},
	},

	ai_unit_per_turn_sum_chance = 75,	-- The chance of AI Lenk getting any replenishment each turn. All beast-specific replenishment rates are downscaled or upscaled to match this. Increase it for more beasts for AI Lenk.
	ai_units ={
		---unit_key, recruitment_source_key, starting amount, replen chance (scaled to sum), max in pool, merc unit group
		{"wh2_main_def_mon_black_dragon", "monster_pen", 			0, 1, 1,		"wh2_twa03_black_dragon"},
		{"wh2_main_lzd_cav_cold_ones_feral_0", "monster_pen", 		2, 15, 3,		"wh2_twa03_cold_ones"},
		{"rhox_lenk_nor_mon_warwolves_0", "monster_pen", 				2, 15, 3,	"rhox_lenk_nor_mon_warwolves_0"},
		{"wh2_main_lzd_mon_stegadon_0", "monster_pen", 				0, 3, 2,		"wh2_twa03_feral_stegadon"},
		{"wh2_main_def_inf_harpies", "monster_pen", 				2, 15, 5,		"wh2_twa03_inf_harpies"},
		{"wh2_dlc14_def_mon_bloodwrack_medusa_0", "monster_pen", 	0, 2, 1,		"wh2_twa03_mon_bloodwrack_medusa_0"},
		{"wh2_main_lzd_mon_carnosaur_0", "monster_pen", 			0, 2, 1,		"wh2_twa03_mon_carnosaur_0"},
		{"rhox_lenk_nor_feral_manticore", "monster_pen", 		0, 5, 2,		"rhox_lenk_nor_feral_manticore"},
		{"wh2_dlc10_def_mon_kharibdyss_0", "monster_pen", 			0, 2, 1,		"wh2_twa03_mon_kharibdyss_0"},
		{"rhox_lenk_nor_mon_war_mammoth_0", "monster_pen", 			0, 2, 1,		"rhox_lenk_nor_mon_war_mammoth_0"},
		{"wh2_main_def_mon_war_hydra", "monster_pen", 				0, 3, 1,		"wh2_twa03_mon_war_hydra"},
		{"wh_twa03_def_inf_squig_explosive_0", "monster_pen", 		0, 10, 3,		"wh2_twa03_squig_explosive"},
		{"wh3_main_monster_feral_bears", "monster_pen", 			0, 15, 2,		"wh2_twa03_mon_monster_feral_bear"},
		{"wh3_main_monster_feral_ice_bears", "monster_pen", 		0, 5, 2,		"wh2_twa03_mon_monster_feral_ice_bear"},
		{"wh2_dlc16_wef_mon_giant_spiders_0", "monster_pen", 		0, 10, 2,		"wh2_twa03_mon_monster_giant_spider"},
		{"wh3_main_ogr_mon_sabretusk_pack_0", "monster_pen", 		0, 10, 2,		"wh2_twa03_mon_monster_sabretusk"},
		{"wh2_twa03_grn_mon_wyvern_0", "monster_pen", 				0, 2, 1,		"wh2_twa03_mon_monster_feral_wyvern"},
	},

	incident_count = 0
}
-----------------
----FUNCTIONS----
-----------------

--LISTENER SETUP--

function LenkBeastHunts:setup_lenk_listeners()
	local lenk_interface =  cm:get_faction(self.lenk_faction_key)
	if lenk_interface ~= false then 
		if lenk_interface:is_human() then
			self:setup_clear_raided_settlements_listener()
			self:setup_settlement_occupation_listener()
			self:setup_post_battle_listener()
			self:setup_raiding_listener()

			cm:add_faction_turn_start_listener_by_name(
				"rhox_lenk_monster_pen_update",
				self.lenk_faction_key,
				function()
					for k, v in pairs(self.bad_luck_modifiers) do
						if v < self.bad_luck_modifier_soft_min then
							self.bad_luck_modifiers[k] = self.bad_luck_modifier_soft_min
						end
					end
				end,
				true)

		elseif cm:is_new_game() then
			self:setup_ai_merc_pool()
		end
	end
end


function LenkBeastHunts:setup_clear_raided_settlements_listener()
	cm:add_faction_turn_start_listener_by_name(
		"RhoxLenkFactionClearRaidedSettlements",
		self.lenk_faction_key,
		function(context)
			self.settlements_beast_raided_this_turn = {}
		end,
		true
	)
end

function LenkBeastHunts:setup_settlement_occupation_listener()
	core:add_listener(
		"RhoxLenkFactionCharacterPerformsSettlementOccupationDecision",
		"CharacterPerformsSettlementOccupationDecision",
		function(context)
			local settlement_option = context:settlement_option()
			if not self:is_char_lenk_general_with_army(context:character()) or context:occupation_decision() == self.occupation_do_nothing then
				return false
			end

			local has_already_been_sacked = false

			if has_already_been_sacked then
				return false
			end

			return true
		end,
		function(context)
			local previous_owner_culture = context:previous_owner_culture()

			if previous_owner_culture == nil or self.lenk_incidents.settlement_occupation[previous_owner_culture] == nil then
				return false
			end

			local event_type = "settlement_occupation"
			local garrison_residence = context:garrison_residence()
			local modifiers = self.bad_luck_modifiers[event_type]
			local character_rank = context:character():rank()

			modifiers = modifiers + character_rank

			if context:character():has_skill(LenkBeastHunts.lenk_skill_key) then
				modifiers = modifiers + LenkBeastHunts.lenk_skill_bonus_chance
			end

			if LenkBeastHunts:is_occupied_residence_province_capital(garrison_residence) then
				modifiers = modifiers + LenkBeastHunts.province_capital_modifier
			end

			self:generate_beast_incident(event_type, previous_owner_culture, modifiers, context:character():command_queue_index(), context:garrison_residence():settlement_interface():key())
		end,
		true
	)
end

function LenkBeastHunts:setup_post_battle_listener()
	core:add_listener(
		"RhoxLenkFactionCharacterCompletedBattle",
		"CharacterCompletedBattle",
		function(context)
			if not context:pending_battle():has_contested_garrison() and self:is_char_lenk_general_with_army(context:character()) and self:lenk_faction_won_battle(context:pending_battle()) then
				return true
			end
		end,
		function(context)
			local pending_battle = context:pending_battle()
			local character = context:character()
			local casualty_coefficient = self:get_casualty_coefficient(pending_battle)
			local event_type = "post_battle"
			local beast_incident_generated = false
			local battle_type = "land"
			local character_rank = context:character():rank()
			if context:character():has_skill(LenkBeastHunts.lenk_skill_key) then
				modifiers = modifiers + LenkBeastHunts.lenk_skill_bonus_chance
			end

			local modifiers = self.bad_luck_modifiers[event_type] + (casualty_coefficient*50)
			modifiers = modifiers + character_rank

		
			if self:is_character_at_sea(character) then
				battle_type = "naval"
			elseif self:is_underway_battle(pending_battle) then
				battle_type = "underway"
			end
			
			beast_incident_generated = self:generate_beast_incident(event_type, battle_type, modifiers, character:command_queue_index())
		
			---if you didn't get a beast from the first roll, give a bonus roll if you choose to slaughter.
			if not beast_incident_generated then
				LenkBeastHunts:setup_slaughter_listener(battle_type, modifiers)
			end

		end,
		true
	)
end

function LenkBeastHunts:setup_raiding_listener()
	core:add_listener(
		"RhoxLenkFactionCharacterTurnStart",
		"CharacterTurnStart",
		function(context)
			local character = context:character()
			return self:is_char_lenk_general_with_army(character) and self:character_is_raiding(character)
		end,
		function(context)
			local character = context:character()
			local climate_key = self:get_local_climate_from_character(character)
			local corruption_type, chaos_corruption = cm:get_highest_corruption_in_region(character:region(), self.chaos_corruption_types)
			local event_type = "raiding"
			local modifiers = self.bad_luck_modifiers[event_type]
			local character_rank = context:character():rank()

			modifiers = modifiers + character_rank
			if context:character():has_skill(LenkBeastHunts.lenk_skill_key) then
				modifiers = modifiers + LenkBeastHunts.lenk_skill_bonus_chance
			end

			local corrupted_incident = false
			local corruption_factor = 0

			if chaos_corruption > self.chaos_corruption_min_threshold then
				-- There's a level of chaos corruption above which only chaos beasts can be captured in a province.
				corruption_factor = math.min((chaos_corruption - self.chaos_corruption_min_threshold) / (self.chaos_corruption_max_threshold - self.chaos_corruption_min_threshold) * 100, 100)
				corrupted_incident = cm:random_number() < corruption_factor
			end

			if corrupted_incident then
				-- The chance of getting a chaos beast in itself also increases as the level of corruption increases.
				self:generate_beast_incident(event_type, "chaos_corrupted", modifiers + (corruption_factor * self.chaos_corruption_increased_luck / 100), character:command_queue_index())
			elseif self:is_relevant_climate(climate_key) then
				self:generate_beast_incident(event_type, climate_key, modifiers, character:command_queue_index())
			end
		end,
		true
	)
end



function LenkBeastHunts:setup_slaughter_listener(battle_type, luck_modifier)
	core:add_listener(
		"RhoxLenkFactionCharacterPostBattleSlaughter",
		"CharacterPostBattleSlaughter",
		true,
		function(context)
			local event_type = "post_battle"
			self:generate_beast_incident(event_type, battle_type, luck_modifier, context:character():command_queue_index())
			core:remove_listener("RhoxLenkFactionCharacterPostBattleEnslave")
			core:remove_listener("RhoxLenkFactionCharacterPostBattleRelease")
		end,
		false
	)

	--we also need to set up listeners for the other choices so that we can remove the slaughter one if it's not chosen
	core:add_listener(
		"RhoxLenkFactionCharacterPostBattleEnslave",
		"CharacterPostBattleEnslave",
		true,
		function()
			core:remove_listener("RhoxLenkFactionCharacterPostBattleSlaughter")
			core:remove_listener("RhoxLenkFactionCharacterPostBattleRelease")
		end,
		false
	)

	core:add_listener(
		"RhoxLenkFactionCharacterPostBattleRelease",
		"CharacterPostBattleRelease",
		true,
		function()
			core:remove_listener("RhoxLenkFactionCharacterPostBattleEnslave")
			core:remove_listener("RhoxLenkFactionCharacterPostBattleSlaughter")
		end,
		false
	)

end

-- Get a random incident from the given event type and context, usiong the incidents' 'chance' value for weighted randomness.
-- A 'reduce chance of getting nothing' number can be argued. If 100, the chance of getting nothing is reduced by 100%, and you're guaranteed to get an incident.
function LenkBeastHunts:get_weighted_random_outcome(event_type, event_context, reduce_chance_of_getting_nothing_by)
	local reduce_chance_of_getting_nothing_by = math.min(reduce_chance_of_getting_nothing_by, 100)

	local error_signature = string.format("beast-hunt incident pool ('%s', '%s')", event_type, event_context)
	if self.lenk_incidents[event_type] == nil or self.lenk_incidents[event_type][event_context] == nil then
		script_error(string.format("ERROR: Could not get weighted random beast-hunt outcome for '%s'. No such beast-pool with this type or context has been defined.",
			error_signature))
		return nil
	end
	local beast_incident_pool = self.lenk_incidents[event_type][event_context]

	local sum_chance = 0
	local disallowed_incidents = {}
	for _, value in ipairs(beast_incident_pool) do
		if value.dlc ~= nil and not cm:faction_has_dlc_or_is_ai(value.dlc, self.lenk_faction_key) then
			disallowed_incidents[value.unit_key] = true
		else
			sum_chance = sum_chance + value.chance
		end
	end
	if sum_chance > 100 then
		script_error(string.format("ERROR: '%s' has a chance sum greater than 100. The chances of each incident should add up to 100 or less (in which case the remainder is the chance that nothing happens).",
			error_signature))
		return nil
	end

	-- Say we have one option at 40% probability, the next at 40%, and the remaining 20% is 'nothing'.
	-- If you argue 50 as the reduce_chance_of_getting_nothing_by, the chance for 'nothing' is effectively reduced from 20 to 10.
	-- If you argue 100 as the reduce_chance_of_getting_nothing_by, the 20% chance to get nothing is removed entirely.
	local chance_of_getting_nothing = math.floor((100 - sum_chance) * (100 - reduce_chance_of_getting_nothing_by) / 100)
	local rand = cm:random_number(sum_chance + chance_of_getting_nothing)

	local cumulative_chance = 0
	local selected_incident = nil
	local selected_amount = nil
	for _, value in ipairs(beast_incident_pool) do
		if disallowed_incidents[value.unit_key] == nil then
			cumulative_chance = cumulative_chance + value.chance
			if rand <= cumulative_chance then
				selected_incident = value.unit_key
				selected_amount = value.amount
				break
			end
		end
	end
	return selected_incident, selected_amount
end

---CORE FUNCTIONS

function LenkBeastHunts:generate_beast_incident(event_type, event_context, chance_mod, acting_character_cqi, settlement)
	-- Disallow getting beasts from the same settlement twice per turn (helps avoid double-dipping by sacking then razing)
	if settlement ~= nil and self.settlements_beast_raided_this_turn[settlement] then
		return false
	end

	local unit_key, amount = self:get_weighted_random_outcome(event_type, event_context, chance_mod)
	local cqi_for_incident = 0

	if is_number(acting_character_cqi) then
		cqi_for_incident = acting_character_cqi
	end

	if unit_key and amount then
		self.incident_count = self.incident_count + 1


		local incident_builder = cm:create_incident_builder(self.lenk_incident_key)
		incident_builder:add_target("default", cm:get_character_by_cqi(cqi_for_incident))
		local payload_builder = cm:create_payload()
		payload_builder:add_mercenary_to_faction_pool(unit_key, amount)  
		incident_builder:set_payload(payload_builder)
		cm:launch_custom_incident_from_builder(incident_builder, cm:get_faction(self.lenk_faction_key))

		if settlement ~= nil then
			self.settlements_beast_raided_this_turn[settlement] = true
		end

		beast_incident_generated = true
	end

	if unit_key == nil then
		if self.bad_luck_modifiers[event_type] < self.bad_luck_modifier_max then
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifiers[event_type] + self.bad_luck_modifier_increment
		else
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifier_max
		end
	else
		if self.bad_luck_modifiers[event_type] >= self.bad_luck_modifier_min then
			if self.bad_luck_modifiers[event_type] > self.bad_luck_modifier_max then 
				self.bad_luck_modifiers[event_type] = self.bad_luck_modifier_max
			end
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifiers[event_type] + self.streak_prevention_value
		else
			self.bad_luck_modifiers[event_type] = self.bad_luck_modifier_min 
		end
	end

	return beast_incident_generated
end

--- for the AI, we simply overwrite the merc pool setup with one that fills up automatically via code

function LenkBeastHunts:setup_ai_merc_pool()
	local lenk_interface = cm:get_faction(self.lenk_faction_key)
	local sum_chances = 0
	for i, v in pairs(self.ai_units) do
		sum_chances = sum_chances + v[4]
	end

	-- If the desired AI replenish rate is 75% chance of getting a beast each turn, but the sum chances are 100, then 100 / 75 = 0.75, so all chances are downscaled by this.
	local ai_chance_scale = sum_chances / self.ai_unit_per_turn_sum_chance

	for i, v in pairs(self.ai_units) do
		cm:add_unit_to_faction_mercenary_pool(
			lenk_interface,
			v[1], -- key
			v[2], -- recruitment source
			v[3], -- count
			v[4] * ai_chance_scale, --replen chance
			v[5], -- max units
			1, -- max per turn
			"",
			"",
			"",
			false,
			v[6] -- merc unit group
		)
	end	
end

--- QUERY FUNCTIONS

function LenkBeastHunts:is_char_lenk_general_with_army(character)
	if character:is_null_interface() then
		script_error("Function LenkBeastHunts:is_char_lenk_general_with_army() called without valid character interface")
		return false
	elseif not cm:char_is_mobile_general_with_army(character) then
		return false
	else 
		return character:faction():name() == self.lenk_faction_key
	end
end

function LenkBeastHunts:get_local_climate_from_character(character)

	local region_interface

	if character:is_null_interface() then
		script_error("Function LenkBeastHunts:get_local_climate_from_character() called without valid character interface")
		return false
	elseif not character:has_region() then
		script_error("Function LenkBeastHunts:get_local_climate_from_character() called for a character without a region")
		return false
	else 
		region_interface = character:region()
	end

	local settlement = region_interface:settlement()

	if not settlement:is_null_interface() then
		return settlement:get_climate()
	else 
		return false
	end
end

function LenkBeastHunts:is_relevant_climate(climate_key)
	if climate_key == false then
		return false
	elseif not is_string(climate_key) then
		script_error("Function LenkBeastHunts:is_relevant_climate() is trying to pass a climate key that is not false or a string")
		return false
	end

	local relevant_climates_table = self.lenk_incidents["raiding"]

	if relevant_climates_table[climate_key] == nil then 
		return false
	else
		return true
	end
end

function LenkBeastHunts:is_underway_battle(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function LenkBeastHunts:is_underway_battle() called without valid pending battle interface")
		return false
	end

	if not cm:pending_battle_cache_faction_is_attacker(self.lenk_faction_key) then
		return false
	end

	local num_defenders = cm:pending_battle_cache_num_defenders()

	for i =1, num_defenders do
		local char_cqi, mf_cqi, faction_name = cm:pending_battle_cache_get_defender(i)
		local force_interface = cm:get_military_force_by_cqi(mf_cqi)
		if force_interface:active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_TUNNELING" then
			local defender_culture = cm:get_faction(faction_name):culture()
			if self.underway_cultures[defender_culture] then
				return true
			end
		end
	end


	return false
end

function LenkBeastHunts:is_character_at_sea(character)
	if character:is_null_interface() then
		script_error("Function LenkBeastHunts:is_character_at_sea() called without valid character")
		return false
	else
		return character:is_at_sea()
	end
end

function LenkBeastHunts:get_casualty_coefficient(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function LenkBeastHunts:get_casualty_coefficient() called without valid pending battle interrface")
		return false
	end
	local attacker_value = cm:pending_battle_cache_attacker_value()
	local defender_value = cm:pending_battle_cache_defender_value()

	local overall_value = attacker_value + defender_value

	local attacker_ratio = attacker_value/overall_value
	local defender_ratio = 1 - attacker_ratio

	local defender_casualties = pending_battle:percentage_of_defender_killed()
	local attacker_casualties = pending_battle:percentage_of_attacker_killed()

	local weighted_attacker_casualties = attacker_ratio*attacker_casualties
	local weighted_defender_casualties = defender_ratio*defender_casualties

	local total_casualties = weighted_attacker_casualties + weighted_defender_casualties

	return  tonumber(string.format("%." .. 2 .. "f", total_casualties))
end

function LenkBeastHunts:is_occupied_residence_province_capital(garrison_residence)
	local settlement = garrison_residence:settlement_interface()
	if settlement:is_null_interface() then
		script_error("Function LenkBeastHunts:is_occupied_residence_province_capital() called without valid settlement")
		return false
	end
	return settlement:region():is_province_capital()

end

function LenkBeastHunts:character_is_raiding(character)
	if character:is_null_interface() then
		script_error("Function LenkBeastHunts:character_is_raiding() called without valid character")
		return false

	elseif not character:has_military_force() then
		return false

	elseif character:military_force():active_stance() == "MILITARY_FORCE_ACTIVE_STANCE_TYPE_LAND_RAID" then
		return true

	else 
		return false

	end
end

function LenkBeastHunts:lenk_faction_won_battle(pending_battle)
	if pending_battle:is_null_interface() then
		script_error("Function LenkBeastHunts:lenk_faction_won_battle() called without valid pending battle interrface")
		return false
	end

	local winner_faction_key = ""

	if pending_battle:has_attacker() then
		local attacker_faction_key = pending_battle:attacker():faction():name()
		if pending_battle:attacker():won_battle() then
			winner_faction_key = attacker_faction_key
		end
	end

	if pending_battle:has_defender() then
		local defender_faction_key = pending_battle:defender():faction():name()
		if pending_battle:defender():won_battle() then
			winner_faction_key = defender_faction_key
		end
	end

	if winner_faction_key == self.lenk_faction_key then
		return true
	else
		return false
	end
end

----save/load

cm:add_saving_game_callback(
	function(context)
		cm:save_named_value("RhoxLenkBadLuckModifiers", LenkBeastHunts.bad_luck_modifiers, context)
		cm:save_named_value("RhoxLenkIncidentCount", LenkBeastHunts.incident_count, context)
		cm:save_named_value("RhoxLenkSettlementsBeastRaidedThisTurn", LenkBeastHunts.settlements_beast_raided_this_turn, context)
	end
)
cm:add_loading_game_callback(
	function(context)
		if not cm:is_new_game() then
			LenkBeastHunts.bad_luck_modifiers = cm:load_named_value("RhoxLenkBadLuckModifiers", LenkBeastHunts.bad_luck_modifiers, context)
			LenkBeastHunts.incident_count = cm:load_named_value("RhoxLenkIncidentCount", LenkBeastHunts.incident_count, context)
			LenkBeastHunts.settlements_beast_raided_this_turn = cm:load_named_value("RhoxLenkSettlementsBeastRaidedThisTurn", LenkBeastHunts.settlements_beast_raided_this_turn, context)
		end
	end
)