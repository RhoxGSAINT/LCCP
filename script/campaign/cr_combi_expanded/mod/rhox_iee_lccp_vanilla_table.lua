-----------------------------Vanilla Legendary Hero thing
------------Volrik
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], "rhox_nor_ravenblessed")
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_aekold_helbrass_stage_1_nor")
character_unlocking.character_data["aekold"]["starting_mission_keys"]["rhox_nor_ravenblessed"]={}
character_unlocking.character_data["aekold"]["starting_mission_keys"]["rhox_nor_ravenblessed"]["main_warhammer"]="rhox_iee_lccp_tze_aekold_helbrass_stage_1_nor"

table.insert(character_unlocking.character_data["scribes"]["override_allowed_factions"]["main_warhammer"], "rhox_nor_ravenblessed")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_1_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_2_b_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_2_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_3_nor")
table.insert(character_unlocking.character_data["scribes"]["missions_to_trigger_dilemma"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_3_nor")
character_unlocking.character_data["scribes"]["starting_mission_keys"]["rhox_nor_ravenblessed"]={}
character_unlocking.character_data["scribes"]["starting_mission_keys"]["rhox_nor_ravenblessed"]["main_warhammer"]="rhox_iee_lccp_tze_blue_scribes_stage_1_nor"


------------Slaurith, and Valbrand
table.insert(character_unlocking.character_data["karanak"]["override_allowed_factions"]["main_warhammer"], "cr_kho_servants_of_the_blood_nagas")
table.insert(character_unlocking.character_data["karanak"]["override_allowed_factions"]["main_warhammer"], "rhox_nor_firebrand_slavers")

character_unlocking.character_data["karanak"]["starting_mission_keys"]["cr_kho_servants_of_the_blood_nagas"]={}
character_unlocking.character_data["karanak"]["starting_mission_keys"]["rhox_nor_firebrand_slavers"]={}

character_unlocking.character_data["karanak"]["starting_mission_keys"]["cr_kho_servants_of_the_blood_nagas"]["main_warhammer"] ="wh3_pro12_mis_ie_kho_karanak_unlock_01"
character_unlocking.character_data["karanak"]["starting_mission_keys"]["rhox_nor_firebrand_slavers"]["main_warhammer"] = "rhox_iee_lccp_mis_ie_valbrand_karanak_unlock_01"


table.insert(character_unlocking.character_data["karanak"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_mis_ie_valbrand_karanak_unlock_01")
table.insert(character_unlocking.character_data["karanak"]["missions_to_trigger_dilemma"]["main_warhammer"], "rhox_iee_lccp_mis_ie_valbrand_karanak_unlock_01")

table.insert(character_unlocking.character_data["skarr"]["override_allowed_factions"], "cr_kho_servants_of_the_blood_nagas")
table.insert(character_unlocking.character_data["skarr"]["override_allowed_factions"], "rhox_nor_firebrand_slavers")


table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "cr_kho_servants_of_the_blood_nagas")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "rhox_nor_firebrand_slavers")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "cr_nor_tokmars")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "rhox_nor_ravenblessed")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "rhox_nor_khazags")

----------Engra
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], "rhox_chs_the_deathswords")
character_unlocking.character_data["aekold"]["starting_mission_keys"]["rhox_chs_the_deathswords"]={}
character_unlocking.character_data["aekold"]["starting_mission_keys"]["rhox_chs_the_deathswords"]["main_warhammer"]="wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs"

table.insert(character_unlocking.character_data["scribes"]["override_allowed_factions"]["main_warhammer"], "rhox_chs_the_deathswords")
character_unlocking.character_data["scribes"]["starting_mission_keys"]["rhox_chs_the_deathswords"]={}
character_unlocking.character_data["scribes"]["starting_mission_keys"]["rhox_chs_the_deathswords"]["main_warhammer"]="wh3_dlc24_mis_tze_blue_scribes_stage_1_chs"

