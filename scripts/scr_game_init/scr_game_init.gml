function scr_game_init() {
	randomize();
	scr_grid_init();

	global.spawn_weights = [0, 1, 1, 1, 1, 1, 1];
	global.drop_timer = 0;
	global.das_timer = 0;
	global.das_direction = 0;
	global.lock_timer = 0;
	global.lock_resets = 0;
	global.lock_active = false;
	global.last_pair_col = SPAWN_COL_LEFT;
	global.game_over = false;
	global.paused = false;
	global.ghost_enabled = true;
	global.score = 0;
	global.level = 0;
	global.combo_count = 0;
	global.hold_val1 = -1;
	global.hold_val2 = -1;
	global.hold_used = false;

	// Gamepad state
	global.gamepad_stick_up_prev = false;

	// Touch state
	global.touch_active = false;
	global.touch_start_x = 0;
	global.touch_start_y = 0;
	global.touch_dragging = false;
	global.touch_drag_col = 0;

	scr_pair_generate_next();
	scr_pair_spawn();
}