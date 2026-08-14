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

	var _menu_count = array_length(scr_pause_menu_items());
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

// THE description of the pause menu — the only place a row is defined. The layout, the navigation
// wrap-around, the mouse hit-test, the draw and the confirm action all read this same list, so
// adding, removing or reordering a row is a one-place change. It used to be spelled out in four
// separate spots (a string array, a hardcoded count of 10, a chain of index comparisons, and an
// array of blank-line indices) that had to be kept in sync by hand.
//   label       what's drawn
//   action      which PAUSE_ACTION confirming this row performs
//   checked     present only on a toggle row — whether its X is currently showing
//   blank_after present only where a group separator gap follows this row
function scr_pause_menu_items() {
	return [
		{ label: STR_MENU_RESUME,  action: PAUSE_ACTION.RESUME },
		{ label: STR_MENU_RESTART, action: PAUSE_ACTION.RESTART },
		{ label: STR_MENU_HELP,    action: PAUSE_ACTION.HELP, blank_after: true },
		{ label: STR_MENU_MUTE_MUSIC, action: PAUSE_ACTION.MUTE_MUSIC, checked: global.music_muted },
		{ label: STR_MENU_MUTE_SFX,   action: PAUSE_ACTION.MUTE_SFX,   checked: global.sfx_muted, blank_after: true },
		{ label: STR_MENU_SHOW_GRID,  action: PAUSE_ACTION.SHOW_GRID,  checked: global.grid_lines },
		{ label: STR_MENU_SHOW_QUEUE, action: PAUSE_ACTION.SHOW_QUEUE, checked: global.show_queue },
		{ label: STR_MENU_HOLD_SWAP,  action: PAUSE_ACTION.HOLD_SWAP,  checked: global.hold_swap_enabled },
		{ label: STR_MENU_GHOST,      action: PAUSE_ACTION.GHOST,      checked: global.ghost_enabled, blank_after: true },
		{ label: STR_MENU_QUIT,    action: PAUSE_ACTION.QUIT }
	];
}

// The two optional fields of a menu row, each read through one accessor so the field name is
// spelled once instead of at every site that asks about it.
// A toggle is exactly a row that carries a checked state.
function scr_menu_item_is_toggle(_item) {
	return variable_struct_exists(_item, "checked");
}

// A group separator gap follows this row.
function scr_menu_item_has_gap(_item) {
	return variable_struct_exists(_item, "blank_after");
}

// The row as it reads on screen, checkbox included. Used for width/centering; the draw code
// re-composes the same pieces when it needs to color them independently (see scr_ui_draw).
function scr_pause_item_text(_item) {
	if (!scr_menu_item_is_toggle(_item)) return _item.label;
	return STR_TOGGLE_OPEN + (_item.checked ? STR_TOGGLE_ON : STR_TOGGLE_OFF) + STR_TOGGLE_CLOSE + _item.label;
}

function scr_pause_menu_select(_index) {
	var _items = scr_pause_menu_items();
	if (_index < 0 || _index >= array_length(_items)) return;

	switch (_items[_index].action) {
		case PAUSE_ACTION.RESUME:
			scr_game_over_pause();
			break;
		case PAUSE_ACTION.RESTART:
			scr_game_restart();
			break;
		case PAUSE_ACTION.HELP:
			global.help_active = true; // stays paused — Back (or Escape) returns from here, see scr_help_menu_update
			break;
		case PAUSE_ACTION.MUTE_MUSIC:
			scr_audio_toggle_music();
			break;
		case PAUSE_ACTION.MUTE_SFX:
			scr_audio_toggle_sfx();
			break;
		case PAUSE_ACTION.SHOW_GRID:
			global.grid_lines = !global.grid_lines; // same flag as the Tab/Select in-game toggle
			break;
		case PAUSE_ACTION.SHOW_QUEUE:
			global.show_queue = !global.show_queue;
			break;
		case PAUSE_ACTION.HOLD_SWAP:
			global.hold_swap_enabled = !global.hold_swap_enabled;
			break;
		case PAUSE_ACTION.GHOST:
			scr_ghost_toggle();
			break;
		case PAUSE_ACTION.QUIT:
			audio_stop_all();
			global.paused = false;
			global.game_state = STATE_SPLASH;
			scr_screen_splash_init();
			break;
	}
}

function scr_pause_menu_layout() {
	var _items = scr_pause_menu_items();

	// Blank lines come from the rows themselves, so a group separator can never end up attached
	// to the wrong row after a reorder.
	var _blank_count = 0;
	for (var _i = 0; _i < array_length(_items); _i++) {
		if (scr_menu_item_has_gap(_items[_i])) _blank_count++;
	}

	draw_set_font(fnt_pause_buttons_bungee_med);
	var _line_h = string_height("M") * UI_MENU_LINE_H_FACTOR;
	var _blank_h = string_height("M") * UI_MENU_BLANK_LINE_FACTOR;
	var _menu_h = array_length(_items) * _line_h + _blank_count * _blank_h;
	draw_set_font(fnt_pause_title_bungee_med);
	var _title_h = string_height(STR_PAUSED);
	var _gap = _title_h * 0.5;
	var _block_h = _title_h + _gap + _menu_h;
	var _box_top = GRID_Y - GRID_OUTLINE_WIDTH;
	var _box_h = GRID_HEIGHT + GRID_OUTLINE_WIDTH * 2;
	var _top = _box_top + (_box_h - _block_h) / 2;
	var _menu_top = _top + _title_h + _gap;

	// Walk the rows in order, adding a gap after any row that asks for one — the offset accumulates
	// naturally instead of being recomputed from a separate list of indices.
	var _item_y = array_create(array_length(_items));
	var _y = _menu_top;
	for (var _i = 0; _i < array_length(_items); _i++) {
		_item_y[_i] = _y;
		_y += _line_h;
		if (scr_menu_item_has_gap(_items[_i])) _y += _blank_h;
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

	var _menu_count = array_length(scr_game_over_menu_items());
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

// Same single-source-of-truth rule as scr_pause_menu_items, on a much shorter menu. No toggles
// and no group separators here, so a row is just a label and its action.
function scr_game_over_menu_items() {
	return [
		{ label: STR_MENU_RESTART, action: GAME_OVER_ACTION.RESTART },
		{ label: STR_MENU_QUIT,    action: GAME_OVER_ACTION.QUIT }
	];
}

function scr_game_over_menu_select(_index) {
	var _items = scr_game_over_menu_items();
	if (_index < 0 || _index >= array_length(_items)) return;

	switch (_items[_index].action) {
		case GAME_OVER_ACTION.RESTART:
			scr_game_restart();
			break;
		case GAME_OVER_ACTION.QUIT:
			audio_stop_all();
			global.game_over = false;
			global.game_state = STATE_SPLASH;
			scr_screen_splash_init();
			break;
	}
}

function scr_game_over_menu_layout() {
	var _items = scr_game_over_menu_items();

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
