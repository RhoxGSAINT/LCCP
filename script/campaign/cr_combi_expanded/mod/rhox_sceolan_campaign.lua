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
        return character:faction():name() == "rhox_wef_far_away_forest" and (climate == "climate_frozen" or "climate_magicforest")
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
        return character:faction():name() == "rhox_wef_far_away_forest" and (climate == "climate_frozen" or "climate_magicforest")
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
        return character:faction():name() == "rhox_wef_far_away_forest" and (climate == "climate_frozen" or "climate_magicforest")
    end,
    function(context) rhox_sceolan_apply_effect_bundle(context:character()) end,
    true
)
