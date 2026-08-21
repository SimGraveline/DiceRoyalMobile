// Maps a die value to the sprite/subimage that represents it — shared by every HUD spot that
// draws a die (Hold, Next, Unlocks tiles), so the special-case list (Bomb/Mimic/Brick/Clear R/
// Clear C/Random) only lives in one place.
function scr_ui_get_die_sprite_info(_value) {
	switch (_value) {
		case DIE_BOMB:    return { spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_BOMB };
		case DIE_MIMIC:   return { spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_MIMIC };
		case DIE_BRICK:   return { spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_BRICK };
		case DIE_CLEAR_R: return { spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_CLEAR_R };
		case DIE_CLEAR_C: return { spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_CLEAR_C };
		case DIE_RANDOM:  return { spr: spr_dice, sub: global.pair_random_val };
		default:          return { spr: spr_dice, sub: _value };
	}
}

function scr_ui_draw_die_ext(_x, _y, _value, _size, _col, _alpha) {
	var _info = scr_ui_get_die_sprite_info(_value);
	var _scale = _size / sprite_get_width(_info.spr);
	draw_sprite_ext(_info.spr, _info.sub, _x, _y, _scale, _scale, 0, _col, _alpha);
}

function scr_ui_draw_die(_x, _y, _value) {
	scr_ui_draw_die_ext(_x, _y, _value, CELL_SIZE, c_white, 1.0);
}

function scr_ui_draw_text(_x, _y, _str, _col) {
	var _s = UI_SHADOW_OFFSET;
	draw_set_color(c_black);
	draw_text(_x - _s, _y + _s, _str);
	draw_set_color(_col);
	draw_text(_x, _y, _str);
}

// No drop shadow — used inside the HUD side-column boxes, where a shadow doesn't read well at
// the smaller box font sizes (unlike the full-screen menu text scr_ui_draw_text is meant for).
function scr_ui_draw_text_plain(_x, _y, _str, _col) {
	draw_set_color(_col);
	draw_text(_x, _y, _str);
}

// Draws a "KEY = ACTION" help control row as three colored segments, centered as one unit
// (font must already be set by the caller).
function scr_ui_draw_control_row(_y, _key, _action) {
	var _eq = STR_HELP_CTRL_SEPARATOR;
	var _full_w = string_width(_key) + string_width(_eq) + string_width(_action);
	var _cx = GAME_WIDTH / 2 - _full_w / 2;
	draw_set_halign(fa_left);
	scr_ui_draw_text(_cx, _y, _key, COLOR_BOX_FILL);
	_cx += string_width(_key);
	scr_ui_draw_text_plain(_cx, _y, _eq, COLOR_GOLD);
	_cx += string_width(_eq);
	scr_ui_draw_text(_cx, _y, _action, c_white);
	draw_set_halign(fa_center);
}

// --- Shared box chrome for every HUD side-column box (Score/High Score/Level/Chains/Next/Hold/Unlocks) ---
function scr_ui_draw_box_bg(_x, _y, _w, _h) {
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(_x, _y, _x + _w - 1, _y + _h - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(_x - _o, _y - _o, _x + _w - 1 + _o, _y + _h - 1 + _o, true);
	}
}

// Every box's label sits inside the box, top-left, same font/color regardless of box type.
// No drop shadow — see scr_ui_draw_text_plain.
function scr_ui_draw_box_title(_x, _y, _title) {
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	scr_ui_draw_text_plain(_x, _y, _title, COLOR_BG);
}

// --- Score / High Score / Level: title + one big value ---
function scr_ui_stat_box_height() {
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	draw_set_font(fnt_hud_boxtext_bungee_big);
	var _value_h = string_height("A");
	return UI_BOX_PADDING * 2 + _title_h + UI_BOX_TITLE_GAP + _value_h;
}

