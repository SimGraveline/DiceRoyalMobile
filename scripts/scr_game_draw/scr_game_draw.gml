function scr_game_draw() {
	draw_clear(COLOR_BG);
	scr_game_bg_draw();
	scr_grid_draw();
	scr_pair_draw_ghost();
	scr_pair_draw();
	scr_ui_draw();
	scr_countdown_draw();
}