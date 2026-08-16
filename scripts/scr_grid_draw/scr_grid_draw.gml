// --- Grid shake -------------------------------------------------------------------------------
// Two independent effects layered onto the grid's drawn position (see GRID_DRAW_X/GRID_DRAW_Y).
// Both are purely cosmetic: nothing here is ever read by the simulation, so a shake can never
// affect where a die lands or what it matches with.
//   impact  a single downward punch when a die stacks, easing back to rest — sells the weight
//   rumble  a two-axis jitter while a chain is going off
// Lives in this file because it's a grid-rendering concern and Sim creates script resources, not
// Claude — move it to its own script if one ever gets added.

function scr_grid_shake_init() {
	global.grid_shake_x = 0;
	global.grid_shake_y = 0;
	global.grid_impact_peak = 0;
	global.grid_impact_timer = 0;
	global.grid_impact_duration = 0;
	global.grid_rumble_timer = 0;
}

// Punches the grid down. Called for a hard drop at full weight, and for a soft drop scaled down —
// see scr_pair_detach for which landings get one at all.
// Retriggering mid-punch restarts it rather than stacking offsets.
function scr_grid_shake_impact(_scale) {
	global.grid_impact_peak = GRID_IMPACT_OFFSET * _scale;
	global.grid_impact_duration = GRID_IMPACT_DURATION;
	global.grid_impact_timer = global.grid_impact_duration;
}

// Starts (or restarts) the chain jitter. Called from the same two places that play the chain SFX,
// so the shake and the sound always fire together.
function scr_grid_shake_chain() {
	global.grid_rumble_timer = GRID_RUMBLE_DURATION;
}

// Ticks both effects and resolves this frame's offset. Called from scr_game_update alongside the
// other per-frame visuals — which means it stops being called while paused, so a shake freezes in
// place instead of living on under the menu (same rule as the dying shake and the bg jitter).
function scr_grid_shake_update() {
	if (!GRID_SHAKE_ENABLED) {
		global.grid_shake_x = 0;
		global.grid_shake_y = 0;
		return;
	}

	var _dt = delta_time / DELTA_TO_SECONDS;
	var _x = 0;
	var _y = 0;

	// Impact: full offset at the instant of landing, easing back to rest. The decay is squared
	// rather than linear — the grid pulls away from the impact quickly and then settles gently
	// into place, where a linear return reads as a mechanical slide instead of a landing. This is
	// what keeps a bigger offset from feeling like a jolt.
	if (global.grid_impact_timer > 0) {
		global.grid_impact_timer -= _dt;
		if (global.grid_impact_timer < 0) global.grid_impact_timer = 0;
		if (global.grid_impact_duration > 0) {
			var _t = global.grid_impact_timer / global.grid_impact_duration;
			_y += global.grid_impact_peak * _t * _t;
		}
	}

	// Rumble: fresh jitter every frame, constant amplitude, hard stop when the timer runs out.
	if (global.grid_rumble_timer > 0) {
		global.grid_rumble_timer -= _dt;
		if (global.grid_rumble_timer < 0) global.grid_rumble_timer = 0;
		_x += random_range(-GRID_RUMBLE_AMOUNT, GRID_RUMBLE_AMOUNT);
		_y += random_range(-GRID_RUMBLE_AMOUNT, GRID_RUMBLE_AMOUNT);
	}

	global.grid_shake_x = _x;
	global.grid_shake_y = _y;
}

function scr_grid_draw() {
	var _x = GRID_DRAW_X;
	var _y = GRID_DRAW_Y;

	// Grid background
	draw_set_color(COLOR_GRID_BG);
	draw_roundrect(_x, _y, _x + GRID_WIDTH - 1, _y + GRID_HEIGHT - 1, false);

	// Cell lines
	if (global.grid_lines) {
		draw_set_color(c_gray);
		for (var _col = 0; _col <= GRID_COLS; _col++) {
			var _lx = _x + (_col * CELL_SIZE);
			draw_line(_lx, _y, _lx, _y + GRID_HEIGHT);
		}
		for (var _row = 0; _row <= GRID_ROWS + 1; _row++) {
			var _ly = _y + (_row * CELL_SIZE);
			draw_line(_x, _ly, _x + GRID_WIDTH, _ly);
		}
	}

	// Grid outline
	draw_set_color(COLOR_GRID_OUTLINE);
	for (var _o = 0; _o < GRID_OUTLINE_WIDTH; _o++) {
		draw_roundrect(_x - _o, _y - _o, _x + GRID_WIDTH - 1 + _o, _y + GRID_HEIGHT - 1 + _o, true);
	}

	// Dead zone line
	draw_set_color(c_red);
	var _dead_y = _y + CELL_SIZE;
	draw_line_width(_x, _dead_y, _x + GRID_WIDTH, _dead_y, DEAD_ZONE_LINE_WIDTH);

	// Draw stacked dice
	for (var _col = 0; _col < GRID_COLS; _col++) {
		for (var _row = 0; _row <= GRID_ROWS; _row++) {
			var _val = global.grid[_col][_row];
			if (_val > 0) {
				scr_die_draw(_col, _row, _val);
			}
		}
	}
}
