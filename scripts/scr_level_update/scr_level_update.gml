function scr_level_update() {
	var _prev_level = global.level;

	if (global.level_pulse_timer > 0) {
		global.level_pulse_timer -= delta_time / DELTA_TO_SECONDS;
		if (global.level_pulse_timer < 0) global.level_pulse_timer = 0;
	}

	if (global.score >= LEVEL_ENDLESS_BASE_SCORE) {
		// Open-ended progression past the fixed table: fixed speed, recurring threshold step
		global.level = LEVEL_COUNT + floor((global.score - LEVEL_ENDLESS_BASE_SCORE) / LEVEL_ENDLESS_SCORE_STEP);
		global.drop_speed = LEVEL_ENDLESS_SPEED;
	} else {
		for (var _i = LEVEL_COUNT - 1; _i >= 0; _i--) {
			if (global.score >= LEVEL_THRESHOLDS[_i]) {
				global.level = _i + 1;
				global.drop_speed = LEVEL_SPEEDS[_i];
				break;
			}
		}
	}

	// Dice 7-8-9 are fully wired but kept dormant — see DICE_HIGH_VALUES_ENABLED
	if (DICE_HIGH_VALUES_ENABLED) {
		if (global.level >= DICE_7_UNLOCK_LEVEL) global.spawn_weights[7] = 1;
		if (global.level >= DICE_8_UNLOCK_LEVEL) global.spawn_weights[8] = 1;
		if (global.level >= DICE_9_UNLOCK_LEVEL) global.spawn_weights[9] = 1;
	}

	if (global.level > _prev_level) {
		scr_audio_play_sfx(snd_level);
		global.level_pulse_timer = LEVEL_PULSE_DURATION;
	}
}
