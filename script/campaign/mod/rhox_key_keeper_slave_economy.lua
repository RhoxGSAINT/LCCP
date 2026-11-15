-- The standalone rhox_def_slaves mod covers every Dark Elf faction; this LCCP copy stands down when it is installed
if vfs.exists("script/campaign/mod/rhox_def_slaves_economy.lua") then
	return
end

local rhox_key_keeper_slaves = {
	faction_keys = {
		rhox_def_key_keepers = true,
	},

	pool_resource_key = "def_slaves",
	pool_factor_key = "rhox_def_slaves_distributed",

	province_resource_key = "rhox_def_slaves_province",
	province_factor_key = "rhox_def_slaves_distributed",

	need_resource_key = "rhox_def_slaves_province_need",

	-- Stores the MISSING percentage (100 - efficiency), same as wh3_dlc23_chd_efficiency
	inefficiency_resource_key = "rhox_def_slaves_province_inefficiency",
	other_factor_key = "other",

	region_bundle_key = "rhox_def_slaves_region_income",
	gdp_mod_effect_key = "rhox_def_slaves_effect_gdp_mod_slaves",
	gdp_flat_effect_key = "rhox_def_slaves_effect_gdp_slaves_flat",
	region_effect_scope = "region_to_region_own",
	gold_neutral_efficiency = 50,
	gold_per_slave = 1,

	loss_factor_key = "rhox_def_slaves_loss",
	loss_control_brackets = {
		{min = -100, max = -75, loss_percent = 20},
		{min = -74, max = -50, loss_percent = 15},
		{min = -49, max = -25, loss_percent = 10},
		{min = -24, max = 24, loss_percent = 5},
		{min = 25, max = 49, loss_percent = 5},
		{min = 50, max = 74, loss_percent = 3},
		{min = 75, max = 100, loss_percent = 3},
	},
	min_slave_loss = 5,

	starting_slaves = {
		rhox_def_key_keepers = {
			cr_combi_province_white_wastes = 100,
		},
	},

	move_event_prefix = "rhox_def_slaves_move:",

	panel_name = "rhox_def_slaves_economy",
	escape_callback_name = "rhox_def_slaves_close_panel",
	panel_path = "ui/campaign ui/rhox_def_slaves_economy.twui.xml",
	close_button_name = "rhox_def_slaves_close",

	hud_button_name = "rhox_def_slaves_economy_button",
	hud_button_template = "ui/templates/round_hud_button_toggle",
	hud_button_icon = "ui/skins/default/icon_slaves.png",
}

-- Human only: the AI cannot use the panel and would only get the penalty
function rhox_key_keeper_slaves:is_valid_faction(faction)
	return faction and not faction:is_null_interface() and faction:is_human() and self.faction_keys[faction:name()] == true
end

function rhox_key_keeper_slaves:get_faction_province(faction, province_key)
	local province_list = faction:provinces()
	for i = 0, province_list:num_items() - 1 do
		local faction_province = province_list:item_at(i)
		if faction_province:province():key() == province_key then
			return faction_province
		end
	end
	return false
end

function rhox_key_keeper_slaves:refresh_need(faction)
	local faction_key = faction:name()
	local province_list = faction:provinces()
	for i = 0, province_list:num_items() - 1 do
		cm:apply_regular_reset_income(province_list:item_at(i):pooled_resource_manager())
	end

	-- apply_regular_reset_income is not visible in the same tick; the CHD efficiency script also waits
	cm:callback(
		function()
			local refreshed_faction = cm:get_faction(faction_key)
			if self:is_valid_faction(refreshed_faction) then
				self:update_faction(refreshed_faction)
			end
		end,
		0.5
	)
end

function rhox_key_keeper_slaves:update_faction(faction)
	local province_list = faction:provinces()
	for i = 0, province_list:num_items() - 1 do
		self:update_efficiency(province_list:item_at(i))
	end
end

function rhox_key_keeper_slaves:update_all_factions()
	for faction_key in pairs(self.faction_keys) do
		local faction = cm:get_faction(faction_key)
		if self:is_valid_faction(faction) then
			self:update_faction(faction)
		end
	end
end

function rhox_key_keeper_slaves:update_efficiency(faction_province)
	local manager = faction_province:pooled_resource_manager()
	local slaves = manager:resource(self.province_resource_key)
	local need = manager:resource(self.need_resource_key)
	local inefficiency = manager:resource(self.inefficiency_resource_key)

	if slaves:is_null_interface() or need:is_null_interface() or inefficiency:is_null_interface() then
		return
	end

	local gdp_mod = 0
	local target_inefficiency = 0
	local need_value = need:value()
	if need_value > 0 then
		local efficiency = math.clamp(math.ceil((slaves:value() / need_value) * 100), 0, 100)
		target_inefficiency = 100 - efficiency
		gdp_mod = efficiency - self.gold_neutral_efficiency
	end

	self:set_resource_value(inefficiency, target_inefficiency)
	self:apply_region_income(faction_province, gdp_mod, slaves:value() * self.gold_per_slave)
