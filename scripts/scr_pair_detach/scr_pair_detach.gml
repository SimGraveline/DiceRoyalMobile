// _drop_type only feeds the landing impact's weight (see scr_grid_shake_impact) — it never changes
// where anything lands or how it resolves.
function scr_pair_detach(_drop_type) {
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

		// The grid only exists up to DEAD_ZONE_ROW — scr_grid_cell_blocked deliberately reports
		// everything above it as free so a pair can spawn and move up there, but there is no cell
		// to land in. A vertical pair locking with its lower die in the dead zone leaves the upper
		// one resting one row past the end of the column: writing it anyway created a phantom row
		// that nothing draws, nothing applies gravity to and nothing ever clears, and every read
		// that followed it (the join check, a Clear R/C sweep scanning that row) reached past the
		// end of the arrays. Discard the die instead — its partner is sitting in the dead zone at
		// this point, so the run is ending on the next update either way (see scr_game_update).
		// Clearing _solo_col also skips the Clear trigger further below, for the same reason.
		if (_solo_row > DEAD_ZONE_ROW) {
			_solo_col = -1;
		} else {
			scr_die_place(_solo_col, _solo_row, _solo_val);
			global.game_score += SCORE_STACK;

			scr_grid_check_join(_solo_col, _solo_row);
			scr_grid_match();
		}
	}

	// Clear R/C trigger checks run last, once every die from this detach (master, slave, and any
	// solo faller) is written to the grid — a vertical pair's solo partner lands directly on top of
	// the other die in the same column, so checking any earlier would let the sweep miss it entirely
	// (see scr_die_clear_trigger's comment for why this ordering matters).
	if (_master_landed) scr_die_clear_try_trigger(_master_col, _master_row);
	if (_slave_landed) scr_die_clear_try_trigger(_slave_col, _slave_row);
	if (_solo_col >= 0) scr_die_clear_try_trigger(_solo_col, _solo_row);

	scr_audio_play_sfx(snd_dice_stack);

	// Player-driven landings only. The punch and the rumble are feedback for something the player
	// DID — a hard drop lands the frame it hits, a soft drop commits after the much shorter
	// LOCK_DELAY_SOFT, so in both cases the hit arrives while the contact is still being read as
	// the player's own action. A NORMAL landing gets nothing: it detaches at the end of the full
	// LOCK_DELAY, with the pair already sitting visibly at rest on the stack, so the punch would
	// read as a random jolt rather than an impact. For the same reason a Junk Drop never punches at
	// all — the player didn't do it.
	// One impact per detach, not per die: both dice of a pair land as a single event, and it fires
	// with the stack SFX so the punch, the rumble and the sound are all the same beat.
	if (_drop_type == DROP_TYPE.HARD || _drop_type == DROP_TYPE.SOFT) {
		var _impact_scale = (_drop_type == DROP_TYPE.HARD) ? 1 : GRID_IMPACT_SOFT_SCALE;
		scr_grid_shake_impact(_impact_scale);
		scr_pad_rumble_impact(_impact_scale);
	}

	global.last_pair_col = _master_col;
}
