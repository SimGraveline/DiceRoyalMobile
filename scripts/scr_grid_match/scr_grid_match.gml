function scr_grid_flood_fill(_col, _row, _value, _visited) {
	if (_col < 0 || _col >= GRID_COLS) return;
	if (_row < 0 || _row > GRID_ROWS) return;
	if (_visited[_col][_row]) return;
	if (global.grid[_col][_row] != _value) return;
	if (global.grid_dying[_col][_row] > 0) return;

	_visited[_col][_row] = true;

	scr_grid_flood_fill(_col - 1, _row, _value, _visited);
	scr_grid_flood_fill(_col + 1, _row, _value, _visited);
	scr_grid_flood_fill(_col, _row - 1, _value, _visited);
	scr_grid_flood_fill(_col, _row + 1, _value, _visited);
}

function scr_grid_match() {
	var _visited = array_create(GRID_COLS);
	for (var _c = 0; _c < GRID_COLS; _c++) {
		_visited[_c] = array_create(GRID_ROWS + 1, false);
	}

	var _found = false;

	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			var _val = global.grid[_col][_row];
			if (_val < 2 || _visited[_col][_row] || global.grid_dying[_col][_row] > 0) continue;

			var _group = array_create(GRID_COLS);
			for (var _c = 0; _c < GRID_COLS; _c++) {
				_group[_c] = array_create(GRID_ROWS + 1, false);
			}

			scr_grid_flood_fill(_col, _row, _val, _group);

			var _count = 0;
			for (var _gc = 0; _gc < GRID_COLS; _gc++) {
				for (var _gr = 0; _gr <= GRID_ROWS; _gr++) {
					if (_group[_gc][_gr]) {
						_count++;
						_visited[_gc][_gr] = true;
					}
				}
			}

			if (_count >= _val) {
				_found = true;
				for (var _gc = 0; _gc < GRID_COLS; _gc++) {
					for (var _gr = 0; _gr <= GRID_ROWS; _gr++) {
						if (_group[_gc][_gr]) {
							global.grid_dying[_gc][_gr] = DYING_DURATION;
						}
					}
				}
			}
		}
	}

	// Propagate dying to adjacent same-value dice (and 1's special case)
	if (_found) {
		scr_grid_propagate_dying();
	}

	return _found;
}

function scr_grid_propagate_dying() {
	var _changed = true;
	while (_changed) {
		_changed = false;

		for (var _col = 0; _col < GRID_COLS; _col++) {
			for (var _row = 0; _row <= GRID_ROWS; _row++) {
				if (global.grid_dying[_col][_row] <= 0) continue;

				var _val = global.grid[_col][_row];
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

					// Same value → flood fill and mark dying
					if (_nval == _val) {
						var _group = array_create(GRID_COLS);
						for (var _c = 0; _c < GRID_COLS; _c++) {
							_group[_c] = array_create(GRID_ROWS + 1, false);
						}
						scr_grid_flood_fill(_nc, _nr, _nval, _group);
						for (var _gc = 0; _gc < GRID_COLS; _gc++) {
							for (var _gr = 0; _gr <= GRID_ROWS; _gr++) {
								if (_group[_gc][_gr] && global.grid_dying[_gc][_gr] == 0) {
									global.grid_dying[_gc][_gr] = DYING_DURATION;
									_changed = true;
								}
							}
						}
					}

					// 1's special case: any 1 adjacent to any dying die → all 1's die
					if (_nval == 1) {
						for (var _c = 0; _c < GRID_COLS; _c++) {
							for (var _r = 0; _r <= GRID_ROWS; _r++) {
								if (global.grid[_c][_r] == 1 && global.grid_dying[_c][_r] == 0) {
									global.grid_dying[_c][_r] = DYING_DURATION;
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