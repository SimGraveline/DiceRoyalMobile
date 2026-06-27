function scr_init_grid() {
	global.grid = array_create(GRID_COLS);
	for (var _col = 0; _col < GRID_COLS; _col++) {
		global.grid[_col] = array_create(GRID_ROWS + 1, 0);
	}
}