table.insert(character_unlocking.character_data["karanak"]["override_allowed_factions"]["main_warhammer"], "rhox_chs_the_deathswords")
character_unlocking.character_data["karanak"]["starting_mission_keys"]["rhox_chs_the_deathswords"]={}
character_unlocking.character_data["karanak"]["starting_mission_keys"]["rhox_chs_the_deathswords"]["main_warhammer"] ="wh3_pro12_mis_ie_chs_karanak_unlock_01"


table.insert(character_unlocking.character_data["skarr"]["override_allowed_factions"], "rhox_chs_the_deathswords")
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "rhox_chs_the_deathswords")

-----------Nurgle Plague
nurgle_plagues.plague_faction_info["cr_nur_tide_of_pestilence"] = {max_blessed_symptoms = 1, current_symptoms_list = {}, plague_creation_counter = 3}
nurgle_plagues.plague_button_unlock["cr_nur_tide_of_pestilence"] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200}


-----------Norsca guys for Beorg
table.insert(character_unlocking.character_data["beorg_bearstruck"]["override_allowed_factions"], "rhox_nor_ravenblessed")
table.insert(character_unlocking.character_data["beorg_bearstruck"]["override_allowed_factions"], "rhox_nor_khazags")
table.insert(character_unlocking.character_data["beorg_bearstruck"]["override_allowed_factions"], "rhox_nor_firebrand_slavers")
table.insert(character_unlocking.character_data["beorg_bearstruck"]["override_allowed_factions"], "cr_nor_tokmars")
table.insert(character_unlocking.character_data["caradryan"]["override_allowed_factions"], "cr_hef_gate_guards")


-----------Norsca pillage and hunting --only add rhox prefix guys. cr guys are added by CR in the IEE
table.insert(nor_pillaging.pillage_enabled_factions, "rhox_nor_ravenblessed")
table.insert(nor_pillaging.pillage_enabled_factions, "rhox_nor_khazags")
--table.insert(nor_pillaging.pillage_enabled_factions, "rhox_nor_firebrand_slavers")

monster_hunt.config.ultimate_monster_hunter_rewards["rhox_nor_ravenblessed"] = {
    incident = "wh3_dlc27_nor_become_ultimate_monster_hunter",
    effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_ultimate_hunter_reward_bundle",
}
monster_hunt.config.ultimate_monster_hunter_rewards["rhox_nor_khazags"] = {
    incident = "wh3_dlc27_nor_become_ultimate_monster_hunter",
    effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_ultimate_hunter_reward_bundle",
}
monster_hunt.config.ultimate_monster_hunter_rewards["rhox_nor_firebrand_slavers"] = {
    incident = "wh3_dlc27_nor_become_ultimate_monster_hunter",
    effect_bundle = "wh3_dlc27_nor_monstrous_arcanum_ultimate_hunter_reward_bundle",
}

table.insert(monster_hunt.config.playable_monster_hunt_factions, "rhox_nor_ravenblessed")
table.insert(monster_hunt.config.playable_monster_hunt_factions, "rhox_nor_khazags")
table.insert(monster_hunt.config.playable_monster_hunt_factions, "rhox_nor_firebrand_slavers")

monster_hunt.config.turn_to_unlock["rhox_nor_ravenblessed"] = 8
monster_hunt.config.turn_to_unlock["rhox_nor_khazags"] = 8
monster_hunt.config.turn_to_unlock["rhox_nor_firebrand_slavers"] = 8

----Norsca dedication

norscan_gods.allegiance_factions["rhox_nor_khazags"]= norscan_gods.allegiance_factions["wh_dlc08_nor_norsca"]
norscan_gods.allegiance_factions["cr_nor_tokmars"]= norscan_gods.allegiance_factions["wh_dlc08_nor_norsca"]
norscan_gods.allegiance_factions["rhox_nor_ravenblessed"]= {crow_dilemma_spawned = true, eagle_dilemma_spawned = false, hound_dilemma_spawned = true, serpent_dilemma_spawned = true, champion_spawned = false}
--norscan_gods.allegiance_factions["rhox_nor_firebrand_slavers"]= {crow_dilemma_spawned = true, eagle_dilemma_spawned = true, hound_dilemma_spawned = false, serpent_dilemma_spawned = true, champion_spawned = false}--because of home_region error thing, we're manually triggering this
norscan_gods.allegiance_factions["rhox_nor_firebrand_slavers"]= norscan_gods.allegiance_factions["wh_dlc08_nor_norsca"]

