function scr_grid_check_suite() {
	// Max unlocked normal die value = suite length
	var _n = PAIR_MIN_VALUE;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		if (global.spawn_weights[_i] > 0) _n = _i;
	}
	if (_n < 6) return false;

	// A 6-suite scores through the normal per-die resolve, same as any other chain — no flat bonus.
	var _suite_score = 0;
	if      (_n == 7) _suite_score = SCORE_SUITE_7;
	else if (_n == 8) _suite_score = SCORE_SUITE_8;
	else if (_n == 9) _suite_score = SCORE_SUITE_9;

	var _found = false;

	// Horizontal suites
	for (var _row = 0; _row <= GRID_ROWS; _row++) {
		for (var _col = 0; _col <= GRID_COLS - _n; _col++) {
			var _asc = true;
			var _desc = true;
			for (var _i = 0; _i < _n; _i++) {
				if (global.grid_dying[_col + _i][_row] > 0) { _asc = false; _desc = false; break; }
				var _v = global.grid[_col + _i][_row];
				if (_v != _i + 1)    _asc  = false;
				if (_v != _n - _i)   _desc = false;
				if (!_asc && !_desc) break;
			}
			if (_asc || _desc) {
				for (var _i = 0; _i < _n; _i++) {
					global.grid_dying[_col + _i][_row] = DYING_DURATION;
				}
				global.game_score += _suite_score;
				_found = true;
			}
		}
	}

	// Vertical suites
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS - _n; _row++) {
			var _asc = true;
			var _desc = true;
			for (var _i = 0; _i < _n; _i++) {
				if (global.grid_dying[_col][_row + _i] > 0) { _asc = false; _desc = false; break; }
				var _v = global.grid[_col][_row + _i];
				if (_v != _i + 1)    _asc  = false;
				if (_v != _n - _i)   _desc = false;
				if (!_asc && !_desc) break;
			}
			if (_asc || _desc) {
				for (var _i = 0; _i < _n; _i++) {
					global.grid_dying[_col][_row + _i] = DYING_DURATION;
				}
				global.game_score += _suite_score;
				_found = true;
			}
		}
	}

	if (_found) {
		scr_audio_play_sfx(snd_chain_dying);
		scr_grid_propagate_dying();
	}

	return _found;
}
