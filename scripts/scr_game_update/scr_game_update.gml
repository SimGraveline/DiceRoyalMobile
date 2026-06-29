function scr_game_update() {
	if (global.game_state == STATE_LOGOS) {
		scr_screen_logos_update();
		return;
	}

	scr_game_input_keyboard();
	scr_game_input_gamepad();
	scr_game_input_touch();

	if (global.game_state == STATE_SPLASH) {
		scr_screen_splash_update();
		return;
	}

	if (global.input_restart) {
		audio_stop_all();
		room_restart();
		exit;
	}

	if (global.input_exit) {
		game_end();
		exit;
	}

	if (global.help_active && (global.input_help || global.input_pause)) {
		global.help_active = false;
		global.paused = false;
	} else if (global.input_help && !global.game_over && !global.countdown_active) {
		global.help_active = true;
		global.paused = true;
	} else if (global.input_pause && !global.game_over && !global.countdown_active) {
		scr_game_pause();
	}

	if (global.input_grid_lines) {
		global.grid_lines = !global.grid_lines;
	}

	if (global.input_mute_music) {
		scr_audio_toggle_music();
	}

	if (global.paused) {
		scr_game_pause_update();
		return;
	}

	if (global.countdown_active) {
		scr_countdown_update();
		scr_game_bg_update();
		return;
	}

	if (global.game_over) {
		global.game_over_tap_timer -= delta_time / DELTA_TO_SECONDS;
		global.game_over_blink_timer += delta_time / DELTA_TO_SECONDS;
		if (global.game_over_tap_timer <= 0) {
			scr_game_over_menu_update();
		}
	}

	if (global.input_hold) {
		scr_game_hold();
	}

	if (!global.game_over) {
		if (global.pair_active) {
			scr_pair_update();
		} else {
			var _blocked = false;
			for (var _col = 0; _col < GRID_COLS; _col++) {
				if (global.grid[_col][DEAD_ZONE_ROW] != 0) {
					_blocked = true;
					break;
				}
			}

			if (_blocked) {
				// Only game over if nothing is resolving — dying dice may free the dead zone
				var _resolving = false;
				for (var _col = 0; _col < GRID_COLS; _col++) {
					for (var _row = 0; _row <= GRID_ROWS; _row++) {
						if (global.grid_dying[_col][_row] > 0) {
							_resolving = true;
							break;
						}
					}
					if (_resolving) break;
				}
				if (!_resolving) {
					global.game_over = true;
					global.game_over_tap_timer = GAME_OVER_TAP_DELAY;
					global.game_over_blink_timer = 0;
					global.game_over_cursor = 0;
					global.game_over_highlight = false;
					global.game_over_stick_prev = false;
					if (global.score > global.high_score) {
						global.high_score = global.score;
						scr_save_write();
					}
				}
			} else {
				scr_pair_spawn_next();
			}
		}
	}

	scr_grid_resolve();
	scr_level_update();
	scr_game_bg_update();

	if (!global.high_score_beaten && global.score > global.high_score) {
		global.high_score_beaten = true;
		audio_play_sound(snd_highscore, 0, false);
	}

	scr_screen_fade_update();
}