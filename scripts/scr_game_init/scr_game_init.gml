// Everything a fresh run needs, in one place — called both by the true game launch
// (scr_game_init) and by every soft restart (scr_game_restart), so no starting value ever has to
// be maintained in two spots. Deliberately NOT here: anything that must survive a restart (the
// options loaded from disk, the high score, the level tables) and anything tied to one entry
// point only (which screen we land on, stopping the old track, the countdown) — see both callers.
// Requires LEVEL_SPEEDS to already exist, and randomize() to have already run.
function scr_game_reset_run() {
	scr_grid_init();

	// Spawn weight per die value (index = value) — 1's are deliberately half as likely as the
	// rest. Values 7-9 sit at 0 and are gated behind DICE_HIGH_VALUES_ENABLED (see scr_level_update).
	global.spawn_weights = [0, 0.5, 1, 1, 1, 1, 1, 0, 0, 0];

	global.match_preview_pulse = 0; // breathing phase for the match preview glow
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
	global.game_score = 0;
	global.level = 1;
	global.high_score_beaten = false;
	global.drop_speed = LEVEL_SPEEDS[0];
	global.chain_count = 0;
	global.chain_best = 0;
	global.hold_val1 = -1;
	global.hold_val2 = -1;
	global.hold_used = false;
	global.pair_random_val = 1;
	global.pair_random_timer = 0;
	// No current pair yet — scr_pair_generate_next reads this to know it has nothing to compare
	// against for the "no two identical pairs in a row" rule. Parking it here (rather than asking
	// whether the global exists) also means a fresh run never inherits the previous run's last
	// pair as a constraint.
	global.pair_val1 = -1;
	global.pair_val2 = -1;

	// Gamepad state
	global.gamepad_stick_up_prev = false;

	global.junk_spawn_counter = 0;
	global.junk_spawn_target = scr_junk_drop_roll_target();
	global.junk_state = JUNK_STATE.NONE;
	global.junk_queue = [];
	global.junk_falling = [];
	global.junk_drop_timer = 0;

	// Background combo tint doesn't reset on its own — if a chain was mid-color when the player
	// paused and quit, it would otherwise still be showing that color on the next game.
	global.bg_combo_color = c_white;
	global.bg_combo_alpha = BG_ALPHA;

	// Grid must start at rest — a shake left running when the player quit mid-chain would otherwise
	// carry its offset into the next game, same trap as the bg tint above.
	scr_grid_shake_init();
	scr_pad_rumble_init();

	scr_audio_init();
	scr_pair_generate_next();
	scr_pair_spawn();
}

// True game launch — runs once per executable, from obj_game's Create event.
function scr_game_init() {
	randomize();

	LEVEL_THRESHOLDS = [0, 5000, 15000, 30000, 50000, 75000, 105000, 140000, 180000, 225000, 275000, 330000, 390000, 455000, 525000, 600000, 680000, 765000, 855000, 950000];
	LEVEL_SPEEDS     = [0.75, 0.75, 0.75, 0.50, 0.50, 0.50, 0.40, 0.40, 0.40, 0.30, 0.30, 0.30, 0.30, 0.30, 0.20, 0.20, 0.20, 0.20, 0.20, 0.10];
	for (var _i = 0; _i < array_length(LEVEL_SPEEDS); _i++) {
		LEVEL_SPEEDS[_i] *= DROP_SPEED_MULTIPLIER;
	}

	// Chain reward curve — see COMBO_MULTIPLIERS. Steps: +0.5, +0.75, +1.0, +1.25, +1.5, ...
	COMBO_MULTIPLIERS = [1, 1.5, 2.25, 3.25, 4.5, 6, 7.75, 9.75, 12, 14.5];

	scr_save_load(); // sets high_score(_name), music_muted, sfx_muted, grid_lines, show_queue, hold_swap_enabled, ghost_enabled

	// Screen-transition state — launch-only, because a restart can legitimately happen mid-fade
	// (Splash -> Game goes through one) and must not cancel it.
	global.fade_active = false;
	global.countdown_active = false;

	// Display state, launch-only. Both are seeded to a deliberately invalid value so their first
	// check always misses: app_surface_fullscreen starts as the opposite of the real window state
	// so the first frame performs exactly one application_surface resize (scr_game_update), and
	// the HUD layout cache starts on a size no screen can have so its first lookup always rebuilds
	// (scr_ui_hud_layout). Seeding them here is what lets both spots read the globals directly
	// instead of asking whether they exist yet by name.
	global.app_surface_fullscreen = !window_get_fullscreen();
	global.hud_layout_cache = undefined;
	global.hud_layout_w = -1;
	global.hud_layout_h = -1;

	scr_game_reset_run();

	global.game_state = STATE_LOGOS;
	scr_screen_logos_init();
	scr_game_bg_init();
}

// Soft restart — a new run without relaunching the game (pause menu Restart, Game Over Restart,
// Splash -> Game). Options and the high score deliberately survive: only scr_game_init re-reads
// them from the save file.
function scr_game_restart() {
	audio_stop_all();

	scr_game_reset_run();

	global.game_state = STATE_GAME;
	if (!global.fade_active) {
		scr_countdown_start();
	}
}