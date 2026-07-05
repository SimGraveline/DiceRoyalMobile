function scr_grid_gravity() {
	var _moved = false;

	for (var _col = 0; _col < GRID_COLS; _col++) {
		var _write = 0;
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			if (global.grid_dying[_col][_row] > 0) {
				_write = _row + 1;
			} else if (global.grid[_col][_row] != 0) {
				if (_write != _row) {
					global.grid[_col][_write] = global.grid[_col][_row];
					global.grid_special[_col][_write] = global.grid_special[_col][_row];
					global.grid[_col][_row] = 0;
					global.grid_special[_col][_row] = 0;
					_moved = true;
				}
				_write++;
			}
		}
	}

	// Activate idle special dice after gravity
	if (_moved) {
		for (var _gc = 0; _gc < GRID_COLS; _gc++) {
			for (var _gr = 1; _gr <= GRID_ROWS; _gr++) {
				var _special = global.grid_special[_gc][_gr];
				var _below   = global.grid[_gc][_gr - 1];
				// Idle ? or ! landed on a die below
				if (_special == DIE_MIMIC && global.grid[_gc][_gr] == DIE_MIMIC) {
					if (_below >= 1 && _below <= PAIR_MAX_VALUE) {
						global.grid[_gc][_gr] = _below;
					}
				} else if (_special == DIE_BOMB && global.grid[_gc][_gr] == DIE_BOMB) {
					if ((_below >= 1 && _below <= PAIR_MAX_VALUE) || _below == DIE_BRICK || _below == DIE_BOMB || _below == DIE_MIMIC) {
						scr_die_bomb_activate(_gc, _gr, _below);
					}
				}
				// Die fell on top of idle ? or ! (die at _gr, special at _gr-1)
				var _val = global.grid[_gc][_gr];
				if (_val >= 1 && _val <= PAIR_MAX_VALUE && global.grid_dying[_gc][_gr] == 0) {
					if (global.grid[_gc][_gr - 1] == DIE_MIMIC && global.grid_special[_gc][_gr - 1] == DIE_MIMIC) {
						global.grid[_gc][_gr - 1] = _val;
					} else if (global.grid[_gc][_gr - 1] == DIE_BOMB && global.grid_special[_gc][_gr - 1] == DIE_BOMB) {
						scr_die_bomb_activate(_gc, _gr - 1, _val);
					}
				}
			}
		}
	}

	return _moved;
}