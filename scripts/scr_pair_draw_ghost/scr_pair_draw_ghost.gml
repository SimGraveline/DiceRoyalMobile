function scr_ghost_toggle() {
	global.ghost_enabled = !global.ghost_enabled;
}

// Is (_col, _row) unavailable to a falling die, counting the pair partner that has already come to
// rest at (_taken_col, _taken_row)? scr_pair_detach writes the landed die into the grid BEFORE the
// solo partner falls, which is what stops the partner on top of it. A simulation that only calls
// scr_grid_cell_blocked has no such write, so the second die falls straight through the first —
// harmless for the ghost (it only draws the lower die of a vertical pair, so the bad position was
// computed but never shown) and very visible for anything that reads both dice.
// Pass _taken_col = -1 for "nothing landed yet".
function scr_pair_landing_blocked(_col, _row, _taken_col, _taken_row) {
	if (_taken_col >= 0 && _col == _taken_col && _row == _taken_row) return true;
	return scr_grid_cell_blocked(_col, _row);
}

// Where the active pair would come to rest if dropped right now. Mirrors scr_pair_detach's order:
// the pair falls together until either die is blocked, that die takes its cell, then whichever die
// didn't land continues alone down its column — stopping on its partner like it does for real.
// Shared by the ghost and the match preview so the two can never disagree about where the dice go.
function scr_pair_ghost_landing() {
	var _mc = global.pair_col;
	var _mr = global.pair_row;
	var _oc = global.pair_offset_col;
	var _or = global.pair_offset_row;
	var _sc = _mc + _oc;

	// Step 1: simulate pair dropping together
	var _drop = _mr;
	while (true) {
		if (scr_grid_cell_blocked(_mc, _drop - 1)) break;
		if (scr_grid_cell_blocked(_sc, _drop - 1 + _or)) break;
		_drop -= 1;
	}

	// Step 2: determine which die lands, which continues as solo
	var _pair_mr = _drop;
	var _pair_sr = _drop + _or;
	var _final_mr = _pair_mr;
	var _final_sr = _pair_sr;

	// Whichever die is blocked takes its cell first — exactly like scr_pair_detach writing it to the
	// grid — and the other one then falls with that cell counted as solid.
	var _solo_r = 0;
	if (!scr_grid_cell_blocked(_mc, _pair_mr - 1)) {
		// Master is the solo faller; the slave has landed and now occupies its cell.
		_solo_r = _pair_mr;
		while (!scr_pair_landing_blocked(_mc, _solo_r - 1, _sc, _pair_sr)) {
			_solo_r -= 1;
		}
		_final_mr = _solo_r;
	} else if (!scr_grid_cell_blocked(_sc, _pair_sr - 1)) {
		// Slave is the solo faller; the master has landed.
		_solo_r = _pair_sr;
		while (!scr_pair_landing_blocked(_sc, _solo_r - 1, _mc, _pair_mr)) {
			_solo_r -= 1;
		}
		_final_sr = _solo_r;
	}

	return {
		master_col: _mc,
		master_row: _final_mr,
		slave_col:  _sc,
		slave_row:  _final_sr
	};
}

