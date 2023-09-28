--his innate trait
local function recalculate_mass_bonus_effect(character, faction)
    if character:has_effect_bundle("rhox_valbrand_innate_effect_bundle") then
        cm:remove_effect_bundle_from_character("rhox_valbrand_innate_effect_bundle", character)
    end-- remove the pre-existing one if any
    
    local value = 5;
    local war_faction_number = faction:factions_at_war_with():num_items()
    local valbarand_bundle = cm:create_new_custom_effect_bundle("rhox_valbrand_innate_effect_bundle");
    valbarand_bundle:set_duration(0);
    valbarand_bundle:add_effect("wh3_main_effect_character_stat_unit_mass_percentage_mod", "character_to_character_own", value*war_faction_number);

    cm:apply_custom_effect_bundle_to_character(valbarand_bundle, character)
end

core:add_listener(
    "rhox_valbarand_innate_trait_1",
    "CharacterTurnStart",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_valbrand")
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        
        recalculate_mass_bonus_effect(character, faction)
        
    end,
    true
)

core:add_listener(
    "rhox_valbarand_innate_trait_2",
    "FactionLeaderDeclaresWar",
    function(context)
        local character = context:character()
        return character:character_subtype("hkrul_valbrand")
    end,
    function(context)
        local character = context:character()    
        local faction = character:faction()
        
        recalculate_mass_bonus_effect(character, faction)
        
    end,
    true
)



--unlock techs by sacking instead
------------------------------------------
local rhox_norsca_region_to_tech= {
    wh3_main_combi_region_naggarond =  "wh_dlc08_tech_nor_nw_03",
    wh3_main_combi_region_lothern =   "wh_dlc08_tech_nor_nw_05",
    wh3_main_combi_region_hexoatl =   "wh_dlc08_tech_nor_nw_07",
    wh3_main_combi_region_skavenblight =  "wh_dlc08_tech_nor_nw_09",
    wh3_main_combi_region_khemri = "wh_dlc08_tech_nor_nw_11",
    wh3_main_combi_region_the_awakening = "wh_dlc08_tech_nor_nw_21",
    wh3_main_combi_region_couronne =  "wh_dlc08_tech_nor_other_08",
    wh3_main_combi_region_miragliano = "wh_dlc08_tech_nor_other_10",
    wh3_main_combi_region_karaz_a_karak =  "wh_dlc08_tech_nor_other_12",
    wh3_main_combi_region_altdorf = "wh_dlc08_tech_nor_other_15",
    wh3_main_combi_region_castle_drakenhof =  "wh_dlc08_tech_nor_other_17",
    wh3_main_combi_region_black_crag =  "wh_dlc08_tech_nor_other_19",
    wh3_main_combi_region_great_hall_of_greasus = "wh3_main_ie_tech_nor_darklands_ogre_kingdoms_capital",
    wh3_main_combi_region_the_oak_of_ages = "wh_dlc08_tech_nor_other_21",
    wh3_main_combi_region_zharr_naggrund = "wh3_main_ie_tech_nor_darklands_chaos_dwarfs_capital",
    wh3_main_combi_region_kislev = "wh3_main_ie_tech_nor_oldworld_kislev_capital",
    wh3_main_chaos_region_kislev = "wh3_main_ie_tech_nor_oldworld_kislev_capital",
    wh3_main_combi_region_wei_jin =  "wh3_main_ie_tech_nor_darklands_cathay_capital"
}




core:add_listener(
    "rhox_valbrand_tech_check",
    "CharacterPerformsSettlementOccupationDecision",
    function(context)
        local region_key = context:garrison_residence():region():name()
        return context:occupation_decision() == "1963655228" and context:character():faction():name() == "rhox_nor_firebrand_slavers" and rhox_norsca_region_to_tech[region_key]--raze for hound
    end,
    function(context) 
        local region_key = context:garrison_residence():region():name()
        local tech_key = rhox_norsca_region_to_tech[region_key]
        cm:unlock_technology(context:character():faction():name(), tech_key)
    end,
    true
);