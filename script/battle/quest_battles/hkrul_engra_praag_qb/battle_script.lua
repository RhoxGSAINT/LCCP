
load_script_libraries();

-------------------------------------------------------------------------------------------------
-- SETUP / GENERATED BATTLE -- native diagnostics (unchanged since 0.002/0.003f)
-------------------------------------------------------------------------------------------------

bm:out("--- CAPTURE LOCATIONS: bm:print_capture_locations() ---");
bm:print_capture_locations();
bm:out("");

bm:out("--- CAPTURE LOCATIONS: manual enumeration via capture_location_manager() ---");
local clm = bm.battle:capture_location_manager();
bm:out("capture_location_manager() reports " .. tostring(clm:count()) .. " capture location(s)");

for i = 1, clm:count() do
	local cl = clm:item(i);
	bm:out(
		"[" .. i .. "]" ..
		" unique_id=" .. tostring(cl:unique_id()) ..
		" script_id=" .. tostring(cl:script_id()) ..
		" type=" .. tostring(cl:type()) ..
		" position=" .. v_to_s(cl:position()) ..
		" contributes_to_victory=" .. tostring(cl:contributes_to_victory())
	);
end;
bm:out("");

bm:out("--- TOGGLE SLOTS: bm:print_toggle_slots() ---");
bm:print_toggle_slots();
bm:out("");

bm:out("--- SPAWN ZONES: bm:construct_spawn_zone_list() ---");
bm:construct_spawn_zone_list();
bm:out("");

local hkrul_capture_last_holder = {};

core:add_listener(
	"hkrul_engra_diag_capture_commenced",
	"BattleCaptureLocationCaptureCommenced",
	true,
	function(context)
		local cl = context:battle_capture_location();
		local contesting_unit = context:battle_unit();
		local uid = cl:unique_id();
		local new_holder = context:battle_holding_alliance_id();
		local previous_holder = hkrul_capture_last_holder[uid];

		bm:out(
			"[DIAG] CaptureCommenced" ..
			" unique_id=" .. tostring(uid) ..
			" script_id=" .. tostring(cl:script_id()) ..
			" type=" .. tostring(cl:type()) ..
			" position=" .. v_to_s(cl:position()) ..
			" contributes_to_victory=" .. tostring(cl:contributes_to_victory()) ..
			" event_type=Commenced" ..
			" previous_holder=" .. tostring(previous_holder == nil and "none" or previous_holder) ..
			" new_holder=" .. tostring(new_holder) ..
			" contesting_unit=" .. tostring(contesting_unit and contesting_unit:unique_ui_id() or "nil")
		);
	end,
	true
);

core:add_listener(
	"hkrul_engra_diag_capture_completed",
	"BattleCaptureLocationCaptureCompleted",
	true,
	function(context)
		local cl = context:battle_capture_location();
		local contesting_unit = context:battle_unit();
		local uid = cl:unique_id();
		local new_holder = context:battle_holding_alliance_id();
		local previous_holder = hkrul_capture_last_holder[uid];

		bm:out(
			"[DIAG] CaptureCompleted" ..
			" unique_id=" .. tostring(uid) ..
			" script_id=" .. tostring(cl:script_id()) ..
			" type=" .. tostring(cl:type()) ..
			" position=" .. v_to_s(cl:position()) ..
			" contributes_to_victory=" .. tostring(cl:contributes_to_victory()) ..
			" event_type=Completed" ..
			" previous_holder=" .. tostring(previous_holder == nil and "none" or previous_holder) ..
			" new_holder=" .. tostring(new_holder) ..
			" contesting_unit=" .. tostring(contesting_unit and contesting_unit:unique_ui_id() or "nil")
		);

		hkrul_capture_last_holder[uid] = new_holder;
	end,
	true
);
bm:out("");

-------------------------------------------------------------------------------------------------
-- 0.3 FIX (Task D, campaign deployment regression) -- restore cinematic-UI/camera state that
-- generated_battle leaves unset when the opening cutscene fires post-deployment-start (VANILLA
-- WH3 PRECEDENT: grom_the_paunch/final_battle, eltharion_the_grim/warden_of_tor_yvresse)
-------------------------------------------------------------------------------------------------

bm:camera():fade(false, 0);
bm:enable_cinematic_ui(false, true, false);		-- ensures UI is available during deployment

