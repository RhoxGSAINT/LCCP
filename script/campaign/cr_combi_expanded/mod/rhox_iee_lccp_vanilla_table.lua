-----------------------------Vanilla Legendary Hero thing
------------Volrik
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], "rhox_nor_ravenblessed")
table.insert(character_unlocking.character_data["aekold"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_aekold_helbrass_stage_1_nor")
character_unlocking.character_data["aekold"]["mission_keys"]["rhox_nor_ravenblessed"]={}
character_unlocking.character_data["aekold"]["mission_keys"]["rhox_nor_ravenblessed"]["main_warhammer"]="rhox_iee_lccp_tze_aekold_helbrass_stage_1_nor"

table.insert(character_unlocking.character_data["scribes"]["override_allowed_factions"]["main_warhammer"], "rhox_nor_ravenblessed")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_1_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_2_b_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_2_nor")
table.insert(character_unlocking.character_data["scribes"]["mission_chain_keys"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_3_nor")
table.insert(character_unlocking.character_data["scribes"]["missions_to_trigger_dilemma"]["main_warhammer"], "rhox_iee_lccp_tze_blue_scribes_stage_3_nor")
character_unlocking.character_data["scribes"]["mission_keys"]["rhox_nor_ravenblessed"]={}
character_unlocking.character_data["scribes"]["mission_keys"]["rhox_nor_ravenblessed"]["main_warhammer"]="rhox_iee_lccp_tze_blue_scribes_stage_1_nor"






----------Engra
table.insert(character_unlocking.character_data["aekold"]["override_allowed_factions"]["main_warhammer"], "rhox_chs_the_deathswords")
character_unlocking.character_data["aekold"]["mission_keys"]["rhox_chs_the_deathswords"]={}
character_unlocking.character_data["aekold"]["mission_keys"]["rhox_chs_the_deathswords"]["main_warhammer"]="wh3_dlc24_mis_ie_tze_aekold_helbrass_stage_1_chs"

table.insert(character_unlocking.character_data["scribes"]["override_allowed_factions"]["main_warhammer"], "rhox_chs_the_deathswords")
character_unlocking.character_data["scribes"]["mission_keys"]["rhox_chs_the_deathswords"]={}
character_unlocking.character_data["scribes"]["mission_keys"]["rhox_chs_the_deathswords"]["main_warhammer"]="wh3_dlc24_mis_tze_blue_scribes_stage_1_chs"


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
        campaign_traits.legendary_lord_defeated_traits["hkrul_beorg"] ="hkrul_defeated_trait_beorg"
	end
)
