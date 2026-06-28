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
	global.solo_active = false;
	global.solo_col = 0;
	global.solo_row = 0;
	global.solo_val = 0;
	global.last_pair_col = SPAWN_COL_LEFT;

	// Touch state
	global.touch_active = false;
	global.touch_start_x = 0;
	global.touch_start_y = 0;
	global.touch_dragging = false;
	global.touch_drag_col = 0;

	scr_pair_spawn();
}