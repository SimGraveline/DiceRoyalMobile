function scr_game_bg(){

}

function scr_game_bg_init() {
	global.bg_offset_x = 0;
	global.bg_offset_y = 0;
	global.bg_speed = BG_SPEED;
	global.bg_dir_x = 1;
	global.bg_dir_y = -1;
	global.bg_scale = BG_SCALE;
	global.bg_spacing_x = BG_SPACING_X;
	global.bg_spacing_y = BG_SPACING_Y;
	global.bg_alpha = BG_ALPHA;
	global.bg_change_rate = BG_CHANGE_RATE;
	global.bg_change_timer = global.bg_change_rate;

	global.bg_shake_odds = BG_SHAKE_ODDS;
	global.bg_shake_threshold = BG_SHAKE_THRESHOLD;
	global.bg_shake_min = BG_SHAKE_MIN;
	global.bg_shake_max = BG_SHAKE_MAX;
	global.bg_shake_reset_rate = BG_SHAKE_RESET_RATE;
	global.bg_shake_reset_timer = global.bg_shake_reset_rate;

	// Combo feel — tint/alpha driven by scr_grid_resolve while a chain is dying
	global.bg_combo_color = c_white;
	global.bg_combo_alpha = BG_ALPHA;

	var _cols = ceil(GAME_WIDTH / global.bg_spacing_x) + 2;
	var _rows = ceil(GAME_HEIGHT / global.bg_spacing_y) + 2;
	global.bg_grid_cols = _cols;
	global.bg_grid_rows = _rows;
	global.bg_shake_active = [];
	for (var _i = 0; _i < _cols * _rows; _i++) {
		global.bg_shake_active[_i] = false;
	}
}

function scr_game_bg_update() {
	global.bg_offset_x += global.bg_speed * global.bg_dir_x;
	global.bg_offset_y += global.bg_speed * global.bg_dir_y;
	global.bg_offset_x = global.bg_offset_x mod global.bg_spacing_x;
	global.bg_offset_y = global.bg_offset_y mod global.bg_spacing_y;

	global.bg_change_timer -= delta_time / DELTA_TO_SECONDS;
	if (global.bg_change_timer <= 0) {
		global.bg_change_timer = global.bg_change_rate;
		var _old_dx = global.bg_dir_x;
		global.bg_dir_x = -global.bg_dir_y;
		global.bg_dir_y = _old_dx;
	}

	global.bg_shake_reset_timer -= delta_time / DELTA_TO_SECONDS;
	if (global.bg_shake_reset_timer <= 0) {
		global.bg_shake_reset_timer = global.bg_shake_reset_rate;
		var _count = global.bg_grid_cols * global.bg_grid_rows;
		for (var _i = 0; _i < _count; _i++) {
			global.bg_shake_active[_i] = (irandom(global.bg_shake_odds) > global.bg_shake_threshold);
		}
	}
}

function scr_game_bg_draw() {
	var _sx = global.bg_spacing_x;
	var _sy = global.bg_spacing_y;
	var _ox = global.bg_offset_x - _sx;
	var _oy = global.bg_offset_y - _sy;
	var _base = global.bg_scale;
	var _color = BG_COMBO_ENABLED ? global.bg_combo_color : c_white;
	var _alpha = BG_COMBO_ENABLED ? global.bg_combo_alpha : global.bg_alpha;
	var _i = 0;
	var _count = global.bg_grid_cols * global.bg_grid_rows;

	for (var _x = _ox; _x < GAME_WIDTH + _sx; _x += _sx) {
		for (var _y = _oy; _y < GAME_HEIGHT + _sy; _y += _sy) {
			var _idx = _i mod _count;
			var _xs = _base;
			var _ys = _base;
			// Never re-roll the jitter while paused — the simulation is frozen, the background
			// shouldn't still look alive underneath the menu (same rule as scr_die_draw's shake).
			if (global.bg_shake_active[_idx] && !global.paused) {
				_xs = _base * random_range(global.bg_shake_min, global.bg_shake_max);
				_ys = _base * random_range(global.bg_shake_min, global.bg_shake_max);
			}
			draw_sprite_ext(spr_dxr, 0, _x, _y, _xs, _ys, 0, _color, _alpha);
			_i++;
		}
	}
}