norscan_gods.allegiance_advice_tracker["rhox_nor_khazags"]=norscan_gods.allegiance_advice_tracker["wh_dlc08_nor_norsca"]
norscan_gods.allegiance_advice_tracker["cr_nor_tokmars"]=norscan_gods.allegiance_advice_tracker["wh_dlc08_nor_norsca"]
norscan_gods.allegiance_advice_tracker["rhox_nor_ravenblessed"]=norscan_gods.allegiance_advice_tracker["wh_dlc08_nor_norsca"]
norscan_gods.allegiance_advice_tracker["rhox_nor_firebrand_slavers"]=norscan_gods.allegiance_advice_tracker["wh_dlc08_nor_norsca"]


nor_generic_config.altar_raise_occupation_options_display_overrides["1197046429"]="wh_main_settlement_norscaruin_khorne"
nor_generic_config.altar_raise_occupation_options_display_overrides["1197046430"]="wh_main_settlement_norscaruin_tzeentch"



cm:add_first_tick_callback(
	function()
		campaign_traits.legendary_lord_defeated_traits["hkrul_sceolan"] ="hkrul_defeated_trait_sceolan"
		campaign_traits.legendary_lord_defeated_traits["hkrul_valbrand"] ="hkrul_defeated_trait_valbrand"
		campaign_traits.legendary_lord_defeated_traits["hkrul_volrik"] ="hkrul_defeated_trait_volrik"
		campaign_traits.legendary_lord_defeated_traits["hkrul_zach"] ="hkrul_defeated_trait_zach"
		campaign_traits.legendary_lord_defeated_traits["hef_calith_torinubar"] ="rhox_torinubar_defeated_torinubar"
		campaign_traits.legendary_lord_defeated_traits["hkrul_hrothyogg"] ="hkrul_defeated_trait_hrothyogg"
		campaign_traits.legendary_lord_defeated_traits["hkrul_orghotts"] ="hkrul_defeated_trait_orghotts"
		campaign_traits.legendary_lord_defeated_traits["hkrul_aelfric"] ="hkrul_defeated_trait_aelfric"
		campaign_traits.legendary_lord_defeated_traits["hkrul_burlok"] ="hkrul_defeated_trait_burlok"
		campaign_traits.legendary_lord_defeated_traits["hkrul_dolmance"] ="hkrul_defeated_trait_dolmance"
		campaign_traits.legendary_lord_defeated_traits["hkrul_thorgar"] ="hkrul_defeated_trait_thorgar"
		campaign_traits.legendary_lord_defeated_traits["hkrul_slaurith"] ="hkrul_defeated_trait_slaurith"
		campaign_traits.legendary_lord_defeated_traits["hkrul_arbaal"] ="hkrul_defeated_trait_arbaal"
        campaign_traits.legendary_lord_defeated_traits["hkrul_engra"] ="hkrul_defeated_trait_engra"
        campaign_traits.legendary_lord_defeated_traits["hkrul_vroth"] ="hkrul_defeated_trait_vroth"
        campaign_traits.legendary_lord_defeated_traits["hkrul_karitamen"] ="hkrul_defeated_trait_karitamen"
        campaign_traits.legendary_lord_defeated_traits["hkrul_duriath"] ="hkrul_defeated_trait_duriath"
	end
)

--------------Dwarfs
table.insert(book_of_grudges.confederation_factions_list, "cr_dwf_firebeards_excavators")


book_of_grudges.faction_confederation_data["cr_dwf_firebeards_excavators"]= {
    ritual = "rhox_burlok_dwf_ritual_legendary_lord_burlok",
    cost_mod_effect = "rhox_burlok_dwf_ritual_confederation_burlok_cost_mod"
}