-------------------------------------------------------------------------------------------------
-- ACT I -- OUTER WARDS: capture hint (message-routed, unique_id=10, player alliance=2)

local HKRUL_ENGRA_OUTER_WARDS_UNIQUE_ID = 10;
local HKRUL_ENGRA_PLAYER_ALLIANCE_ID = 2;

core:add_listener(
	"hkrul_engra_outer_wards_hint",
	"BattleCaptureLocationCaptureCompleted",
	function(context)
		local cl = context:battle_capture_location();
		return cl:unique_id() == HKRUL_ENGRA_OUTER_WARDS_UNIQUE_ID
			and context:battle_holding_alliance_id() == HKRUL_ENGRA_PLAYER_ALLIANCE_ID;
	end,
	function(context)
		bm:out("PRAAG: point 10 capture condition satisfied");
		get_messager():trigger_message("praag_outer_wards_fallen");
	end,
	false		-- persistent = false: fires at most once, ever
);
bm:out("");

-------------------------------------------------------------------------------------------------
-- OPENING CUTSCENE / GENERATED BATTLE -- Engra's speech, then native siege begins
------

gb = generated_battle:new(
	false,	-- screen_starts_black
	false,	-- prevent_deployment_for_player
	false,	-- prevent_deployment_for_ai
	function() gb_start_opening_cutscene() end,
	false	-- is_debug
);


function gb_start_opening_cutscene()
	bm:out("PRAAG OPENING: cutscene start");
	local gc_opening = generated_cutscene:new(true, true);
	gc_opening:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 5500, false, false, false);
	gc_opening:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_far_high_01", 5000, false, false, false);
	gc_opening:add_element(nil, "hkrul_engra_praag_qb_0001_opening_shot3", "gc_orbit_90_medium_commander_front_close_low_01", 8500, false, false, false);
	gc_opening:add_element(nil, "hkrul_engra_praag_qb_0001_opening_shot4", "gc_slow_enemy_army_pan_front_left_to_front_right_far_high_01", 6000, false, false, false);
	gc_opening:add_element(nil, "hkrul_engra_praag_qb_0001_opening_shot5", "gc_slow_army_pan_front_left_to_front_right_far_high_01", 6000, false, false, false);
	gc_opening:add_element(nil, "hkrul_engra_praag_qb_0001_opening_shot6", "gc_orbit_90_medium_commander_front_close_low_01", 4500, false, true, false, "hkrul_engra_opening_cutscene_end");
	gb:start_generated_cutscene(gc_opening);
	bm:out("PRAAG OPENING: cutscene end (queued)");
end;


gb:queue_help_on_message("praag_outer_wards_fallen", "hkrul_engra_praag_qb_0001_hint_outer_wards", 2500, 400);

-------------------------------------------------------------------------------------------------
-- ARMY 2 -- INNER RESERVE (hidden Kislev force near Point 6, disable->teleport->enable->defend)
-------------------------------------------------------------------------------------------------

local ga_reserve = gb:get_army(gb:get_non_player_alliance_num(), "praag_reserve");

