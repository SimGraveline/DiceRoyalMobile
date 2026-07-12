function scr_grid_init() {
	global.grid = array_create(GRID_COLS);
	global.grid_dying = array_create(GRID_COLS);
	global.grid_special = array_create(GRID_COLS);
	// Marks cells whose dying was caused by a Clear R/C sweep — these never propagate to
	// neighbors and never accept new dice joining them (see scr_grid_propagate, scr_grid_check_join).
	global.grid_dying_clear = array_create(GRID_COLS);
	// Landing squash timer — counts down from SQUASH_DURATION to 0, purely visual (see scr_die_draw).
	global.grid_squash = array_create(GRID_COLS);
	for (var _col = 0; _col < GRID_COLS; _col++) {
		global.grid[_col] = array_create(GRID_ROWS + 1, 0);
		global.grid_dying[_col] = array_create(GRID_ROWS + 1, 0);
		global.grid_special[_col] = array_create(GRID_ROWS + 1, 0);
		global.grid_dying_clear[_col] = array_create(GRID_ROWS + 1, false);
		global.grid_squash[_col] = array_create(GRID_ROWS + 1, 0);
	}
}
