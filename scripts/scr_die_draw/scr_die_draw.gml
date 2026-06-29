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

	var _scale = CELL_SIZE / sprite_get_width(spr_dice);
	draw_sprite_ext(spr_dice, _value, _x, _y, _scale, _scale, 0, c_white, _alpha);

	draw_set_alpha(1.0);
}
