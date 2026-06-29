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
	global.grid_lines = false;
	global.score = 0;
	global.level = 1;
	global.drop_speed = 1.00;
	scr_save_load();
	global.high_score_beaten = false;

	LEVEL_THRESHOLDS = [0, 10000, 30000, 60000, 100000, 150000, 210000, 280000, 360000, 450000, 550000];
	LEVEL_SPEEDS     = [1.00, 0.95, 0.85, 0.70, 0.50, 0.25, 0.10, 0.075, 0.05, 0.025, 0.01];
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

	scr_game_bg_init();
	scr_audio_init();
	scr_pair_generate_next();
	scr_pair_spawn();
	scr_countdown_start();
}