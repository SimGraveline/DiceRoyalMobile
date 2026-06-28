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

	if (global.paused) return;

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
				global.game_over = true;
			} else {
				scr_pair_spawn_next();
			}
		}
	}

	scr_grid_resolve();
}