if ga_reserve then

	-- Independent physical battle.army, confirmed by runtime diagnostic in 0.04 testing
	-- (represents_full_logical_army=true) -- see QUEST_BATTLE_PATTERNS.md for the reusable finding.
	ga_reserve:set_enabled(false);

	local HKRUL_PRAAG_RESERVE_ANCHOR_X = -210;
	local HKRUL_PRAAG_RESERVE_ANCHOR_Z = 81;

	-- [x_offset, z_offset] per unit slot, relative to the anchor above.
	-- 0.3 REPAIR (Task C): rebuilt for the current 14-unit roster (was 7 slots for an
	-- already-14-unit roster -- units 8-14 fell through to "no offset/handle defined"). Slot order
	-- matches battle_set_piece_armies_units_junctions_tables row order for
	-- kossars x2, streltsi_ror x1, streltsi x1, little_grom x2, boyar x1,
	-- armoured_kossars x2. Laid out as a defensive line fanning back from the anchor:
	-- elite melee front rank, hero support just behind, infantry/ranged second rank,
	-- vehicles and boyar in support, armoured kossars anchoring the rear.
	local hkrul_praag_reserve_offsets = {
		{-24, 10},	-- [1] tzar guard (front rank, far-left)
		{-8,  10},	-- [2] tzar guard (front rank, centre-left)
		{8,   10},	-- [3] tzar guard (front rank, centre-right)
		{24,  10},	-- [4] tzar guard (front rank, far-right)
		{0,   4},	-- [5] frost maiden (hero, centre, just behind the line)
		{-16, -2},	-- [6] kossars (second rank, left)
		{16,  -2},	-- [7] kossars (second rank, right)
		{-8,  -8},	-- [8] streltsi ror (ranged, left)
		{8,   -8},	-- [9] streltsi (ranged, right)
		{-16, -14},	-- [10] little grom (vehicle, rear-left)
		{16,  -14},	-- [11] little grom (vehicle, rear-right)
		{0,   -8},	-- [12] boyar (hero, centre, leading from the ranged line)
		{-8,  -20},	-- [13] armoured kossars (rear-most, left)
		{8,   -20}	-- [14] armoured kossars (rear-most, right)
	};

	local hkrul_reserve_sunits = ga_reserve.sunits;
	local hkrul_reserve_count = hkrul_reserve_sunits:count();

	bm:out("[PRAAG RESERVE] sunits:count() = " .. tostring(hkrul_reserve_count));

	for i = 1, hkrul_reserve_count do
		local su = hkrul_reserve_sunits:item(i);
		local offset = hkrul_praag_reserve_offsets[i];

		if offset and su and su.unit then
			local target_x = HKRUL_PRAAG_RESERVE_ANCHOR_X + offset[1];
			local target_z = HKRUL_PRAAG_RESERVE_ANCHOR_Z + offset[2];
			local target_bearing = su.unit:bearing();
			local target_width = su.unit:ordered_width();

			su:teleport_to_location(v(target_x, target_z), target_bearing, target_width);

			bm:out(
				"[PRAAG RESERVE] unit " .. i .. " (" .. tostring(su.unit:name()) .. ")" ..
				" teleported to [" .. target_x .. ", " .. target_z .. "]" ..
				" bearing=" .. tostring(target_bearing) ..
				" width=" .. tostring(target_width)
			);
		else
			bm:out("[PRAAG RESERVE] WARNING: unit " .. i .. " has no offset/handle defined -- not teleported");
		end;
	end;
	bm:out("");

	-- Activates ~10s after battle start, then holds Point 6 under defend() -- VERIFIED IN OUR MOD.
	gb:message_on_time_offset("hkrul_praag_reserve_activate", 10000, "battle_started");

	local HKRUL_PRAAG_RESERVE_DEFEND_RADIUS = 45;

	gb:add_listener(
		"hkrul_praag_reserve_activate",
		function()
			ga_reserve:set_enabled(true);
			ga_reserve:defend(HKRUL_PRAAG_RESERVE_ANCHOR_X, HKRUL_PRAAG_RESERVE_ANCHOR_Z, HKRUL_PRAAG_RESERVE_DEFEND_RADIUS);
			bm:out("PRAAG RESERVE: enabled, defend position issued");
		end,
		true
	);

	-- Released to native/generated siege AI once the Act II cutscene genuinely ends -- mirrors
	-- Army 3's own release architecture exactly
	ga_reserve:release_on_message("hkrul_engra_act2_cutscene_end", 200);
else
	bm:out("[PRAAG RESERVE] ERROR: gb:get_army() returned nil for script_name \"praag_reserve\" -- reserve army handle not found");
end;
bm:out("");

-------------------------------------------------------------------------------------------------
-- ARMY 3 -- ARTILLERY RESERVE (Imperial guns under Kislev command, Point 11)
--

local ga_army3 = gb:get_army(gb:get_non_player_alliance_num(), "praag_army3");