function scr_ui_draw_stat_box(_x, _y, _w, _h, _title, _value_str, _value_col) {
	scr_ui_draw_box_bg(_x, _y, _w, _h);
	scr_ui_draw_box_title(_x + UI_BOX_PADDING, _y + UI_BOX_PADDING, _title);

	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	draw_set_font(fnt_hud_boxtext_bungee_big);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	scr_ui_draw_text_plain(_x + UI_BOX_PADDING, _y + UI_BOX_PADDING + _title_h + UI_BOX_TITLE_GAP, _value_str, _value_col);
}

// --- Chains: title + Last/Best side by side ---
function scr_ui_chains_box_height() {
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	draw_set_font(fnt_hud_boxsub_bungee_small);
	var _sub_h = string_height("A");
	draw_set_font(fnt_hud_boxtext_bungee_big);
	var _value_h = string_height("A");
	return UI_BOX_PADDING * 2 + _title_h + UI_BOX_TITLE_GAP + _sub_h + UI_BOX_TITLE_GAP + _value_h;
}

function scr_ui_draw_chains_box(_x, _y, _w, _h) {
	scr_ui_draw_box_bg(_x, _y, _w, _h);
	scr_ui_draw_box_title(_x + UI_BOX_PADDING, _y + UI_BOX_PADDING, STR_CHAINS);

	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	var _content_y = _y + UI_BOX_PADDING + _title_h + UI_BOX_TITLE_GAP;
	var _col_w = (_w - UI_BOX_PADDING * 2) / 2;

	draw_set_halign(fa_left);
	draw_set_valign(fa_top);

	draw_set_font(fnt_hud_boxsub_bungee_small);
	scr_ui_draw_text_plain(_x + UI_BOX_PADDING, _content_y, STR_LAST, c_dkgray);
	var _sub_h = string_height("A");
	draw_set_font(fnt_hud_boxtext_bungee_big);
	scr_ui_draw_text_plain(_x + UI_BOX_PADDING, _content_y + _sub_h + UI_BOX_TITLE_GAP, string(global.chain_count), c_white);

	draw_set_font(fnt_hud_boxsub_bungee_small);
	scr_ui_draw_text_plain(_x + UI_BOX_PADDING + _col_w, _content_y, STR_BEST, c_dkgray);
	draw_set_font(fnt_hud_boxtext_bungee_big);
	scr_ui_draw_text_plain(_x + UI_BOX_PADDING + _col_w, _content_y + _sub_h + UI_BOX_TITLE_GAP, string(global.chain_best), COLOR_GOLD);
}

// --- Next / Hold+Swap: title + dice preview. _val1 < 0 skips the preview (empty Hold slot). ---
function scr_ui_pair_box_height() {
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	return UI_BOX_PADDING * 2 + _title_h + UI_BOX_TITLE_GAP + CELL_SIZE;
}

// Draws a Hold/Next style box + dice preview + label at an arbitrary anchor.
// _val1 < 0 skips the preview (used for an empty Hold slot). Mobile version: fixed box size from
// BOX_WIDTH/BOX_HEIGHT with the label underneath, rather than the desktop columns' measured height.
function scr_ui_draw_pair_box(_x, _y, _val1, _val2, _label) {
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(_x, _y, _x + BOX_WIDTH - 1, _y + BOX_HEIGHT - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(_x - _o, _y - _o, _x + BOX_WIDTH - 1 + _o, _y + BOX_HEIGHT - 1 + _o, true);
	}

	if (_val1 >= 0) {
		var _dx = _x + (BOX_WIDTH - CELL_SIZE * 2) / 2;
		var _dy = _y + (BOX_HEIGHT - CELL_SIZE) / 2;
		scr_ui_draw_die(_dx, _dy, _val1);
		scr_ui_draw_die(_dx + CELL_SIZE, _dy, _val2);
	}

	draw_set_font(fnt_hud_boxtitle_bungee_med);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(_x + BOX_WIDTH / 2, _y + BOX_HEIGHT + BOX_LABEL_OFFSET, _label, c_white);
}

