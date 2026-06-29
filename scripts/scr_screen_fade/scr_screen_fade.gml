function scr_screen_fade(){

}

function scr_screen_fade_start(_next_state) {
	global.fade_active = true;
	global.fade_phase = FADE_OUT;
	global.fade_scale = FADE_SCALE_START;
	global.fade_alpha = 0;
	global.fade_next_state = _next_state;
}

function scr_screen_fade_update() {
	if (!global.fade_active) return;

	if (global.fade_phase == FADE_OUT) {
		global.fade_scale -= FADE_SCALE_RATE;
		global.fade_alpha += FADE_ALPHA_RATE;
		if (global.fade_scale <= FADE_SCALE_MID) {
			global.fade_alpha = 1;
			global.fade_phase = FADE_IN;
			global.fade_scale = FADE_SCALE_MID;
			if (global.fade_next_state == STATE_GAME) {
				scr_game_restart();
			}
			global.game_state = global.fade_next_state;
		}
	} else if (global.fade_phase == FADE_IN) {
		global.fade_scale += FADE_SCALE_RATE;
		global.fade_alpha -= FADE_ALPHA_RATE;
		if (global.fade_alpha <= 0 || global.fade_scale >= FADE_SCALE_END) {
			global.fade_alpha = 0;
			global.fade_active = false;
			if (global.fade_next_state == STATE_GAME) {
				scr_countdown_start();
			}
		}
	}
}

function scr_screen_fade_draw() {
	if (!global.fade_active) return;

	var _cx = GAME_WIDTH / 2;
	var _cy = GAME_HEIGHT / 2;

	draw_sprite_ext(spr_screen_fade, 0, _cx, _cy, global.fade_scale, global.fade_scale, 0, c_white, global.fade_alpha);
}