if ga_army3 then

	ga_army3:set_enabled(false);

	local HKRUL_PRAAG_ARMY3_ANCHOR_X = -470;
	local HKRUL_PRAAG_ARMY3_ANCHOR_Z = 149;


	local hkrul_praag_army3_offsets = {
		{-21, -14},	-- [1] mortar (rear, far-left)
		{-7,  -14},	-- [2] mortar (rear, centre-left)
		{7,   -14},	-- [3] helstorm rocket battery (rear, centre-right)
		{21,  -14},	-- [4] helstorm rocket battery (rear, far-right)
		{-24,  10},	-- [5] halberdier (front screen, far-left)
		{-12,  10},	-- [6] halberdier (front screen, centre-left)
		{0,    10},	-- [7] tzar guard (front screen, centre)
		{12,   10},	-- [8] kossars (front screen, centre-right)
		{24,   10}	-- [9] kossars (front screen, far-right)
	};

	local hkrul_army3_sunits = ga_army3.sunits;
	local hkrul_army3_count = hkrul_army3_sunits:count();
	local hkrul_army3_teleported = 0;

	for i = 1, hkrul_army3_count do
		local su = hkrul_army3_sunits:item(i);
		local offset = hkrul_praag_army3_offsets[i];
		local su_type = (su and su.unit and tostring(su.unit:type())) or "nil";

		if offset and su and su.unit then
			local target_x = HKRUL_PRAAG_ARMY3_ANCHOR_X + offset[1];
			local target_z = HKRUL_PRAAG_ARMY3_ANCHOR_Z + offset[2];
			local target_bearing = su.unit:bearing();
			local target_width = su.unit:ordered_width();

			su:teleport_to_location(v(target_x, target_z), target_bearing, target_width);
			hkrul_army3_teleported = hkrul_army3_teleported + 1;

			bm:out(
				"PRAAG ARMY3 TELEPORT: unit " .. i .. " type=" .. su_type ..
				" teleported to [" .. target_x .. ", " .. target_z .. "]" ..
				" bearing=" .. tostring(target_bearing) ..
				" width=" .. tostring(target_width)
			);
		else
			bm:out("PRAAG ARMY3 TELEPORT: WARNING unit " .. i .. " type=" .. su_type .. " has no offset/handle defined -- NOT teleported");
		end;
	end;
	bm:out("PRAAG ARMY3: " .. tostring(hkrul_army3_teleported) .. " of " .. tostring(hkrul_army3_count) .. " units placed, awaiting praag_outer_wards_fallen");
	bm:out("");

	gb:add_listener(
		"praag_outer_wards_fallen",
		function()
			ga_army3:set_enabled(true);
			bm:out("PRAAG ARMY3: enabled, left under native/generated siege AI control");
		end,
		true
	);

	-- Visible for the Act II cutscene's shot of Point 11, then normal visibility restored.
	ga_army3:set_always_visible_on_message("praag_outer_wards_fallen", true);
	ga_army3:release_on_message("hkrul_engra_act2_cutscene_end", 200);
	ga_army3:set_always_visible_on_message("hkrul_engra_act2_cutscene_end", false);
else
	bm:out("[PRAAG ARMY3] ERROR: gb:get_army() returned nil for script_name \"praag_army3\" -- Army 3 handle not found");
end;
bm:out("");

-------------------------------------------------------------------------------------------------
-- ACT I -- OUTER WARDS: objective (locatable, Point 10)
--
-------------------------------------------------------------------------------------------------

gb:set_locatable_objective_on_message(
	"hkrul_engra_opening_cutscene_end",
	"hkrul_engra_praag_qb_0001_obj_act1",
	0,
	v(-158, 40, 260),		-- camera position: elevated, south of point 10
	v(-158, 5, 324),		-- camera target: point 10 (unique_id=10)
	3
);
gb:complete_objective_on_message("praag_outer_wards_fallen", "hkrul_engra_praag_qb_0001_obj_act1", 500);
bm:out("");

-------------------------------------------------------------------------------------------------
-- ACT II -- INNER DEFENCES: cutscene + objective + true-end disambiguation

-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("hkrul_engra_act2_cutscene_start", 4000, "praag_outer_wards_fallen");

gb:add_listener(
	"hkrul_engra_act2_cutscene_start",
	function()
		bm:out("PRAAG ACT2: cutscene start");
		local gc_act2 = generated_cutscene:new(true, true);
		gc_act2:add_element(nil, nil, "gc_orbit_90_medium_ground_offset_north_west_extreme_high_02", 4000, false, false, false);
		gc_act2:add_element(nil, "hkrul_engra_praag_qb_0001_act2_shot2", "gc_slow_enemy_army_pan_front_left_to_front_right_far_high_01", 5000, false, false, false);
		gc_act2:add_element(nil, nil, "gc_slow_army_pan_front_left_to_front_right_far_high_01", 4500, false, false, false);
		gc_act2:add_element(nil, "hkrul_engra_praag_qb_0001_act2_shot4", "gc_orbit_90_medium_commander_front_close_low_01", 4500, false, false, false);
		gc_act2:add_element(nil, nil, "qb_final_position_short", 3500, false, true, false, "hkrul_engra_act2_cutscene_end");
		gb:start_generated_cutscene(gc_act2);
	end,
	true
);

