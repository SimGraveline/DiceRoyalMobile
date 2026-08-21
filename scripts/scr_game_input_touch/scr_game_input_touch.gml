function scr_game_input_touch() {
	// Tap anywhere: splash
	if (global.game_state == STATE_SPLASH && device_mouse_check_button_released(0, mb_left)) {
		global.input_confirm = true;
		return;
	}

	// UI button taps
	if (device_mouse_check_button_released(0, mb_left)) {
		var _mx = device_mouse_x(0);
		var _my = device_mouse_y(0);
		if (_mx >= UI_BTN_PAUSE_X && _mx <= UI_BTN_PAUSE_X + UI_BTN_SIZE
		 && _my >= UI_BTN_PAUSE_Y && _my <= UI_BTN_PAUSE_Y + UI_BTN_SIZE) {
			global.input_pause = true;
			return;
		}
		if (_mx >= UI_BTN_HELP_X && _mx <= UI_BTN_HELP_X + UI_BTN_SIZE
		 && _my >= UI_BTN_HELP_Y && _my <= UI_BTN_HELP_Y + UI_BTN_SIZE) {
			global.input_help = true;
			return;
		}
	}

	if (device_mouse_check_button_pressed(0, mb_left) && global.pair_active) {
		global.touch_active = true;
		global.touch_start_x = device_mouse_x(0);
		global.touch_start_y = device_mouse_y(0);
		global.touch_dragging = false;
		global.touch_drag_col = global.pair_col;
	}

	if (global.touch_active && global.pair_active && device_mouse_check_button(0, mb_left)) {
		var _dx = device_mouse_x(0) - global.touch_start_x;
		var _dy = device_mouse_y(0) - global.touch_start_y;

		if (abs(_dx) > abs(_dy) && abs(_dx) >= DRAG_THRESHOLD) {
			// Horizontal dominant → drag movement
			global.touch_dragging = true;
			var _col_offset = floor(_dx / DRAG_SENSITIVITY);
			var _target_col = global.touch_drag_col + _col_offset;
			if (_target_col < global.pair_col) {
				global.input_left = true;
			} else if (_target_col > global.pair_col) {
				global.input_right = true;
			}
		} else if (_dy > SWIPE_MIN_DISTANCE) {
			// Vertical down held → soft drop
			global.input_soft_drop = true;
		}
	}

	if (global.touch_active && device_mouse_check_button_released(0, mb_left)) {
		var _dx = device_mouse_x(0) - global.touch_start_x;
		var _dy = device_mouse_y(0) - global.touch_start_y;
		var _dist = sqrt(_dx * _dx + _dy * _dy);

		if (!global.touch_dragging) {
			if (_dist >= SWIPE_MIN_DISTANCE && abs(_dy) > abs(_dx) && _dy < 0) {
				// Vertical swipe up → hard drop
				global.input_hard_drop = true;
			} else if (_dist < SWIPE_MIN_DISTANCE) {
				// Tap — check zone
				var _tap_y = global.touch_start_y / GAME_HEIGHT;
				if (_tap_y <= TAP_ZONE_SPLIT) {
					var _tap_x = global.touch_start_x / GAME_WIDTH;
					if (_tap_x >= ROTATE_SPLIT) {
						global.input_rotate_cw = true;
					} else {
						global.input_rotate_ccw = true;
					}
				} else {
					global.input_hold = true;
				}
			}
		}

		global.touch_active = false;
	}
}