function scr_pair_draw() {
	if (!global.pair_active) return;

	var _slave_col = global.pair_col + global.pair_offset_col;
	var _slave_row = global.pair_row + global.pair_offset_row;
	var _master_on_ground = scr_grid_cell_blocked(global.pair_col, global.pair_row - 1);
	var _slave_on_ground = scr_grid_cell_blocked(_slave_col, _slave_row - 1);
	// Stretch only on soft drop (and hard drop, though it resolves in the same frame so it never
	// actually gets rendered mid-air) — not on the regular automatic fall pace.
	var _falling = !_master_on_ground && !_slave_on_ground && global.input_soft_drop;

	scr_die_draw(global.pair_col, global.pair_row, global.pair_val1, -1, _falling);
	scr_die_draw(_slave_col, _slave_row, global.pair_val2, -1, _falling);
}