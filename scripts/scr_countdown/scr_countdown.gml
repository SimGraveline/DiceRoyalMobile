function scr_countdown(){

}

function scr_countdown_start() {
	global.countdown_active = true;
	global.countdown_step = COUNTDOWN_STEPS;
	global.countdown_step_duration = COUNTDOWN_STEP_DUR;
	global.countdown_timer = global.countdown_step_duration;
}

function scr_countdown_update() {
	if (!global.countdown_active) return;

	global.countdown_timer -= delta_time / DELTA_TO_SECONDS;
	if (global.countdown_timer <= 0) {
		global.countdown_step -= 1;
		if (global.countdown_step < 0) {
			global.countdown_active = false;
			global.drop_speed = LEVEL_SPEEDS[0];
			scr_audio_start_game_music();
		} else {
			global.countdown_timer = global.countdown_step_duration;
		}
	}
}

function scr_countdown_draw() {
	if (!global.countdown_active) return;

	var _text = "";
	if (global.countdown_step > 0) {
		_text = string(global.countdown_step);
	} else {
		_text = STR_COUNTDOWN_GO;
	}

	var _progress = 1 - (global.countdown_timer / global.countdown_step_duration);
	var _half = 0.5;
	var _scale;
	if (_progress < _half) {
		_scale = lerp(COUNTDOWN_SCALE_MIN, COUNTDOWN_SCALE_MAX, _progress / _half);
	} else {
		_scale = lerp(COUNTDOWN_SCALE_MAX, COUNTDOWN_SCALE_MIN, (_progress - _half) / _half);
	}

	draw_set_font(fnt_hud_countdown_bungee_big);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	var _x = GAME_WIDTH / 2;
	var _y = GAME_HEIGHT / 2;
	var _s = UI_SHADOW_OFFSET * _scale;

	draw_set_color(c_black);
	draw_text_transformed(_x - _s, _y + _s, _text, _scale, _scale, 0);
	draw_set_color(c_white);
	draw_text_transformed(_x, _y, _text, _scale, _scale, 0);

	draw_set_font(-1);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
}
