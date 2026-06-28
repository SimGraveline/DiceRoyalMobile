function scr_grid_resolve() {
	var _any_expired = false;

	// Tick dying timers and remove expired dice
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			if (global.grid_dying[_col][_row] > 0) {
				global.grid_dying[_col][_row] -= delta_time / DELTA_TO_SECONDS;
				if (global.grid_dying[_col][_row] <= 0) {
					global.grid_dying[_col][_row] = 0;
					global.grid[_col][_row] = 0;
					_any_expired = true;
				}
			}
		}
	}

	// If any died, apply gravity then check for new matches
	if (_any_expired) {
		scr_grid_gravity();
		scr_grid_match();
	}
}