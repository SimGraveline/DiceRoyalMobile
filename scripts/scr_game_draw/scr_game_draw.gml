function scr_game_draw() {
	if (global.game_state == STATE_LOGOS) {
		scr_screen_logos_draw();
		return;
	}

	if (global.game_state == STATE_SPLASH) {
		scr_screen_splash_draw();
		return;
	}

	draw_clear(COLOR_BG);
	scr_game_bg_draw();
	scr_grid_draw();
	scr_junk_drop_draw();
	scr_pair_draw_ghost();
	scr_pair_draw();
	// After the pair, not before: the preview now lights up the active die too, and that glow has to
	// land on top of its sprite rather than behind it. The stacked dice it also lights sit lower on
	// the grid than the pair does, so nothing gets covered by the swap.
	scr_pair_draw_match_preview();
	scr_ui_draw();
	scr_countdown_draw();
	scr_screen_fade_draw();
}