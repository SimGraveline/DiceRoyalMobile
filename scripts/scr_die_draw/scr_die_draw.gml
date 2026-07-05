function scr_die_draw(_col, _row, _value, _alpha_override = -1) {
	var _x = GRID_X + (_col * CELL_SIZE);
	var _y = GRID_Y + ((GRID_ROWS - _row) * CELL_SIZE);

	// Dying fade out
	var _alpha = 1.0;
	var _in_grid = (_col >= 0 && _col < GRID_COLS && _row >= 0 && _row <= GRID_ROWS);
	var _is_dying = _in_grid && global.grid_dying[_col][_row] > 0;
	if (_alpha_override >= 0) {
		_alpha = _alpha_override;
	} else if (_is_dying) {
		_alpha = max(DYING_ALPHA_MIN, global.grid_dying[_col][_row] / DYING_DURATION);
	}

	// Dying shake (same jitter as the splash screen dice rain)
	var _xs = _is_dying ? random_range(RAIN_SHAKE_MIN, RAIN_SHAKE_MAX) : 1.0;
	var _ys = _is_dying ? random_range(RAIN_SHAKE_MIN, RAIN_SHAKE_MAX) : 1.0;

	draw_set_alpha(_alpha);

	// Special die: Mimic — unresolved ("?") uses the shared specials sheet, resolved uses its own sheet
	var _is_question = (_value == DIE_MIMIC) || (_in_grid && global.grid_special[_col][_row] == DIE_MIMIC);
	if (_is_question) {
		if (_value == DIE_MIMIC) {
			var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
			draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_MIMIC, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		} else {
			var _scale = CELL_SIZE / sprite_get_width(spr_dice_mimics);
			draw_sprite_ext(spr_dice_mimics, _value, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		}
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Bomb — static frame for now, animation to come later
	var _is_killer = (_value == DIE_BOMB) || (_in_grid && global.grid_special[_col][_row] == DIE_BOMB);
	if (_is_killer) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_BOMB, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Brick — static frame for now, animation to come later
	var _is_brick = (_value == DIE_BRICK) || (_in_grid && global.grid_special[_col][_row] == DIE_BRICK);
	if (_is_brick) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_BRICK, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Clear Row — static frame, one-shot (no idle grid state)
	if (_value == DIE_CLEAR_R) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_CLEAR_R, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Clear Column — static frame, one-shot (no idle grid state)
	if (_value == DIE_CLEAR_C) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_CLEAR_C, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Random (only appears in active pair, never stored in grid as DIE_RANDOM)
	if (_value == DIE_RANDOM) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice);
		draw_sprite_ext(spr_dice, global.pair_random_val, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	var _scale = CELL_SIZE / sprite_get_width(spr_dice);
	draw_sprite_ext(spr_dice, _value, _x, _y, _scale * _xs, _scale * _ys, 0, c_white, _alpha);

	draw_set_alpha(1.0);
}
