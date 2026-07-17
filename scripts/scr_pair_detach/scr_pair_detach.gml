function scr_pair_detach() {
	var _master_col = global.pair_col;
	var _master_row = global.pair_row;
	var _slave_col = _master_col + global.pair_offset_col;
	var _slave_row = _master_row + global.pair_offset_row;

	var _master_landed = scr_grid_cell_blocked(_master_col, _master_row - 1);
	var _slave_landed = scr_grid_cell_blocked(_slave_col, _slave_row - 1);

	// Write landed die(s) to grid first — Clear R/C's trigger (further below) scans the whole
	// row/column, so every die from this detach (including a later solo faller) must already be
	// written before it runs, otherwise a pair partner sharing that row/column would still read
	// as an empty cell.
	if (_master_landed) {
		scr_die_place(_master_col, _master_row, global.pair_val1);
		global.game_score += SCORE_STACK;
	}
	if (_slave_landed) {
		scr_die_place(_slave_col, _slave_row, global.pair_val2);
		global.game_score += SCORE_STACK;
	}

	// Let matches/joins resolve first — a die that forms a valid chain right as it lands must get
	// caught by that chain, not stolen into an isolated Clear-only dying group first. Clear's sweep
	// (further below) skips anything already dying, so it won't touch cells the match/join already caught.
	if (_master_landed) scr_grid_check_join(_master_col, _master_row);
	if (_slave_landed) scr_grid_check_join(_slave_col, _slave_row);
	scr_grid_match();

	// Determine solo faller
	global.pair_active = false;

	var _solo_col = -1;
	var _solo_row = -1;
	var _solo_val = 0;

	if (!_master_landed) {
		_solo_col = _master_col;
		_solo_row = _master_row;
		_solo_val = global.pair_val1;
	} else if (!_slave_landed) {
		_solo_col = _slave_col;
		_solo_row = _slave_row;
		_solo_val = global.pair_val2;
	}

	// Solo die: always fall to a real resting position first, then check join at that position —
	// same order as a landed pair die and a Junk Drop die (see scr_grid_check_join below). A join
	// is a consequence of where the die actually lands, never a reason to skip the fall.
	if (_solo_col >= 0) {
		while (!scr_grid_cell_blocked(_solo_col, _solo_row - 1)) {
			_solo_row -= 1;
		}
		scr_die_place(_solo_col, _solo_row, _solo_val);
		global.game_score += SCORE_STACK;

		scr_grid_check_join(_solo_col, _solo_row);
		scr_grid_match();
	}

	// Clear R/C trigger checks run last, once every die from this detach (master, slave, and any
	// solo faller) is written to the grid — a vertical pair's solo partner lands directly on top of
	// the other die in the same column, so checking any earlier would let the sweep miss it entirely
	// (see scr_die_clear_trigger's comment for why this ordering matters).
	if (_master_landed) scr_die_clear_try_trigger(_master_col, _master_row);
	if (_slave_landed) scr_die_clear_try_trigger(_slave_col, _slave_row);
	if (_solo_col >= 0) scr_die_clear_try_trigger(_solo_col, _solo_row);

	scr_audio_play_sfx(snd_dice_stack);
	global.last_pair_col = _master_col;
}
