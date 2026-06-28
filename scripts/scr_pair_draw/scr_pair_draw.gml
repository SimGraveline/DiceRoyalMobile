function scr_pair_draw() {
	if (global.pair_active) {
		scr_die_draw(global.pair_col, global.pair_row, global.pair_val1);
		scr_die_draw(global.pair_col + global.pair_offset_col, global.pair_row + global.pair_offset_row, global.pair_val2);
	}

	if (global.solo_active) {
		scr_die_draw(global.solo_col, global.solo_row, global.solo_val);
	}
}