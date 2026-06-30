function scr_ui_draw_die(_x, _y, _value) {
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

function scr_ui_draw() {
	draw_set_font(fnt_bungee);

	// Title
	draw_set_font(fnt_bungee_title);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(GAME_WIDTH / 2, UI_TITLE_Y, STR_TITLE, c_white);
	draw_set_font(fnt_bungee);

	// Score
	scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y, STR_SCORE, c_white);
	var _score_col = c_white;
	if (global.high_score_beaten) {
		_score_col = c_yellow;
	}
	scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y + string_height(STR_SCORE), string(global.score), _score_col);

	// Pause button
	draw_set_font(fnt_bungee_buttons);
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
	draw_set_font(fnt_bungee);

	// Hold box
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(BOX_HOLD_X, BOX_Y, BOX_HOLD_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(BOX_HOLD_X - _o, BOX_Y - _o, BOX_HOLD_X + BOX_WIDTH - 1 + _o, BOX_Y + BOX_HEIGHT - 1 + _o, true);
	}

	// Hold dice preview
	if (global.hold_val1 >= 0) {
		var _hold_dx = BOX_HOLD_X + (BOX_WIDTH - CELL_SIZE * 2) / 2;
		var _hold_dy = BOX_Y + (BOX_HEIGHT - CELL_SIZE) / 2;
		scr_ui_draw_die(_hold_dx, _hold_dy, global.hold_val1);
		scr_ui_draw_die(_hold_dx + CELL_SIZE, _hold_dy, global.hold_val2);
	}

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(BOX_HOLD_X + BOX_WIDTH / 2, BOX_Y + BOX_HEIGHT + BOX_LABEL_OFFSET, STR_HOLD, c_white);

	// Next box
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(BOX_NEXT_X, BOX_Y, BOX_NEXT_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(BOX_NEXT_X - _o, BOX_Y - _o, BOX_NEXT_X + BOX_WIDTH - 1 + _o, BOX_Y + BOX_HEIGHT - 1 + _o, true);
	}

	// Next dice preview
	var _next_dx = BOX_NEXT_X + (BOX_WIDTH - CELL_SIZE * 2) / 2;
	var _next_dy = BOX_Y + (BOX_HEIGHT - CELL_SIZE) / 2;
	scr_ui_draw_die(_next_dx, _next_dy, global.next_val1);
	scr_ui_draw_die(_next_dx + CELL_SIZE, _next_dy, global.next_val2);

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(BOX_NEXT_X + BOX_WIDTH / 2, BOX_Y + BOX_HEIGHT + BOX_LABEL_OFFSET, STR_NEXT, c_white);

	// Level — centered between hold and next, vertically centered with boxes
	var _level_x = GAME_WIDTH / 2;
	var _level_cy = BOX_Y + BOX_HEIGHT / 2;
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	scr_ui_draw_text(_level_x, _level_cy, STR_LEVEL, c_white);
	draw_set_valign(fa_top);
	scr_ui_draw_text(_level_x, _level_cy, string(global.level), c_white);

	// Paused
	if (global.help_active) {
		draw_set_font(fnt_bungee_title);
		var _title_h = string_height(STR_HELP_TITLE);
		draw_set_font(fnt_bungee);
		var _rules_h = string_height(STR_HELP_RULES);
		var _controls_h = string_height(STR_HELP_CONTROLS);
		var _gap = _title_h / 2;
		var _total_h = _title_h + _gap + _rules_h + _gap + _controls_h;
		var _pad = _title_h;
		var _top = GAME_HEIGHT / 2 - _total_h / 2;

		draw_set_alpha(0.85);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, _top - _pad, GAME_WIDTH, _top + _total_h + _pad, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_font(fnt_bungee_title);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _top, STR_HELP_TITLE, c_white);

		draw_set_font(fnt_bungee);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _top + _title_h + _gap, STR_HELP_RULES, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _top + _title_h + _gap + _rules_h + _gap, STR_HELP_CONTROLS, c_white);
	} else if (global.paused) {
		var _items = [STR_MENU_RESUME, STR_MENU_RESTART, STR_MENU_QUIT,
		              global.music_muted ? STR_MENU_MUTE_ON : STR_MENU_MUTE_OFF];

		draw_set_font(fnt_bungee_title);
		var _title_h = string_height(STR_PAUSED);
		draw_set_font(fnt_bungee);
		var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
		var _menu_h = array_length(_items) * _line_h;
		var _gap = _title_h * 0.5;
		var _block_h = _title_h + _gap + _menu_h;
		var _pad = _title_h * 0.5;
		var _top = GAME_HEIGHT / 2 - _block_h / 2;

		draw_set_alpha(0.85);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, _top - _pad, GAME_WIDTH, _top + _block_h + _pad, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_font(fnt_bungee_title);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _top, STR_PAUSED, c_white);

		draw_set_font(fnt_bungee);
		var _menu_top = _top + _title_h + _gap;
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _col = c_white;
			if (global.pause_highlight && _i == global.pause_cursor) {
				_col = COLOR_BOX_FILL;
			}
			scr_ui_draw_text(GAME_WIDTH / 2, _menu_top + _i * _line_h, _items[_i], _col);
		}
	}

	// Game over
	if (global.game_over) {
		var _items = [STR_MENU_RESTART, STR_MENU_QUIT];

		draw_set_font(fnt_bungee_title);
		var _title_h = string_height(STR_GAME_OVER);
		draw_set_font(fnt_bungee);
		var _score_line_h = string_height("M") * UI_SCORE_LINE_H_FACTOR;
		var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
		var _new_best_h = 0;
		if (global.high_score_beaten) {
			_new_best_h = _score_line_h;
		}
		var _scores_h = _new_best_h + _score_line_h * 4;
		var _menu_h = array_length(_items) * _line_h;
		var _gap = _title_h * 0.3;
		var _block_h = _title_h + _scores_h + _gap + _menu_h;
		var _pad = _title_h * 0.5;
		var _top = GAME_HEIGHT / 2 - _block_h / 2;

		draw_set_alpha(0.85);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, _top - _pad, GAME_WIDTH, _top + _block_h + _pad, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		// Title
		draw_set_font(fnt_bungee_title);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _top, STR_GAME_OVER, c_red);

		// Scores
		draw_set_font(fnt_bungee);
		var _sy = _top + _title_h;

		if (global.high_score_beaten) {
			var _pulse = 0.5 + 0.5 * sin(global.game_over_blink_timer * pi * 3);
			draw_set_alpha(_pulse);
			scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_NEW_BEST, c_yellow);
			draw_set_alpha(1.0);
			_sy += _score_line_h;
		}

		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_CURRENT_SCORE, COLOR_BOX_FILL);
		_sy += _score_line_h;
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.score), c_white);
		_sy += _score_line_h;
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_HIGH_SCORE, COLOR_BOX_FILL);
		_sy += _score_line_h;
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.high_score), c_white);

		// Menu
		var _menu_top = _top + _title_h + _scores_h + _gap;
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _col = c_white;
			if (global.game_over_highlight && _i == global.game_over_cursor) {
				_col = COLOR_BOX_FILL;
			}
			scr_ui_draw_text(GAME_WIDTH / 2, _menu_top + _i * _line_h, _items[_i], _col);
		}
	}

	// Reset draw state
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}