function scr_grid_check_join(_col, _row) {
	var _val = global.grid[_col][_row];
	if (_val == 0) return;

	var _neighbors = [
		[_col - 1, _row],
		[_col + 1, _row],
		[_col, _row - 1],
		[_col, _row + 1]
	];

	var _has_chain_dying_neighbor = false;   // any value, chain-dying (match/join/cascade/suite/1) — see grid_dying_chain
	var _has_same_chain_neighbor = false;    // same value AND chain-dying — the only case that lets this die join

	for (var _i = 0; _i < 4; _i++) {
		var _nc = _neighbors[_i][0];
		var _nr = _neighbors[_i][1];
		if (_nc < 0 || _nc >= GRID_COLS || _nr < 0 || _nr > GRID_ROWS) continue;
		// A Clear-triggered dying neighbor never counts as joinable — keeps Clear isolated to
		// exactly what it swept, whether the new die is landing now or was already on the board.
		if (global.grid_dying[_nc][_nr] > 0 && !global.grid_dying_clear[_nc][_nr]) {
			// A standalone dying die that isn't part of a chain (in practice: a Bomb) never
			// recruits new dice into its own death — only a genuine chain can be joined.
			if (global.grid_dying_chain[_nc][_nr]) {
				_has_chain_dying_neighbor = true;
				if (global.grid[_nc][_nr] == _val) {
					_has_same_chain_neighbor = true;
				}
			}
		}
	}

	var _joined = false;

	// 1's special case: any CHAIN-dying neighbor → all 1's on grid die. A Bomb (or any
	// non-chain dying neighbor) never triggers this — see grid_dying_chain.
	if (_val == 1 && _has_chain_dying_neighbor) {
		for (var _c = 0; _c < GRID_COLS; _c++) {
			for (var _r = 0; _r <= GRID_ROWS; _r++) {
				if (global.grid[_c][_r] == 1 && global.grid_dying[_c][_r] == 0) {
					global.grid_dying[_c][_r] = DYING_DURATION;
					global.grid_dying_chain[_c][_r] = true;
					_joined = true;
				}
			}
		}
	}

	// Same value chain-dying neighbor → this die + all connected same-value dice die and join
	// the chain. A same-value neighbor dying for another reason (a Bomb) never triggers this.
	if (_has_same_chain_neighbor) {
		var _group = array_create(GRID_COLS);
		for (var _c = 0; _c < GRID_COLS; _c++) {
			_group[_c] = array_create(GRID_ROWS + 1, false);
		}

		scr_grid_flood_fill(_col, _row, _val, _group);

		for (var _c = 0; _c < GRID_COLS; _c++) {
			for (var _r = 0; _r <= GRID_ROWS; _r++) {
				if (_group[_c][_r] && global.grid_dying[_c][_r] == 0) {
					global.grid_dying[_c][_r] = DYING_DURATION;
					global.grid_dying_chain[_c][_r] = true;
					_joined = true;
				}
			}
		}
	}

	if (_joined) {
		scr_grid_propagate_dying();
	}
}