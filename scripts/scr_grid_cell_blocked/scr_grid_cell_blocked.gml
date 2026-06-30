function scr_grid_cell_blocked(_col, _row) {
	if (_row < 0) return true;
	if (_col < 0 || _col >= GRID_COLS) return true;
	if (_row > GRID_ROWS) return false; // above grid = free, allows pair to spawn and move in dead zone
	return (global.grid[_col][_row] != 0);
}