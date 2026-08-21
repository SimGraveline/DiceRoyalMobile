function scr_grid_gravity() {
	var _moved = false;
	var _moved_cols = [];
	var _moved_rows = [];

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
					array_push(_moved_cols, _col);
					array_push(_moved_rows, _write);
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
				// Idle ? or ! landed on a die below — Mimic only resolves to a real 1-9 value,
				// Bomb accepts anything scr_die_bomb_valid_target allows (never an idle Mimic).
				if (_special == DIE_MIMIC && global.grid[_gc][_gr] == DIE_MIMIC) {
					if (_below >= 1 && _below <= PAIR_MAX_VALUE) {
						global.grid[_gc][_gr] = _below;
					}
				} else if (_special == DIE_BOMB && global.grid[_gc][_gr] == DIE_BOMB) {
					if (scr_die_bomb_valid_target(_below)) {
						scr_die_bomb_activate(_gc, _gr, _below);
					}
				}
				// Die fell on top of an idle ? or ! below it (checked independently per case —
				// Mimic only accepts a real 1-9 value, Bomb uses the same valid-target rule as
				// every other activation site, so this matches placement instead of being
				// narrower than it).
				var _val = global.grid[_gc][_gr];
				if (global.grid_dying[_gc][_gr] == 0) {
					if (global.grid[_gc][_gr - 1] == DIE_MIMIC && global.grid_special[_gc][_gr - 1] == DIE_MIMIC) {
						if (_val >= 1 && _val <= PAIR_MAX_VALUE) {
							global.grid[_gc][_gr - 1] = _val;
						}
					} else if (global.grid[_gc][_gr - 1] == DIE_BOMB && global.grid_special[_gc][_gr - 1] == DIE_BOMB) {
						if (scr_die_bomb_valid_target(_val)) {
							scr_die_bomb_activate(_gc, _gr - 1, _val);
						}
					}
				}
			}
		}

		// A die that just moved down may have landed beside an already-dying same-value die it
		// wasn't previously adjacent to (see scr_grid_check_join) — re-evaluate every cell that
		// actually changed row here, same rule as any other die that just became stacked.
		for (var _i = 0; _i < array_length(_moved_cols); _i++) {
			scr_grid_check_join(_moved_cols[_i], _moved_rows[_i]);
		}
	}

	return _moved;
}