function scr_pair_weighted_random() {
	// Normal pool
	var _normal_total = 0;
	for (var _i = PAIR_MIN_VALUE; _i <= PAIR_MAX_VALUE; _i++) {
		_normal_total += global.spawn_weights[_i];
	}

	// Special die weights: w = normal_total / (CHANCE - 1) → P(special) ≈ 1/CHANCE
	// Odds stay constant for life once unlocked — no endless-tier tightening.
	var _w_q  = (global.level >= DICE_MIMIC_UNLOCK_LEVEL)   ? (_normal_total / (DICE_MIMIC_CHANCE   - 1)) : 0;
	var _w_r  = (global.level >= DICE_RANDOM_UNLOCK_LEVEL)  ? (_normal_total / (DICE_RANDOM_CHANCE   - 1)) : 0;
	var _w_k  = (global.level >= DICE_BOMB_UNLOCK_LEVEL)    ? (_normal_total / (DICE_BOMB_CHANCE     - 1)) : 0;
	var _w_b  = (global.level >= DICE_BRICK_UNLOCK_LEVEL)   ? (_normal_total / (DICE_BRICK_CHANCE    - 1)) : 0;
	var _w_cr = (global.level >= DICE_CLEAR_R_UNLOCK_LEVEL) ? (_normal_total / (DICE_CLEAR_R_CHANCE  - 1)) : 0;
	var _w_cc = (global.level >= DICE_CLEAR_C_UNLOCK_LEVEL) ? (_normal_total / (DICE_CLEAR_C_CHANCE  - 1)) : 0;

	var _total = _normal_total + _w_q + _w_r + _w_k + _w_b + _w_cr + _w_cc;
	var _roll  = random(_total);

	if (_roll < _w_q) return DIE_MIMIC;
	_roll -= _w_q;
	if (_roll < _w_r) return DIE_RANDOM;
	_roll -= _w_r;
	if (_roll < _w_k) return DIE_BOMB;
	_roll -= _w_k;
	if (_roll < _w_b) return DIE_BRICK;
	_roll -= _w_b;
	if (_roll < _w_cr) return DIE_CLEAR_R;
	_roll -= _w_cr;
	if (_roll < _w_cc) return DIE_CLEAR_C;
	_roll -= _w_cc;

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
	}

	// Two independent constraints on v2, re-rolled together in one loop so fixing one never
	// silently reintroduces the other:
	// (1) No 1:1 or 2:2 within the same pair.
	// (2) No two consecutive pairs identical, order-independent (regular or special dice alike) —
	//     compares against the pair that just became current (global.pair_val1/2). Skipped on the
	//     very first call (game init), since no current pair exists yet.
	// If SPAWN_RETRY_MAX is exhausted, whatever's left over is accepted as-is.
	var _has_current = variable_global_exists("pair_val1");
	var _cv1 = _has_current ? global.pair_val1 : -1;
	var _cv2 = _has_current ? global.pair_val2 : -1;

	var _iters = 0;
	while (_iters < SPAWN_RETRY_MAX) {
		var _same_pair_double = (_v1 == _v2) && (_v1 == 1 || _v1 == 2);
		var _matches_current = _has_current && ((_v1 == _cv1 && _v2 == _cv2) || (_v1 == _cv2 && _v2 == _cv1));
		if (!_same_pair_double && !_matches_current) break;

		_v2 = (_v1 > PAIR_MAX_VALUE) ? scr_pair_normal_random() : scr_pair_weighted_random();
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
	scr_junk_drop_track_spawn();
}