end

-- Income goes through a scripted region bundle: pooled_resource_scaled_effects did not change gdp,
-- and a gdp effect with a province target crashes the database.
-- Flat income goes to one region only so it is not multiplied by the region count.
function rhox_key_keeper_slaves:apply_region_income(faction_province, gdp_mod, flat_income)
	local region_list = faction_province:regions()
	if region_list:num_items() == 0 then
		return
	end

	local flat_region = region_list:item_at(0)
	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)
		if region:is_province_capital() then
			flat_region = region
			break
		end
	end

	for i = 0, region_list:num_items() - 1 do
		local region = region_list:item_at(i)

		if region:has_effect_bundle(self.region_bundle_key) then
			cm:remove_effect_bundle_from_region(self.region_bundle_key, region:name())
		end

		local flat = 0
		if region:name() == flat_region:name() then
			flat = flat_income
		end

		if gdp_mod ~= 0 or flat ~= 0 then
			local bundle = cm:create_new_custom_effect_bundle(self.region_bundle_key)
			if gdp_mod ~= 0 then
				bundle:add_effect(self.gdp_mod_effect_key, self.region_effect_scope, gdp_mod)
			end
			if flat ~= 0 then
				bundle:add_effect(self.gdp_flat_effect_key, self.region_effect_scope, flat)
			end
			bundle:set_duration(0)
			cm:apply_custom_effect_bundle_to_region(bundle, region)
		end
	end
end

function rhox_key_keeper_slaves:apply_slave_loss(faction)
	local province_list = faction:provinces()
	for i = 0, province_list:num_items() - 1 do
		local faction_province = province_list:item_at(i)
		local slaves = faction_province:pooled_resource_manager():resource(self.province_resource_key)
		local region_list = faction_province:regions()

		if not slaves:is_null_interface() and slaves:value() > 0 and region_list:num_items() > 0 then
			local control = region_list:item_at(0):public_order()

			for _, bracket in ipairs(self.loss_control_brackets) do
				if control >= bracket.min and control <= bracket.max then
					local loss = math.floor((slaves:value() / 100) * bracket.loss_percent)
					loss = math.min(math.max(loss, self.min_slave_loss), slaves:value())
					cm:pooled_resource_factor_transaction(slaves, self.loss_factor_key, -loss)
					break
				end
			end
		end
	end
end

function rhox_key_keeper_slaves:grant_starting_slaves()
	for faction_key, provinces in pairs(self.starting_slaves) do
		local faction = cm:get_faction(faction_key)
		if self:is_valid_faction(faction) then
			for province_key, amount in pairs(provinces) do
				local faction_province = self:get_faction_province(faction, province_key)
				if faction_province then
					local resource = faction_province:pooled_resource_manager():resource(self.province_resource_key)
					if not resource:is_null_interface() then
						cm:pooled_resource_factor_transaction(resource, self.other_factor_key, amount)
					end
				end
			end
		end
	end
end

function rhox_key_keeper_slaves:set_resource_value(resource, target)
	local delta = target - resource:value()
	if delta ~= 0 then
		cm:pooled_resource_factor_transaction(resource, self.other_factor_key, delta)
	end
end

-- Positive amount: faction pool -> province, negative: province -> faction pool
function rhox_key_keeper_slaves:move_slaves(faction, province_key, amount)
	local faction_province = self:get_faction_province(faction, province_key)
	if not faction_province then
		return
	end

	local province_resource = faction_province:pooled_resource_manager():resource(self.province_resource_key)
	if province_resource:is_null_interface() then
		return
	end

	if amount > 0 then
		local pool_resource = faction:pooled_resource_manager():resource(self.pool_resource_key)
		if pool_resource:is_null_interface() then
			return
		end
		amount = math.min(amount, pool_resource:value())
	else
		amount = -math.min(-amount, province_resource:value())
	end

	if amount == 0 then
		return
	end

	cm:faction_add_pooled_resource(faction:name(), self.pool_resource_key, self.pool_factor_key, -amount)
	cm:pooled_resource_factor_transaction(province_resource, self.province_factor_key, amount)
end

function rhox_key_keeper_slaves:get_panel()
	return find_uicomponent(core:get_ui_root(), self.panel_name)
end

function rhox_key_keeper_slaves:close_panel()
	local panel = self:get_panel()
	if panel then
		panel:Destroy()
	end
	cm:release_escape_key_with_callback(self.escape_callback_name)

	local button = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management", self.hud_button_name)
	if button then
		button:SetState("active")
	end
end

function rhox_key_keeper_slaves:toggle_panel()
	if self:get_panel() then
		self:close_panel()
	else
		core:get_or_create_component(self.panel_name, self.panel_path)
		cm:steal_escape_key_with_callback(
			self.escape_callback_name,
			function()
				self:close_panel()
			end,
			false
		)
	end
