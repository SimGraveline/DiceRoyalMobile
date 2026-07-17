function scr_game_over_pause() {
	global.paused = !global.paused;
	if (global.paused) {
		global.pause_cursor = 0;
		global.pause_highlight = true;
	}
}

// Layout for the Help screen (reached only from the Pause menu) — single source of truth shared
// by the draw code and the Back button's hit-test, same pattern as the pause/game over layouts.
function scr_help_menu_layout() {
	draw_set_font(fnt_help_title_bungee_med);
	var _title_h = string_height(STR_HELP_TITLE);
	draw_set_font(fnt_help_text_bungee_med);
	var _line_h = string_height("M");
	var _blank_h = string_height("M") * UI_MENU_BLANK_LINE_FACTOR;
	var _back_h = string_height(STR_HELP_BACK);
	var _title_gap = _title_h / 2;

	var _total_h = (_title_h + _title_gap)   // HOW TO PLAY
		+ _line_h * 2 + _blank_h             // Rules 1-2, space
		+ _line_h + _blank_h                 // Rules 3, space
		+ _line_h * 3 + _blank_h * 2         // Rules 4-6, space, space
		+ (_title_h + _title_gap)            // CONTROLS
		+ _line_h * 3 + _blank_h             // Ctrl 1-3, space
		+ _line_h * 2 + _blank_h             // Ctrl 4-5, space
		+ _back_h;                           // Back

	var _box_top = GRID_Y - GRID_OUTLINE_WIDTH;
	var _box_h = GRID_HEIGHT + GRID_OUTLINE_WIDTH * 2;
	var _top = _box_top + (_box_h - _total_h) / 2;

	var _y = _top;
	var _title_y = _y; _y += _title_h + _title_gap;
	var _rules1_y = _y; _y += _line_h;
	var _rules2_y = _y; _y += _line_h + _blank_h;
	var _rules3_y = _y; _y += _line_h + _blank_h;
	var _rules4_y = _y; _y += _line_h;
	var _rules5_y = _y; _y += _line_h;
	var _rules6_y = _y; _y += _line_h + _blank_h * 2;
	var _controls_title_y = _y; _y += _title_h + _title_gap;
	var _ctrl1_y = _y; _y += _line_h;
	var _ctrl2_y = _y; _y += _line_h;
	var _ctrl3_y = _y; _y += _line_h + _blank_h;
	var _ctrl4_y = _y; _y += _line_h;
	var _ctrl5_y = _y; _y += _line_h + _blank_h;
	var _back_y = _y;

	return {
		title_y: _title_y,
		rules1_y: _rules1_y,
		rules2_y: _rules2_y,
		rules3_y: _rules3_y,
		rules4_y: _rules4_y,
		rules5_y: _rules5_y,
		rules6_y: _rules6_y,
		controls_title_y: _controls_title_y,
		ctrl1_y: _ctrl1_y,
		ctrl2_y: _ctrl2_y,
		ctrl3_y: _ctrl3_y,
		ctrl4_y: _ctrl4_y,
		ctrl5_y: _ctrl5_y,
		back_y: _back_y,
		back_h: _back_h
	};
}

function scr_help_back_hit(_mouse_y) {
	var _layout = scr_help_menu_layout();
	return (_mouse_y >= _layout.back_y && _mouse_y < _layout.back_y + _layout.back_h);
}

// Help is reached only from the Pause menu (see scr_pause_menu_select) — the only interaction
// here is confirming Back, which returns to Pause without fully closing it. Escape still fully
// closes both (see scr_game_update).
function scr_help_menu_update() {
	if (!global.help_active) return;

	var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
	var _pad = GAMEPAD_INDEX;
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_face1)) _confirm = true;
	}

	if (device_mouse_check_button_released(0, mb_left) && scr_help_back_hit(device_mouse_y(0))) {
		_confirm = true;
	}

	if (_confirm) {
		global.help_active = false;
	}
}

