local zach_faction_keys = {
    ["rhox_vmp_the_everliving"] = true, --IEE
    ["cr_vmp_the_everliving"] = true, --TOW
}
local zach_subtype = "hkrul_zach"

local power_resource_key = "wh3_dlc29_vmp_power"
local power_factor_key = "events"
local power_base_amount = 300 --base + power_per_dragon per dragon (Zombie Dragon recruitment costs 840)
local power_per_dragon = 150
local power_max_amount = 900

local blood_incident_key = "rhox_zach_dragon_blood_incident"
local dragon_trait_key = "rhox_zach_dragon_blood_trait"

local hunt_mission_key = "rhox_zach_dragon_hunt_mission"
local hunt_mission_chance = 15
local hunt_mission_cooldown = 8
local hunt_mission_min_turn = 5
local hunt_mission_turn_limit = 15
local hunt_mission_payloads = {
    "faction_pooled_resource_transaction{resource wh3_dlc29_vmp_power;factor missions;amount 600;context absolute;}",
    "money 2000",
}

--main_unit keys whose land unit uses a dragon skeleton (dr1, dr1b, dr04) as entity or mount. Zombie dragons and toad dragons are excluded on purpose.
--Global so other mods can add their own dragons: rhox_zach_dragon_unit_keys["your_unit_key"] = true
rhox_zach_dragon_unit_keys = {
    ["hef_calith_torinubar_dragon"] = true,
    ["hkrul_duriath_dragon"] = true,
    ["hkrul_sceolan_dragon"] = true,
    ["hkrul_slaurith_mount"] = true,
    ["wh2_dlc10_def_cha_supreme_sorceress_beasts_5"] = true,
    ["wh2_dlc10_def_cha_supreme_sorceress_dark_5"] = true,
    ["wh2_dlc10_def_cha_supreme_sorceress_death_5"] = true,
    ["wh2_dlc10_def_cha_supreme_sorceress_fire_5"] = true,
    ["wh2_dlc10_def_cha_supreme_sorceress_shadow_5"] = true,
    ["wh2_dlc11_def_cha_lokhir_fellheart_1"] = true,
    ["wh2_dlc15_hef_cha_archmage_beasts_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_death_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_fire_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_heavens_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_high_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_life_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_light_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_metal_4"] = true,
    ["wh2_dlc15_hef_cha_archmage_shadows_4"] = true,
    ["wh2_dlc15_hef_cha_imrik_2"] = true,
    ["wh2_dlc15_hef_cha_mage_fire_3"] = true,
    ["wh2_dlc15_hef_mon_black_dragon_imrik"] = true,
    ["wh2_dlc15_hef_mon_black_dragon_imrik_boss"] = true,
    ["wh2_dlc15_hef_mon_forest_dragon_0"] = true,
    ["wh2_dlc15_hef_mon_forest_dragon_imrik"] = true,
    ["wh2_dlc15_hef_mon_forest_dragon_imrik_boss"] = true,
    ["wh2_dlc15_hef_mon_moon_dragon_imrik"] = true,
    ["wh2_dlc15_hef_mon_moon_dragon_imrik_boss"] = true,
    ["wh2_dlc15_hef_mon_star_dragon_imrik"] = true,
    ["wh2_dlc15_hef_mon_star_dragon_imrik_boss"] = true,
    ["wh2_dlc15_hef_mon_sun_dragon_imrik"] = true,
    ["wh2_dlc15_hef_mon_sun_dragon_imrik_boss"] = true,
    ["wh2_dlc16_wef_cha_sisters_of_twilight_1"] = true,
    ["wh2_dlc16_wef_mon_ceithin_har_summoned"] = true,
    ["wh2_main_def_cha_dreadlord_4"] = true,
    ["wh2_main_def_cha_dreadlord_female_4"] = true,
    ["wh2_main_def_cha_malekith_3"] = true,
    ["wh2_main_def_mon_black_dragon"] = true,
    ["wh2_main_hef_cha_alastair_4"] = true,
    ["wh2_main_hef_cha_alastair_5"] = true,
    ["wh2_main_hef_cha_prince_4"] = true,
    ["wh2_main_hef_cha_prince_5"] = true,
    ["wh2_main_hef_cha_princess_4"] = true,
    ["wh2_main_hef_cha_princess_5"] = true,
    ["wh2_main_hef_mon_moon_dragon"] = true,
    ["wh2_main_hef_mon_star_dragon"] = true,
    ["wh2_main_hef_mon_sun_dragon"] = true,
    ["wh2_twa03_def_cha_rakarth_3"] = true,
    ["wh3_dlc24_cth_cha_yuan_bo_dragon"] = true,
    ["wh3_dlc24_cth_cha_yuan_bo_human"] = true, --dragon in human form
    ["wh3_dlc25_emp_cha_elspeth_von_draken_carmine_dragon"] = true,
    ["wh3_dlc25_hef_mon_sun_dragon_boss"] = true,
    ["wh3_dlc25_nur_cha_exalted_hero_chieftain_chaos_dragon"] = true,
    ["wh3_dlc25_nur_chieftain_mon_frost_wyrm_0"] = true,
    ["wh3_dlc27_def_mon_black_dragon_monst_arcanum"] = true,
    ["wh3_dlc27_hef_cha_sea_lord_aislinn_dragon"] = true,
    ["wh3_main_cth_cha_iron_dragon_0"] = true, --dragon in human form
    ["wh3_main_cth_cha_iron_dragon_1"] = true,
    ["wh3_main_cth_cha_storm_dragon_0"] = true, --dragon in human form
    ["wh3_main_cth_cha_storm_dragon_1"] = true,
    ["wh_dlc01_chs_cha_chaos_lord_2"] = true,
    ["wh_dlc01_chs_cha_chaos_sorcerer_lord_death_10"] = true,
    ["wh_dlc01_chs_cha_chaos_sorcerer_lord_fire_10"] = true,
    ["wh_dlc01_chs_cha_chaos_sorcerer_lord_metal_10"] = true,
    ["wh_dlc01_chs_cha_chaos_sorcerer_lord_shadows_4"] = true,
    ["wh_dlc05_wef_cha_female_glade_lord_3"] = true,
    ["wh_dlc05_wef_cha_glade_lord_3"] = true,
    ["wh_dlc05_wef_forest_dragon_0"] = true,
    ["wh_dlc08_chs_cha_chaos_lord_2_qb"] = true,
    ["wh_dlc08_nor_cha_kihar_0"] = true,
    ["wh_dlc08_nor_mon_frost_wyrm_0"] = true,
    ["wh_dlc08_nor_mon_frost_wyrm_boss"] = true,
    ["wh_dlc08_nor_mon_frost_wyrm_ror_0"] = true,
    ["wh_dlc08_wef_forest_dragon_boss"] = true,
}