function scr_ui_unlocks_list() {
	return [
		{ spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_RANDOM_ICON, level: DICE_RANDOM_UNLOCK_LEVEL,  name: STR_DIE_NAME_RANDOM },
		{ spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_CLEAR_ICON,  level: DICE_CLEAR_R_UNLOCK_LEVEL, name: STR_DIE_NAME_CLEAR },
		{ spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_BOMB,        level: DICE_BOMB_UNLOCK_LEVEL,    name: STR_DIE_NAME_BOMB },
		{ spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_JUNK_ICON,   level: DICE_JUNK_UNLOCK_LEVEL,    name: STR_DIE_NAME_JUNK },
		{ spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_BRICK,       level: DICE_BRICK_UNLOCK_LEVEL,   name: STR_DIE_NAME_BRICK },
		{ spr: spr_dice_specials, sub: DICE_SPECIALS_SUB_MIMIC,       level: DICE_MIMIC_UNLOCK_LEVEL,   name: STR_DIE_NAME_MIMIC },
	];
}

function scr_ui_unlocks_box_height() {
	var _rows = ceil(array_length(scr_ui_unlocks_list()) / UI_UNLOCKS_COLS);
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	draw_set_font(fnt_hud_boxsub_bungee_small);
	var _sub_h = string_height("A");
	var _tiles_h = _rows * UI_UNLOCKS_TILE_SIZE + (_rows - 1) * UI_UNLOCKS_TILE_GAP;
	return UI_BOX_PADDING * 2 + _title_h + UI_BOX_TITLE_GAP + _tiles_h + UI_BOX_TITLE_GAP + _sub_h;
}

function scr_ui_draw_unlocks_box(_x, _y, _w, _h) {
	scr_ui_draw_box_bg(_x, _y, _w, _h);
	scr_ui_draw_box_title(_x + UI_BOX_PADDING, _y + UI_BOX_PADDING, STR_UNLOCKS);

	var _list = scr_ui_unlocks_list();

	draw_set_font(fnt_hud_boxtitle_bungee_med);
	var _title_h = string_height("A");
	var _tiles_y = _y + UI_BOX_PADDING + _title_h + UI_BOX_TITLE_GAP;

	var _tiles_w = UI_UNLOCKS_COLS * UI_UNLOCKS_TILE_SIZE + (UI_UNLOCKS_COLS - 1) * UI_UNLOCKS_TILE_GAP;
	var _tiles_x = _x + (_w - _tiles_w) / 2;

	var _next_locked = undefined;

	for (var _i = 0; _i < array_length(_list); _i++) {
		var _entry = _list[_i];
		var _col = _i mod UI_UNLOCKS_COLS;
		var _row = _i div UI_UNLOCKS_COLS;
		var _tx = _tiles_x + _col * (UI_UNLOCKS_TILE_SIZE + UI_UNLOCKS_TILE_GAP);
		var _ty = _tiles_y + _row * (UI_UNLOCKS_TILE_SIZE + UI_UNLOCKS_TILE_GAP);
		var _unlocked = (global.level >= _entry.level);

		if (!_unlocked && is_undefined(_next_locked)) {
			_next_locked = _entry;
		}

		var _tint = _unlocked ? c_white : c_gray;
		var _alpha = _unlocked ? 1.0 : UI_UNLOCKS_LOCKED_ALPHA;
		var _scale = UI_UNLOCKS_TILE_SIZE / sprite_get_width(_entry.spr);
		draw_sprite_ext(_entry.spr, _entry.sub, _tx, _ty, _scale, _scale, 0, _tint, _alpha);
	}

	var _rows = ceil(array_length(_list) / UI_UNLOCKS_COLS);
	var _sub_y = _tiles_y + _rows * (UI_UNLOCKS_TILE_SIZE + UI_UNLOCKS_TILE_GAP) - UI_UNLOCKS_TILE_GAP + UI_BOX_TITLE_GAP;
	var _next_str = is_undefined(_next_locked) ? STR_UNLOCKS_ALL_DONE : (STR_UNLOCKS_NEXT_PREFIX + _next_locked.name + STR_UNLOCKS_LEVEL_PREFIX + string(_next_locked.level));

	draw_set_font(fnt_hud_boxsub_bungee_small);
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	scr_ui_draw_text_plain(_x + UI_BOX_PADDING, _sub_y, _next_str, c_dkgray);
}

