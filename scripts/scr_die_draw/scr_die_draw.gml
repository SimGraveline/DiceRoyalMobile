function scr_die_draw(_col, _row, _value) {
	var _colors = [
		c_black,      // 0 = unused
		c_white,      // 1
		c_yellow,     // 2
		c_red,        // 3
		c_green,      // 4
		c_blue,       // 5
		c_black,      // 6
		COLOR_DIE_7,  // 7
		COLOR_DIE_8,  // 8
		COLOR_DIE_9   // 9
	];

	var _x = GRID_X + (_col * CELL_SIZE);
	var _y = GRID_Y + ((GRID_ROWS - _row) * CELL_SIZE);

	// Dying fade out
	var _alpha = 1.0;
	var _in_grid = (_col >= 0 && _col < GRID_COLS && _row >= 0 && _row <= GRID_ROWS);
	if (_in_grid && global.grid_dying[_col][_row] > 0) {
		_alpha = global.grid_dying[_col][_row] / DYING_DURATION;
	}

	draw_set_alpha(_alpha);

	// Special die: Mimic
	var _is_question = (_value == DIE_MIMIC) || (_in_grid && global.grid_special[_col][_row] == DIE_MIMIC);
	if (_is_question) {
		var _subimage = (_value == DIE_MIMIC) ? 0 : _value;
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_mimic);
		draw_sprite_ext(spr_dice_mimic, _subimage, _x, _y, _scale, _scale, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Bomb
	var _is_killer = (_value == DIE_BOMB) || (_in_grid && global.grid_special[_col][_row] == DIE_BOMB);
	if (_is_killer) {
		var _frame = floor(current_time / DIE_BOMB_ANIM_MS) mod 2;
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_bomb);
		draw_sprite_ext(spr_dice_bomb, _frame, _x, _y, _scale, _scale, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Random (only appears in active pair, never stored in grid as DIE_RANDOM)
	if (_value == DIE_RANDOM) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice);
		draw_sprite_ext(spr_dice, global.pair_random_val, _x, _y, _scale, _scale, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	var _scale = CELL_SIZE / sprite_get_width(spr_dice);
	draw_sprite_ext(spr_dice, _value, _x, _y, _scale, _scale, 0, c_white, _alpha);

	draw_set_alpha(1.0);
}
