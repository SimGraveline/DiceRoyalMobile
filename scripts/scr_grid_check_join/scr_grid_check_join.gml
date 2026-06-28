function scr_grid_check_join(_col, _row) {
	var _val = global.grid[_col][_row];
	if (_val == 0) return;

	var _neighbors = [
		[_col - 1, _row],
		[_col + 1, _row],
		[_col, _row - 1],
		[_col, _row + 1]
	];

	var _has_dying_neighbor = false;
	var _has_same_dying_neighbor = false;

	for (var _i = 0; _i < 4; _i++) {
		var _nc = _neighbors[_i][0];
		var _nr = _neighbors[_i][1];
		if (_nc < 0 || _nc >= GRID_COLS || _nr < 0 || _nr > GRID_ROWS) continue;
		if (global.grid_dying[_nc][_nr] > 0) {
			_has_dying_neighbor = true;
			if (global.grid[_nc][_nr] == _val) {
				_has_same_dying_neighbor = true;
			}
		}
	}

	var _joined = false;

	// 1's special case: any dying neighbor → all 1's on grid die
	if (_val == 1 && _has_dying_neighbor) {
		for (var _c = 0; _c < GRID_COLS; _c++) {
			for (var _r = 0; _r <= GRID_ROWS; _r++) {
				if (global.grid[_c][_r] == 1 && global.grid_dying[_c][_r] == 0) {
					global.grid_dying[_c][_r] = DYING_DURATION;
					_joined = true;
				}
			}
		}
	}

	// Same value dying neighbor → this die + all connected same-value dice die
	if (_has_same_dying_neighbor) {
		var _group = array_create(GRID_COLS);
		for (var _c = 0; _c < GRID_COLS; _c++) {
			_group[_c] = array_create(GRID_ROWS + 1, false);
		}

		scr_grid_flood_fill(_col, _row, _val, _group);

		for (var _c = 0; _c < GRID_COLS; _c++) {
			for (var _r = 0; _r <= GRID_ROWS; _r++) {
				if (_group[_c][_r] && global.grid_dying[_c][_r] == 0) {
					global.grid_dying[_c][_r] = DYING_DURATION;
					_joined = true;
				}
			}
		}
	}

	if (_joined) {
		scr_grid_propagate_dying();
	}
}