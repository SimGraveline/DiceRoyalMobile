function scr_die_place(_col, _row, _val) {
	global.grid_squash[_col][_row] = SQUASH_DURATION;

	if (_val == DIE_MIMIC) {
		var _below = (_row > 0) ? global.grid[_col][_row - 1] : 0;
		if (_below >= 1 && _below <= PAIR_MAX_VALUE) {
			global.grid[_col][_row] = _below;
		} else {
			global.grid[_col][_row] = DIE_MIMIC;
		}
		global.grid_special[_col][_row] = DIE_MIMIC;
		scr_die_try_activate_below(_col, _row, DIE_MIMIC);
	} else if (_val == DIE_BOMB) {
		var _below = (_row > 0) ? global.grid[_col][_row - 1] : 0;
		if (scr_die_bomb_valid_target(_below)) {
			scr_die_bomb_activate(_col, _row, _below);
		} else {
			global.grid[_col][_row] = DIE_BOMB;
			global.grid_special[_col][_row] = DIE_BOMB;
		}
	} else if (_val == DIE_BRICK) {
		global.grid[_col][_row] = DIE_BRICK;
		global.grid_special[_col][_row] = DIE_BRICK;
		scr_die_try_activate_below(_col, _row, DIE_BRICK);
	} else if (_val == DIE_CLEAR_R || _val == DIE_CLEAR_C) {
		scr_die_clear_write(_col, _row, _val == DIE_CLEAR_R);
	} else if (_val == DIE_RANDOM) {
		var _locked = global.pair_random_val;
		global.grid[_col][_row] = _locked;
		global.grid_special[_col][_row] = 0;
		scr_die_try_activate_below(_col, _row, _locked);
	} else {
		global.grid[_col][_row] = _val;
		global.grid_special[_col][_row] = 0;
		scr_die_try_activate_below(_col, _row, _val);
	}
}
