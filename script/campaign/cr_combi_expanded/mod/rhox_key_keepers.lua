local key_keepers_faction_key = "rhox_def_key_keepers"

local key_keepers_watch_towers={
	{region="wh3_main_combi_region_ashrak", factor="rhox_key_keepers_vigil_tower_ashrak"},
	{region="wh3_main_combi_region_dargoth", factor="rhox_key_keepers_vigil_tower_dargoth"},
	{region="wh3_main_combi_region_kauark", factor="rhox_key_keepers_vigil_tower_kauark"},
	{region="wh3_main_combi_region_nagrar", factor="rhox_key_keepers_vigil_tower_nagrar"},
	{region="wh3_main_combi_region_shagrath", factor="rhox_key_keepers_vigil_tower_shagrath"},
	{region="wh3_main_combi_region_ghrond", factor="rhox_key_keepers_vigil_tower_ghrond"},
}

local function rhox_key_keepers_update_vigil()
	for _, tower in ipairs(key_keepers_watch_towers) do
		local region = cm:get_region(tower.region)
		if region and region:is_abandoned() == false then
			local owner = region:owning_faction()
			if owner:name() == key_keepers_faction_key then
				cm:faction_add_pooled_resource(key_keepers_faction_key, "rhox_key_keepers_vigil", tower.factor, 1)
			elseif owner:culture() ~= "wh2_main_def_dark_elves" then
				cm:faction_add_pooled_resource(key_keepers_faction_key, "rhox_key_keepers_vigil", tower.factor, -1)
			end
		end
	end
end


cm:add_first_tick_callback(
	function()
		core:add_listener(
			"rhox_key_keepers_vigil_watch_towers",
			"FactionTurnStart",
			function(context)
				return context:faction():name() == key_keepers_faction_key
			end,
			function()
				rhox_key_keepers_update_vigil()
			end,
			true
		)
	end
)
