function scr_draw_grid() {
	var _x = GRID_X;
	var _y = GRID_Y;

	// Grid background
	draw_set_color(c_dkgray);
	draw_rectangle(_x, _y, _x + GRID_WIDTH - 1, _y + GRID_HEIGHT - 1, false);

	// Cell lines
	draw_set_color(c_gray);
	for (var _col = 0; _col <= GRID_COLS; _col++) {
		var _lx = _x + (_col * CELL_SIZE);
		draw_line(_lx, _y, _lx, _y + GRID_HEIGHT);
	}
	for (var _row = 0; _row <= GRID_ROWS + 1; _row++) {
		var _ly = _y + (_row * CELL_SIZE);
		draw_line(_x, _ly, _x + GRID_WIDTH, _ly);
	}

	// Dead zone line
	draw_set_color(c_red);
	var _dead_y = _y + CELL_SIZE;
	draw_line_width(_x, _dead_y, _x + GRID_WIDTH, _dead_y, 2);

	// Draw stacked dice
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row < GRID_ROWS + 1; _row++) {
			var _val = global.grid[_col][_row];
			if (_val > 0) {
				scr_draw_die(_col, _row, _val);
			}
		}
	}
}
