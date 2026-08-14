function scr_grid_resolve() {
	var _any_expired = false;
	var _any_chain_expired = false;

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
					// Uniform scoring — every die, regular or special, goes through the same formula
					// on death: base points x chain multiplier, no exceptions and no special case
					// for any one die. Only the base points differ by type (scr_die_score_value).
					// chain_count is how many waves of this chain have already resolved, so the
					// multiplier climbs with every cascade — the deeper the chain, the more each
					// remaining die is worth. See COMBO_MULTIPLIERS.
					var _val = global.grid[_col][_row];
					var _combo = scr_combo_multiplier(global.chain_count);
					// floor(x + 0.5) rather than round(): GML's round() is banker's rounding (half
					// to even — round(2.5) is 2 but round(3.5) is 4), so an exact .5 would land
					// unpredictably. This always sends a half up. The current curve never produces
					// a fraction anyway (every multiplier is a multiple of 0.25), but that holds
					// only as long as nobody retunes an entry to something like 1.33.
					global.game_score += floor(scr_die_score_value(_val) * _combo + 0.5);
					// Chains Tracker only counts genuine chain waves (grid_dying_chain) — Bomb/Clear
					// kills never set this flag, same distinction already used for shake/tint.
					if (global.grid_dying_chain[_col][_row]) {
						_any_chain_expired = true;
					}
					global.grid_dying[_col][_row] = 0;
					global.grid_dying_clear[_col][_row] = false;
					global.grid_dying_chain[_col][_row] = false;
					global.grid[_col][_row] = 0;
					global.grid_special[_col][_row] = 0;
					_any_expired = true;
				} else if (global.grid_dying_chain[_col][_row]) {
					var _chain_val = global.grid[_col][_row];
					if (_chain_val >= MATCH_MIN_VALUE && _chain_val <= PAIR_MAX_VALUE) {
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
		// chain_count is both the Chains Tracker's live "Last" value and the index into
		// COMBO_MULTIPLIERS — deliberately one counter and not two, so the number shown to the
		// player and the reward they actually receive can never drift into telling two different
		// stories. It counts genuine chain waves only: a wave made up entirely of Bomb/Clear kills
		// still eliminates and scores its dice, but never advances the chain — exactly as it never
		// shakes, never tints the background and never shows in the tracker (see grid_dying_chain).
		if (_any_chain_expired) {
			global.chain_count += 1;
		}
		scr_grid_gravity();
		scr_grid_clear_check_pending();
		scr_grid_match();
	}
}

// Base points a die is worth when it dies, before the chain multiplier.
// A die that still has a face value scores that value — this covers regular 1-9 dice, a Random
// (which locks to a real value the moment it lands) and a resolved Mimic (which holds the value it
// copied), so all three score exactly like the die they are.
// Everything else is still a special at the moment it dies — Bomb, Brick, Clear R, Clear C, and an
// unresolved Mimic that never found a value to copy — and they all pay the same flat SCORE_SPECIAL.
function scr_die_score_value(_val) {
	if (_val >= PAIR_MIN_VALUE && _val <= PAIR_MAX_VALUE) return SCORE_BASE * _val;
	return SCORE_SPECIAL;
}

// Score multiplier for a die dying on wave (_wave + 1) of the current chain — _wave is how many
// waves already resolved, so it indexes COMBO_MULTIPLIERS directly. Anything past the end of the
// table holds the last entry: on a grid this size, a chain that deep is already beyond what the
// curve was tuned for, and holding keeps it predictable instead of extrapolating into nonsense.
function scr_combo_multiplier(_wave) {
	return COMBO_MULTIPLIERS[clamp(_wave, 0, array_length(COMBO_MULTIPLIERS) - 1)];
}

// Called wherever the grid is confirmed fully idle (next pair about to spawn, Junk Drop about to
// fall) — folds the just-finished combo's wave count into chain_best if it's a new record, then
// resets chain_count back to 0 so it's ready to climb again from the next chain's first wave.
function scr_chain_finalize() {
	if (global.chain_count > global.chain_best) global.chain_best = global.chain_count;
	global.chain_count = 0;
}

// Maps a die value to its representative color. The single palette for the whole game: the
// background tint during a chain (scr_grid_resolve) and the ghost trail/preview
// (scr_pair_draw_ghost) both read it here, so they can never drift apart.
// Value 1 has no color of its own and falls through to white, like any value with no entry.
function scr_die_color(_val) {
	switch (_val) {
		case 2: return COLOR_DIE_2;
		case 3: return COLOR_DIE_3;
		case 4: return COLOR_DIE_4;
		case 5: return COLOR_DIE_5;
		case 6: return COLOR_DIE_6;
		case 7: return COLOR_DIE_7;
		case 8: return COLOR_DIE_8;
		case 9: return COLOR_DIE_9;
		default: return c_white;
	}
}
