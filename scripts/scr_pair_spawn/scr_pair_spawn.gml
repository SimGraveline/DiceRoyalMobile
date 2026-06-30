function scr_pair_weighted_random() {
	var _total = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_total += global.spawn_weights[_i];
	}
	var _roll = random(_total);
	var _sum = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_sum += global.spawn_weights[_i];
		if (_roll < _sum) return _i;
	}
	return PAIR_MAX_VALUE;
}

function scr_pair_generate_next() {
	var _v1 = scr_pair_weighted_random();
	var _v2 = scr_pair_weighted_random();
	while ((_v1 == 1 && _v2 == 1) || (_v1 == 2 && _v2 == 2)) {
		_v2 = scr_pair_weighted_random();
	}
	global.next_val1 = _v1;
	global.next_val2 = _v2;
}

function scr_pair_spawn() {
	global.pair_active = true;
	global.pair_col = SPAWN_COL_LEFT;
	global.pair_row = SPAWN_ROW;
	global.pair_offset_col = 1;
	global.pair_offset_row = 0;
	global.pair_val1 = global.next_val1;
	global.pair_val2 = global.next_val2;

	scr_pair_generate_next();
}