function scr_pair_draw_ghost() {
	if (!global.pair_active || !global.ghost_enabled) return;

	var _mc = global.pair_col;
	var _mr = global.pair_row;
	var _oc = global.pair_offset_col;
	var _or = global.pair_offset_row;
	var _sc = _mc + _oc;
	var _sr = _mr + _or;

	var _land = scr_pair_ghost_landing();
	var _final_mr = _land.master_row;
	var _final_sr = _land.slave_row;

	if (_final_mr == _mr && _final_sr == _sr) return;

	var _vertical = (_oc == 0);

	// In vertical orientation, only the bottom die projects a ghost
	var _draw_master = !_vertical || (_mr <= _sr);
	var _draw_slave  = !_vertical || (_sr < _mr);

	var _mval = (global.pair_val1 == DIE_RANDOM) ? global.pair_random_val : global.pair_val1;
	var _sval = (global.pair_val2 == DIE_RANDOM) ? global.pair_random_val : global.pair_val2;

	// Specials (Bomb/Mimic/Brick/Clear R/Clear C) have no per-value color, so they use the
	// dedicated ghost accent color instead — regular 1-9 dice keep their own die color, taken
	// straight from scr_die_color so the trail and the background chain tint can never drift
	// apart (they used to be two hand-maintained palettes, and the green had already diverged).
	var _m_is_special = (_mval == DIE_BOMB) || (_mval == DIE_MIMIC) || (_mval == DIE_BRICK) || (_mval == DIE_CLEAR_R) || (_mval == DIE_CLEAR_C);
	var _s_is_special = (_sval == DIE_BOMB) || (_sval == DIE_MIMIC) || (_sval == DIE_BRICK) || (_sval == DIE_CLEAR_R) || (_sval == DIE_CLEAR_C);
	var _m_color = _m_is_special ? GHOST_COLOR : scr_die_color(_mval);
	var _s_color = _s_is_special ? GHOST_COLOR : scr_die_color(_sval);

	if (_draw_master) {
		var _m_x = GRID_DRAW_X + (_mc * CELL_SIZE);
		var _m_top_y = GRID_DRAW_Y + ((GRID_ROWS - _mr) * CELL_SIZE) + CELL_SIZE * 0.5;
		var _m_land_y = GRID_DRAW_Y + ((GRID_ROWS - _final_mr) * CELL_SIZE);
		draw_set_color(_m_color);
		draw_set_alpha(GHOST_TRAIL_ALPHA);
		draw_roundrect_ext(_m_x, _m_top_y, _m_x + CELL_SIZE - 1, _m_land_y + CELL_SIZE - 1, GHOST_TRAIL_CORNER_RADIUS, GHOST_TRAIL_CORNER_RADIUS, false);
		draw_set_alpha(GHOST_PREVIEW_ALPHA);
		draw_roundrect_ext(_m_x, _m_land_y, _m_x + CELL_SIZE - 1, _m_land_y + CELL_SIZE - 1, GHOST_TRAIL_CORNER_RADIUS, GHOST_TRAIL_CORNER_RADIUS, false);
	}

	if (_draw_slave) {
		var _s_x = GRID_DRAW_X + (_sc * CELL_SIZE);
		var _s_top_y = GRID_DRAW_Y + ((GRID_ROWS - _sr) * CELL_SIZE) + CELL_SIZE * 0.5;
		var _s_land_y = GRID_DRAW_Y + ((GRID_ROWS - _final_sr) * CELL_SIZE);
		draw_set_color(_s_color);
		draw_set_alpha(GHOST_TRAIL_ALPHA);
		draw_roundrect_ext(_s_x, _s_top_y, _s_x + CELL_SIZE - 1, _s_land_y + CELL_SIZE - 1, GHOST_TRAIL_CORNER_RADIUS, GHOST_TRAIL_CORNER_RADIUS, false);
		draw_set_alpha(GHOST_PREVIEW_ALPHA);
		draw_roundrect_ext(_s_x, _s_land_y, _s_x + CELL_SIZE - 1, _s_land_y + CELL_SIZE - 1, GHOST_TRAIL_CORNER_RADIUS, GHOST_TRAIL_CORNER_RADIUS, false);
	}

	draw_set_alpha(1.0);
}

// --- Match preview ------------------------------------------------------------------------------
// Highlights the chain the active pair is about to complete, the way Block Blast lights up the rows
// a piece is about to clear. Purely a read of the board: it writes nothing, and the simulation never
// sees it.
// Scope of this first pass: ordinary same-value chains only. Suites, the 1's wild rule, and the
// specials (a Bomb's grid-wide kill, a Clear's row/column sweep) are NOT previewed — each needs its
// own rule and they'd all light up very differently.

// Raw contents of a cell in the hypothetical board where the pair has already landed — dying dice
// included, because they still physically occupy their cell. This is what a Mimic reads when it
// copies the die beneath it (see scr_die_place, which looks straight at the grid without caring
// whether that die is on its way out).
function scr_match_preview_raw_at(_col, _row, _landed) {
	if (_row < 0 || _row > GRID_ROWS || _col < 0 || _col >= GRID_COLS) return 0;
	for (var _i = 0; _i < array_length(_landed); _i++) {
		if (_landed[_i].col == _col && _landed[_i].row == _row) return _landed[_i].val;
	}
	return global.grid[_col][_row];
}

// Effective value of a cell for matching purposes. Same as the raw read, except dying cells count as
// empty: scr_grid_flood_fill refuses to traverse them, so a preview that counted them would promise
// a chain the real match can't deliver. Not a prediction that they'll be gone — a dying die simply
// can't join a new group while it fades.
function scr_match_preview_value_at(_col, _row, _landed) {
	if (_row < 0 || _row > GRID_ROWS || _col < 0 || _col >= GRID_COLS) return 0;
	for (var _i = 0; _i < array_length(_landed); _i++) {
		if (_landed[_i].col == _col && _landed[_i].row == _row) return _landed[_i].val;
	}
	if (global.grid_dying[_col][_row] > 0) return 0;
	return global.grid[_col][_row];
}