end

function rhox_key_keeper_slaves:create_hud_button()
	local parent = find_uicomponent(core:get_ui_root(), "hud_campaign", "faction_buttons_docker", "button_group_management")
	if not parent then
		return
	end

	local button = core:get_or_create_component(self.hud_button_name, self.hud_button_template, parent)
	if not button then
		return
	end

	button:SetImagePath(self.hud_button_icon, 0)
	button:SetTooltipText(common.get_localised_string("campaign_localised_strings_string_rhox_def_slaves_hud_button"), true)
	button:SetVisible(true)
end

function rhox_key_keeper_slaves:setup_ui()
	local local_faction = cm:get_faction(cm:get_local_faction_name(true))
	if not self:is_valid_faction(local_faction) then
		return
	end

	self:create_hud_button()

	core:add_listener(
		"rhox_def_slaves_hud_button",
		"ComponentLClickUp",
		function(context)
			return context.string == self.hud_button_name
		end,
		function()
			self:toggle_panel()
		end,
		true
	)

	core:add_listener(
		"rhox_def_slaves_close_button",
		"ComponentLClickUp",
		function(context)
			return context.string == self.close_button_name
		end,
		function()
			self:close_panel()
		end,
		true
	)

	-- TriggerScriptEvent from the cco only fires locally; relay it as a UITrigger so it is synced
	core:add_listener(
		"rhox_def_slaves_context_trigger",
		"ContextTriggerEvent",
		function(context)
			return context.string:starts_with(self.move_event_prefix)
		end,
		function(context)
			local faction = cm:get_faction(cm:get_local_faction_name(true))
			CampaignUI.TriggerCampaignScriptEvent(faction:command_queue_index(), context.string)
		end,
		true
	)
end

function rhox_key_keeper_slaves:setup_listeners()
	core:add_listener(
		"rhox_def_slaves_ui_trigger",
		"UITrigger",
		function(context)
			return context:trigger():starts_with(self.move_event_prefix)
		end,
		function(context)
			local faction = cm:model():faction_for_command_queue_index(context:faction_cqi())
			if not self:is_valid_faction(faction) then
				return
			end

			local params = context:trigger():sub(#self.move_event_prefix + 1):split(":")
			local province_key = params[1]
			local amount = tonumber(params[2])
			if not province_key or not amount then
				return
			end

			self:move_slaves(faction, province_key, math.floor(amount))
		end,
		true
	)

	core:add_listener(
		"rhox_def_slaves_efficiency_changed",
		"PooledResourceChanged",
		function(context)
			local key = context:resource():key()
			return key == self.province_resource_key or key == self.need_resource_key
		end,
		function(context)
			self:update_all_factions()
		end,
		true
	)

	core:add_listener(
		"rhox_def_slaves_efficiency_income",
		"PooledResourceRegularIncome",
		function(context)
			local key = context:resource():key()
			return key == self.province_resource_key or key == self.need_resource_key
		end,
		function(context)
			self:update_all_factions()
		end,
		true
	)

	core:add_listener(
		"rhox_def_slaves_region_owner_changed",
		"RegionFactionChangeEvent",
		true,
		function(context)
			local region = context:region()
			if region:has_effect_bundle(self.region_bundle_key) then
				cm:remove_effect_bundle_from_region(self.region_bundle_key, region:name())
			end

			-- Need comes from settlement buildings, so both the new and the previous owner must refresh it
			local refreshed = {}
			for _, faction in ipairs({region:owning_faction(), context:previous_faction()}) do
				if self:is_valid_faction(faction) and not refreshed[faction:name()] then
					refreshed[faction:name()] = true
					self:refresh_need(faction)
				end
			end

			self:update_all_factions()
		end,
		true
	)

	core:add_listener(
		"rhox_def_slaves_building_completed",
		"BuildingCompleted",
		function(context)
			return self:is_valid_faction(context:building():faction())
		end,
		function(context)
			self:refresh_need(context:building():faction())
		end,
		true
	)

	core:add_listener(
		"rhox_def_slaves_refresh_need",
		"FactionTurnStart",
		function(context)
			return self:is_valid_faction(context:faction())
		end,
		function(context)
			if cm:turn_number() >= 2 then
				self:apply_slave_loss(context:faction())
			end
			self:refresh_need(context:faction())
		end,
		true
	)
end

cm:add_first_tick_callback(
	function()
		rhox_key_keeper_slaves:setup_listeners()

		if cm:is_new_game() then
			rhox_key_keeper_slaves:grant_starting_slaves()
			for faction_key in pairs(rhox_key_keeper_slaves.faction_keys) do
				local faction = cm:get_faction(faction_key)
				if rhox_key_keeper_slaves:is_valid_faction(faction) then
					rhox_key_keeper_slaves:refresh_need(faction)
				end
			end
		end

		rhox_key_keeper_slaves:setup_ui()
	end
)
