local zach_mission_key = "rhox_lccp_vmp_mission_confederate_lord_zach"

vampire_bloodlines.confederation_missions[zach_mission_key]={
			target_faction = "rhox_vmp_the_everliving",
			ritual_key = "rhox_lccp_vmp_ritual_confederate_lord_zach",
			lord_subtype = "hkrul_zach",
			limit_power_objective = true,
			payload = {
				"text_display dummy_confederate_lord_zach"
			},
			unique_objectives_config = {
				unit_count = 6,
				unit_rank = 7,
				unit_list = {
					"wh_main_vmp_inf_grave_guard_0",
					"wh_main_vmp_inf_grave_guard_1",
					"wh3_main_vmp_inf_grave_guard_2"
				},
				scripted_unit_key = "rhox_zach_vmp_scripted_zach_ranked_grave_guard_units",
				unit_override_text = "mission_text_text_rhox_lccp_vmp_zach_ranked_ethereal_units",

				book_count = 1,
				scripted_book_key = "rhox_zach_vmp_scripted_zach_collect_books_of_nagash",
				book_override_text = "mission_text_text_rhox_lccp_vmp_zach_collect_books_of_nagash",
			},

			add_unique_objectives = function(faction_key, mm, mission_data, mission_key)
				local objective_data = mission_data.unique_objectives_config

				local objectives = {
					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_unit_key,
						objective_data.unit_override_text,
						objective_data.unit_count,
						0,
						false
					),

					generate_SCRIPTED_MISSION_objective(
						objective_data.scripted_book_key,
						objective_data.book_override_text,
						objective_data.book_count,
						0,
						false
					),
				}

				vampire_bloodlines:add_non_scripted_objectives(mm, objectives)
			end,

			post_trigger_callback = function(faction_key, mission_data, mission_key)
				vampire_bloodlines:rhox_update_zach_confederation_objectives(faction_key)
			end
		}
vampire_bloodlines.confederation_rituals["rhox_lccp_vmp_ritual_confederate_lord_zach"]="rhox_vmp_the_everliving"

function vampire_bloodlines:rhox_update_zach_confederation_objectives(faction_key)
	local mission_data = self.confederation_missions[zach_mission_key]
	local objective_data = mission_data.unique_objectives_config
	local faction = cm:get_faction(faction_key)

	if not faction or faction:is_null_interface() then
		return
	end

	-- Vet units

	local units_completed_saved_value_key = faction_key .. "_zach_confederation_ranked_units_completed"
	local units_completed = cm:get_saved_value(units_completed_saved_value_key) or false

	if not units_completed then
		local current_unit_count = math.min(
			self:count_units_from_list_with_min_rank(
				faction,
				objective_data.unit_list,
				objective_data.unit_rank
			),
			objective_data.unit_count
		)

		cm:set_scripted_mission_text(
			zach_mission_key,
			objective_data.scripted_unit_key,
			objective_data.unit_override_text,
			current_unit_count,
			objective_data.unit_count
		)

		if current_unit_count >= objective_data.unit_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				zach_mission_key,
				objective_data.scripted_unit_key,
				true
			)

			cm:set_saved_value(units_completed_saved_value_key, true)
		end
	end

	-- Books of Nagash

	local books_completed_saved_value_key = faction_key .. "_zach_confederation_books_completed"
	local books_completed = cm:get_saved_value(books_completed_saved_value_key) or false

	if not books_completed and is_function(get_count_of_books_owned_by_faction) then
		local current_book_count = math.min(
			get_count_of_books_owned_by_faction(faction_key),
			objective_data.book_count
		)

		cm:set_scripted_mission_text(
			zach_mission_key,
			objective_data.scripted_book_key,
			objective_data.book_override_text,
			current_book_count,
			objective_data.book_count
		)

		if current_book_count >= objective_data.book_count then
			cm:complete_scripted_mission_objective(
				faction_key,
				zach_mission_key,
				objective_data.scripted_book_key,
				true
			)

			cm:set_saved_value(books_completed_saved_value_key, true)
		end
	end
end

local function is_valid_zach_confederation_faction(faction)
	local mission_data = vampire_bloodlines.confederation_missions[zach_mission_key]
	local target_faction = cm:get_faction(mission_data.target_faction)

	return faction
		and faction:is_null_interface() == false
		and faction:is_human()
		and faction:subculture() == "wh_main_sc_vmp_vampire_counts"
		and faction:name() ~= mission_data.target_faction
		and target_faction
		and target_faction:is_human() == false
end

-- Zach - Update when a unit gains experience
core:add_listener(
	"RhoxVampireBloodlinesZachRankedUnit",
	"UnitExperienceLevelChanged",
	function(context)
		local objective_data = vampire_bloodlines.confederation_missions[zach_mission_key].unique_objectives_config
		local unit = context:unit()

		return is_valid_zach_confederation_faction(unit:faction())
			and table.contains(objective_data.unit_list, unit:unit_key())
			and context:previous_level() < objective_data.unit_rank
			and unit:experience_level() >= objective_data.unit_rank
	end,
	function(context)
		vampire_bloodlines:rhox_update_zach_confederation_objectives(context:unit():faction():name())
	end,
	true
)

-- Zach - Update when a unit is created
core:add_listener(
	"RhoxVampireBloodlinesZachUnitCreated",
	"UnitCreated",
	function(context)
		local objective_data = vampire_bloodlines.confederation_missions[zach_mission_key].unique_objectives_config
		local unit = context:unit()

		return is_valid_zach_confederation_faction(unit:faction())
			and table.contains(objective_data.unit_list, unit:unit_key())
			and unit:experience_level() >= objective_data.unit_rank
	end,
	function(context)
		local faction_key = context:unit():faction():name()

		cm:callback(
			function()
				vampire_bloodlines:rhox_update_zach_confederation_objectives(faction_key)
			end,
			0.1
		)
	end,
	true
)

-- Zach - Update when the faction's Books of Nagash count changes
core:add_listener(
	"RhoxVampireBloodlinesZachBookOfNagashUpdated",
	"ScriptEventBookOfNagashUpdated",
	function(context)
		return is_valid_zach_confederation_faction(context:faction())
	end,
	function(context)
		vampire_bloodlines:rhox_update_zach_confederation_objectives(context:faction():name())
	end,
	true
)

-- Zach - Update after storing books in the capital via the non-participant dilemma (vanilla doesn't fire ScriptEventBookOfNagashUpdated here)
core:add_listener(
	"RhoxVampireBloodlinesZachBookDilemma",
	"DilemmaChoiceMadeEvent",
	function(context)
		return context:dilemma() == "wh3_dlc29_book_of_nagash_acquired_not_book_faction_1"
			and context:choice_key() == "SECOND"
			and is_valid_zach_confederation_faction(context:faction())
	end,
	function(context)
		local faction_key = context:faction():name()

		cm:callback(
			function()
				vampire_bloodlines:rhox_update_zach_confederation_objectives(faction_key)
			end,
			0.1
		)
	end,
	true
)

-- Zach - Fallback/state refresh
core:add_listener(
	"RhoxVampireBloodlinesZachTurnStartUpdate",
	"FactionTurnStart",
	function(context)
		return is_valid_zach_confederation_faction(context:faction())
	end,
	function(context)
		vampire_bloodlines:rhox_update_zach_confederation_objectives(context:faction():name())
	end,
	true
)




