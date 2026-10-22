local key_keepers_faction_key = "rhox_def_key_keepers"
local key_keepers_vigil_key = "rhox_key_keepers_vigil"

local key_keepers_incursion_faction = "wh3_main_rogue_kurgan_warband"
local key_keepers_incursion_threshold = 25 --at or below this, incursion may happen
local key_keepers_incursion_chance = 20 --percent per turn
local key_keepers_incursion_restore_value = 40
local key_keepers_defeat_vigil_loss = 5

local key_keepers_watch_towers={
	{region="wh3_main_combi_region_ashrak", factor="rhox_key_keepers_vigil_tower_ashrak"},
	{region="wh3_main_combi_region_dargoth", factor="rhox_key_keepers_vigil_tower_dargoth"},
	{region="wh3_main_combi_region_kauark", factor="rhox_key_keepers_vigil_tower_kauark"},
	{region="wh3_main_combi_region_nagrar", factor="rhox_key_keepers_vigil_tower_nagrar"},
	{region="wh3_main_combi_region_shagrath", factor="rhox_key_keepers_vigil_tower_shagrath"},
	{region="wh3_main_combi_region_ghrond", factor="rhox_key_keepers_vigil_tower_ghrond"},
}

random_army_manager:new_force("rhox_key_keepers_incursion")
random_army_manager:add_mandatory_unit("rhox_key_keepers_incursion", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_mandatory_unit("rhox_key_keepers_incursion", "wh_dlc08_nor_inf_marauder_hunters_1", 1)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_main_nor_inf_chaos_marauders_0", 4)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_main_nor_inf_chaos_marauders_1", 3)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_dlc08_nor_inf_marauder_berserkers_0", 2)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_main_chs_cav_marauder_horsemen_0", 2)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_main_nor_mon_chaos_warhounds_0", 2)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_main_nor_mon_chaos_trolls", 1)
random_army_manager:add_unit("rhox_key_keepers_incursion", "wh_main_chs_inf_chaos_warriors_0", 2)


local function rhox_key_keepers_update_vigil()
	for _, tower in ipairs(key_keepers_watch_towers) do
		local region = cm:get_region(tower.region)
		if region and region:is_abandoned() == false then
			local owner = region:owning_faction()
			if owner:name() == key_keepers_faction_key or owner:culture() ~= "wh2_main_def_dark_elves" then
				cm:faction_add_pooled_resource(key_keepers_faction_key, key_keepers_vigil_key, tower.factor, 1)
			elseif owner:culture() ~= "wh2_main_def_dark_elves" then
				cm:faction_add_pooled_resource(key_keepers_faction_key, key_keepers_vigil_key, tower.factor, -1)
			end
		end
	end
end

local function rhox_key_keepers_get_incursion_army_size()
	local turn = cm:turn_number()
	if turn <= 30 then
		return 8
	elseif turn <= 60 then
		return 12
	end
	return 16
end

local function rhox_key_keepers_spawn_incursion(faction)
	local tower = key_keepers_watch_towers[cm:random_number(#key_keepers_watch_towers)]
	local region = cm:get_region(tower.region)
	if not region then
		return
	end
	local settlement = region:settlement()
	local x, y = cm:find_valid_spawn_location_for_character_from_position(key_keepers_incursion_faction, settlement:logical_position_x(), settlement:logical_position_y(), false, 8)
	if x == -1 then
		return
	end

	local force_list = random_army_manager:generate_force("rhox_key_keepers_incursion", rhox_key_keepers_get_incursion_army_size(), false)

	cm:create_force_with_general(
		key_keepers_incursion_faction,
		force_list,
		tower.region,
		x,
		y,
		"general",
		"wh_main_nor_marauder_chieftain",
		"",
		"",
		"",
		"",
		false,
		function(cqi)
			cm:apply_effect_bundle_to_characters_force("wh_main_bundle_military_upkeep_free_force", cqi, 0)
			local general = cm:get_character_by_cqi(cqi)
			local invasion = invasion_manager:new_invasion_from_existing_force("rhox_key_keepers_incursion_"..cqi, general:military_force())

			if region:is_abandoned() == false and region:owning_faction():name() == key_keepers_faction_key then
				invasion:set_target("REGION", tower.region, key_keepers_faction_key)
			else
				local coords = {{x = x, y = y},{x = x, y = y}}
				invasion:set_target("PATROL", coords, nil)
				invasion:add_aggro_radius(10)
			end
			invasion:start_invasion(nil, true, false, false)
		end
	)

	if faction:is_human() then
		cm:show_message_event_located(
			key_keepers_faction_key,
			"event_feed_strings_text_rhox_key_keepers_incursion_title",
			"event_feed_strings_text_rhox_key_keepers_incursion_primary_detail",
			"event_feed_strings_text_rhox_key_keepers_incursion_secondary_detail",
			x,
			y,
			false,
			711
		)
	end
end

local function rhox_key_keepers_check_incursion(faction)
	local vigil = faction:pooled_resource_manager():resource(key_keepers_vigil_key):value()
	if vigil > key_keepers_incursion_threshold or not cm:model():random_percent(key_keepers_incursion_chance) then
		return
	end

	cm:faction_add_pooled_resource(key_keepers_faction_key, key_keepers_vigil_key, "rhox_key_keepers_vigil_incursion", key_keepers_incursion_restore_value - vigil)
	rhox_key_keepers_spawn_incursion(faction)
end


cm:add_first_tick_callback(
	function()
		if cm:get_local_faction_name(true) == key_keepers_faction_key then
			local parent_ui = find_uicomponent(core:get_ui_root(), "hud_campaign", "resources_bar_holder", "resources_bar")
			core:get_or_create_component("rhox_key_keepers_vigil_bar", "ui/campaign ui/rhox_keep_keeper_guage.twui.xml", parent_ui)
		end

		core:add_listener(
			"rhox_key_keepers_vigil_watch_towers",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == key_keepers_faction_key
			end,
			function(context)
				rhox_key_keepers_update_vigil()
				rhox_key_keepers_check_incursion(context:faction())
			end,
			true
		)

		core:add_listener(
			"rhox_key_keepers_vigil_defeat",
			"BattleCompleted",
			function()
				return cm:model():pending_battle():has_been_fought() and cm:pending_battle_cache_faction_lost_battle(key_keepers_faction_key)
			end,
			function()
				cm:faction_add_pooled_resource(key_keepers_faction_key, key_keepers_vigil_key, "rhox_key_keepers_vigil_defeats", -key_keepers_defeat_vigil_loss)
			end,
			true
		)
	end
)
