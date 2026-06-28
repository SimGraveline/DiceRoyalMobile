function scr_pair_rotate(_clockwise) {
	if (!global.pair_active) return false;

	var _oc, _or;
	if (_clockwise) {
		_oc = global.pair_offset_row;
		_or = -global.pair_offset_col;
	} else {
		_oc = -global.pair_offset_row;
		_or = global.pair_offset_col;
	}

	var _col = global.pair_col;
	var _slave_col = _col + _oc;
	var _slave_row = global.pair_row + _or;

	// Check if rotation fits (bounds + grid)
	if (_slave_col >= 0 && _slave_col < GRID_COLS && _slave_row >= 0
		&& !scr_grid_cell_blocked(_slave_col, _slave_row)) {
		global.pair_offset_col = _oc;
		global.pair_offset_row = _or;
		return true;
	}

	// Wall kick — shift pair by one cell
	var _kick = 0;
	if (_slave_col < 0) _kick = 1;
	else if (_slave_col >= GRID_COLS) _kick = -1;
	else if (_slave_row < 0) {
		global.pair_row += 1;
		global.pair_offset_col = _oc;
		global.pair_offset_row = _or;
		return true;
	} else {
		return false;
	}

	var _kicked_col = _col + _kick;
	var _kicked_slave_col = _kicked_col + _oc;
	var _kicked_slave_row = global.pair_row + _or;

	if (_kicked_col >= 0 && _kicked_col < GRID_COLS && _kicked_slave_col >= 0 && _kicked_slave_col < GRID_COLS
		&& !scr_grid_cell_blocked(_kicked_slave_col, _kicked_slave_row)) {
		global.pair_col = _kicked_col;
		global.pair_offset_col = _oc;
		global.pair_offset_row = _or;
		return true;
	}

	return false;
}