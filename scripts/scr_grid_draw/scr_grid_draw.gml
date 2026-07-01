function scr_grid_draw() {
	var _x = GRID_X;
	var _y = GRID_Y;

	// Grid background
	draw_set_color(COLOR_GRID_BG);
	draw_roundrect(_x, _y, _x + GRID_WIDTH - 1, _y + GRID_HEIGHT - 1, false);

	// Cell lines
	if (global.grid_lines) {
		draw_set_color(c_gray);
		for (var _col = 0; _col <= GRID_COLS; _col++) {
			var _lx = _x + (_col * CELL_SIZE);
			draw_line(_lx, _y, _lx, _y + GRID_HEIGHT);
		}
		for (var _row = 0; _row <= GRID_ROWS + 1; _row++) {
			var _ly = _y + (_row * CELL_SIZE);
			draw_line(_x, _ly, _x + GRID_WIDTH, _ly);
		}
	}

	// Grid outline
	draw_set_color(COLOR_GRID_OUTLINE);
	for (var _o = 0; _o < GRID_OUTLINE_WIDTH; _o++) {
		draw_roundrect(_x - _o, _y - _o, _x + GRID_WIDTH - 1 + _o, _y + GRID_HEIGHT - 1 + _o, true);
	}

	// Dead zone line
	draw_set_color(c_red);
	var _dead_y = _y + CELL_SIZE;
	draw_line_width(_x, _dead_y, _x + GRID_WIDTH, _dead_y, DEAD_ZONE_LINE_WIDTH);

	// Draw stacked dice
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			var _val = global.grid[_col][_row];
			if (_val > 0) {
				scr_die_draw(_col, _row, _val);
			}
		}
	}
}
