function scr_game_update() {
	scr_display_mode_update();

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
	} else if (global.input_help && !global.game_over && !global.countdown_active && !global.fade_active) {
		global.help_active = true;
		global.paused = true;
	} else if (global.input_pause && !global.game_over && !global.countdown_active && !global.fade_active) {
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

	if (global.fade_active) {
		scr_screen_fade_update();
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
			} else if (global.junk_state == "none") {
				scr_pair_spawn_next();
			}
		}

		scr_junk_drop_check_start();
		scr_junk_drop_update();
	}

	// --- Random die cycling (always active for next box display) ---
	global.pair_random_timer += delta_time / DELTA_TO_SECONDS;
	var _random_cycle_speed = (global.level >= RANDOM_CYCLE_SPEED_FAST_LEVEL) ? RANDOM_CYCLE_SPEED_FAST : RANDOM_CYCLE_SPEED_BASE;
	if (global.pair_random_timer >= _random_cycle_speed) {
		global.pair_random_timer -= _random_cycle_speed;
		var _max_rnd = PAIR_MIN_VALUE;
		for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
			if (global.spawn_weights[_i] > 0) _max_rnd = _i;
		}
		global.pair_random_val++;
		if (global.pair_random_val > _max_rnd) global.pair_random_val = PAIR_MIN_VALUE;
	}

	scr_grid_resolve();
	scr_level_update();
	scr_game_bg_update();

	if (!global.high_score_beaten && global.score > global.high_score) {
		global.high_score_beaten = true;
		scr_audio_play_sfx(snd_highscore);
	}

	scr_screen_fade_update();
}