function scr_pair_detach() {
	var _master_col = global.pair_col;
	var _master_row = global.pair_row;
	var _slave_col = _master_col + global.pair_offset_col;
	var _slave_row = _master_row + global.pair_offset_row;

	var _master_landed = scr_grid_cell_blocked(_master_col, _master_row - 1);
	var _slave_landed = scr_grid_cell_blocked(_slave_col, _slave_row - 1);

	// Write landed die(s) to grid and check matches/joins
	if (_master_landed) {
		scr_die_place(_master_col, _master_row, global.pair_val1);
		global.score += SCORE_STACK;
		scr_grid_check_join(_master_col, _master_row);
	}
	if (_slave_landed) {
		scr_die_place(_slave_col, _slave_row, global.pair_val2);
		global.score += SCORE_STACK;
		scr_grid_check_join(_slave_col, _slave_row);
	}
	scr_grid_match();

	// Determine solo faller
	global.pair_active = false;

	var _solo_col = -1;
	var _solo_row = -1;
	var _solo_val = 0;

	if (!_master_landed) {
		_solo_col = _master_col;
		_solo_row = _master_row;
		_solo_val = global.pair_val1;
	} else if (!_slave_landed) {
		_solo_col = _slave_col;
		_solo_row = _slave_row;
		_solo_val = global.pair_val2;
	}

	// Solo die: check dying join first, otherwise snap to lowest position
	if (_solo_col >= 0) {
		var _should_join = false;
		var _neighbors = [
			[_solo_col - 1, _solo_row],
			[_solo_col + 1, _solo_row],
			[_solo_col, _solo_row - 1],
			[_solo_col, _solo_row + 1]
		];

		for (var _i = 0; _i < 4; _i++) {
			var _nc = _neighbors[_i][0];
			var _nr = _neighbors[_i][1];
			if (_nc < 0 || _nc >= GRID_COLS || _nr < 0 || _nr > GRID_ROWS) continue;
			if (global.grid_dying[_nc][_nr] > 0) {
				if (global.grid[_nc][_nr] == _solo_val || _solo_val == 1) {
					_should_join = true;
					break;
				}
			}
		}

		if (_should_join) {
			scr_die_place(_solo_col, _solo_row, _solo_val);
		} else {
			while (!scr_grid_cell_blocked(_solo_col, _solo_row - 1)) {
				_solo_row -= 1;
			}
			scr_die_place(_solo_col, _solo_row, _solo_val);
		}
		global.score += SCORE_STACK;

		scr_grid_check_join(_solo_col, _solo_row);
		scr_grid_match();
	}

	scr_audio_play_sfx(snd_dice_stack);
	global.last_pair_col = _master_col;
}