// Same flood fill as the real matcher, reading the hypothetical board instead of the live grid.
function scr_match_preview_fill(_col, _row, _value, _visited, _landed) {
	if (_col < 0 || _col >= GRID_COLS) return;
	if (_row < 0 || _row > GRID_ROWS) return;
	if (_visited[_col][_row]) return;
	if (scr_match_preview_value_at(_col, _row, _landed) != _value) return;

	_visited[_col][_row] = true;

	scr_match_preview_fill(_col - 1, _row, _value, _visited, _landed);
	scr_match_preview_fill(_col + 1, _row, _value, _visited, _landed);
	scr_match_preview_fill(_col, _row - 1, _value, _visited, _landed);
	scr_match_preview_fill(_col, _row + 1, _value, _visited, _landed);
}

function scr_pair_draw_match_preview() {
	if (!MATCH_PREVIEW_ENABLED) return;
	// Still drawn while paused — the pulse below freezes instead, so the glow holds its brightness
	// rather than vanishing out from under the pause panel.
	if (!global.pair_active) return;

	var _land = scr_pair_ghost_landing();

	// Resolve the faces the dice will actually wear on landing. A Random has already locked its
	// displayed value; every other special has no face to match on, so it isn't a candidate.
	var _mval = (global.pair_val1 == DIE_RANDOM) ? global.pair_random_val : global.pair_val1;
	var _sval = (global.pair_val2 == DIE_RANDOM) ? global.pair_random_val : global.pair_val2;

	// Both dice go in, so two dice of the same value landing side by side count as one group.
	// Built LOWEST ROW FIRST, because the dice resolve in that order for real: a Mimic riding on top
	// of its own partner copies that partner, so the lower die has to be settled before we ask what
	// the upper one becomes.
	var _master_first = (_land.master_row <= _land.slave_row);
	var _first  = _master_first ? { col: _land.master_col, row: _land.master_row, val: _mval } : { col: _land.slave_col,  row: _land.slave_row,  val: _sval };
	var _second = _master_first ? { col: _land.slave_col,  row: _land.slave_row,  val: _sval } : { col: _land.master_col, row: _land.master_row, val: _mval };

	var _landed = [];
	if (_first.row  <= DEAD_ZONE_ROW) array_push(_landed, _first);
	if (_second.row <= DEAD_ZONE_ROW) array_push(_landed, _second);
	if (array_length(_landed) == 0) return;

	// A Mimic takes the face of whatever sits directly beneath it the moment it lands, so its value
	// is knowable now — no guessing about what the board will look like later. If there's nothing
	// readable below (floor, empty, or another unresolved special), it stays idle and simply can't
	// match, which the value check further down handles on its own.
	for (var _i = 0; _i < array_length(_landed); _i++) {
		if (_landed[_i].val != DIE_MIMIC) continue;
		var _below = scr_match_preview_raw_at(_landed[_i].col, _landed[_i].row - 1, _landed);
		if (_below >= 1 && _below <= PAIR_MAX_VALUE) _landed[_i].val = _below;
	}

	var _highlight = array_create(GRID_COLS);
	for (var _c = 0; _c < GRID_COLS; _c++) {
		_highlight[_c] = array_create(GRID_ROWS + 1, false);
	}

	var _color = c_white;
	var _any = false;

	for (var _i = 0; _i < array_length(_landed); _i++) {
		var _val = _landed[_i].val;
		if (_val < MATCH_MIN_VALUE || _val > PAIR_MAX_VALUE) continue;
		if (_highlight[_landed[_i].col][_landed[_i].row]) continue; // already caught by the other die's group

		var _group = array_create(GRID_COLS);
		for (var _c = 0; _c < GRID_COLS; _c++) {
			_group[_c] = array_create(GRID_ROWS + 1, false);
		}

		scr_match_preview_fill(_landed[_i].col, _landed[_i].row, _val, _group, _landed);

		var _count = 0;
		for (var _gc = 0; _gc < GRID_COLS; _gc++) {
			for (var _gr = 0; _gr <= GRID_ROWS; _gr++) {
				if (_group[_gc][_gr]) _count++;
			}
		}

		// Same threshold as the real matcher: a group is only a chain at count >= value.
		if (_count < _val) continue;

		for (var _gc = 0; _gc < GRID_COLS; _gc++) {
			for (var _gr = 0; _gr <= GRID_ROWS; _gr++) {
				if (_group[_gc][_gr]) _highlight[_gc][_gr] = true;
			}
		}
		_color = scr_match_preview_glow_color(_val);
		_any = true;
	}

	if (!_any) return;

	// Breathing intensity. Advanced here rather than in the update loop because the preview is the
	// only thing that reads it — but gated on !paused all the same, so a paused game shows the glow
	// held still instead of still pulsing under the menu.
	if (!global.paused) global.match_preview_pulse += delta_time / DELTA_TO_SECONDS;
	var _pulse = 1 + MATCH_PREVIEW_PULSE_AMOUNT * sin(global.match_preview_pulse * MATCH_PREVIEW_PULSE_SPEED);

	// Additive: every pass adds light instead of painting over, so overlapping halos between two
	// neighboring dice of the group blend into one mass rather than showing their seams.
	gpu_set_blendmode(bm_add);
	draw_set_color(_color);

	for (var _c = 0; _c < GRID_COLS; _c++) {
		for (var _r = 0; _r <= GRID_ROWS; _r++) {
			if (_highlight[_c][_r]) scr_match_preview_glow_cell(_c, _r, _pulse);
		}
	}

	// The die still in the player's hands lights up too, at its CURRENT position rather than where
	// it will land — that's the whole point, connecting what they're holding to what it will set off.
	// A die counts if its landing cell ended up in the group, whether it formed that group itself or
	// simply joined the one its partner made.
	var _slave_col = global.pair_col + global.pair_offset_col;
	var _slave_row = global.pair_row + global.pair_offset_row;

	if (_land.master_row >= 0 && _land.master_row <= GRID_ROWS && _highlight[_land.master_col][_land.master_row]) {
		scr_match_preview_glow_cell(global.pair_col, global.pair_row, _pulse);
	}
	if (_land.slave_row >= 0 && _land.slave_row <= GRID_ROWS && _highlight[_land.slave_col][_land.slave_row]) {
		scr_match_preview_glow_cell(_slave_col, _slave_row, _pulse);
	}

	gpu_set_blendmode(bm_normal);
	draw_set_alpha(1.0);
}

