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
	global.pause_highlight = true;
	global.pause_selected_index = -1;
	global.pause_stick_prev = false;
	global.pause_mouse_x = 0;
	global.pause_mouse_y = 0;
	global.fade_active = false;
	global.countdown_active = false;
	global.game_score = 0;
	global.level = 1;
	global.level_pulse_timer = 0;
	scr_save_load(); // sets high_score(_name), music_muted, sfx_muted, grid_lines, show_queue, hold_swap_enabled, ghost_enabled
	global.high_score_beaten = false;

	LEVEL_THRESHOLDS = [0, 5000, 15000, 30000, 50000, 75000, 105000, 140000, 180000, 225000, 275000, 330000, 390000, 455000, 525000, 600000, 680000, 765000, 855000, 950000];
	LEVEL_SPEEDS     = [0.75, 0.75, 0.75, 0.50, 0.50, 0.50, 0.40, 0.40, 0.40, 0.30, 0.30, 0.30, 0.30, 0.30, 0.20, 0.20, 0.20, 0.20, 0.20, 0.10];
	for (var _i = 0; _i < array_length(LEVEL_SPEEDS); _i++) {
		LEVEL_SPEEDS[_i] *= DROP_SPEED_MULTIPLIER;
	}
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

	global.junk_spawn_counter = 0;
	global.junk_spawn_target = scr_junk_drop_roll_target();
	global.junk_state = "none";
	global.junk_queue = [];
	global.junk_falling = [];
	global.junk_drop_timer = 0;

	global.game_state = STATE_LOGOS;
	scr_screen_logos_init();
	scr_game_bg_init();
	scr_audio_init();
	scr_pair_generate_next();
	scr_pair_spawn();
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
	global.pause_highlight = true;
	global.pause_selected_index = -1;
	global.pause_stick_prev = false;
	global.pause_mouse_x = 0;
	global.pause_mouse_y = 0;
	// Deliberately NOT resetting ghost_enabled/grid_lines/show_queue/hold_swap_enabled/mute flags
	// here, and no scr_save_load() call either — these are session-long options, they must survive
	// a restart. Only a true game launch (scr_game_init) re-reads them from the save file.
	global.game_score = 0;
	global.level = 1;
	global.drop_speed = LEVEL_SPEEDS[0];
	global.level_pulse_timer = 0;
	global.high_score_beaten = false;
	global.combo_count = 0;
	global.hold_val1 = -1;
	global.hold_val2 = -1;
	global.hold_used = false;
	global.pair_random_val = 1;
	global.pair_random_timer = 0;
	global.gamepad_stick_up_prev = false;

	global.junk_spawn_counter = 0;
	global.junk_spawn_target = scr_junk_drop_roll_target();
	global.junk_state = "none";
	global.junk_queue = [];
	global.junk_falling = [];
	global.junk_drop_timer = 0;

	// Background combo tint doesn't reset on its own — if a chain was mid-color when the player
	// paused and quit, it would otherwise still be showing that color on the next game.
	global.bg_combo_color = c_white;
	global.bg_combo_alpha = BG_ALPHA;

	global.game_state = STATE_GAME;
	scr_audio_init();
	scr_pair_generate_next();
	scr_pair_spawn();
	if (!global.fade_active) {
		scr_countdown_start();
	}
}