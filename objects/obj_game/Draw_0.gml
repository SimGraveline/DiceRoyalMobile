scr_grid_draw();
scr_pair_draw();

if (global.game_over) {
	draw_set_color(c_red);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_set_font(-1);
	draw_text(GAME_WIDTH / 2, GAME_OVER_Y, STR_GAME_OVER);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
