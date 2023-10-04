local sceolan_cold_bundle = "rhox_sceolan_embrace_cold"


local function rhox_sceolan_apply_effect_bundle(character)
    
    local character_cqi = character:command_queue_index()
    
    cm:remove_effect_bundle_from_characters_force(sceolan_cold_bundle, character_cqi)
    cm:apply_effect_bundle_to_characters_force(sceolan_cold_bundle, character_cqi, 3, false)
end


core:add_listener(
    "rhox_sceolan_CharacterEntersGarrison",
    "CharacterEntersGarrison",
    function(context) 
        local character=context:character()
        local region = character:region()
        if not region then
            return false
        end
        local settlement=region:settlement()
        if not settlement then
            return false
        end
        local climate = settlement:get_climate()
        return character:faction():name() == "rhox_wef_far_away_forest" and (climate == "climate_frozen" or climate == "climate_magicforest")
    end,
    function(context) rhox_sceolan_apply_effect_bundle(context:character()) end,
    true
)

core:add_listener(
    "rhox_sceolan_CharacterLeavesGarrison",
    "CharacterLeavesGarrison",
    function(context) 
        local character=context:character()
        local region = character:region()
        if not region then
            return false
        end
        local settlement=region:settlement()
        if not settlement then
            return false
        end
        local climate = settlement:get_climate()
        return character:faction():name() == "rhox_wef_far_away_forest" and (climate == "climate_frozen" or climate == "climate_magicforest")
    end,
    function(context) rhox_sceolan_apply_effect_bundle(context:character()) end,
    true
)

core:add_listener(
    "rhox_sceolan_CharacterTurnStart",
    "CharacterTurnStart",
    function(context) 
        local character=context:character()
        local region = character:region()
        if not region then
            return false
        end
        local settlement=region:settlement()
        if not settlement then
            return false
        end
        local climate = settlement:get_climate()
        return character:faction():name() == "rhox_wef_far_away_forest" and (climate == "climate_frozen" or climate == "climate_magicforest")
    end,
    function(context) rhox_sceolan_apply_effect_bundle(context:character()) end,
    true
)
--------------------------------------------------------------------------Encounter

Worldroots.encounters["the_far_place_high_elf_invaders_me"] = {
    spawn_turn = 2,--TODO change it to 8
    forest = "the_far_place",
    spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
    region = "cr_combi_region_elithis_2_1",
    setup = function() 
        Worldroots:set_up_generic_encounter_marker("the_far_place_high_elf_invaders_me", "rhox_sceolan_high_elf_invaders", 1449, 44, "the_far_place")
    end,
    on_battle_trigger_callback = function(self, character, marker_info)
        Worldroots:set_up_generic_encounter_forced_battle(character, "wh2_main_hef_high_elves_qb1", "wh2_main_sc_hef_high_elves", false)
    end,
}

Worldroots.encounters["the_far_place_cathay_invaders_me"] = {
    spawn_turn = 2,
    forest = "the_far_place",
    spawn_incident = "wh2_dlc16_incident_wef_new_encounter_available",
    region = "cr_combi_region_elithis_2_1",
    setup = function() 
        Worldroots:set_up_generic_encounter_marker("the_far_place_cathay_invaders_me", "rhox_sceolan_cathay_invaders", 1501, 72, "the_far_place")
    end,
    on_battle_trigger_callback = function(self, character, marker_info)
    end,
}
