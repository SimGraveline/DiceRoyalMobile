function scr_grid_init() {
	global.grid = array_create(GRID_COLS);
	global.grid_dying = array_create(GRID_COLS);
	global.grid_special = array_create(GRID_COLS);
	for (var _col = 0; _col < GRID_COLS; _col++) {
		global.grid[_col] = array_create(GRID_ROWS + 1, 0);
		global.grid_dying[_col] = array_create(GRID_ROWS + 1, 0);
		global.grid_special[_col] = array_create(GRID_ROWS + 1, 0);
	}
}