function scr_game_pause_update() {
	if (!global.paused || global.help_active) return;

	global.pause_selected_index = -1;

	var _menu_count = 10;
	var _moved = false;

	// Navigation — keyboard
	if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) { global.pause_cursor--; _moved = true; }
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) { global.pause_cursor++; _moved = true; }

	// Navigation — gamepad
	var _pad = GAMEPAD_INDEX;
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_padu)) { global.pause_cursor--; _moved = true; }
		if (gamepad_button_check_pressed(_pad, gp_padd)) { global.pause_cursor++; _moved = true; }
		var _ly = gamepad_axis_value(_pad, gp_axislv);
		if (abs(_ly) > GAMEPAD_DEADZONE) {
			if (!global.pause_stick_prev) {
				if (_ly < 0) { global.pause_cursor--; _moved = true; }
				if (_ly > 0) { global.pause_cursor++; _moved = true; }
			}
			global.pause_stick_prev = true;
		} else {
			global.pause_stick_prev = false;
		}
	}

	if (_moved) {
		global.pause_highlight = true;
		global.pause_cursor = (global.pause_cursor + _menu_count) mod _menu_count;
	}

	// Mouse hover — the last input device used always wins. Keyboard/gamepad navigation this
	// frame (above) takes priority outright; the mouse only gets a say when it's the one that
	// actually moved, past a threshold that filters out a resting hand's sensor jitter.
	var _mx = device_mouse_x(0);
	var _my = device_mouse_y(0);
	var _mouse_moved = (abs(_mx - global.pause_mouse_x) > MENU_MOUSE_MOVE_THRESHOLD || abs(_my - global.pause_mouse_y) > MENU_MOUSE_MOVE_THRESHOLD);
	global.pause_mouse_x = _mx;
	global.pause_mouse_y = _my;
	if (!_moved && _mouse_moved) {
		var _hover_index = scr_pause_menu_hit(_my);
		if (_hover_index >= 0) {
			global.pause_cursor = _hover_index;
			global.pause_highlight = true;
		}
	}

	// Confirm — keyboard/gamepad
	var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_face1)) _confirm = true;
	}

	// Touch — tap on option
	if (device_mouse_check_button_released(0, mb_left)) {
		var _tap_index = scr_pause_menu_hit(_my);
		if (_tap_index >= 0) {
			global.pause_cursor = _tap_index;
			_confirm = true;
		}
	}

	if (_confirm) {
		global.pause_selected_index = global.pause_cursor;
		scr_pause_menu_select(global.pause_cursor);
	}
}

function scr_pause_menu_select(_index) {
	if (_index == 0) {
		scr_game_over_pause();
	} else if (_index == 1) {
		scr_game_restart();
	} else if (_index == 2) {
		global.help_active = true; // stays paused — Back (or Escape) returns from here, see scr_help_menu_update
	} else if (_index == 3) {
		scr_audio_toggle_music();
	} else if (_index == 4) {
		scr_audio_toggle_sfx();
	} else if (_index == 5) {
		global.grid_lines = !global.grid_lines; // same flag as the Tab/Select in-game toggle
	} else if (_index == 6) {
		global.show_queue = !global.show_queue;
	} else if (_index == 7) {
		global.hold_swap_enabled = !global.hold_swap_enabled;
	} else if (_index == 8) {
		scr_ghost_toggle();
	} else if (_index == 9) {
		audio_stop_all();
		global.paused = false;
		global.game_state = STATE_SPLASH;
		scr_screen_splash_init();
	}
}

function scr_pause_menu_layout() {
	var _items = [STR_MENU_RESUME, STR_MENU_RESTART, STR_MENU_HELP,
	              global.music_muted ? STR_MENU_MUTE_ON : STR_MENU_MUTE_OFF,
	              global.sfx_muted ? STR_MENU_SFX_ON : STR_MENU_SFX_OFF,
	              global.grid_lines ? STR_MENU_SHOW_GRID_ON : STR_MENU_SHOW_GRID_OFF,
	              global.show_queue ? STR_MENU_SHOW_QUEUE_ON : STR_MENU_SHOW_QUEUE_OFF,
	              global.hold_swap_enabled ? STR_MENU_HOLD_SWAP_ON : STR_MENU_HOLD_SWAP_OFF,
	              global.ghost_enabled ? STR_MENU_GHOST_ON : STR_MENU_GHOST_OFF,
	              STR_MENU_QUIT];
	// Blank line inserted after each of these item indices
	var _blank_after = [2, 4, 8];

	draw_set_font(fnt_pause_buttons_bungee_med);
	var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
	var _blank_h = string_height("M") * UI_MENU_BLANK_LINE_FACTOR;
	var _menu_h = array_length(_items) * _line_h + array_length(_blank_after) * _blank_h;
	draw_set_font(fnt_pause_title_bungee_med);
	var _title_h = string_height(STR_PAUSED);
	var _gap = _title_h * 0.5;
	var _block_h = _title_h + _gap + _menu_h;
	var _box_top = GRID_Y - GRID_OUTLINE_WIDTH;
	var _box_h = GRID_HEIGHT + GRID_OUTLINE_WIDTH * 2;
	var _top = _box_top + (_box_h - _block_h) / 2;
	var _menu_top = _top + _title_h + _gap;

	var _item_y = array_create(array_length(_items));
	for (var _i = 0; _i < array_length(_items); _i++) {
		var _shift = 0;
		for (var _b = 0; _b < array_length(_blank_after); _b++) {
			if (_blank_after[_b] < _i) _shift += 1;
		}
		_item_y[_i] = _menu_top + _i * _line_h + _shift * _blank_h;
	}

	return {
		items: _items,
		item_y: _item_y,
		line_h: _line_h,
		title_h: _title_h,
		gap: _gap,
		block_h: _block_h,
		top: _top,
		menu_top: _menu_top
	};
}

function scr_pause_menu_hit(_mouse_y) {
	var _layout = scr_pause_menu_layout();

	for (var _i = 0; _i < array_length(_layout.items); _i++) {
		var _item_y = _layout.item_y[_i];
		if (_mouse_y >= _item_y && _mouse_y < _item_y + _layout.line_h) {
			return _i;
		}
	}
	return -1;
}

