function scr_pair_weighted_random() {
	// Normal pool
	var _normal_total = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_normal_total += global.spawn_weights[_i];
	}

	// Special die weights: w = normal_total / (CHANCE - 1) → P(special) ≈ 1/CHANCE
	var _w_q = (global.level >= DICE_MIMIC_UNLOCK_LEVEL) ? (_normal_total / (DICE_MIMIC_CHANCE - 1)) : 0;
	var _w_r = (global.level >= DICE_RANDOM_UNLOCK_LEVEL)   ? (_normal_total / (DICE_RANDOM_CHANCE   - 1)) : 0;
	var _w_k = (global.level >= DICE_BOMB_UNLOCK_LEVEL)   ? (_normal_total / (DICE_BOMB_CHANCE   - 1)) : 0;

	var _total = _normal_total + _w_q + _w_r + _w_k;
	var _roll  = random(_total);

	if (_roll < _w_q) return DIE_MIMIC;
	_roll -= _w_q;
	if (_roll < _w_r) return DIE_RANDOM;
	_roll -= _w_r;
	if (_roll < _w_k) return DIE_BOMB;
	_roll -= _w_k;

	var _sum = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_sum += global.spawn_weights[_i];
		if (_roll < _sum) return _i;
	}
	for (var _i = PAIR_MAX_VALUE; _i >= PAIR_MIN_VALUE; _i--) {
		if (global.spawn_weights[_i] > 0) return _i;
	}
	return PAIR_MIN_VALUE;
}

function scr_pair_normal_random() {
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
	for (var _i = PAIR_MAX_VALUE; _i >= PAIR_MIN_VALUE; _i--) {
		if (global.spawn_weights[_i] > 0) return _i;
	}
	return PAIR_MIN_VALUE;
}

function scr_pair_generate_next() {
	var _v1 = scr_pair_weighted_random();

	// If v1 is special, v2 must be a normal die (max one special per pair)
	var _v2;
	if (_v1 > PAIR_MAX_VALUE) {
		_v2 = scr_pair_normal_random();
	} else {
		_v2 = scr_pair_weighted_random();
		// If v2 also came out special, force it to be normal
		if (_v2 > PAIR_MAX_VALUE) {
			_v2 = scr_pair_normal_random();
		}
	}

	// No 1:1 or 2:2
	var _iters = 0;
	while ((_v1 == _v2) && (_v1 == 1 || _v1 == 2) && _iters < SPAWN_RETRY_MAX) {
		_v2 = scr_pair_normal_random();
		_iters++;
	}

	global.next_val1 = _v1;
	global.next_val2 = _v2;
}

function scr_pair_spawn() {
	global.pair_active = true;
	global.pair_random_val = PAIR_MIN_VALUE;
	global.pair_random_timer = 0;
	global.pair_col = SPAWN_COL_LEFT;
	global.pair_row = SPAWN_ROW;
	global.pair_offset_col = 1;
	global.pair_offset_row = 0;
	global.pair_val1 = global.next_val1;
	global.pair_val2 = global.next_val2;

	scr_pair_generate_next();
}