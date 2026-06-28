function scr_pair_draw() {
	if (!global.pair_active) return;

	scr_die_draw(global.pair_col, global.pair_row, global.pair_val1);
	scr_die_draw(global.pair_col + global.pair_offset_col, global.pair_row + global.pair_offset_row, global.pair_val2);
}