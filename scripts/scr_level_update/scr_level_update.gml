function scr_level_update() {
	for (var _i = LEVEL_COUNT - 1; _i >= 0; _i--) {
		if (global.score >= LEVEL_THRESHOLDS[_i]) {
			global.level = _i + 1;
			global.drop_speed = LEVEL_SPEEDS[_i];
			break;
		}
	}
}