gb:set_objective_with_leader_on_message("hkrul_engra_act2_cutscene_end", "hkrul_engra_praag_qb_0001_obj_act2");
-- Left ACTIVE/uncompleted for the remainder of the battle -- native siege victory remains the
-- sole win condition, no further phase completes this objective explicitly. Same pattern is
-- reused deliberately for the Kholek survival objective below.
bm:out("");

local hkrul_praag_cutscene_end_count = 0;

gb.sm:add_listener(
	"generated_custscene_ended",
	function()
		hkrul_praag_cutscene_end_count = hkrul_praag_cutscene_end_count + 1;

		if hkrul_praag_cutscene_end_count == 1 then
			bm:out("OPENING CUTSCENE TRUE END");
			gb.sm:trigger_message("hkrul_engra_opening_cutscene_true_end");
		elseif hkrul_praag_cutscene_end_count == 2 then
			bm:out("ACT II CUTSCENE TRUE END");
			gb.sm:trigger_message("hkrul_engra_act2_cutscene_true_end");
		else
			bm:out("[PRAAG] WARNING: generated_custscene_ended received a " .. tostring(hkrul_praag_cutscene_end_count) .. " time -- no further true-end message mapped, ignoring");
		end;
	end,
	true
);
bm:out("");

-------------------------------------------------------------------------------------------------
-- TEMPORARY HINTS -- reserve taunt + artillery encouragement
--
-------------------------------------------------------------------------------------------------

gb:message_on_time_offset("hkrul_engra_reserve_hint", 80000, "hkrul_engra_opening_cutscene_end");
gb:queue_help_on_message("hkrul_engra_reserve_hint", "hkrul_engra_praag_qb_0001_hint_reserve");

gb:message_on_time_offset("hkrul_engra_artillery_hint", 18000, "hkrul_engra_act2_cutscene_true_end");
gb:queue_help_on_message("hkrul_engra_artillery_hint", "hkrul_engra_praag_qb_0001_hint_artillery");
bm:out("");

-------------------------------------------------------------------------------------------------
-- CAPTURE-POINT MARKERS -- Point 6 + Point 11 (genuine Eltharion-style ping-icon "yellow eye")
--

-------------------------------------------------------------------------------------------------

local HKRUL_PRAAG_YELLOW_EYE_POS = v(-210, 20, 81);

gb:add_ping_icon_on_message("hkrul_engra_reserve_hint", HKRUL_PRAAG_YELLOW_EYE_POS, 16, 0);
gb:remove_ping_icon_on_message("praag_outer_wards_fallen", HKRUL_PRAAG_YELLOW_EYE_POS, 0);

local HKRUL_PRAAG_POINT11_YELLOW_EYE_POS = v(-470, 20, 149);

-------------------------------------------------------------------------------------------------
-- TZAR GUARD FINAL RESERVE -- Point 11, permanent 2-unit force, never released
--

-------------------------------------------------------------------------------------------------

local ga_tzarguard = gb:get_army(gb:get_non_player_alliance_num(), "praag_tzarguard_final");

