function scr_junk_drop(){

}

// Rolls a fresh random trigger target for the next cycle (called at init/restart and right
// after each drop resolves) — each cycle's target is independent, no carryover between cycles.
function scr_junk_drop_roll_target() {
	if (global.level >= LEVEL_ENDLESS_TIER_LEVEL) {
		return irandom_range(JUNK_DROP_SPAWN_INTERVAL_LATE_MIN, JUNK_DROP_SPAWN_INTERVAL_LATE_MAX);
	}
	return irandom_range(JUNK_DROP_SPAWN_INTERVAL_MIN, JUNK_DROP_SPAWN_INTERVAL_MAX);
}

// Called on every pair spawn — counts toward the next Junk Drop trigger
function scr_junk_drop_track_spawn() {
	if (global.level < DICE_JUNK_UNLOCK_LEVEL) return;
	if (global.junk_state != "none") return;

	global.junk_spawn_counter += 1;
	if (global.junk_spawn_counter >= global.junk_spawn_target) {
		global.junk_spawn_counter = 0;
		global.junk_spawn_target = scr_junk_drop_roll_target();
		scr_junk_drop_queue();
	}
}

// Same weighting formula as scr_pair_weighted_random, restricted to normal values + Brick
// (Junk Drop never carries Mimic/Bomb/Random) — keeps Brick's odds consistent with pair spawn
function scr_junk_weighted_random() {
	var _normal_total = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_normal_total += global.spawn_weights[_i];
	}

	var _is_endless_tier = (global.level >= LEVEL_ENDLESS_TIER_LEVEL);
	var _brick_chance = _is_endless_tier ? DICE_ENDLESS_CHANCE : DICE_BRICK_CHANCE;
	var _w_b = (global.level >= DICE_BRICK_UNLOCK_LEVEL) ? (_normal_total / (_brick_chance - 1)) : 0;

	var _total = _normal_total + _w_b;
	var _roll  = random(_total);

	if (_roll < _w_b) return DIE_BRICK;
	_roll -= _w_b;

	var _sum = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_sum += global.spawn_weights[_i];
		if (_roll < _sum) return _i;
	}
	for (var _i = PAIR_MAX_VALUE; _i >= PAIR_MIN_VALUE; _i--) {
		if (global.spawn_weights[_i] > 0) return _i;
	}
	return PAIR_MIN_VALUE;
}

// Picks columns/values and enters the telegraph state (0.5 alpha, dead zone)
function scr_junk_drop_queue() {
	// Ramps 1 (at unlock) to JUNK_DROP_MAX_QTY over subsequent levels, then holds
	var _qty = clamp(global.level - (DICE_JUNK_UNLOCK_LEVEL - 1), 1, JUNK_DROP_MAX_QTY);

	var _safe_cols = [];
	for (var _c = 0; _c < GRID_COLS; _c++) {
		if (global.grid[_c][DEAD_ZONE_ROW] == 0) {
			array_push(_safe_cols, _c);
		}
	}
	if (array_length(_safe_cols) == 0) return;
	if (_qty > array_length(_safe_cols)) _qty = array_length(_safe_cols);

	global.junk_queue = [];
	for (var _i = 0; _i < _qty; _i++) {
		var _idx = irandom(array_length(_safe_cols) - 1);
		var _col = _safe_cols[_idx];
		array_delete(_safe_cols, _idx, 1);

		var _val = scr_junk_weighted_random();

		array_push(global.junk_queue, { col: _col, val: _val });
	}

	global.junk_state = "telegraph";
}

// Waits for the grid to be fully idle, then starts the fall
function scr_junk_drop_check_start() {
	if (global.junk_state != "telegraph") return;
	if (global.pair_active) return;

	for (var _c = 0; _c < GRID_COLS; _c++) {
		for (var _r = 0; _r <= GRID_ROWS; _r++) {
			if (global.grid_dying[_c][_r] > 0) return;
		}
	}

	global.junk_falling = global.junk_queue;
	global.junk_queue = [];
	for (var _i = 0; _i < array_length(global.junk_falling); _i++) {
		global.junk_falling[_i].row = DEAD_ZONE_ROW;
	}
	global.junk_drop_timer = 0;
	global.junk_state = "falling";
	global.combo_count = 0;
}

// Animates the fall at a fixed pace (does not scale with level), lands each die individually
function scr_junk_drop_update() {
	if (global.junk_state != "falling") return;

	global.junk_drop_timer += delta_time / DELTA_TO_SECONDS;
	if (global.junk_drop_timer < JUNK_DROP_SPEED) return;
	global.junk_drop_timer -= JUNK_DROP_SPEED;

	for (var _i = array_length(global.junk_falling) - 1; _i >= 0; _i--) {
		var _d = global.junk_falling[_i];
		var _steps = JUNK_DROP_STEP;
		while (_steps > 0 && !scr_grid_cell_blocked(_d.col, _d.row - 1)) {
			_d.row -= 1;
			_steps -= 1;
		}
		if (scr_grid_cell_blocked(_d.col, _d.row - 1)) {
			scr_die_place(_d.col, _d.row, _d.val);
			scr_grid_check_join(_d.col, _d.row);
			scr_grid_match();
			array_delete(global.junk_falling, _i, 1);
		}
	}

	if (array_length(global.junk_falling) == 0) {
		global.junk_state = "none";
	}
}

// Draws the telegraph (dead zone, 0.5 alpha) and the falling dice (1.0 alpha) — no ghost
function scr_junk_drop_draw() {
	if (global.junk_state == "telegraph") {
		for (var _i = 0; _i < array_length(global.junk_queue); _i++) {
			var _d = global.junk_queue[_i];
			scr_die_draw(_d.col, DEAD_ZONE_ROW, _d.val, JUNK_PREVIEW_ALPHA);
		}
	} else if (global.junk_state == "falling") {
		for (var _i = 0; _i < array_length(global.junk_falling); _i++) {
			var _d = global.junk_falling[_i];
			scr_die_draw(_d.col, _d.row, _d.val, 1.0);
		}
	}
}
