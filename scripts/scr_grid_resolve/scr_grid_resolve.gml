function scr_grid_resolve() {
	var _any_expired = false;

	// Tracks the "freshest" still-dying cell that came from a genuine value-cluster match
	// (grid_dying_match — see scr_grid_match) so the background dice can tint to match it. Bomb,
	// Clear, suites, and the "1 joins anything" rule never set that flag, so none of them can
	// trigger this even though they also set grid_dying — see scr_die_color.
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
					global.grid_dying_match[_col][_row] = false;
					global.grid[_col][_row] = 0;
					global.grid_special[_col][_row] = 0;
					_any_expired = true;
				} else if (global.grid_dying_match[_col][_row]) {
					_any_dying = true;
					if (global.grid_dying[_col][_row] > _best_timer) {
						_best_timer = global.grid_dying[_col][_row];
						_best_val = global.grid[_col][_row];
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
// called with a value carrying grid_dying_match (2-9), so no other case is reachable.
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
