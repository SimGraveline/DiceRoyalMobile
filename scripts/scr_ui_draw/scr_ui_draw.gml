function scr_ui_draw_die(_x, _y, _value) {
	if (_value == DIE_BOMB) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_BOMB, _x, _y, _scale, _scale, 0, c_white, 1.0);
		return;
	}
	if (_value == DIE_MIMIC) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_MIMIC, _x, _y, _scale, _scale, 0, c_white, 1.0);
		return;
	}
	if (_value == DIE_BRICK) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_BRICK, _x, _y, _scale, _scale, 0, c_white, 1.0);
		return;
	}
	if (_value == DIE_CLEAR_R) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_CLEAR_R, _x, _y, _scale, _scale, 0, c_white, 1.0);
		return;
	}
	if (_value == DIE_CLEAR_C) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice_specials);
		draw_sprite_ext(spr_dice_specials, DICE_SPECIALS_SUB_CLEAR_C, _x, _y, _scale, _scale, 0, c_white, 1.0);
		return;
	}
	if (_value == DIE_RANDOM) {
		var _scale = CELL_SIZE / sprite_get_width(spr_dice);
		draw_sprite_ext(spr_dice, global.pair_random_val, _x, _y, _scale, _scale, 0, c_white, 1.0);
		return;
	}
	var _scale = CELL_SIZE / sprite_get_width(spr_dice);
	draw_sprite_ext(spr_dice, _value, _x, _y, _scale, _scale, 0, c_white, 1.0);
}

function scr_ui_draw_text(_x, _y, _str, _col) {
	var _s = UI_SHADOW_OFFSET;
	draw_set_color(c_black);
	draw_text(_x - _s, _y + _s, _str);
	draw_set_color(_col);
	draw_text(_x, _y, _str);
}

// Draws a Hold/Next style box + dice preview + label at an arbitrary anchor.
// _val1 < 0 skips the preview (used for an empty Hold slot).
function scr_ui_draw_pair_box(_x, _y, _val1, _val2, _label) {
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(_x, _y, _x + BOX_WIDTH - 1, _y + BOX_HEIGHT - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(_x - _o, _y - _o, _x + BOX_WIDTH - 1 + _o, _y + BOX_HEIGHT - 1 + _o, true);
	}

	if (_val1 >= 0) {
		var _dx = _x + (BOX_WIDTH - CELL_SIZE * 2) / 2;
		var _dy = _y + (BOX_HEIGHT - CELL_SIZE) / 2;
		scr_ui_draw_die(_dx, _dy, _val1);
		scr_ui_draw_die(_dx + CELL_SIZE, _dy, _val2);
	}

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(_x + BOX_WIDTH / 2, _y + BOX_HEIGHT + BOX_LABEL_OFFSET, _label, c_white);
}

function scr_ui_draw() {
	draw_set_font(FONT_BODY);

	var _score_col = global.high_score_beaten ? c_yellow : c_white;

	// --- Score (top-left) / Level (top-right) ---
	var _margin = UI_SCREEN_MARGIN;

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	scr_ui_draw_text(_margin, _margin, STR_SCORE, COLOR_BOX_FILL);
	var _score_y = _margin + string_height(STR_SCORE);
	scr_ui_draw_text(_margin, _score_y, string(global.game_score), _score_col);

	draw_set_halign(fa_right);
	scr_ui_draw_text(GAME_WIDTH - _margin, _margin, STR_LEVEL, COLOR_BOX_FILL);
	var _level_y = _margin + string_height(STR_LEVEL);
	scr_ui_draw_text(GAME_WIDTH - _margin, _level_y, string(global.level), c_white);

	// Hold (left of grid) / Next (right of grid) — each centered vertically on the screen,
	// and horizontally centered in the gap between the grid and its side of the screen.
	var _box_y = (GAME_HEIGHT - BOX_HEIGHT) / 2;
	var _hold_x = GRID_X / 2 - BOX_WIDTH / 2;
	var _next_x = (GRID_X + GRID_WIDTH + GAME_WIDTH) / 2 - BOX_WIDTH / 2;

	scr_ui_draw_pair_box(_hold_x, _box_y, global.hold_val1, global.hold_val2, STR_HOLD);
	scr_ui_draw_pair_box(_next_x, _box_y, global.next_val1, global.next_val2, STR_NEXT);

	// Paused
	if (global.help_active) {
		var _controls_str = STR_HELP_CONTROLS;

		draw_set_font(FONT_TITLE);
		var _title_h = string_height(STR_HELP_TITLE);
		draw_set_font(FONT_BODY);
		var _rules_h = string_height(STR_HELP_RULES);
		var _controls_h = string_height(_controls_str);
		var _blank_line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
		var _gap = _title_h / 2;
		var _total_h = _title_h + _gap + _rules_h + _blank_line_h + _gap + _controls_h;
		var _box_top = GRID_Y - GRID_OUTLINE_WIDTH;
		var _box_h = GRID_HEIGHT + GRID_OUTLINE_WIDTH * 2;
		var _top = _box_top + (_box_h - _total_h) / 2;

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_font(FONT_TITLE);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _top, STR_HELP_TITLE, c_white);

		draw_set_font(FONT_BODY);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _top + _title_h + _gap, STR_HELP_RULES, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _top + _title_h + _gap + _rules_h + _blank_line_h + _gap, _controls_str, c_white);
	} else if (global.paused) {
		var _layout = scr_pause_menu_layout();
		var _items = _layout.items;

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_font(FONT_TITLE);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.top, STR_PAUSED, c_white);

		draw_set_font(FONT_BODY);
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _col = c_white;
			if (global.pause_highlight && _i == global.pause_cursor) {
				_col = COLOR_BOX_FILL;
			}
			scr_ui_draw_text(GAME_WIDTH / 2, _layout.item_y[_i], _items[_i], _col);
		}
	}

	// Game over
	if (global.game_over) {
		var _layout = scr_game_over_menu_layout();
		var _items = _layout.items;

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		// Title
		draw_set_font(FONT_TITLE);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.top, STR_GAME_OVER, c_red);

		// Scores
		draw_set_font(FONT_BODY);
		var _sy = _layout.top + _layout.title_h;

		if (global.high_score_beaten) {
			var _pulse = 0.5 + 0.5 * sin(global.game_over_blink_timer * pi * 3);
			draw_set_alpha(_pulse);
			scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_NEW_BEST, c_yellow);
			draw_set_alpha(1.0);
			_sy += _layout.score_line_h;
		}

		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_CURRENT_SCORE, COLOR_BOX_FILL);
		_sy += _layout.score_line_h;
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.game_score), c_white);
		_sy += _layout.score_line_h;
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_HIGH_SCORE, COLOR_BOX_FILL);
		_sy += _layout.score_line_h;
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.high_score), c_white);

		// Menu
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _col = c_white;
			if (global.game_over_highlight && _i == global.game_over_cursor) {
				_col = COLOR_BOX_FILL;
			}
			scr_ui_draw_text(GAME_WIDTH / 2, _layout.menu_top + _i * _layout.line_h, _items[_i], _col);
		}
	}

	// Reset draw state
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}