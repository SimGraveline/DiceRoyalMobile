function scr_die_draw(_col, _row, _value, _alpha_override = -1, _falling = false) {
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

	// A genuine chain (match/join/cascade/suite) shakes while dying — a standalone dying die
	// (Bomb, or Clear via its own isolation) stays still, so a chain reads visually distinct
	// from an artificial elimination.
	var _is_chain_dying = _is_dying && global.grid_dying_chain[_col][_row];

	// Dying shake (same jitter as the splash screen dice rain) — chain only, and never while
	// paused: the simulation is frozen, so nothing on the grid should visibly keep moving.
	// Same rule any future animated die (specials included) should follow — see scr_pair_draw
	// for the same pattern applied to the falling pair's stretch.
	var _shaking = _is_chain_dying && !global.paused;
	var _xs = _shaking ? random_range(RAIN_SHAKE_MIN, RAIN_SHAKE_MAX) : 1.0;
	var _ys = _shaking ? random_range(RAIN_SHAKE_MIN, RAIN_SHAKE_MAX) : 1.0;

	// Squash & stretch — stretch while airborne (pivots on the center), squash right after
	// landing (pivots on the bottom so the die reads as pressing into the stack, not sinking
	// through the floor). The two never overlap: falling dice aren't in the grid yet, and
	// grid_squash only gets set the instant scr_die_place writes a cell.
	var _sqx = 1.0;
	var _sqy = 1.0;
	var _pivot_bottom = false;
	if (SQUASH_STRETCH_ENABLED) {
		if (_falling) {
			_sqx = STRETCH_SCALE_X;
			_sqy = STRETCH_SCALE_Y;
		} else if (_in_grid && global.grid_squash[_col][_row] > 0) {
			var _t = global.grid_squash[_col][_row] / SQUASH_DURATION;
			_sqx = lerp(1.0, SQUASH_SCALE_X, _t);
			_sqy = lerp(1.0, SQUASH_SCALE_Y, _t);
			_pivot_bottom = true;
		}
	}

	draw_set_alpha(_alpha);

	// Special die: Mimic — unresolved ("?") uses the shared specials sheet, resolved uses its own sheet
	var _is_question = (_value == DIE_MIMIC) || (_in_grid && global.grid_special[_col][_row] == DIE_MIMIC);
	if (_is_question) {
		if (_value == DIE_MIMIC) {
			var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
			scr_die_draw_sprite(spr_dice_specials, DICE_SPECIALS_SUB_MIMIC, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		} else {
			var _scale = CELL_SIZE / sprite_get_width(spr_dice_mimics);
			scr_die_draw_sprite(spr_dice_mimics, _value, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		}
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Bomb — static frame for now, animation to come later
	var _is_killer = (_value == DIE_BOMB) || (_in_grid && global.grid_special[_col][_row] == DIE_BOMB);
	if (_is_killer) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		scr_die_draw_sprite(spr_dice_specials, DICE_SPECIALS_SUB_BOMB, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Brick — static frame for now, animation to come later
	var _is_brick = (_value == DIE_BRICK) || (_in_grid && global.grid_special[_col][_row] == DIE_BRICK);
	if (_is_brick) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		scr_die_draw_sprite(spr_dice_specials, DICE_SPECIALS_SUB_BRICK, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Clear Row — static frame, one-shot (no idle grid state)
	if (_value == DIE_CLEAR_R) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		scr_die_draw_sprite(spr_dice_specials, DICE_SPECIALS_SUB_CLEAR_R, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Clear Column — static frame, one-shot (no idle grid state)
	if (_value == DIE_CLEAR_C) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		scr_die_draw_sprite(spr_dice_specials, DICE_SPECIALS_SUB_CLEAR_C, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	// Special die: Random (only appears in active pair, never stored in grid as DIE_RANDOM)
	if (_value == DIE_RANDOM) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice);
		scr_die_draw_sprite(spr_dice, global.pair_random_val, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);
		draw_set_alpha(1.0);
		return;
	}

	var _scale = CELL_SIZE / sprite_get_width(spr_dice);
	scr_die_draw_sprite(spr_dice, _value, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha);

	draw_set_alpha(1.0);
}

// Shared draw call for every die sprite — applies the squash/stretch scale on top of the base
// scale/jitter, offsetting position so the effect pivots on the center (stretch) or the bottom
// (squash) instead of the sprite's top-left draw origin.
function scr_die_draw_sprite(_sprite, _subimg, _x, _y, _scale, _xs, _ys, _sqx, _sqy, _pivot_bottom, _alpha, _color = c_white) {
	var _draw_x = _x + CELL_SIZE * (1 - _sqx) * 0.5;
	var _draw_y = _pivot_bottom
		? _y + CELL_SIZE * (1 - _sqy)
		: _y + CELL_SIZE * (1 - _sqy) * 0.5;
	draw_sprite_ext(_sprite, _subimg, _draw_x, _draw_y, _scale * _xs * _sqx, _scale * _ys * _sqy, 0, _color, _alpha);
}
