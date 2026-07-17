function scr_grid_resolve() {
	var _any_expired = false;

	// Tracks the "freshest" still-dying cell that's part of a genuine 2-9 value-cluster chain
	// (grid_dying_chain — see scr_grid_init — restricted to regular values here) so the background
	// dice can tint to match it. 1's and specials never drive the tint, even when grid_dying_chain
	// is set on them (e.g. a 1 caught by the chain-dying rule) — only the 2-9 chain itself does.
	var _any_dying = false;
	var _best_timer = 0;
	var _best_val = 0;

	// Tick dying timers and remove expired dice — score on removal
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			if (global.grid_squash[_col][_row] > 0) {
				global.grid_squash[_col][_row] -= delta_time / DELTA_TO_SECONDS;
				if (global.grid_squash[_col][_row] < 0) global.grid_squash[_col][_row] = 0;
			}

			if (global.grid_dying[_col][_row] > 0) {
				global.grid_dying[_col][_row] -= delta_time / DELTA_TO_SECONDS;
				if (global.grid_dying[_col][_row] <= 0) {
					// Uniform scoring — every die (regular or special) scores the same way on death,
					// using whatever value is in its grid cell. No exceptions.
					var _val = global.grid[_col][_row];
					var _combo = power(COMBO_MULTIPLIER, global.combo_count);
					if (_val == 1) {
						global.game_score += floor(SCORE_BASE * _combo);
					} else {
						global.game_score += floor(SCORE_BASE * _val * _combo);
					}
					global.grid_dying[_col][_row] = 0;
					global.grid_dying_clear[_col][_row] = false;
					global.grid_dying_chain[_col][_row] = false;
					global.grid[_col][_row] = 0;
					global.grid_special[_col][_row] = 0;
					_any_expired = true;
				} else if (global.grid_dying_chain[_col][_row]) {
					var _chain_val = global.grid[_col][_row];
					if (_chain_val >= 2 && _chain_val <= PAIR_MAX_VALUE) {
						_any_dying = true;
						if (global.grid_dying[_col][_row] > _best_timer) {
							_best_timer = global.grid_dying[_col][_row];
							_best_val = _chain_val;
						}
					}
				}
			}
		}
	}

	if (BG_COMBO_ENABLED) {
		if (_any_dying) {
			global.bg_combo_color = scr_die_color(_best_val);
			global.bg_combo_alpha = BG_COMBO_ALPHA;
		} else {
			global.bg_combo_color = c_white;
			global.bg_combo_alpha = BG_ALPHA;
		}
	}

	// If any died, apply gravity then check for new matches (chain combo)
	if (_any_expired) {
		global.combo_count += 1;
		scr_grid_gravity();
		scr_grid_clear_check_pending();
		scr_grid_match();
	}
}

// Maps a die value to its representative color, same palette used by the ghost trail. Only ever
// called with a value in the 2-9 chain range (see scr_grid_resolve), so no other case is reachable.
function scr_die_color(_val) {
	switch (_val) {
		case 2: return c_yellow;
		case 3: return c_red;
		case 4: return c_green;
		case 5: return c_blue;
		case 6: return c_black;
		case 7: return COLOR_DIE_7;
		case 8: return COLOR_DIE_8;
		case 9: return COLOR_DIE_9;
		default: return c_white;
	}
}
