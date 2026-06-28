function scr_die_draw(_col, _row, _value) {
	var _colors = [
		c_black,   // 0 = unused
		c_white,   // 1
		c_red,     // 2
		c_blue,    // 3
		c_green,   // 4
		c_yellow,  // 5
		c_purple   // 6
	];

	var _x = GRID_X + (_col * CELL_SIZE);
	var _y = GRID_Y + ((GRID_ROWS - _row) * CELL_SIZE);

	// Dying fade out
	var _alpha = 1.0;
	if (_col >= 0 && _col < GRID_COLS && _row >= 0 && _row <= GRID_ROWS) {
		var _dying = global.grid_dying[_col][_row];
		if (_dying > 0) {
			_alpha = _dying / DYING_DURATION;
		}
	}

	draw_set_alpha(_alpha);

	// Die body
	draw_set_color(_colors[_value]);
	draw_rectangle(_x + DIE_PADDING, _y + DIE_PADDING, _x + CELL_SIZE - DIE_PADDING - 1, _y + CELL_SIZE - DIE_PADDING - 1, false);

	// Value text
	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(_x + (CELL_SIZE / 2), _y + (CELL_SIZE / 2), string(_value));
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	draw_set_alpha(1.0);
}
