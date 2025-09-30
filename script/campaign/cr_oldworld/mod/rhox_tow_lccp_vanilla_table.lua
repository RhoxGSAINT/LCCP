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
table.insert(character_unlocking.character_data["scyla"]["override_allowed_factions"], "rhox_nor_khazags")



-----------Nurgle Plague
nurgle_plagues.plague_faction_info["cr_nur_tide_of_pestilence"] = {max_blessed_symptoms = 1, current_symptoms_list = {}, plague_creation_counter = 3}
nurgle_plagues.plague_button_unlock["cr_nur_tide_of_pestilence"] = {button_locked = true, infections_gained = 0, infections_end_of_last_turn = 200}


cm:add_first_tick_callback(
	function()
        campaign_traits.legendary_lord_defeated_traits["hkrul_zach"] ="hkrul_defeated_trait_zach"
        campaign_traits.legendary_lord_defeated_traits["hkrul_duriath"] ="hkrul_defeated_trait_duriath"
		campaign_traits.legendary_lord_defeated_traits["hkrul_valbrand"] ="hkrul_defeated_trait_valbrand"
		campaign_traits.legendary_lord_defeated_traits["hkrul_hrothyogg"] ="hkrul_defeated_trait_hrothyogg"
		campaign_traits.legendary_lord_defeated_traits["hkrul_orghotts"] ="hkrul_defeated_trait_orghotts"
		campaign_traits.legendary_lord_defeated_traits["hkrul_thorgar"] ="hkrul_defeated_trait_thorgar"
		campaign_traits.legendary_lord_defeated_traits["hkrul_slaurith"] ="hkrul_defeated_trait_slaurith"
        campaign_traits.legendary_lord_defeated_traits["hkrul_vroth"] ="hkrul_defeated_trait_vroth"
	end
)

