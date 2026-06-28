scr_game_input_keyboard();
scr_game_input_touch();

if (global.input_restart) {
	room_restart();
	exit;
}

if (global.input_exit) {
	game_end();
	exit;
}

if (!global.game_over) {
	if (global.pair_active) {
		scr_pair_update();
	} else {
		// Check game over
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