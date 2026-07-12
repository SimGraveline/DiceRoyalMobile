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

	if (global.pc_mode) {
		// --- PC layout: title/Hold/Next along the left, Score/Level top-right, QR bottom-right ---
		var _top = UI_BTN_SIZE + UI_BTN_MARGIN * 3;

		// Title + Demo label (top-left) — left edge aligned with the pause button's left edge
		var _title_x = UI_BTN_PAUSE_X;

		draw_set_font(FONT_TITLE);
		draw_set_halign(fa_left);
		draw_set_valign(fa_top);
		scr_ui_draw_text(_title_x, _top, STR_TITLE, c_white);
		var _title_h = string_height(STR_TITLE);

		draw_set_font(FONT_BODY);
		scr_ui_draw_text(_title_x, _top + _title_h, STR_DEMO_LABEL, COLOR_BOX_FILL);
		var _demo_h = string_height(STR_DEMO_LABEL);

		// Hold / Next boxes — centered vertically between the bottom of "DEMO" and the bottom of
		// the screen, and centered horizontally between the screen's left edge and the grid's left edge.
		var _demo_bottom = _top + _title_h + _demo_h;
		var _box_gap = CELL_SIZE;
		var _module_h = BOX_HEIGHT + BOX_LABEL_OFFSET + string_height(STR_HOLD)
		              + _box_gap
		              + BOX_HEIGHT + BOX_LABEL_OFFSET + string_height(STR_NEXT);
		var _module_top = _demo_bottom + (GAME_HEIGHT - _demo_bottom - _module_h) / 2;
		var _module_x = (GRID_X - BOX_WIDTH) / 2;

		var _hold_y = _module_top;
		scr_ui_draw_pair_box(_module_x, _hold_y, global.hold_val1, global.hold_val2, STR_HOLD);

		var _next_y = _hold_y + BOX_HEIGHT + BOX_LABEL_OFFSET + string_height(STR_HOLD) + _box_gap + PC_NEXT_NUDGE_Y;
		scr_ui_draw_pair_box(_module_x, _next_y, global.next_val1, global.next_val2, STR_NEXT);

		// Score / Level (top-right) — right edge aligned with the help button's right edge
		var _score_right_x = UI_BTN_HELP_X + UI_BTN_SIZE;
		draw_set_halign(fa_right);
		draw_set_valign(fa_top);
		scr_ui_draw_text(_score_right_x, _top, STR_SCORE, COLOR_BOX_FILL);
		var _score_y = _top + string_height(STR_SCORE);
		scr_ui_draw_text(_score_right_x, _score_y, string(global.game_score), _score_col);

		var _level_y = _score_y + string_height(string(global.game_score)) + CELL_SIZE * 0.5;
		scr_ui_draw_text(_score_right_x, _level_y, STR_LEVEL, COLOR_BOX_FILL);
		scr_ui_draw_text(_score_right_x, _level_y + string_height(STR_LEVEL), string(global.level), c_white);

		// "Scan to download" + QR code — centered horizontally between the grid's right edge and
		// the screen's right edge; the text's top aligns with the Hold box's top edge.
		var _qr_w = sprite_get_width(spr_code_qr);
		var _module2_cx = (GRID_X + GRID_WIDTH + GAME_WIDTH) / 2;

		draw_set_font(fnt_bungee_buttons_pc);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		scr_ui_draw_text(_module2_cx, _hold_y, STR_SCAN_QR, c_white);
		var _scan_h = string_height(STR_SCAN_QR);

		var _qr_x = _module2_cx - _qr_w / 2;
		var _qr_y = _hold_y + _scan_h + BOX_LABEL_OFFSET + PC_QR_NUDGE_Y;
		draw_sprite(spr_code_qr, 0, _qr_x, _qr_y);

		draw_set_font(FONT_BODY);
	} else {
		// --- Mobile layout (unchanged) ---
		draw_set_font(FONT_TITLE);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, UI_TITLE_Y, STR_TITLE, c_white);
		draw_set_font(FONT_BODY);

		scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y, STR_SCORE, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y + string_height(STR_SCORE), string(global.game_score), _score_col);

		var _level_y = UI_SCORE_Y + string_height(STR_SCORE) + string_height(string(global.game_score)) * UI_SCORE_LINE_H_FACTOR;
		scr_ui_draw_text(GAME_WIDTH / 2, _level_y, STR_LEVEL, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _level_y + string_height(STR_LEVEL), string(global.level), c_white);
	}

	// Pause button
	draw_set_font(FONT_BUTTONS);
	draw_set_color(c_gray);
	draw_rectangle(UI_BTN_PAUSE_X, UI_BTN_PAUSE_Y, UI_BTN_PAUSE_X + UI_BTN_SIZE - 1, UI_BTN_PAUSE_Y + UI_BTN_SIZE - 1, false);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(UI_BTN_PAUSE_X + UI_BTN_SIZE / 2, UI_BTN_PAUSE_Y + UI_BTN_SIZE / 2, STR_PAUSE);

	// Help button
	draw_set_color(c_gray);
	draw_rectangle(UI_BTN_HELP_X, UI_BTN_HELP_Y, UI_BTN_HELP_X + UI_BTN_SIZE - 1, UI_BTN_HELP_Y + UI_BTN_SIZE - 1, false);
	draw_set_color(c_white);
	if (global.help_active) {
		draw_text(UI_BTN_HELP_X + UI_BTN_SIZE / 2, UI_BTN_HELP_Y + UI_BTN_SIZE / 2, STR_HELP_CLOSE);
	} else {
		draw_text(UI_BTN_HELP_X + UI_BTN_SIZE / 2, UI_BTN_HELP_Y + UI_BTN_SIZE / 2, STR_HELP);
	}
	draw_set_font(FONT_BODY);

	if (!global.pc_mode) {
		// Hold box
		scr_ui_draw_pair_box(BOX_HOLD_X, BOX_Y, global.hold_val1, global.hold_val2, STR_HOLD);

		// Next box
		scr_ui_draw_pair_box(BOX_NEXT_X, BOX_Y, global.next_val1, global.next_val2, STR_NEXT);
	}

	// Paused
	if (global.help_active) {
		var _controls_str = global.pc_mode ? STR_HELP_CONTROLS_PC : STR_HELP_CONTROLS;

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
		draw_rectangle(0, _box_top, GAME_WIDTH, _box_top + _box_h, false);
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
		draw_rectangle(0, GRID_Y - GRID_OUTLINE_WIDTH, GAME_WIDTH, GRID_Y + GRID_HEIGHT + GRID_OUTLINE_WIDTH, false);
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
		draw_rectangle(0, GRID_Y - GRID_OUTLINE_WIDTH, GAME_WIDTH, GRID_Y + GRID_HEIGHT + GRID_OUTLINE_WIDTH, false);
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