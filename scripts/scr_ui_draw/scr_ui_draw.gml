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

// Draws a "KEY = ACTION" help control row as three colored segments, centered as one unit
// (font must already be set by the caller).
function scr_ui_draw_control_row(_y, _key, _action) {
	var _eq = " = ";
	var _full_w = string_width(_key) + string_width(_eq) + string_width(_action);
	var _cx = GAME_WIDTH / 2 - _full_w / 2;
	draw_set_halign(fa_left);
	scr_ui_draw_text(_cx, _y, _key, COLOR_BOX_FILL);
	_cx += string_width(_key);
	scr_ui_draw_text(_cx, _y, _eq, c_black);
	_cx += string_width(_eq);
	scr_ui_draw_text(_cx, _y, _action, c_white);
	draw_set_halign(fa_center);
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

	draw_set_font(fnt_hud_boxtitle_bungee_med);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(_x + BOX_WIDTH / 2, _y + BOX_HEIGHT + BOX_LABEL_OFFSET, _label, c_white);
}

function scr_ui_draw() {
	var _score_col = global.high_score_beaten ? c_yellow : c_white;

	// --- Score (top-left) / Level (top-right) ---
	var _margin = UI_SCREEN_MARGIN;

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(fnt_hud_scoretitle_bungee_med);
	scr_ui_draw_text(_margin, _margin, STR_SCORE, COLOR_BOX_FILL);
	var _score_y = _margin + string_height(STR_SCORE);
	draw_set_font(fnt_hud_score_bungee_med);
	scr_ui_draw_text(_margin, _score_y, string(global.game_score), _score_col);

	draw_set_halign(fa_right);
	draw_set_font(fnt_hud_leveltitle_bungee_med);
	scr_ui_draw_text(GAME_WIDTH - _margin, _margin, STR_LEVEL, COLOR_BOX_FILL);
	var _level_y = _margin + string_height(STR_LEVEL);
	draw_set_font(fnt_hud_level_bungee_med);
	scr_ui_draw_text(GAME_WIDTH - _margin, _level_y, string(global.level), c_white);

	// Hold (left of grid) / Next (right of grid) — each centered vertically on the screen,
	// and horizontally centered in the gap between the grid and its side of the screen.
	var _box_y = (GAME_HEIGHT - BOX_HEIGHT) / 2;
	var _hold_x = GRID_X / 2 - BOX_WIDTH / 2;
	var _next_x = (GRID_X + GRID_WIDTH + GAME_WIDTH) / 2 - BOX_WIDTH / 2;

	if (global.hold_swap_enabled) {
		scr_ui_draw_pair_box(_hold_x, _box_y, global.hold_val1, global.hold_val2, STR_HOLD);
	}
	if (global.show_queue) {
		scr_ui_draw_pair_box(_next_x, _box_y, global.next_val1, global.next_val2, STR_NEXT);
	}

	// Paused
	if (global.help_active) {
		var _layout = scr_help_menu_layout();

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_valign(fa_top);

		draw_set_font(fnt_help_title_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.title_y, STR_HELP_TITLE, c_white);

		draw_set_font(fnt_help_text_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.rules1_y, STR_HELP_RULES_1, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.rules2_y, STR_HELP_RULES_2, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.rules3_y, STR_HELP_RULES_3, c_white);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.rules4_y, STR_HELP_RULES_4, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.rules5_y, STR_HELP_RULES_5, c_white);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.rules6_y, STR_HELP_RULES_6, c_white);

		draw_set_font(fnt_help_title_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.controls_title_y, STR_HELP_CONTROLS_TITLE, c_white);

		draw_set_font(fnt_help_text_bungee_med);
		scr_ui_draw_control_row(_layout.ctrl1_y, STR_HELP_CTRL_KEY_1, STR_HELP_CTRL_ACTION_1);
		scr_ui_draw_control_row(_layout.ctrl2_y, STR_HELP_CTRL_KEY_2, STR_HELP_CTRL_ACTION_2);
		scr_ui_draw_control_row(_layout.ctrl3_y, STR_HELP_CTRL_KEY_3, STR_HELP_CTRL_ACTION_3);
		scr_ui_draw_control_row(_layout.ctrl4_y, STR_HELP_CTRL_KEY_4, STR_HELP_CTRL_ACTION_4);
		scr_ui_draw_control_row(_layout.ctrl5_y, STR_HELP_CTRL_KEY_5, STR_HELP_CTRL_ACTION_5);

		// Back — always highlighted, it's the only option on this screen
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.back_y, STR_HELP_BACK, COLOR_BOX_FILL);
	} else if (global.paused) {
		var _layout = scr_pause_menu_layout();
		var _items = _layout.items;

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_font(fnt_pause_title_bungee_med);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.top, STR_PAUSED, c_white);

		draw_set_font(fnt_pause_buttons_bungee_med);
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _item = _items[_i];
			var _y = _layout.item_y[_i];
			var _highlighted = (global.pause_highlight && _i == global.pause_cursor);
			var _is_toggle = (string_char_at(_item, 1) == "[");

			if (_i == global.pause_selected_index) {
				scr_ui_draw_text(GAME_WIDTH / 2, _y, _item, c_black);
			} else if (_is_toggle && !_highlighted) {
				// "[" and "]" are always dark gray. The X (only present when on) is always red.
				// The label is always the same pale gray as every other item — none of this
				// changes based on on/off, only whether the X itself is there at all.
				var _bracket_open = string_copy(_item, 1, 1);
				var _state_char = string_copy(_item, 2, 1);
				var _bracket_close = string_copy(_item, 3, 1);
				var _label = string_copy(_item, 4, string_length(_item) - 3);
				var _state_col = (_state_char == "X") ? c_red : c_dkgray;

				var _full_w = string_width(_item);
				var _cx = GAME_WIDTH / 2 - _full_w / 2;
				draw_set_halign(fa_left);
				scr_ui_draw_text(_cx, _y, _bracket_open, c_dkgray);
				_cx += string_width(_bracket_open);
				scr_ui_draw_text(_cx, _y, _state_char, _state_col);
				_cx += string_width(_state_char);
				scr_ui_draw_text(_cx, _y, _bracket_close, c_dkgray);
				_cx += string_width(_bracket_close);
				scr_ui_draw_text(_cx, _y, _label, c_silver);
				draw_set_halign(fa_center);
			} else {
				var _col = _highlighted ? COLOR_BOX_FILL : c_silver;
				scr_ui_draw_text(GAME_WIDTH / 2, _y, _item, _col);
			}
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
		draw_set_font(fnt_gameover_title_bungee_med);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _layout.top, STR_GAME_OVER, c_red);

		// Scores
		var _sy = _layout.top + _layout.title_h;

		if (global.high_score_beaten) {
			var _pulse = 0.5 + 0.5 * sin(global.game_over_blink_timer * pi * 3);
			draw_set_font(fnt_gameover_text_bungee_med);
			draw_set_alpha(_pulse);
			scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_NEW_BEST, c_yellow);
			draw_set_alpha(1.0);
			_sy += _layout.score_line_h;
		}

		draw_set_font(fnt_gameover_scorestitle_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_CURRENT_SCORE, COLOR_BOX_FILL);
		_sy += _layout.score_line_h;
		draw_set_font(fnt_gameover_scores_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.game_score), c_white);
		_sy += _layout.score_line_h;
		draw_set_font(fnt_gameover_scorestitle_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_HIGH_SCORE, COLOR_BOX_FILL);
		_sy += _layout.score_line_h;
		draw_set_font(fnt_gameover_scores_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.high_score), c_white);

		// Menu
		draw_set_font(fnt_gameover_buttons_bungee_med);
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _col;
			if (_i == global.game_over_selected_index) {
				_col = c_black;
			} else if (global.game_over_highlight && _i == global.game_over_cursor) {
				_col = COLOR_BOX_FILL;
			} else {
				_col = c_silver;
			}
			scr_ui_draw_text(GAME_WIDTH / 2, _layout.menu_top + _i * _layout.line_h, _items[_i], _col);
		}
	}

	// Reset draw state
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}