// The die palette can't be used raw for an additive glow: additive blending ADDS light, so a color
// with no light in it adds nothing. Black (the 6) is literally invisible that way, and pure blue
// (the 5) barely registers because it only carries light in one channel. So each color gets lifted
// toward white by how dark it actually looks — perceived luminance, not raw channel values, which is
// why blue needs a big lift despite having a full-strength channel. Bright values (yellow) are left
// alone. The 6 necessarily ends up glowing near-white: there is no such thing as a black glow.
function scr_match_preview_glow_color(_val) {
	var _c = scr_die_color(_val);
	var _luma = (0.299 * colour_get_red(_c) + 0.587 * colour_get_green(_c) + 0.114 * colour_get_blue(_c)) / 255;
	var _lift = clamp(MATCH_PREVIEW_MIN_LUMA - _luma, 0, 1);
	return merge_colour(_c, c_white, _lift);
}

// One die's worth of glow at grid cell (_col, _row): faint wide halo first, bright core on top.
// Assumes the caller has already set the blend mode and color.
function scr_match_preview_glow_cell(_col, _row, _pulse) {
	var _radius = CELL_SIZE * MATCH_PREVIEW_CORNER_FACTOR;
	var _x1 = GRID_DRAW_X + (_col * CELL_SIZE);
	var _y1 = GRID_DRAW_Y + ((GRID_ROWS - _row) * CELL_SIZE);
	var _x2 = _x1 + CELL_SIZE - 1;
	var _y2 = _y1 + CELL_SIZE - 1;

	for (var _l = MATCH_PREVIEW_GLOW_LAYERS; _l >= 1; _l--) {
		var _grow = CELL_SIZE * MATCH_PREVIEW_GLOW_SPREAD * _l;
		draw_set_alpha(MATCH_PREVIEW_GLOW_ALPHA * (1 - (_l - 1) / MATCH_PREVIEW_GLOW_LAYERS) * _pulse);
		draw_roundrect_ext(_x1 - _grow, _y1 - _grow, _x2 + _grow, _y2 + _grow, _radius + _grow, _radius + _grow, false);
	}

	draw_set_alpha(MATCH_PREVIEW_CORE_ALPHA * _pulse);
	draw_roundrect_ext(_x1, _y1, _x2, _y2, _radius, _radius, false);
}