local culture_of_men={
    "wh_main_emp_empire", 
    "wh_main_brt_bretonnia", 
    "wh3_main_ksl_kislev", 
    "wh3_main_cth_cathay",
    "mixer_teb_southern_realms",
    "ovn_albion",
    "ovn_amazon",
    "ovn_araby",
    "ovn_halflings",
    "mixer_nip_nippon",
    "mixer_ind_ind"
}

core:add_listener(
    "rhox_aelfric_battle_completed",
    "CharacterCompletedBattle",
    function(context)
        local character = context:character()
        local faction = character:faction()
        local pb = context:pending_battle();
        

        return faction:name() == "cr_chs_iron_wolves" and pb:has_been_fought() and character:won_battle() and cm:character_won_battle_against_culture(character, culture_of_men) and character:military_force() 
    end,
    function(context)
        local character = context:character()
        local faction = character:faction()
        local military_force = character:military_force() 
        
        if not military_force or military_force:is_null_interface() then
            return
        end
        
        local unit_list = military_force:unit_list()
        if unit_list:num_items() >= 20 then
            return
        end
        
        if faction:is_human() then
            local incident_builder = cm:create_incident_builder("rhox_aelfric_wolf_unit_incident")
            incident_builder:add_target("default", military_force)
            cm:launch_custom_incident_from_builder(incident_builder, faction)
        end
        local character_lookup_str = cm:char_lookup_str(character)
        cm:grant_unit_to_character(character_lookup_str, "wh_dlc08_nor_mon_warwolves_0")
    end,
    true
)