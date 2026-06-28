function scr_pair_draw_ghost() {
	if (!global.pair_active || !global.ghost_enabled) return;

	var _colors = [
		c_black,   // 0 = unused
		c_white,   // 1
		c_red,     // 2
		c_blue,    // 3
		c_green,   // 4
		c_yellow,  // 5
		c_purple   // 6
	];

	var _mc = global.pair_col;
	var _mr = global.pair_row;
	var _oc = global.pair_offset_col;
	var _or = global.pair_offset_row;
	var _sc = _mc + _oc;
	var _sr = _mr + _or;

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
	var _master_blocked = scr_grid_cell_blocked(_mc, _pair_mr - 1);
	var _slave_blocked = scr_grid_cell_blocked(_sc, _pair_sr - 1);

	var _final_mr = _pair_mr;
	var _final_sr = _pair_sr;

	// Solo die snaps to its lowest available position
	if (!_master_blocked) {
		var _solo_r = _pair_mr;
		while (!scr_grid_cell_blocked(_mc, _solo_r - 1)) {
			_solo_r -= 1;
		}
		_final_mr = _solo_r;
	} else if (!_slave_blocked) {
		var _solo_r = _pair_sr;
		while (!scr_grid_cell_blocked(_sc, _solo_r - 1)) {
			_solo_r -= 1;
		}
		_final_sr = _solo_r;
	}

	if (_final_mr == _mr && _final_sr == _sr) return;

	// Draw trail + preview for master
	var _m_x = GRID_X + (_mc * CELL_SIZE);
	var _m_top_y = GRID_Y + ((GRID_ROWS - _mr) * CELL_SIZE) + CELL_SIZE;
	var _m_land_y = GRID_Y + ((GRID_ROWS - _final_mr) * CELL_SIZE);

	draw_set_alpha(GHOST_TRAIL_ALPHA);
	draw_set_color(_colors[global.pair_val1]);
	draw_rectangle(_m_x, _m_top_y, _m_x + CELL_SIZE - 1, _m_land_y + CELL_SIZE - 1, false);

	draw_set_alpha(GHOST_PREVIEW_ALPHA);
	draw_rectangle(_m_x, _m_land_y, _m_x + CELL_SIZE - 1, _m_land_y + CELL_SIZE - 1, false);

	// Draw trail + preview for slave
	var _s_x = GRID_X + (_sc * CELL_SIZE);
	var _s_top_y = GRID_Y + ((GRID_ROWS - _sr) * CELL_SIZE) + CELL_SIZE;
	var _s_land_y = GRID_Y + ((GRID_ROWS - _final_sr) * CELL_SIZE);

	draw_set_alpha(GHOST_TRAIL_ALPHA);
	draw_set_color(_colors[global.pair_val2]);
	draw_rectangle(_s_x, _s_top_y, _s_x + CELL_SIZE - 1, _s_land_y + CELL_SIZE - 1, false);

	draw_set_alpha(GHOST_PREVIEW_ALPHA);
	draw_rectangle(_s_x, _s_land_y, _s_x + CELL_SIZE - 1, _s_land_y + CELL_SIZE - 1, false);

	draw_set_alpha(1.0);
}