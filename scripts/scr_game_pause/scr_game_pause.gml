function scr_game_pause() {
	global.paused = !global.paused;
	if (global.paused) {
		global.pause_cursor = 0;
		global.pause_highlight = false;
	}
}

function scr_game_pause_update() {
	if (!global.paused || global.help_active) return;

	var _menu_count = 5;
	var _moved = false;

	// Navigation — keyboard
	if (keyboard_check_pressed(vk_up)) { global.pause_cursor--; _moved = true; }
	if (keyboard_check_pressed(vk_down)) { global.pause_cursor++; _moved = true; }

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

	// Mouse hover detection
	if (device_mouse_check_button(0, mb_left) || (abs(device_mouse_x(0) - global.pause_mouse_x) > 1) || (abs(device_mouse_y(0) - global.pause_mouse_y) > 1)) {
		global.pause_mouse_x = device_mouse_x(0);
		global.pause_mouse_y = device_mouse_y(0);
	}

	// Confirm — keyboard/gamepad
	var _confirm = keyboard_check_pressed(vk_enter);
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_face1)) _confirm = true;
	}

	// Touch — tap on option
	if (device_mouse_check_button_released(0, mb_left)) {
		var _my = device_mouse_y(0);
		var _tap_index = scr_pause_menu_hit(_my);
		if (_tap_index >= 0) {
			global.pause_cursor = _tap_index;
			_confirm = true;
		}
	}

	if (_confirm) {
		scr_pause_menu_select(global.pause_cursor);
	}
}

function scr_pause_menu_select(_index) {
	if (_index == 0) {
		scr_game_pause();
	} else if (_index == 1) {
		scr_game_restart();
	} else if (_index == 2) {
		audio_stop_all();
		global.paused = false;
		global.game_state = STATE_SPLASH;
		scr_screen_splash_init();
	} else if (_index == 3) {
		scr_audio_toggle_music();
	} else if (_index == 4) {
		scr_audio_toggle_sfx();
	}
}

function scr_pause_menu_hit(_mouse_y) {
	var _items = [STR_MENU_RESUME, STR_MENU_RESTART, STR_MENU_QUIT,
	              global.music_muted ? STR_MENU_MUTE_ON : STR_MENU_MUTE_OFF,
	              global.sfx_muted ? STR_MENU_SFX_ON : STR_MENU_SFX_OFF];
	draw_set_font(fnt_bungee);
	var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
	var _total_h = array_length(_items) * _line_h;
	draw_set_font(fnt_bungee_title);
	var _title_h = string_height(STR_PAUSED);
	var _gap = _title_h * 0.5;
	var _block_h = _title_h + _gap + _total_h;
	var _top = GAME_HEIGHT / 2 - _block_h / 2;
	var _menu_top = _top + _title_h + _gap;

	for (var _i = 0; _i < array_length(_items); _i++) {
		var _item_y = _menu_top + _i * _line_h;
		if (_mouse_y >= _item_y && _mouse_y < _item_y + _line_h) {
			return _i;
		}
	}
	return -1;
}

function scr_game_over_menu_update() {
	var _menu_count = 2;
	var _moved = false;

	if (keyboard_check_pressed(vk_up)) { global.game_over_cursor--; _moved = true; }
	if (keyboard_check_pressed(vk_down)) { global.game_over_cursor++; _moved = true; }

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

	var _confirm = keyboard_check_pressed(vk_enter);
	if (gamepad_is_connected(_pad)) {
		if (gamepad_button_check_pressed(_pad, gp_face1) || gamepad_button_check_pressed(_pad, gp_start)) _confirm = true;
	}

	if (device_mouse_check_button_released(0, mb_left)) {
		var _my = device_mouse_y(0);
		var _tap_index = scr_game_over_menu_hit(_my);
		if (_tap_index >= 0) {
			global.game_over_cursor = _tap_index;
			_confirm = true;
		}
	}

	if (_confirm) {
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

function scr_game_over_menu_hit(_mouse_y) {
	var _items = [STR_MENU_RESTART, STR_MENU_QUIT];
	draw_set_font(fnt_bungee);
	var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
	var _menu_h = array_length(_items) * _line_h;

	draw_set_font(fnt_bungee_title);
	var _title_h = string_height(STR_GAME_OVER);
	draw_set_font(fnt_bungee);
	var _score_line_h = string_height("M") * UI_SCORE_LINE_H_FACTOR;
	var _scores_h = _score_line_h * 4;
	if (global.high_score_beaten) {
		_scores_h += string_height(STR_NEW_BEST);
	}
	var _gap = _title_h * UI_GAME_OVER_GAP_FACTOR;
	var _block_h = _title_h + _scores_h + _gap + _menu_h;
	var _top = GAME_HEIGHT / 2 - _block_h / 2;
	var _menu_top = _top + _title_h + _scores_h + _gap;

	for (var _i = 0; _i < array_length(_items); _i++) {
		var _item_y = _menu_top + _i * _line_h;
		if (_mouse_y >= _item_y && _mouse_y < _item_y + _line_h) {
			return _i;
		}
	}
	return -1;
}