local function rhox_zach_count_dragons_in_cached_side(is_attacker_side)
    local count = 0
    local num = is_attacker_side and cm:pending_battle_cache_num_attackers() or cm:pending_battle_cache_num_defenders()
    for i = 1, num do
        local units = is_attacker_side and cm:pending_battle_cache_get_attacker_units(i) or cm:pending_battle_cache_get_defender_units(i)
        for j = 1, #units do
            if rhox_zach_dragon_unit_keys[units[j].unit_key] then
                count = count + 1
            end
        end
    end
    return count
end

local function rhox_zach_force_has_dragon(military_force)
    local unit_list = military_force:unit_list()
    for i = 0, unit_list:num_items() - 1 do
        if rhox_zach_dragon_unit_keys[unit_list:item_at(i):unit_key()] then
            return true
        end
    end
    return false
end

local function rhox_zach_give_dragon_blood(faction, dragon_count, mf_cqi)
    local amount = math.min(power_base_amount + power_per_dragon * dragon_count, power_max_amount)

    if faction:is_human() then
        local incident_builder = cm:create_incident_builder(blood_incident_key)
        local military_force = mf_cqi and cm:get_military_force_by_cqi(mf_cqi)
        if military_force and not military_force:is_null_interface() then
            incident_builder:add_target("default", military_force)
        end
        local payload_builder = cm:create_payload()
        payload_builder:faction_pooled_resource_transaction(power_resource_key, power_factor_key, amount, false)
        incident_builder:set_payload(payload_builder)
        cm:launch_custom_incident_from_builder(incident_builder, faction)
    else
        cm:faction_add_pooled_resource(faction:name(), power_resource_key, power_factor_key, amount)
    end
