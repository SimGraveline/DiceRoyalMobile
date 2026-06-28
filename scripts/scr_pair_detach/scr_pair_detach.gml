function scr_pair_detach() {
	var _master_col = global.pair_col;
	var _master_row = global.pair_row;
	var _slave_col = _master_col + global.pair_offset_col;
	var _slave_row = _master_row + global.pair_offset_row;

	var _master_landed = scr_grid_cell_blocked(_master_col, _master_row - 1);
	var _slave_landed = scr_grid_cell_blocked(_slave_col, _slave_row - 1);

	// Write landed die(s) to grid
	if (_master_landed) {
		global.grid[_master_col][_master_row] = global.pair_val1;
	}
	if (_slave_landed) {
		global.grid[_slave_col][_slave_row] = global.pair_val2;
	}

	// Determine solo faller
	global.pair_active = false;

	if (!_master_landed) {
		global.solo_active = true;
		global.solo_col = _master_col;
		global.solo_row = _master_row;
		global.solo_val = global.pair_val1;
	} else if (!_slave_landed) {
		global.solo_active = true;
		global.solo_col = _slave_col;
		global.solo_row = _slave_row;
		global.solo_val = global.pair_val2;
	} else {
		global.solo_active = false;
	}

	global.last_pair_col = _master_col;
}