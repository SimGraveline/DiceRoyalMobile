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
			if (_val < 2 || _val > PAIR_MAX_VALUE || _visited[_col][_row] || global.grid_dying[_col][_row] > 0) continue;

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
							global.grid_dying_match[_gc][_gr] = true;
						}
					}
				}
			}
		}
	}

	// Propagate dying to adjacent same-value dice (and 1's special case)
	if (_found) {
		scr_audio_play_sfx(snd_chain_dying);
		scr_grid_propagate_dying();
	}

	var _suite = scr_grid_check_suite();
	return _found || _suite;
}

