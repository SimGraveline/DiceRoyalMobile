function scr_screen_logos(){

}

function scr_screen_logos_init() {
	global.logo_step = 0;
	global.logo_timer = LOGO_DURATION_1;
}

function scr_screen_logos_update() {
	global.logo_timer -= delta_time / DELTA_TO_SECONDS;
	if (global.logo_timer <= 0) {
		global.logo_step += 1;
		if (global.logo_step >= LOGO_COUNT) {
			global.game_state = STATE_SPLASH;
			scr_screen_splash_init();
		} else {
			global.logo_timer = LOGO_DURATION_2;
		}
	}
}

function scr_screen_logos_draw() {
	draw_clear(COLOR_BG);

	var _cx = GAME_WIDTH / 2;
	var _cy = GAME_HEIGHT / 2;

	draw_set_halign(fa_center);

	if (global.logo_step == 0) {
		draw_set_font(fnt_inkfree_logo);
		draw_set_valign(fa_bottom);
		scr_ui_draw_text(_cx, _cy - LOGO_TEXT_OFFSET, STR_LOGO_MADE_WITH, c_white);

		var _scale = MOBILE_GAME_WIDTH * LOGO_SCALE_GM / sprite_get_width(spr_logo_gamemaker);
		draw_sprite_ext(spr_logo_gamemaker, 0, _cx, _cy + LOGO_TEXT_OFFSET, _scale, _scale, 0, c_white, 1.0);
	} else {
		var _scale = MOBILE_GAME_WIDTH * LOGO_SCALE_GG / sprite_get_width(spr_logo_gravegames);
		var _logo_h = sprite_get_height(spr_logo_gravegames) * _scale;

		draw_set_font(fnt_bebasneue_logo);
		draw_set_valign(fa_bottom);
		scr_ui_draw_text(_cx, _cy - _logo_h / 2, STR_LOGO_STUDIO, c_white);

		draw_sprite_ext(spr_logo_gravegames, 0, _cx - UI_SHADOW_OFFSET, _cy + UI_SHADOW_OFFSET, _scale, _scale, 0, c_black, 1.0);
		draw_sprite_ext(spr_logo_gravegames, 0, _cx, _cy, _scale, _scale, 0, c_white, 1.0);

		draw_set_valign(fa_top);
		scr_ui_draw_text(_cx, _cy + _logo_h / 2, STR_LOGO_PRESENTS, c_white);
	}

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}
