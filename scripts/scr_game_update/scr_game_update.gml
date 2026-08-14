function scr_game_update() {
	// application_surface stays fixed at whatever size it was created at (the initial
	// windowed size) unless explicitly resized — without this, switching to fullscreen
	// just stretches that lower-res surface instead of rendering at full detail.
	// Only resize on an actual fullscreen-state change, never on a live pixel comparison —
	// GAME_WIDTH/HEIGHT are room_width/room_height, and in the HTML5/itch.io embed the browser
	// can jitter the canvas by a pixel on its own (page reflow, DPI rounding) with no real
	// window_get_fullscreen() change; comparing raw dimensions every step would still resize
	// (and reallocate the surface's render target) far too often. Gating on the boolean instead
	// means this only ever fires on a genuine transition — at most once, since this game has no
	// runtime fullscreen toggle anymore.
	// app_surface_fullscreen is seeded to the opposite of the real state in scr_game_init, so the
	// very first frame always counts as a transition and resizes once.
	var _is_fullscreen = window_get_fullscreen();
	if (_is_fullscreen != global.app_surface_fullscreen) {
		global.app_surface_fullscreen = _is_fullscreen;
		if (_is_fullscreen) {
			surface_resize(application_surface, GAME_WIDTH, GAME_HEIGHT);
		} else {
			surface_resize(application_surface, WINDOW_WIDTH, WINDOW_HEIGHT);
		}
	}

	scr_game_input_keyboard();
	scr_game_input_gamepad();

	// Ticked here, above every state-specific early return — a spinning motor has to be shut off
	// on any screen the game jumps to, it can't just freeze like a visual effect can.
	scr_pad_rumble_update();

	// DEBUG: available everywhere, regardless of screen — checked before any state-specific
	// early return below.
	if (global.input_restart) {
		audio_stop_all();
		scr_pad_rumble_apply(0); // don't leave the pad buzzing through the room reload
		room_restart();
		exit;
	}

	if (global.input_exit) {
		scr_pad_rumble_apply(0);
		game_end();
		exit;
	}

	if (global.input_reset_highscore) {
		global.high_score = 0;
		global.high_score_name = "";
		global.high_score_beaten = false;
		scr_save_write();
	}

	if (global.game_state == STATE_LOGOS) {
		scr_screen_logos_update();
		return;
	}

	if (global.game_state == STATE_SPLASH) {
		scr_screen_splash_update();
		return;
	}

	if (global.help_active && global.input_pause) {
		// Escape always force-closes Help straight back to gameplay. Enter never does this —
		// its only role in Help is confirming the Back button (see scr_help_menu_update),
		// which returns to Pause instead.
		global.help_active = false;
		global.paused = false;
	} else if (global.input_pause && !global.game_over && !global.countdown_active && !global.fade_active) {
		scr_game_over_pause();
		return; // don't let scr_game_pause_update() also process this same keypress this frame
	} else if (global.input_pause_alt && !global.paused && !global.game_over && !global.countdown_active && !global.fade_active) {
		// Enter also opens the pause menu, same as Escape — but only to open it. Once paused,
		// Enter is reserved for confirming a menu selection (see scr_game_pause_update).
		scr_game_over_pause();
		return; // same reason — Enter would otherwise also read as "confirm" the instant the menu opens
	}

	if (global.help_active) {
		scr_help_menu_update();
		if (!global.help_active) return; // Back/Escape just closed Help this frame — don't let
		                                  // scr_game_pause_update() also read the same keypress
		                                  // (the pause cursor is still sitting on "Help")
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

	if (global.input_hold && global.hold_swap_enabled) {
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
					global.game_over_highlight = true;
					global.game_over_selected_index = -1;
					global.game_over_stick_prev = false;
					global.game_over_mouse_x = 0;
					global.game_over_mouse_y = 0;
					// global.high_score is already kept live-synced below as soon as it's beaten,
					// so this only needs to persist it to disk once the run is over.
					if (global.high_score_beaten) {
						scr_save_write();
					}
				}
			} else if (global.junk_state == JUNK_STATE.NONE) {
				scr_pair_spawn_next();
			}
		}

		scr_junk_drop_check_start();
		scr_junk_drop_update();
	}

	// --- Random die cycling (always active for next box display) ---
	// Cycle speed always tracks the current drop speed, so it speeds up/slows down in lockstep with it.
	global.pair_random_timer += delta_time / DELTA_TO_SECONDS;
	var _random_cycle_speed = global.drop_speed * DICE_RANDOM_CYCLE_FACTOR;
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
	scr_grid_shake_update();

	if (global.game_score > global.high_score) {
		// Keeps the HUD's High Score box live-accurate for the rest of the run instead of only
		// updating global.high_score once at game over.
		global.high_score = global.game_score;
		if (!global.high_score_beaten) {
			global.high_score_beaten = true;
			scr_audio_play_sfx(snd_highscore);
		}
	}

	scr_screen_fade_update();
}