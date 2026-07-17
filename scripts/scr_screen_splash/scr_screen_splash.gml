function scr_screen_splash(){

}

function scr_screen_splash_init() {
	global.rain_dice = [];
	global.rain_spawn_timer = 0;
	global.splash_blink_timer = 0;
	global.splash_music_id = audio_play_sound(snd_theme, 1, true);
	audio_sound_gain(global.splash_music_id, global.music_muted ? 0 : 1, 0);
}

function scr_screen_splash_update() {
	// Spawn new dice
	global.rain_spawn_timer -= delta_time / DELTA_TO_SECONDS;
	if (global.rain_spawn_timer <= 0 && array_length(global.rain_dice) < RAIN_MAX_DICE) {
		global.rain_spawn_timer = RAIN_SPAWN_RATE;
		var _die = {
			x: random(GAME_WIDTH),
			y: random(GAME_HEIGHT),
			frame: irandom_range(1, 6),
			alpha: random_range(RAIN_ALPHA_MIN, RAIN_ALPHA_MAX),
			speed: random_range(RAIN_SPEED_MIN, RAIN_SPEED_MAX),
			shaking: (irandom(RAIN_SHAKE_ODDS) < RAIN_SHAKE_CHANCE)
		};
		array_push(global.rain_dice, _die);
	}

	// Update dice
	var _count = array_length(global.rain_dice);
	for (var _i = _count - 1; _i >= 0; _i--) {
		var _d = global.rain_dice[_i];
		_d.y += _d.speed;
		_d.alpha -= RAIN_FADE_RATE;

		if (_d.alpha <= 0 || _d.y > GAME_HEIGHT + RAIN_DESTROY_BUFFER) {
			array_delete(global.rain_dice, _i, 1);
		}
	}

	global.splash_blink_timer += delta_time / DELTA_TO_SECONDS;

	// Fade update
	scr_screen_fade_update();

	// Input — keyboard: any key. Mouse: left/right click. Gamepad: face buttons, Start, Select,
	// bumpers, triggers — never the d-pad or analog sticks (those move too easily by accident).
	var _any_input = keyboard_check_pressed(vk_anykey)
		|| mouse_check_button_pressed(mb_left)
		|| mouse_check_button_pressed(mb_right);

	var _pad = GAMEPAD_INDEX;
	if (gamepad_is_connected(_pad)) {
		_any_input = _any_input
			|| gamepad_button_check_pressed(_pad, gp_face1)
			|| gamepad_button_check_pressed(_pad, gp_face2)
			|| gamepad_button_check_pressed(_pad, gp_face3)
			|| gamepad_button_check_pressed(_pad, gp_face4)
			|| gamepad_button_check_pressed(_pad, gp_start)
			|| gamepad_button_check_pressed(_pad, gp_select)
			|| gamepad_button_check_pressed(_pad, gp_shoulderl)
			|| gamepad_button_check_pressed(_pad, gp_shoulderr)
			|| gamepad_button_check_pressed(_pad, gp_shoulderlb)
			|| gamepad_button_check_pressed(_pad, gp_shoulderrb);
	}

	if (_any_input && !global.fade_active) {
		if (global.splash_music_id != -1 && audio_exists(global.splash_music_id)) {
			audio_sound_gain(global.splash_music_id, 0, SPLASH_MUSIC_FADE_MS);
		}
		scr_screen_fade_start(STATE_GAME);
	}
}

function scr_screen_splash_draw() {
	draw_clear(COLOR_BG);

	// Dice rain
	var _base = RAIN_SCALE;
	var _count = array_length(global.rain_dice);
	for (var _i = 0; _i < _count; _i++) {
		var _d = global.rain_dice[_i];
		var _xs = _base;
		var _ys = _base;
		if (_d.shaking) {
			_xs = _base * random_range(RAIN_SHAKE_MIN, RAIN_SHAKE_MAX);
			_ys = _base * random_range(RAIN_SHAKE_MIN, RAIN_SHAKE_MAX);
		}
		draw_sprite_ext(spr_dice_rain, _d.frame, _d.x, _d.y, _xs, _ys, 0, c_white, _d.alpha);
	}

	// Title
	draw_set_font(fnt_splash_title_bungee_big);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	scr_ui_draw_text(GAME_WIDTH / 2, GAME_HEIGHT / 2, STR_TITLE, c_white);

	// Tap to Stack (blink)
	var _title_h = string_height(STR_TITLE);
	var _blink_alpha = 0.5 + 0.5 * sin(global.splash_blink_timer * pi * 2);
	draw_set_alpha(_blink_alpha);
	draw_set_font(fnt_splash_pressstart_inkfree_med);
	draw_set_valign(fa_top);
	scr_ui_draw_text(GAME_WIDTH / 2, GAME_HEIGHT / 2 + _title_h, STR_TAP_TO_STACK, c_white);
	draw_set_alpha(1.0);

	// Credits
	draw_set_font(fnt_splash_credits_bebasneue_small);
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	scr_ui_draw_text(GAME_WIDTH / 2, GAME_HEIGHT - CREDITS_MARGIN_BOTTOM, STR_CREDITS, c_white);

	// Beta version tag
	draw_set_font(fnt_splash_version_bebasneue_small);
	draw_set_valign(fa_top);
	scr_ui_draw_text(GAME_WIDTH / 2, BETA_VERSION_MARGIN_TOP, STR_BETA_VERSION, c_white);

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);

	scr_screen_fade_draw();
}