end

core:add_listener(
    "rhox_zach_dragon_battle_completed",
    "BattleCompleted",
    function(context)
        return cm:model():pending_battle():has_been_fought()
    end,
    function(context)
        for faction_key, _ in pairs(zach_faction_keys) do
            if cm:pending_battle_cache_faction_won_battle(faction_key) then
                local is_attacker = cm:pending_battle_cache_faction_is_attacker(faction_key)
                local dragon_count = rhox_zach_count_dragons_in_cached_side(not is_attacker)
                if dragon_count > 0 then
                    local faction = cm:get_faction(faction_key)
                    local zach_mf_cqi = nil
                    local first_mf_cqi = nil
                    local num = is_attacker and cm:pending_battle_cache_num_attackers() or cm:pending_battle_cache_num_defenders()
                    for i = 1, num do
                        local char_cqi, mf_cqi, side_faction_key
                        local subtype
                        if is_attacker then
                            char_cqi, mf_cqi, side_faction_key = cm:pending_battle_cache_get_attacker(i)
                            subtype = cm:pending_battle_cache_get_attacker_subtype(i)
                        else
                            char_cqi, mf_cqi, side_faction_key = cm:pending_battle_cache_get_defender(i)
                            subtype = cm:pending_battle_cache_get_defender_subtype(i)
                        end
                        if side_faction_key == faction_key then
                            first_mf_cqi = first_mf_cqi or mf_cqi
                            if subtype == zach_subtype then
                                zach_mf_cqi = mf_cqi
                                local character = cm:get_character_by_cqi(char_cqi)
                                if character and not character:is_null_interface() then
                                    cm:force_add_trait(cm:char_lookup_str(character), dragon_trait_key, true, dragon_count)
                                end
                            end
                        end
                    end
                    if faction and not faction:is_null_interface() then
                        rhox_zach_give_dragon_blood(faction, dragon_count, zach_mf_cqi or first_mf_cqi)
                    end
                end
            end
        end
    end,
    true
)


--returns the cqi of the chosen target force (or nil), the number of forces checked and the number of dragon forces found
local function rhox_zach_find_dragon_hunt_target(zach_faction)
    local zach_positions = {}
    local zach_forces = zach_faction:military_force_list()
    for i = 0, zach_forces:num_items() - 1 do
        local mf = zach_forces:item_at(i)
        if mf:has_general() and not mf:is_armed_citizenry() then
            local general = mf:general_character()
            table.insert(zach_positions, {x = general:logical_position_x(), y = general:logical_position_y()})
        end
    end
    if #zach_positions == 0 then
        return nil, 0, 0
    end

    local best_war_cqi, best_war_dist = nil, math.huge
    local best_other_cqi, best_other_dist = nil, math.huge
    local checked_count = 0
    local dragon_force_count = 0

    local faction_list = cm:model():world():faction_list()
    for i = 0, faction_list:num_items() - 1 do
        local faction = faction_list:item_at(i)
        if faction:name() ~= zach_faction:name() and not faction:is_dead() and not faction:allied_with(zach_faction) and not faction:is_vassal_of(zach_faction) and not zach_faction:is_vassal_of(faction) then
            local at_war = zach_faction:at_war_with(faction)
            local force_list = faction:military_force_list()
            for j = 0, force_list:num_items() - 1 do
                local mf = force_list:item_at(j)
                if mf:has_general() and not mf:is_armed_citizenry() then
                    checked_count = checked_count + 1
                    if rhox_zach_force_has_dragon(mf) then
                        dragon_force_count = dragon_force_count + 1
                        local general = mf:general_character()
                        local x, y = general:logical_position_x(), general:logical_position_y()
                        local dist = math.huge
                        for k = 1, #zach_positions do
                            dist = math.min(dist, distance_squared(x, y, zach_positions[k].x, zach_positions[k].y))
                        end
                        if at_war then
                            if dist < best_war_dist then
                                best_war_cqi, best_war_dist = mf:command_queue_index(), dist
                            end
                        elseif dist < best_other_dist then
                            best_other_cqi, best_other_dist = mf:command_queue_index(), dist
                        end
                    end
                end
            end
        end
    end

    return best_war_cqi or best_other_cqi, checked_count, dragon_force_count