if ga_tzarguard then

	-- Independent physical battle.army, confirmed by runtime diagnostic in 0.04 testing
	-- (represents_full_logical_army=true) -- see QUEST_BATTLE_PATTERNS.md for the reusable finding.
	ga_tzarguard:set_enabled(false);

	local HKRUL_PRAAG_TZARGUARD_ANCHOR_X = -470;
	local HKRUL_PRAAG_TZARGUARD_ANCHOR_Z = 149;

	local hkrul_praag_tzarguard_offsets = {
		{-6, 0},
		{6,  0}
	};

	local hkrul_tzarguard_sunits = ga_tzarguard.sunits;
	local hkrul_tzarguard_count = hkrul_tzarguard_sunits:count();

	for i = 1, hkrul_tzarguard_count do
		local su = hkrul_tzarguard_sunits:item(i);
		local offset = hkrul_praag_tzarguard_offsets[i];

		if offset and su and su.unit then
			local target_x = HKRUL_PRAAG_TZARGUARD_ANCHOR_X + offset[1];
			local target_z = HKRUL_PRAAG_TZARGUARD_ANCHOR_Z + offset[2];
			local target_bearing = su.unit:bearing();
			local target_width = su.unit:ordered_width();

			su:teleport_to_location(v(target_x, target_z), target_bearing, target_width);

			bm:out(
				"[PRAAG TZAR GUARD] unit " .. i .. " teleported to [" .. target_x .. ", " .. target_z .. "]" ..
				" bearing=" .. tostring(target_bearing) .. " width=" .. tostring(target_width)
			);
		else
			bm:out("[PRAAG TZAR GUARD] WARNING: unit " .. i .. " has no offset/handle defined -- not teleported");
		end;
	end;
	bm:out("");

	-- 0.05 POLISH (Section 3): once revealed as the final scripted last stand, the Tzar Guard
	-- remain visible for the rest of the battle. Activation time, position, defend() radius, hint,
	-- and the Point 11 marker are unaffected by this addition.
	ga_tzarguard:set_always_visible_on_message("hkrul_engra_tzarguard_activate", true);

	gb:message_on_time_offset("hkrul_engra_tzarguard_activate", 60000, "hkrul_engra_act2_cutscene_true_end");

	local HKRUL_PRAAG_TZARGUARD_DEFEND_RADIUS = 20;

	gb:add_listener(
		"hkrul_engra_tzarguard_activate",
		function()
			ga_tzarguard:set_enabled(true);
			ga_tzarguard:defend(HKRUL_PRAAG_TZARGUARD_ANCHOR_X, HKRUL_PRAAG_TZARGUARD_ANCHOR_Z, HKRUL_PRAAG_TZARGUARD_DEFEND_RADIUS);
			bm:out("TZAR GUARD FINAL RESERVE: enabled, defend order issued");
			-- NOTE: no release()/release_on_message() call is ever made for this army, by design --
			-- it remains under the scripted defend() planner for the rest of the battle.
		end,
		true
	);

	-- Hint registered before the marker on the same trigger message -- required ordering,
	-- QUEST_BATTLE_PATTERNS.md §24.
	gb:queue_help_on_message("hkrul_engra_tzarguard_activate", "hkrul_engra_praag_qb_0001_hint_tzarguard");
	gb:add_ping_icon_on_message("hkrul_engra_tzarguard_activate", HKRUL_PRAAG_POINT11_YELLOW_EYE_POS, 16, 0);
else
	bm:out("[PRAAG TZAR GUARD] ERROR: gb:get_army() returned nil for script_name \"praag_tzarguard_final\" -- Tzar Guard handle not found");
end;
bm:out("");

-------------------------------------------------------------------------------------------------
-- KHOLEK REINFORCEMENT -- Point 10 breach, Act II cutscene start/true-end
--
-------------------------------------------------------------------------------------------------

local ga_kholek = gb:get_army(gb:get_player_alliance_num(), "praag_kholek");

