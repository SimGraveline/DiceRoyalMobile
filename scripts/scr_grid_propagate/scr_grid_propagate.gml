function scr_grid_propagate_dying() {
	var _changed = true;
	while (_changed) {
		_changed = false;

		for (var _col = 0; _col < GRID_COLS; _col++) {
			for (var _row = 0; _row <= GRID_ROWS; _row++) {
				if (global.grid_dying[_col][_row] <= 0) continue;
				// A Clear-triggered cell never acts as a cascade source — keeps Clear isolated to
				// exactly what it swept, no matter when/why propagation runs afterward.
				if (global.grid_dying_clear[_col][_row]) continue;

				var _val = global.grid[_col][_row];
				// Whether this source is itself part of a genuine chain — only a chain source can
				// pass grid_dying_chain onward (to a same-value cascade or the 1's rule). A Bomb-killed
				// cell still triggers ordinary elimination via the checks below, it just never spreads
				// the "chain" flag.
				var _is_chain = global.grid_dying_chain[_col][_row];
				var _neighbors = [
					[_col - 1, _row],
					[_col + 1, _row],
					[_col, _row - 1],
					[_col, _row + 1]
				];

				for (var _i = 0; _i < 4; _i++) {
					var _nc = _neighbors[_i][0];
					var _nr = _neighbors[_i][1];
					if (_nc < 0 || _nc >= GRID_COLS || _nr < 0 || _nr > GRID_ROWS) continue;
					if (global.grid_dying[_nc][_nr] > 0) continue;

					var _nval = global.grid[_nc][_nr];
					if (_nval == 0) continue;

					// Same value → flood fill and mark dying, joining the chain. Only a genuine chain
					// source can cascade at all — a standalone dying die (in practice: a Bomb) never
					// recruits adjacent same-value dice into its own death.
					if (_nval == _val && _is_chain) {
						var _group = array_create(GRID_COLS);
						for (var _c = 0; _c < GRID_COLS; _c++) {
							_group[_c] = array_create(GRID_ROWS + 1, false);
						}
						scr_grid_flood_fill(_nc, _nr, _nval, _group);
						for (var _gc = 0; _gc < GRID_COLS; _gc++) {
							for (var _gr = 0; _gr <= GRID_ROWS; _gr++) {
								if (_group[_gc][_gr] && global.grid_dying[_gc][_gr] == 0) {
									global.grid_dying[_gc][_gr] = DYING_DURATION;
									global.grid_dying_chain[_gc][_gr] = true;
									_changed = true;
								}
							}
						}
					}

					// 1's special case: any 1 adjacent to a CHAIN-dying die → all 1's die. A Bomb
					// (or any non-chain source) never triggers this — see grid_dying_chain.
					if (_nval == 1 && _is_chain) {
						for (var _c = 0; _c < GRID_COLS; _c++) {
							for (var _r = 0; _r <= GRID_ROWS; _r++) {
								if (global.grid[_c][_r] == 1 && global.grid_dying[_c][_r] == 0) {
									global.grid_dying[_c][_r] = DYING_DURATION;
									global.grid_dying_chain[_c][_r] = true;
									_changed = true;
								}
							}
						}
					}
				}
			}
		}
	}
}