end

local function rhox_zach_issue_dragon_hunt_mission(zach_faction, target_cqi)
    local faction_key = zach_faction:name()
    local mm = mission_manager:new(faction_key, hunt_mission_key)
    mm:add_new_objective("ENGAGE_FORCE")
    mm:add_condition("cqi " .. target_cqi)
    mm:add_condition("requires_victory")
    for i = 1, #hunt_mission_payloads do
        mm:add_payload(hunt_mission_payloads[i])
    end
    mm:set_turn_limit(hunt_mission_turn_limit)
    mm:set_should_cancel_before_issuing(false)
    mm:trigger()
    cm:set_saved_value("rhox_zach_dragon_hunt_active_" .. faction_key, true)
    cm:set_saved_value("rhox_zach_dragon_hunt_last_turn_" .. faction_key, cm:model():turn_number())
end

local function rhox_zach_try_dragon_hunt_mission(zach_faction)
    local target_cqi = rhox_zach_find_dragon_hunt_target(zach_faction)
    if target_cqi then
        rhox_zach_issue_dragon_hunt_mission(zach_faction, target_cqi)
        return true
    end
    return false
end

core:add_listener(
    "rhox_zach_dragon_hunt_turn_start",
    "FactionTurnStart",
    function(context)
        local faction = context:faction()
        if not zach_faction_keys[faction:name()] or not faction:is_human() then
            return false
        end
        local faction_key = faction:name()
        local turn = cm:model():turn_number()
        if turn < hunt_mission_min_turn or cm:get_saved_value("rhox_zach_dragon_hunt_active_" .. faction_key) then
            return false
        end
        local last_turn = cm:get_saved_value("rhox_zach_dragon_hunt_last_turn_" .. faction_key) or -hunt_mission_cooldown
        return turn - last_turn >= hunt_mission_cooldown and cm:random_number(100) <= hunt_mission_chance
    end,
    function(context)
        rhox_zach_try_dragon_hunt_mission(context:faction())
    end,
    true
)

core:add_listener(
    "rhox_zach_dragon_hunt_mission_ended",
    "MissionSucceeded",
    function(context)
        return context:mission():mission_record_key() == hunt_mission_key
    end,
    function(context)
        cm:set_saved_value("rhox_zach_dragon_hunt_active_" .. context:faction():name(), false)
    end,
    true
)
core:add_listener(
    "rhox_zach_dragon_hunt_mission_failed",
    "MissionFailed",
    function(context)
        return context:mission():mission_record_key() == hunt_mission_key
    end,
    function(context)
        cm:set_saved_value("rhox_zach_dragon_hunt_active_" .. context:faction():name(), false)
    end,
    true
)
core:add_listener(
    "rhox_zach_dragon_hunt_mission_cancelled",
    "MissionCancelled",
    function(context)
        return context:mission():mission_record_key() == hunt_mission_key
    end,
    function(context)
        cm:set_saved_value("rhox_zach_dragon_hunt_active_" .. context:faction():name(), false)
    end,
    true
)


--Debug: run the dragon force scan and print how long it took. Pass true to also issue the mission (ignores chance/cooldown, but not an already active mission).
function rhox_zach_debug_dragon_hunt(issue_mission)
    for faction_key, _ in pairs(zach_faction_keys) do
        local faction = cm:get_faction(faction_key)
        if faction and not faction:is_dead() then
            local start_time = os.clock()
            local target_cqi, checked_count, dragon_force_count = rhox_zach_find_dragon_hunt_target(faction)
            local elapsed_ms = (os.clock() - start_time) * 1000
            out("Rhox Zach dragon hunt debug: " .. faction_key .. " checked " .. checked_count .. " forces, found " .. dragon_force_count .. " with dragons, target cqi " .. tostring(target_cqi) .. ", took " .. string.format("%.2f", elapsed_ms) .. "ms")
            if issue_mission and target_cqi then
                if cm:get_saved_value("rhox_zach_dragon_hunt_active_" .. faction_key) then
                    out("Rhox Zach dragon hunt debug: mission already active, not issuing")
                else
                    rhox_zach_issue_dragon_hunt_mission(faction, target_cqi)
                end
            end
        end
    end
end