// Computes both HUD columns so they share the same top Y and bottom Y — whichever column is
// naturally shorter gets its inter-box gaps stretched to fill the same span, rather than the
// two columns drifting to different heights.
// Cached: every box height here only depends on the screen size (font metrics + CELL_SIZE, which
// itself derives from GAME_HEIGHT) — none of it changes frame to frame. Recomputing it from
// scratch every single step (several draw_set_font/string_height calls plus fresh arrays/struct,
// forever) was pure waste; this reuses the last result unless GAME_WIDTH/GAME_HEIGHT actually change.
function scr_ui_hud_layout() {
	if (global.hud_layout_w == GAME_WIDTH && global.hud_layout_h == GAME_HEIGHT) {
		return global.hud_layout_cache;
	}

	var _stat_h    = scr_ui_stat_box_height();
	var _chains_h  = scr_ui_chains_box_height();
	var _pair_h    = scr_ui_pair_box_height();
	var _unlocks_h = scr_ui_unlocks_box_height();

	var _left_h  = [_stat_h, _stat_h, _stat_h, _chains_h];
	var _right_h = [_unlocks_h, _pair_h, _pair_h];

	var _left_sum = 0;
	for (var _i = 0; _i < array_length(_left_h); _i++) _left_sum += _left_h[_i];
	var _right_sum = 0;
	for (var _i = 0; _i < array_length(_right_h); _i++) _right_sum += _right_h[_i];

	var _left_span  = _left_sum  + (array_length(_left_h)  - 1) * UI_HUD_BOX_GAP;
	var _right_span = _right_sum + (array_length(_right_h) - 1) * UI_HUD_BOX_GAP;
	var _span = max(_left_span, _right_span);
	var _top = (GAME_HEIGHT - _span) / 2;

	var _left_gap  = (_span - _left_sum)  / (array_length(_left_h)  - 1);
	var _right_gap = (_span - _right_sum) / (array_length(_right_h) - 1);

	var _left_y = [];
	var _y = _top;
	for (var _i = 0; _i < array_length(_left_h); _i++) {
		_left_y[_i] = _y;
		_y += _left_h[_i] + _left_gap;
	}

	var _right_y = [];
	_y = _top;
	for (var _i = 0; _i < array_length(_right_h); _i++) {
		_right_y[_i] = _y;
		_y += _right_h[_i] + _right_gap;
	}

	global.hud_layout_cache = {
		left_x:  GRID_X / 2 - BOX_WIDTH / 2,
		right_x: (GRID_X + GRID_WIDTH + GAME_WIDTH) / 2 - BOX_WIDTH / 2,
		left_h:  _left_h,
		right_h: _right_h,
		left_y:  _left_y,
		right_y: _right_y,
	};
	global.hud_layout_w = GAME_WIDTH;
	global.hud_layout_h = GAME_HEIGHT;
	return global.hud_layout_cache;
}

