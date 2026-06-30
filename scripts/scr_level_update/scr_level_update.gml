function scr_level_update() {
	var _prev_level = global.level;

	if (global.level_pulse_timer > 0) {
		global.level_pulse_timer -= delta_time / DELTA_TO_SECONDS;
		if (global.level_pulse_timer < 0) global.level_pulse_timer = 0;
	}

	for (var _i = LEVEL_COUNT - 1; _i >= 0; _i--) {
		if (global.score >= LEVEL_THRESHOLDS[_i]) {
			global.level = _i + 1;
			global.drop_speed = LEVEL_SPEEDS[_i];
			break;
		}
	}
	if (global.level >= DICE_7_UNLOCK_LEVEL) global.spawn_weights[7] = 1;
	if (global.level >= DICE_8_UNLOCK_LEVEL) global.spawn_weights[8] = 1;
	if (global.level >= DICE_9_UNLOCK_LEVEL) global.spawn_weights[9] = 1;

	if (global.level > _prev_level) {
		scr_audio_play_sfx(snd_level);
		global.level_pulse_timer = LEVEL_PULSE_DURATION;
	}
}
