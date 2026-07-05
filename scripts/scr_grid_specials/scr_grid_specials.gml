function scr_grid_specials(){

}

// Checks the cell directly below (_col, _row) for an idle Mimic or Bomb and activates it using
// _target. An idle Mimic only resolves to a real 1-9 value; an idle Bomb accepts any target
// (real value, Brick, another Bomb, or an unresolved Mimic) — see scr_die_bomb_activate.
function scr_die_try_activate_below(_col, _row, _target) {
	if (_row <= 0) return;

	var _below_val = global.grid[_col][_row - 1];
	var _below_sp  = global.grid_special[_col][_row - 1];

	if (_below_val == DIE_MIMIC && _below_sp == DIE_MIMIC && _target >= 1 && _target <= PAIR_MAX_VALUE) {
		global.grid[_col][_row - 1] = _target;
	} else if (_below_val == DIE_BOMB && _below_sp == DIE_BOMB) {
		scr_die_bomb_activate(_col, _row - 1, _target);
	}
}

function scr_die_bomb_activate(_col, _row, _target_val) {
	global.grid[_col][_row] = DIE_BOMB;
	global.grid_special[_col][_row] = DIE_BOMB;
	global.grid_dying[_col][_row] = DYING_DURATION;

	for (var _c = 0; _c < GRID_COLS; _c++) {
		for (var _r = 0; _r <= GRID_ROWS; _r++) {
			if (global.grid[_c][_r] == _target_val && global.grid_dying[_c][_r] == 0) {
				global.grid_dying[_c][_r] = DYING_DURATION;
			}
		}
	}

	// Combo: a Bomb reading a Brick as its target also wipes every Bomb on the grid (idle or not).
	// Reading DIE_BOMB or DIE_MIMIC directly (see scr_die_place) already covers those cases generically
	// through the scan above — this is only for the Brick-specific combo side effect.
	if (_target_val == DIE_BRICK) {
		for (var _c = 0; _c < GRID_COLS; _c++) {
			for (var _r = 0; _r <= GRID_ROWS; _r++) {
				if (global.grid[_c][_r] == DIE_BOMB && global.grid_dying[_c][_r] == 0) {
					global.grid_dying[_c][_r] = DYING_DURATION;
				}
			}
		}
	}

	scr_audio_play_sfx(snd_chain_dying);
	scr_grid_propagate_dying();
}

// Writes the Clear die itself into the grid. Activation is deferred (see scr_die_clear_try_trigger) —
// if the pair partner landing in the same detach shares this row/column, it must be written to the
// grid first, otherwise the scan below would skip it as an empty cell.
function scr_die_clear_write(_col, _row, _horizontal) {
	var _clear_val = _horizontal ? DIE_CLEAR_R : DIE_CLEAR_C;
	global.grid[_col][_row] = _clear_val;
	global.grid_special[_col][_row] = _clear_val;
}

// One-shot: sets dying on the whole row (horizontal) or column (vertical) through (_col, _row),
// including the Clear die itself and any Brick in its path. Never re-triggers afterward.
// Every cell it touches is flagged in grid_dying_clear so it stays isolated: it never propagates
// to same-value neighbors outside the swept line (scr_grid_propagate_dying skips it as a source),
// and no new/existing die can join it later (scr_grid_check_join skips it as a neighbor) — this is
// what keeps a Clear from chaining into a near-infinite board wipe.
// Must only be called once every die from the same detach (including a pair partner sharing this
// row/column) has already been written to the grid via scr_die_clear_write, and only once this
// Clear die is resting on solid (non-dying) ground — see scr_die_clear_try_trigger.
function scr_die_clear_trigger(_col, _row) {
	if (global.grid_dying[_col][_row] > 0) return;

	var _horizontal = (global.grid[_col][_row] == DIE_CLEAR_R);
	global.grid_dying[_col][_row] = DYING_DURATION;
	global.grid_dying_clear[_col][_row] = true;

	if (_horizontal) {
		for (var _c = 0; _c < GRID_COLS; _c++) {
			if (global.grid[_c][_row] != 0 && global.grid_dying[_c][_row] == 0) {
				global.grid_dying[_c][_row] = DYING_DURATION;
				global.grid_dying_clear[_c][_row] = true;
			}
		}
	} else {
		for (var _r = 0; _r <= GRID_ROWS; _r++) {
			if (global.grid[_col][_r] != 0 && global.grid_dying[_col][_r] == 0) {
				global.grid_dying[_col][_r] = DYING_DURATION;
				global.grid_dying_clear[_col][_r] = true;
			}
		}
	}

	scr_audio_play_sfx(snd_chain_dying);
}

// Checks whether a Clear die at (_col, _row) has reached its final resting spot and triggers it if so.
// Not just the cell directly below — anything dying anywhere further down the column will eventually
// pull this Clear (and whatever non-dying dice sit between them) down too, so none of them are at their
// final destination yet. Leave it pending (grid_dying stays 0) and let scr_grid_clear_check_pending
// catch it once gravity settles the whole column.
function scr_die_clear_try_trigger(_col, _row) {
	var _sp = global.grid_special[_col][_row];
	if (_sp != DIE_CLEAR_R && _sp != DIE_CLEAR_C) return;

	for (var _r = _row - 1; _r >= 0; _r--) {
		if (global.grid_dying[_col][_r] > 0) return;
	}
	scr_die_clear_trigger(_col, _row);
}

// Called after every gravity pass — re-checks every Clear die still waiting for solid ground
// (placed but not yet triggered) now that supports may have shifted.
function scr_grid_clear_check_pending() {
	for (var _c = 0; _c < GRID_COLS; _c++) {
		for (var _r = 0; _r <= GRID_ROWS; _r++) {
			var _sp = global.grid_special[_c][_r];
			if ((_sp == DIE_CLEAR_R || _sp == DIE_CLEAR_C) && global.grid_dying[_c][_r] == 0) {
				scr_die_clear_try_trigger(_c, _r);
			}
		}
	}
}
