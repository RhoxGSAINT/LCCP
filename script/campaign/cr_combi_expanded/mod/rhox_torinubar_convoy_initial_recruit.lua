


local basic ={
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_art_eagle_claw_bolt_thrower"
}


local elite ={
    "wh2_main_hef_inf_phoenix_guard",
    "wh2_main_hef_inf_swordmasters_of_hoeth_0",
    "wh2_main_hef_inf_white_lions_of_chrace_0",
    "wh2_main_hef_inf_white_lions_of_chrace_0",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1"
}

local ranged ={
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_cav_silver_helms_1",
    "wh2_main_hef_cav_silver_helms_1"
}

local infantry={
    "wh2_dlc15_hef_inf_silverin_guard_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_main_hef_inf_lothern_sea_guard_1",
    "wh2_dlc10_hef_inf_sisters_of_avelorn_0",
    "wh2_dlc10_hef_inf_shadow_warriors_0",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
}

local dragon_willed={
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_spearmen_0",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_inf_archers_1",
    "wh2_main_hef_mon_sun_dragon"
}



function rhox_torinubar_add_inital_force(caravan)
	
	out.design("Try to add inital force to caravan, based on trait")
	
	local force_cqi = caravan:caravan_force():command_queue_index();
	local lord_cqi = caravan:caravan_force():general_character():command_queue_index();
	local lord_str = cm:char_lookup_str(lord_cqi);
	
	if caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_army_3_competent") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
		--fully heal when returning
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_army_3_respectful") then
		for i=1, #elite do
			cm:grant_unit_to_character(lord_str, elite[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_army_3_strong_willed") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_battle_3_elusive") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
		cm:add_experience_to_units_commanded_by_character(lord_str, 4)
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_battle_3_hale_and_hearty") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_battle_3_trained") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_campaign_3_observant") then
		for i=1, #ranged do
			cm:grant_unit_to_character(lord_str, ranged[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_army_7_doctrinal") then
		for i=1, #elite do
			cm:grant_unit_to_character(lord_str, elite[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_army_7_dragon_willed") then
		for i=1, #dragon_willed do
			cm:grant_unit_to_character(lord_str, dragon_willed[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_army_7_resistant") then
		for i=1, #infantry do
			cm:grant_unit_to_character(lord_str, infantry[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_battle_7_dangerous") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
    elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_battle_7_resilient") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
	elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_battle_7_vigorous") then
		for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end			
    elseif caravan:caravan_master():character_details():has_skill("rhox_torinubar_convoy_skill_innate_hef_prince_campaign_7_adept") then
		for i=1, #ranged do
			cm:grant_unit_to_character(lord_str, ranged[i]);
		end	
	else
        for i=1, #basic do
			cm:grant_unit_to_character(lord_str, basic[i]);
		end
		out("*** Unknown Caravan Master ??? ***")
	end
end