function scr_game_over_menu_update() {
	global.game_over_selected_index = -1;

	var _menu_count = 2;
	var _moved = false;

	if (keyboard_check_pressed(vk_up) || keyboard_check_pressed(ord("W"))) { global.game_over_cursor--; _moved = true; }
	if (keyboard_check_pressed(vk_down) || keyboard_check_pressed(ord("S"))) { global.game_over_cursor++; _moved = true; }

	var _pad = GAMEPAD_INDEX;
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_padu)) { global.game_over_cursor--; _moved = true; }
		if (gamepad_button_check_pressed(_pad, gp_padd)) { global.game_over_cursor++; _moved = true; }
		var _ly = gamepad_axis_value(_pad, gp_axislv);
		if (abs(_ly) > GAMEPAD_DEADZONE) {
			if (!global.game_over_stick_prev) {
				if (_ly < 0) { global.game_over_cursor--; _moved = true; }
				if (_ly > 0) { global.game_over_cursor++; _moved = true; }
			}
			global.game_over_stick_prev = true;
		} else {
			global.game_over_stick_prev = false;
		}
	}

	if (_moved) {
		global.game_over_highlight = true;
		global.game_over_cursor = (global.game_over_cursor + _menu_count) mod _menu_count;
	}

	// Mouse hover — the last input device used always wins, same rule as the pause menu.
	var _mx = device_mouse_x(0);
	var _my = device_mouse_y(0);
	var _mouse_moved = (abs(_mx - global.game_over_mouse_x) > MENU_MOUSE_MOVE_THRESHOLD || abs(_my - global.game_over_mouse_y) > MENU_MOUSE_MOVE_THRESHOLD);
	global.game_over_mouse_x = _mx;
	global.game_over_mouse_y = _my;
	if (!_moved && _mouse_moved) {
		var _hover_index = scr_game_over_menu_hit(_my);
		if (_hover_index >= 0) {
			global.game_over_cursor = _hover_index;
			global.game_over_highlight = true;
		}
	}

	var _confirm = keyboard_check_pressed(vk_enter) || keyboard_check_pressed(vk_space);
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_face1) || gamepad_button_check_pressed(_pad, gp_start)) _confirm = true;
	}

	if (device_mouse_check_button_released(0, mb_left)) {
		var _tap_index = scr_game_over_menu_hit(_my);
		if (_tap_index >= 0) {
			global.game_over_cursor = _tap_index;
			_confirm = true;
		}
	}

	if (_confirm) {
		global.game_over_selected_index = global.game_over_cursor;
		scr_game_over_menu_select(global.game_over_cursor);
	}
}

function scr_game_over_menu_select(_index) {
	if (_index == 0) {
		scr_game_restart();
	} else if (_index == 1) {
		audio_stop_all();
		global.game_over = false;
		global.game_state = STATE_SPLASH;
		scr_screen_splash_init();
	}
}

function scr_game_over_menu_layout() {
	var _items = [STR_MENU_RESTART, STR_MENU_QUIT];

	draw_set_font(fnt_gameover_title_bungee_med);
	var _title_h = string_height(STR_GAME_OVER);
	draw_set_font(fnt_gameover_scores_bungee_med);
	var _score_line_h = string_height("M") * UI_SCORE_LINE_H_FACTOR;
	var _value_gap = string_height("M") * UI_SCORE_VALUE_GAP_FACTOR;
	draw_set_font(fnt_gameover_buttons_bungee_med);
	var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
	var _gap = string_height("M") * UI_MENU_BLANK_LINE_FACTOR;

	var _new_best_h = 0;
	if (global.high_score_beaten) {
		_new_best_h = _score_line_h;
	}
	// Current Score/High Score each get a tight label->value gap, with the normal (larger)
	// line height separating the two groups and trailing after the last value.
	var _scores_h = _new_best_h + _score_line_h * 2 + _value_gap * 2;
	var _menu_h = array_length(_items) * _line_h;
	var _block_h = _title_h + _scores_h + _gap + _menu_h;
	var _box_top = GRID_Y - GRID_OUTLINE_WIDTH;
	var _box_h = GRID_HEIGHT + GRID_OUTLINE_WIDTH * 2;
	var _top = _box_top + (_box_h - _block_h) / 2;
	var _menu_top = _top + _title_h + _scores_h + _gap;

	return {
		items: _items,
		line_h: _line_h,
		score_line_h: _score_line_h,
		value_gap: _value_gap,
		title_h: _title_h,
		scores_h: _scores_h,
		gap: _gap,
		block_h: _block_h,
		top: _top,
		menu_top: _menu_top
	};
}

function scr_game_over_menu_hit(_mouse_y) {
	var _layout = scr_game_over_menu_layout();

	for (var _i = 0; _i < array_length(_layout.items); _i++) {
		var _item_y = _layout.menu_top + _i * _layout.line_h;
		if (_mouse_y >= _item_y && _mouse_y < _item_y + _layout.line_h) {
			return _i;
		}
	}
	return -1;
}
