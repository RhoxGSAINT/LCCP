local duriath_faction_key = "cr_def_corsairs_of_spite"
local lokhir_faction_key = "wh2_dlc11_def_the_blessed_dread"
local lokhir_subtype = "wh2_dlc11_def_lokhir"
local lokhir_mission_key = "rhox_duriath_lokhir_mission" --issued in rhox_iee_lccp_init.lua

core:add_listener(
    "rhox_duriath_lokhir_battle_completed",
    "BattleCompleted",
    function(context)
        return cm:model():pending_battle():has_been_fought()
            and not cm:get_saved_value("rhox_duriath_lokhir_mission_done")
            and cm:pending_battle_cache_faction_won_battle(duriath_faction_key)
            and cm:get_faction(duriath_faction_key):is_human()
    end,
    function(context)
        local is_attacker = cm:pending_battle_cache_faction_is_attacker(duriath_faction_key)
        local num = is_attacker and cm:pending_battle_cache_num_defenders() or cm:pending_battle_cache_num_attackers()
        for i = 1, num do
            local subtype = is_attacker and cm:pending_battle_cache_get_defender_subtype(i) or cm:pending_battle_cache_get_attacker_subtype(i)
            if subtype == lokhir_subtype then
                cm:set_saved_value("rhox_duriath_lokhir_mission_done", true)
                cm:set_scripted_mission_entity_completion_states(lokhir_mission_key, lokhir_mission_key, {{cm:get_faction(lokhir_faction_key), true}})
                cm:complete_scripted_mission_objective(duriath_faction_key, lokhir_mission_key, lokhir_mission_key, true)
                return
            end
        end
    end,
    true
)
