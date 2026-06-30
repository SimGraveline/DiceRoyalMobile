function scr_die_bomb_activate(_col, _row, _target_val) {
	global.grid[_col][_row] = 0;
	global.grid_special[_col][_row] = 0;
	var _found = false;
	for (var _c = 0; _c < GRID_COLS; _c++) {
		for (var _r = 0; _r <= GRID_ROWS; _r++) {
			if (global.grid[_c][_r] == _target_val && global.grid_dying[_c][_r] == 0) {
				global.grid_dying[_c][_r] = DYING_DURATION;
				_found = true;
			}
		}
	}
	if (_found) {
		scr_audio_play_sfx(snd_chain_dying);
		scr_grid_propagate_dying();
	}
}

function scr_die_place(_col, _row, _val) {
	if (_val == DIE_MIMIC) {
		var _below = (_row > 0) ? global.grid[_col][_row - 1] : 0;
		if (_below >= 1 && _below <= PAIR_MAX_VALUE) {
			global.grid[_col][_row] = _below;
		} else {
			global.grid[_col][_row] = DIE_MIMIC;
		}
		global.grid_special[_col][_row] = DIE_MIMIC;
	} else if (_val == DIE_BOMB) {
		var _below = (_row > 0) ? global.grid[_col][_row - 1] : 0;
		if (_below >= 1 && _below <= PAIR_MAX_VALUE) {
			scr_die_bomb_activate(_col, _row, _below);
		} else {
			global.grid[_col][_row] = DIE_BOMB;
			global.grid_special[_col][_row] = DIE_BOMB;
		}
	} else if (_val == DIE_RANDOM) {
		var _locked = global.pair_random_val;
		global.grid[_col][_row] = _locked;
		global.grid_special[_col][_row] = 0;
		if (_row > 0) {
			var _below_sp = global.grid_special[_col][_row - 1];
			if (global.grid[_col][_row - 1] == DIE_MIMIC && _below_sp == DIE_MIMIC) {
				global.grid[_col][_row - 1] = _locked;
			} else if (global.grid[_col][_row - 1] == DIE_BOMB && _below_sp == DIE_BOMB) {
				scr_die_bomb_activate(_col, _row - 1, _locked);
			}
		}
	} else {
		global.grid[_col][_row] = _val;
		global.grid_special[_col][_row] = 0;
		if (_row > 0) {
			var _below_sp = global.grid_special[_col][_row - 1];
			// Activate idle Mimic below
			if (global.grid[_col][_row - 1] == DIE_MIMIC && _below_sp == DIE_MIMIC) {
				global.grid[_col][_row - 1] = _val;
			}
			// Activate idle Bomb below
			if (global.grid[_col][_row - 1] == DIE_BOMB && _below_sp == DIE_BOMB) {
				scr_die_bomb_activate(_col, _row - 1, _val);
			}
		}
	}
}
