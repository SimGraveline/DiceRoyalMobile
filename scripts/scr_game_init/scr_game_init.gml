function scr_game_init() {
	randomize();
	scr_grid_init();

	global.spawn_weights = [0, 1, 1, 1, 1, 1, 1, 0, 0, 0];
	global.drop_timer = 0;
	global.das_timer = 0;
	global.das_direction = 0;
	global.lock_timer = 0;
	global.lock_resets = 0;
	global.lock_active = false;
	global.last_pair_col = SPAWN_COL_LEFT;
	global.game_over = false;
	global.paused = false;
	global.help_active = false;
	global.pause_cursor = 0;
	global.pause_highlight = false;
	global.pause_stick_prev = false;
	global.pause_mouse_x = 0;
	global.pause_mouse_y = 0;
	global.fade_active = false;
	global.countdown_active = false;
	global.ghost_enabled = true;
	global.grid_lines = false;
	global.score = 0;
	global.level = 1;
	global.level_pulse_timer = 0;
	scr_save_load();
	global.high_score_beaten = false;

	LEVEL_THRESHOLDS = [0, 1000, 3000, 5000, 7000, 10000, 20000, 30000, 40000, 50000,
	                    100000, 200000, 300000, 400000, 500000, 600000, 700000, 800000, 900000, 1000000];
	LEVEL_SPEEDS     = [1.00, 0.90, 0.80, 0.70, 0.60, 0.50, 0.40, 0.30, 0.20, 0.10,
	                    0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.10, 0.05];
	global.drop_speed = LEVEL_SPEEDS[0];
	global.combo_count = 0;
	global.hold_val1 = -1;
	global.hold_val2 = -1;
	global.hold_used = false;
	global.pair_random_val = 1;
	global.pair_random_timer = 0;
	global.splash_music_id = -1;

	// Gamepad state
	global.gamepad_stick_up_prev = false;

	// Touch state
	global.touch_active = false;
	global.touch_start_x = 0;
	global.touch_start_y = 0;
	global.touch_dragging = false;
	global.touch_drag_col = 0;

	global.junk_spawn_counter = 0;
	global.junk_state = "none";
	global.junk_queue = [];
	global.junk_falling = [];
	global.junk_drop_timer = 0;
	global.junk_track_pending = false;
	global.junk_track_timer = 0;

	global.game_state = STATE_LOGOS;
	scr_screen_logos_init();
	scr_game_bg_init();
	scr_audio_init();
	scr_pair_generate_next();
	scr_pair_spawn();
	global.junk_track_pending = true;
}

function scr_game_restart() {
	audio_stop_all();
	scr_grid_init();

	global.spawn_weights = [0, 1, 1, 1, 1, 1, 1, 0, 0, 0];
	global.drop_timer = 0;
	global.das_timer = 0;
	global.das_direction = 0;
	global.lock_timer = 0;
	global.lock_resets = 0;
	global.lock_active = false;
	global.last_pair_col = SPAWN_COL_LEFT;
	global.game_over = false;
	global.paused = false;
	global.help_active = false;
	global.pause_cursor = 0;
	global.pause_highlight = false;
	global.pause_stick_prev = false;
	global.pause_mouse_x = 0;
	global.pause_mouse_y = 0;
	global.ghost_enabled = true;
	global.grid_lines = false;
	global.score = 0;
	global.level = 1;
	global.drop_speed = LEVEL_SPEEDS[0];
	global.level_pulse_timer = 0;
	scr_save_load();
	global.high_score_beaten = false;
	global.combo_count = 0;
	global.hold_val1 = -1;
	global.hold_val2 = -1;
	global.hold_used = false;
	global.pair_random_val = 1;
	global.pair_random_timer = 0;
	global.gamepad_stick_up_prev = false;
	global.touch_active = false;
	global.touch_start_x = 0;
	global.touch_start_y = 0;
	global.touch_dragging = false;
	global.touch_drag_col = 0;

	global.junk_spawn_counter = 0;
	global.junk_state = "none";
	global.junk_queue = [];
	global.junk_falling = [];
	global.junk_drop_timer = 0;
	global.junk_track_pending = false;
	global.junk_track_timer = 0;

	global.game_state = STATE_GAME;
	scr_audio_init();
	scr_pair_generate_next();
	scr_pair_spawn();
	global.junk_track_pending = true;
	if (!global.fade_active) {
		scr_countdown_start();
	}
}