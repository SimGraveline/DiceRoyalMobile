function scr_pair_update() {
	if (!global.pair_active) return;

	// --- Movement ---
	var _acted = false;
	var _dir = 0;
	if (global.input_left) _dir = -1;
	if (global.input_right) _dir = 1;

	if (_dir != 0) {
		var _move = false;
		if (_dir != global.das_direction) {
			_move = true;
			global.das_timer = 0;
			global.das_direction = _dir;
		} else {
			global.das_timer += delta_time / DELTA_TO_SECONDS;
			if (global.das_timer >= DAS_DELAY) {
				global.das_timer -= DAS_REPEAT;
				_move = true;
			}
		}

		if (_move) {
			var _new_col = global.pair_col + _dir;
			var _new_slave_col = _new_col + global.pair_offset_col;
			if (_new_col >= 0 && _new_col < GRID_COLS && _new_slave_col >= 0 && _new_slave_col < GRID_COLS
				&& !scr_grid_cell_blocked(_new_col, global.pair_row)
				&& !scr_grid_cell_blocked(_new_slave_col, global.pair_row + global.pair_offset_row)) {
				global.pair_col = _new_col;
				_acted = true;
			}
		}
	} else {
		global.das_timer = 0;
		global.das_direction = 0;
	}

	// --- Rotation ---
	if (global.input_rotate_cw && scr_pair_rotate(true)) _acted = true;
	if (global.input_rotate_ccw && scr_pair_rotate(false)) _acted = true;

	// --- Check if pair is resting on something (after move/rotate, so it reflects the
	// current shape/position — not a stale value from before this frame's changes) ---
	var _master_on_ground = scr_grid_cell_blocked(global.pair_col, global.pair_row - 1);
	var _slave_col = global.pair_col + global.pair_offset_col;
	var _slave_row = global.pair_row + global.pair_offset_row;
	var _slave_on_ground = scr_grid_cell_blocked(_slave_col, _slave_row - 1);
	var _touching = _master_on_ground || _slave_on_ground;

	// --- Lock delay ---
	if (_touching) {
		if (!global.lock_active) {
			global.lock_active = true;
			global.lock_timer = 0;
			global.lock_resets = 0;
		}

		if (_acted && global.lock_resets < LOCK_RESETS_MAX) {
			global.lock_timer = 0;
			global.lock_resets += 1;
		}

		global.lock_timer += delta_time / DELTA_TO_SECONDS;

		if (global.lock_timer >= LOCK_DELAY) {
			scr_pair_detach();
			global.lock_active = false;
			return;
		}
	} else {
		global.lock_active = false;
	}

	// --- Hard drop ---
	if (global.input_hard_drop) {
		while (true) {
			var _mb = scr_grid_cell_blocked(global.pair_col, global.pair_row - 1);
			var _sc = global.pair_col + global.pair_offset_col;
			var _sr = global.pair_row + global.pair_offset_row;
			var _sb = scr_grid_cell_blocked(_sc, _sr - 1);
			if (_mb || _sb) break;
			global.pair_row -= 1;
		}
		scr_pair_detach();
		global.lock_active = false;
		return;
	}

	// --- Drop ---
	if (!_touching) {
		global.drop_timer += delta_time / DELTA_TO_SECONDS;
		var _speed = global.drop_speed;
		if (global.input_soft_drop) {
			_speed = global.drop_speed / SOFT_DROP_MULTIPLIER;
		}

		if (global.drop_timer >= _speed) {
			global.drop_timer -= _speed;
			global.pair_row -= 1;
		}
	}
}

// --- Spawn next pair at previous X ---
function scr_pair_spawn_next() {
	global.drop_timer = 0;
	scr_chain_finalize();
	global.combo_count = 0;
	global.hold_used = false;
	scr_pair_spawn();
	global.pair_col = global.last_pair_col;

	var _slave_col = global.pair_col + global.pair_offset_col;
	if (_slave_col >= GRID_COLS) {
		global.pair_col = GRID_COLS - 2;
	}
	if (global.pair_col < 0) {
		global.pair_col = 0;
	}
}