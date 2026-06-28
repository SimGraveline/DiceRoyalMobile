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
					global.grid[_col][_row] = 0;
					_moved = true;
				}
				_write++;
			}
		}
	}

	return _moved;
}