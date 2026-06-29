function scr_game_update() {
	scr_game_input_keyboard();
	scr_game_input_gamepad();
	scr_game_input_touch();

	if (global.input_restart) {
		room_restart();
		exit;
	}

	if (global.input_exit) {
		game_end();
		exit;
	}

	if (global.input_pause && !global.game_over) {
		scr_game_pause();
	}

	if (global.input_grid_lines) {
		global.grid_lines = !global.grid_lines;
	}

	if (global.input_mute_music) {
		scr_audio_toggle_music();
	}

	if (global.paused) return;

	if (global.countdown_active) {
		scr_countdown_update();
		scr_game_bg_update();
		return;
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
}