if ga_kholek then

	ga_kholek:set_enabled(false);

	local HKRUL_PRAAG_KHOLEK_ANCHOR_X = -197;
	local HKRUL_PRAAG_KHOLEK_ANCHOR_Z = 302;
	local HKRUL_PRAAG_KHOLEK_DEFEND_RADIUS = 30;

	-- Kholek spearheading with Chaos Spawn skirmishing ahead of him, Dragon Ogres forming
	-- the heavy second wave either side.
	local hkrul_praag_kholek_offsets = {
		{0,   10},	-- [1] spearhead (Kholek or Chaos Spawn, front-centre)
		{-10,  6},	-- [2] Chaos Spawn (left)
		{10,   6},	-- [3] Chaos Spawn (right)
		{0,    2},	-- [4] Chaos Spawn / Kholek (centre)
		{-16, -4},	-- [5] Dragon Ogre (far-left)
		{-6,  -4},	-- [6] Dragon Ogre (left)
		{6,   -4},	-- [7] Dragon Ogre (right)
		{16,  -4}	-- [8] Dragon Ogre (far-right)
	};

	local hkrul_kholek_sunits = ga_kholek.sunits;
	local hkrul_kholek_count = hkrul_kholek_sunits:count();

	bm:out("[PRAAG KHOLEK] sunits:count() = " .. tostring(hkrul_kholek_count) .. " (Kholek + 3x Chaos Spawn + 4x Dragon Ogre)");

	for i = 1, hkrul_kholek_count do
		local su = hkrul_kholek_sunits:item(i);
		local offset = hkrul_praag_kholek_offsets[i];

		if offset and su and su.unit then
			local target_x = HKRUL_PRAAG_KHOLEK_ANCHOR_X + offset[1];
			local target_z = HKRUL_PRAAG_KHOLEK_ANCHOR_Z + offset[2];
			local target_bearing = 272.8125;
			local target_width = su.unit:ordered_width();
			-- 0.005 FIX: was su.unit:unit_type() (not a real accessor -- always fell through to
			-- "unknown"). Corrected to su.unit:type(), the same CA-correct accessor Army 3's own
			-- diagnostic uses above.
			local hkrul_kholek_unit_type = tostring(su.unit:type());

			su:teleport_to_location(v(target_x, target_z), target_bearing, target_width);

			bm:out(
				"[PRAAG KHOLEK] unit " .. i .. " (" .. hkrul_kholek_unit_type .. ") teleported to [" ..
				target_x .. ", " .. target_z .. "] bearing=" .. tostring(target_bearing) ..
				" width=" .. tostring(target_width)
			);
		else
			bm:out("[PRAAG KHOLEK] WARNING: unit " .. i .. " has no offset/handle defined -- not teleported");
		end;
	end;
	bm:out("");

	-- combat AI instead of handing him to native/general AI. Everything else about this army
	-- (teleport, enable/defend on cutscene start, hint, survival objective) is unchanged.
	ga_kholek:attack_on_message("hkrul_engra_act2_cutscene_true_end", 200);

	gb:add_listener(
		"hkrul_engra_act2_cutscene_start",
		function()
			ga_kholek:set_enabled(true);
			ga_kholek:defend(HKRUL_PRAAG_KHOLEK_ANCHOR_X, HKRUL_PRAAG_KHOLEK_ANCHOR_Z, HKRUL_PRAAG_KHOLEK_DEFEND_RADIUS);
		end,
		true
	);


	gb:message_on_time_offset("hkrul_engra_kholek_hint", 3500, "hkrul_engra_act2_cutscene_true_end");
	gb:queue_help_on_message("hkrul_engra_kholek_hint", "hkrul_engra_praag_qb_0001_hint_kholek");


	ga_kholek:message_on_commander_dead_or_shattered("hkrul_engra_kholek_dead_or_shattered");

	gb:set_locatable_objective_callback_on_message(
		"hkrul_engra_kholek_hint",
		"hkrul_engra_praag_qb_0001_obj_kholek",
		0,
		function()
			local sunit = ga_kholek.sunits:get_general_sunit();
			if sunit then
				local cam_targ = sunit.unit:position();

				bm:out("[PRAAG KHOLEK][OBJ-CALLBACK] live position=" .. v_to_s(cam_targ));
				local cam_pos = v_offset_by_bearing(
					cam_targ,
					get_bearing(cam_targ, bm:camera():position()),
					75,
					d_to_r(30)
				);
				return cam_pos, cam_targ;
			else
				bm:out("[PRAAG KHOLEK][OBJ-CALLBACK] ERROR: get_general_sunit() found no general -- objective camera cannot resolve a target");
			end;
		end,
		2
	);
	gb:fail_objective_on_message("hkrul_engra_kholek_dead_or_shattered", "hkrul_engra_praag_qb_0001_obj_kholek", 2500);

	gb:add_listener(
		"hkrul_engra_kholek_dead_or_shattered",
		function()
			bm:out("HKRUL_005: Kholek commander_dead_or_shattered fired -- survival objective failing");
		end,
		true
	);
else
	bm:out("[PRAAG KHOLEK] ERROR: gb:get_army() returned nil for script_name \"praag_kholek\" -- Kholek handle not found");
end;
bm:out("");

-------------------------------------------------------------------------------------------------
-- VICTORY / NATIVE SIEGE
-------------------------------------------------------------------------------------------------

if core:is_tweaker_set("ALLOW_ADVICE_IN_CUSTOM_BATTLE") then
	bm:out("\tLoading advice");
	require("wh_battle_advice");
else
	bm:out("\tNot loading advice");
end;

bm:load_scripted_tours();
