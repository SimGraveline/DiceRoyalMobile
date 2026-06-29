function scr_ui_draw_die(_x, _y, _value) {
	var _scale = CELL_SIZE / sprite_get_width(spr_dice);
	draw_sprite_ext(spr_dice, _value, _x, _y, _scale, _scale, 0, c_white, 1.0);
}

function scr_ui_draw_text(_x, _y, _str, _col) {
	var _s = UI_SHADOW_OFFSET;
	draw_set_color(c_black);
	draw_text(_x - _s, _y + _s, _str);
	draw_set_color(_col);
	draw_text(_x, _y, _str);
}

function scr_ui_draw() {
	draw_set_font(fnt_bungee);

	// Title
	draw_set_font(fnt_bungee_title);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(GAME_WIDTH / 2, UI_TITLE_Y, STR_TITLE, c_white);
	draw_set_font(fnt_bungee);

	// Score
	scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y, STR_SCORE, c_white);
	var _score_col = c_white;
	if (global.score > global.high_score) {
		_score_col = c_yellow;
	}
	scr_ui_draw_text(GAME_WIDTH / 2, UI_SCORE_Y + string_height(STR_SCORE), string(global.score), _score_col);

	// Pause button
	draw_set_font(fnt_bungee_buttons);
	draw_set_color(c_gray);
	draw_rectangle(UI_BTN_PAUSE_X, UI_BTN_PAUSE_Y, UI_BTN_PAUSE_X + UI_BTN_SIZE - 1, UI_BTN_PAUSE_Y + UI_BTN_SIZE - 1, false);
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(UI_BTN_PAUSE_X + UI_BTN_SIZE / 2, UI_BTN_PAUSE_Y + UI_BTN_SIZE / 2, STR_PAUSE);

	// Help button
	draw_set_color(c_gray);
	draw_rectangle(UI_BTN_HELP_X, UI_BTN_HELP_Y, UI_BTN_HELP_X + UI_BTN_SIZE - 1, UI_BTN_HELP_Y + UI_BTN_SIZE - 1, false);
	draw_set_color(c_white);
	draw_text(UI_BTN_HELP_X + UI_BTN_SIZE / 2, UI_BTN_HELP_Y + UI_BTN_SIZE / 2, STR_HELP);
	draw_set_font(fnt_bungee);

	// Hold box
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(BOX_HOLD_X, BOX_Y, BOX_HOLD_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(BOX_HOLD_X - _o, BOX_Y - _o, BOX_HOLD_X + BOX_WIDTH - 1 + _o, BOX_Y + BOX_HEIGHT - 1 + _o, true);
	}

	// Hold dice preview
	if (global.hold_val1 >= 0) {
		var _hold_dx = BOX_HOLD_X + (BOX_WIDTH - CELL_SIZE * 2) / 2;
		var _hold_dy = BOX_Y + (BOX_HEIGHT - CELL_SIZE) / 2;
		scr_ui_draw_die(_hold_dx, _hold_dy, global.hold_val1);
		scr_ui_draw_die(_hold_dx + CELL_SIZE, _hold_dy, global.hold_val2);
	}

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(BOX_HOLD_X + BOX_WIDTH / 2, BOX_Y + BOX_HEIGHT + BOX_LABEL_OFFSET, STR_HOLD, c_white);

	// Next box
	draw_set_color(COLOR_BOX_FILL);
	draw_roundrect(BOX_NEXT_X, BOX_Y, BOX_NEXT_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, false);
	draw_set_color(COLOR_BOX_OUTLINE);
	for (var _o = 0; _o < BOX_OUTLINE_WIDTH; _o++) {
		draw_roundrect(BOX_NEXT_X - _o, BOX_Y - _o, BOX_NEXT_X + BOX_WIDTH - 1 + _o, BOX_Y + BOX_HEIGHT - 1 + _o, true);
	}

	// Next dice preview
	var _next_dx = BOX_NEXT_X + (BOX_WIDTH - CELL_SIZE * 2) / 2;
	var _next_dy = BOX_Y + (BOX_HEIGHT - CELL_SIZE) / 2;
	scr_ui_draw_die(_next_dx, _next_dy, global.next_val1);
	scr_ui_draw_die(_next_dx + CELL_SIZE, _next_dy, global.next_val2);

	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	scr_ui_draw_text(BOX_NEXT_X + BOX_WIDTH / 2, BOX_Y + BOX_HEIGHT + BOX_LABEL_OFFSET, STR_NEXT, c_white);

	// Level — centered between hold and next, vertically centered with boxes
	var _level_x = GAME_WIDTH / 2;
	var _level_cy = BOX_Y + BOX_HEIGHT / 2;
	draw_set_halign(fa_center);
	draw_set_valign(fa_bottom);
	scr_ui_draw_text(_level_x, _level_cy, STR_LEVEL, c_white);
	draw_set_valign(fa_top);
	scr_ui_draw_text(_level_x, _level_cy, string(global.level), c_white);

	// Paused
	if (global.paused) {
		draw_set_font(fnt_bungee_title);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		scr_ui_draw_text(GAME_WIDTH / 2, GAME_HEIGHT / 2, STR_PAUSED, c_white);
		draw_set_font(fnt_bungee);
	}

	// Game over
	if (global.game_over) {
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		scr_ui_draw_text(GAME_WIDTH / 2, GAME_OVER_Y, STR_GAME_OVER, c_red);
	}

	// Reset draw state
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}