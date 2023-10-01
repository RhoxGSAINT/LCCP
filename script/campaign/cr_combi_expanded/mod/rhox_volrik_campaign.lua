local rhox_volrik_gift_units = {
	---unit_key, recruitment_source_key,  starting amount, replen chance, max in pool
		{"wh3_main_tze_mon_flamers_0", "daemonic_summoning", 0, 0, 4},
		{"wh3_main_tze_mon_lord_of_change_0", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc20_chs_mon_warshrine", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc20_chs_mon_warshrine_mtze", "daemonic_summoning", 0, 0, 2},
		{"wh3_main_tze_mon_soul_grinder_0", "daemonic_summoning", 0, 0, 2},
		{"wh3_main_tze_inf_pink_horrors_0", "daemonic_summoning", 1, 0, 4},
		{"wh_main_chs_art_hellcannon", "daemonic_summoning", 0, 0, 4},
		{"wh3_main_tze_mon_screamers_0", "daemonic_summoning", 0, 0, 4},
		{"wh3_dlc24_tze_mon_mutalith_vortex_beast", "daemonic_summoning", 0, 0, 2},
		{"wh3_dlc24_tze_mon_cockatrice", "daemonic_summoning", 0, 0, 4}
}

----------------------Granting gift stuff for the AI
core:add_listener(
    "rhox_volrik_ai_gift",
    "FactionTurnStart",
    function (context)
        local faction = context:faction()
        return faction:name()=="cr_nor_avags" and faction:is_human() == false and cm:turn_number()%3 ==0
    end,
    function(context)
        local unit_list = weighted_list:new();
        for i, v in pairs(rhox_volrik_gift_units) do
            unit_list:add_item(v[1], v[5]);
		end
		cm:add_units_to_faction_mercenary_pool(context:faction():command_queue_index(), unit_list:weighted_select(), 1)
    end,
    true
)