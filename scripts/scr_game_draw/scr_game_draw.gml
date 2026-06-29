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
	scr_pair_draw_ghost();
	scr_pair_draw();
	scr_ui_draw();
	scr_countdown_draw();
	scr_screen_fade_draw();
}