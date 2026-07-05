function scr_grid_resolve() {
	var _any_expired = false;

	// Tick dying timers and remove expired dice — score on removal
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			if (global.grid_dying[_col][_row] > 0) {
				global.grid_dying[_col][_row] -= delta_time / DELTA_TO_SECONDS;
				if (global.grid_dying[_col][_row] <= 0) {
					var _val = global.grid[_col][_row];
					// DIE_MIMIC here means it died still unresolved (never became a real value) — no score, like Bomb
					var _no_score = (_val == DIE_BOMB) || (_val == DIE_CLEAR_R) || (_val == DIE_CLEAR_C) || (_val == DIE_MIMIC);
					if (!_no_score) {
						var _combo = power(COMBO_MULTIPLIER, global.combo_count);
						if (_val == 1 || _val == DIE_BRICK) {
							global.score += floor(SCORE_BASE * _combo);
						} else {
							global.score += floor(SCORE_BASE * _val * _combo);
						}
					}
					global.grid_dying[_col][_row] = 0;
					global.grid[_col][_row] = 0;
					global.grid_special[_col][_row] = 0;
					_any_expired = true;
				}
			}
		}
	}

	// If any died, apply gravity then check for new matches (chain combo)
	if (_any_expired) {
		global.combo_count += 1;
		scr_grid_gravity();
		scr_grid_match();
	}
}