function scr_ui_draw() {
	// --- Title / Score / Level, centered in the headroom above the grid ---
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);

	draw_set_font(fnt_hud_boxtext_bungee_big);
	scr_ui_draw_text(GAME_WIDTH / 2, UI_TITLE_Y, STR_TITLE, c_white);

	draw_set_font(fnt_hud_boxtitle_bungee_med);
	scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y, STR_SCORE, COLOR_BOX_FILL);
	var _score_label_h = string_height(STR_SCORE);

	draw_set_font(fnt_hud_boxtext_bungee_big);
	scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y + _score_label_h, string(global.game_score), c_white);
	var _score_value_h = string_height(string(global.game_score));

	var _level_y = UI_SCORE_Y + _score_label_h + _score_value_h * UI_SCORE_LINE_H_FACTOR;
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	scr_ui_draw_text(GAME_WIDTH / 2, _level_y, STR_LEVEL, COLOR_BOX_FILL);
	var _level_label_h = string_height(STR_LEVEL);

	draw_set_font(fnt_hud_boxtext_bungee_big);
	scr_ui_draw_text(GAME_WIDTH / 2, _level_y + _level_label_h, string(global.level), c_white);

	// --- Hold / Next, in the gap under the grid ---
	if (global.hold_swap_enabled) {
		scr_ui_draw_pair_box(BOX_HOLD_X, BOX_Y, global.hold_val1, global.hold_val2, STR_HOLD);
	}
	if (global.show_queue) {
		scr_ui_draw_pair_box(BOX_NEXT_X, BOX_Y, global.next_val1, global.next_val2, STR_NEXT);
	}

	// --- Touch buttons (pause / help) ---
	draw_set_font(fnt_hud_boxtitle_bungee_med);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	draw_set_color(c_gray);
	draw_rectangle(UI_BTN_PAUSE_X, UI_BTN_PAUSE_Y, UI_BTN_PAUSE_X + UI_BTN_SIZE - 1, UI_BTN_PAUSE_Y + UI_BTN_SIZE - 1, false);
	draw_set_color(c_white);
	draw_text(UI_BTN_PAUSE_X + UI_BTN_SIZE / 2, UI_BTN_PAUSE_Y + UI_BTN_SIZE / 2, STR_PAUSE);

	draw_set_color(c_gray);
	draw_rectangle(UI_BTN_HELP_X, UI_BTN_HELP_Y, UI_BTN_HELP_X + UI_BTN_SIZE - 1, UI_BTN_HELP_Y + UI_BTN_SIZE - 1, false);
	draw_set_color(c_white);
	draw_text(UI_BTN_HELP_X + UI_BTN_SIZE / 2, UI_BTN_HELP_Y + UI_BTN_SIZE / 2, global.help_active ? STR_HELP_CLOSE : STR_HELP);

	// Paused
	if (global.help_active) {
		var _help = scr_help_menu_layout();

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_valign(fa_top);

		draw_set_font(fnt_help_title_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.title_y, STR_HELP_TITLE, c_white);

		draw_set_font(fnt_help_text_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.rules1_y, STR_HELP_RULES_1, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.rules2_y, STR_HELP_RULES_2, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.rules3_y, STR_HELP_RULES_3, c_white);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.rules4_y, STR_HELP_RULES_4, COLOR_BOX_FILL);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.rules5_y, STR_HELP_RULES_5, c_white);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.rules6_y, STR_HELP_RULES_6, c_white);

		draw_set_font(fnt_help_title_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _help.controls_title_y, STR_HELP_CONTROLS_TITLE, c_white);

		draw_set_font(fnt_help_text_bungee_med);
		scr_ui_draw_control_row(_help.ctrl1_y, STR_HELP_CTRL_KEY_1, STR_HELP_CTRL_ACTION_1);
		scr_ui_draw_control_row(_help.ctrl2_y, STR_HELP_CTRL_KEY_2, STR_HELP_CTRL_ACTION_2);
		scr_ui_draw_control_row(_help.ctrl3_y, STR_HELP_CTRL_KEY_3, STR_HELP_CTRL_ACTION_3);
		scr_ui_draw_control_row(_help.ctrl4_y, STR_HELP_CTRL_KEY_4, STR_HELP_CTRL_ACTION_4);

		// Back — always highlighted, it's the only option on this screen
		scr_ui_draw_text(GAME_WIDTH / 2, _help.back_y, STR_HELP_BACK, COLOR_BOX_FILL);
	} else if (global.paused) {
		var _pause = scr_pause_menu_layout();
		var _items = _pause.items;

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		draw_set_font(fnt_pause_title_bungee_med);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _pause.top, STR_PAUSED, c_white);

		draw_set_font(fnt_pause_buttons_bungee_med);
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _item = _items[_i];
			var _y = _pause.item_y[_i];
			var _text = scr_pause_item_text(_item);
			var _highlighted = (global.pause_highlight && _i == global.pause_cursor);

			if (_i == global.pause_selected_index) {
				scr_ui_draw_text(GAME_WIDTH / 2, _y, _text, c_black);
			} else if (scr_menu_item_is_toggle(_item) && !_highlighted) {
				// Brackets always dark gray, the X always red (simply absent when off), the label
				// the same pale gray as every other row — the on/off state only decides whether
				// the X is there at all, never a color. Drawn as separate segments laid out from
				// the centered whole, which is why each piece is its own string macro.
				var _state = _item.checked ? STR_TOGGLE_ON : STR_TOGGLE_OFF;
				var _state_col = _item.checked ? c_red : c_dkgray;

				var _cx = GAME_WIDTH / 2 - string_width(_text) / 2;
				draw_set_halign(fa_left);
				scr_ui_draw_text(_cx, _y, STR_TOGGLE_OPEN, c_dkgray);
				_cx += string_width(STR_TOGGLE_OPEN);
				scr_ui_draw_text(_cx, _y, _state, _state_col);
				_cx += string_width(_state);
				scr_ui_draw_text(_cx, _y, STR_TOGGLE_CLOSE, c_dkgray);
				_cx += string_width(STR_TOGGLE_CLOSE);
				scr_ui_draw_text(_cx, _y, _item.label, c_silver);
				draw_set_halign(fa_center);
			} else {
				var _col = _highlighted ? COLOR_BOX_FILL : c_silver;
				scr_ui_draw_text(GAME_WIDTH / 2, _y, _text, _col);
			}
		}
	}

	// Game over
	if (global.game_over) {
		var _over = scr_game_over_menu_layout();
		var _items = _over.items;

		draw_set_alpha(MENU_OVERLAY_ALPHA);
		draw_set_color(COLOR_BG);
		draw_rectangle(0, 0, GAME_WIDTH, GAME_HEIGHT, false);
		draw_set_alpha(1.0);
		draw_set_halign(fa_center);

		// Title
		draw_set_font(fnt_gameover_title_bungee_med);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, _over.top, STR_GAME_OVER, c_red);

		// Scores
		var _sy = _over.top + _over.title_h + _over.title_gap;

		if (global.high_score_beaten) {
			var _pulse = 0.5 + 0.5 * sin(global.game_over_blink_timer * pi * GAME_OVER_PULSE_SPEED);
			draw_set_font(fnt_gameover_text_bungee_med);
			draw_set_alpha(_pulse);
			scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_NEW_BEST, c_yellow);
			draw_set_alpha(1.0);
			_sy += _over.score_line_h;
		}

		draw_set_font(fnt_gameover_scorestitle_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_CURRENT_SCORE, c_yellow);
		_sy += _over.value_gap;
		draw_set_font(fnt_gameover_scores_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.game_score), c_white);
		_sy += _over.score_line_h;
		draw_set_font(fnt_gameover_scorestitle_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, STR_HIGH_SCORE, c_yellow);
		_sy += _over.value_gap;
		draw_set_font(fnt_gameover_scores_bungee_med);
		scr_ui_draw_text(GAME_WIDTH / 2, _sy, string(global.high_score), c_white);

		// Menu
		draw_set_font(fnt_gameover_buttons_bungee_med);
		for (var _i = 0; _i < array_length(_items); _i++) {
			var _col;
			if (_i == global.game_over_selected_index) {
				_col = c_black;
			} else if (global.game_over_highlight && _i == global.game_over_cursor) {
				_col = COLOR_BOX_FILL;
			} else {
				_col = c_silver;
			}
			scr_ui_draw_text(GAME_WIDTH / 2, _over.menu_top + _i * _over.line_h, _items[_i].label, _col);
		}
	}

	// Reset draw state
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}