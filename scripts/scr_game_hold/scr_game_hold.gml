function scr_game_hold() {
	if (!global.pair_active || global.hold_used) return;

	var _old_v1 = global.pair_val1;
	var _old_v2 = global.pair_val2;

	if (global.hold_val1 < 0) {
		// Hold is empty — store current, spawn next
		global.hold_val1 = _old_v1;
		global.hold_val2 = _old_v2;
		scr_pair_spawn();
		global.pair_col = global.last_pair_col;
		var _slave_col = global.pair_col + global.pair_offset_col;
		if (_slave_col >= GRID_COLS) {
			global.pair_col = GRID_COLS - 2;
		}
		if (global.pair_col < 0) {
			global.pair_col = 0;
		}
	} else {
		// Swap — hold pair takes current position and orientation
		global.pair_val1 = global.hold_val1;
		global.pair_val2 = global.hold_val2;
		global.hold_val1 = _old_v1;
		global.hold_val2 = _old_v2;
	}

	global.hold_used = true;
	global.drop_timer = 0;
	global.lock_active = false;
}