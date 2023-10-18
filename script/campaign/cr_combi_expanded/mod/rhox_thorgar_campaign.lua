local function rhox_thorgar_get_enemy_subtypes()--changeling one except for the heroes one and the agent_subtype
	local pb = cm:model():pending_battle()
	local attacker_subtypes = {}
	local defender_subtypes = {}
	local was_attacker = false

	local num_attackers = cm:pending_battle_cache_num_attackers()
	local num_defenders = cm:pending_battle_cache_num_defenders()

	if pb:night_battle() == true or pb:ambush_battle() == true then
		num_attackers = 1
		num_defenders = 1
	end
	
	for i = 1, num_attackers do
		local char_subtype = cm:pending_battle_cache_get_attacker_subtype(i)
		
		if char_subtype == "hkrul_thorgar" then
			was_attacker = true
			break
		end

		if not was_attacker then
			table.insert(attacker_subtypes, char_subtype)
		
		--[[
			local embedded_attacker_subtypes = cm:pending_battle_cache_get_attacker_embedded_character_subtypes(i)
			
			for j = 1, #embedded_attacker_subtypes do
				table.insert(attacker_subtypes, embedded_attacker_subtypes[j])
			end
			]]
		end
	end
	
	if was_attacker == false then
		return attacker_subtypes
	end
	
	for i = 1, num_defenders do
		local char_subtype = cm:pending_battle_cache_get_defender_subtype(i)
		
		table.insert(defender_subtypes, char_subtype)
		
		--[[
		local embedded_defender_subtypes = cm:pending_battle_cache_get_defender_embedded_character_subtypes(i)
		
		for j = 1, #embedded_defender_subtypes do
			table.insert(defender_subtypes, embedded_defender_subtypes[j])
		end
		]]
	end

	return defender_subtypes
end


--------------------------------------------Thorgar Initiatives
initiative_cultures["wh_dlc08_nor_norsca"]=true
table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_01",--win 5 battles against LL
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				if not character:won_battle() then
                    return false
				end
				
				local enemy_agent_subtype = rhox_thorgar_get_enemy_subtypes()
                for i = 1, #enemy_agent_subtype do
                    --out("Rhox Thorgar: Looking at: ".. enemy_agent_subtype[i])
                    if cm:is_agent_transformation_available(enemy_agent_subtype[i]) then
                        --out("Rhox Thorgar: It's a LL")
                        if not cm:get_saved_value("rhox_thorgar_ll_number") then
                            cm:set_saved_value("rhox_thorgar_ll_number", 0)
                        end
                        cm:set_saved_value("rhox_thorgar_ll_number", cm:get_saved_value("rhox_thorgar_ll_number")+1)
                    end
                end
				
				return cm:get_saved_value("rhox_thorgar_ll_number") and cm:get_saved_value("rhox_thorgar_ll_number")>=5;
			end
	}
)


table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_02",--10 reginos
		["event"] = "CharacterTurnStart",
		["condition"] =
			function(context)
				local character = context:character();
				local faction = character:faction()
				return faction and faction:region_list():num_items()>=10;
			end
	}
)

table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_02",--level 30
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
				return context:character():rank() >= 30;
			end
	}
)

table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_initiative_02",--20 offensive battle win
		["event"] = "CharacterCompletedBattle",
		["condition"] =
			function(context)
				local character = context:character();
				return character:offensive_battles_won() >= 20
			end
	}
)


table.insert(initiative_templates,
    {

		["initiative_key"] = "rhox_thorgar_ascend",
		["event"] = "CharacterRankUp",
		["condition"] =
			function(context)
                local character = context:character();
				local faction = character:faction()
				return cm:get_saved_value("rhox_thorgar_ll_number") and cm:get_saved_value("rhox_thorgar_ll_number")>=5 and
				faction and faction:region_list():num_items()>=10 and
				character:rank() >= 30 and character:offensive_battles_won() >= 20
			end
	}
)

CUS.initiative_to_agent_junctions["rhox_thorgar_ascend"] = {
    type = "general",
    subtype = "hkrul_thorgar_daemon_prince",
}
