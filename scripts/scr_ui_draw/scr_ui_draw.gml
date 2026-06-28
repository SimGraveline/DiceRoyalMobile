function scr_ui_draw_die(_x, _y, _value) {
	var _colors = [
		c_black,   // 0 = unused
		c_white,   // 1
		c_red,     // 2
		c_blue,    // 3
		c_green,   // 4
		c_yellow,  // 5
		c_purple   // 6
	];

	draw_set_color(_colors[_value]);
	draw_rectangle(_x + DIE_PADDING, _y + DIE_PADDING, _x + CELL_SIZE - DIE_PADDING - 1, _y + CELL_SIZE - DIE_PADDING - 1, false);

	draw_set_color(c_black);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);
	draw_text(_x + CELL_SIZE / 2, _y + CELL_SIZE / 2, string(_value));
}

function scr_ui_draw() {
	draw_set_font(fnt_bungee);

	// Title
	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text(GAME_WIDTH / 2, UI_TITLE_Y, STR_TITLE);

	// Score
	draw_text(GAME_WIDTH / 2, UI_SCORE_Y, STR_SCORE);
	draw_text(GAME_WIDTH / 2, UI_SCORE_Y + string_height(STR_SCORE), string(global.score));

	// Pause button
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

	// Hold box
	draw_set_color(c_dkgray);
	draw_rectangle(BOX_HOLD_X, BOX_Y, BOX_HOLD_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, false);
	draw_set_color(c_gray);
	draw_rectangle(BOX_HOLD_X, BOX_Y, BOX_HOLD_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, true);

	// Hold dice preview
	if (global.hold_val1 >= 0) {
		var _hold_dx = BOX_HOLD_X + (BOX_WIDTH - CELL_SIZE * 2) / 2;
		var _hold_dy = BOX_Y + (BOX_HEIGHT - CELL_SIZE) / 2;
		scr_ui_draw_die(_hold_dx, _hold_dy, global.hold_val1);
		scr_ui_draw_die(_hold_dx + CELL_SIZE, _hold_dy, global.hold_val2);
	}

	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text(BOX_HOLD_X + BOX_WIDTH / 2, BOX_Y + BOX_HEIGHT + BOX_LABEL_OFFSET, STR_HOLD);

	// Next box
	draw_set_color(c_dkgray);
	draw_rectangle(BOX_NEXT_X, BOX_Y, BOX_NEXT_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, false);
	draw_set_color(c_gray);
	draw_rectangle(BOX_NEXT_X, BOX_Y, BOX_NEXT_X + BOX_WIDTH - 1, BOX_Y + BOX_HEIGHT - 1, true);

	// Next dice preview
	var _next_dx = BOX_NEXT_X + (BOX_WIDTH - CELL_SIZE * 2) / 2;
	var _next_dy = BOX_Y + (BOX_HEIGHT - CELL_SIZE) / 2;
	scr_ui_draw_die(_next_dx, _next_dy, global.next_val1);
	scr_ui_draw_die(_next_dx + CELL_SIZE, _next_dy, global.next_val2);

	draw_set_color(c_white);
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text(BOX_NEXT_X + BOX_WIDTH / 2, BOX_Y + BOX_HEIGHT + BOX_LABEL_OFFSET, STR_NEXT);

	// Level — centered between hold and next
	var _level_x = GAME_WIDTH / 2;
	draw_set_halign(fa_center);
	draw_set_valign(fa_top);
	draw_text(_level_x, BOX_Y, STR_LEVEL);
	draw_text(_level_x, BOX_Y + string_height(STR_LEVEL), string(global.level));

	// Paused
	if (global.paused) {
		draw_set_color(c_white);
		draw_set_halign(fa_center);
		draw_set_valign(fa_middle);
		draw_text(GAME_WIDTH / 2, GAME_HEIGHT / 2, STR_PAUSED);
	}

	// Game over
	if (global.game_over) {
		draw_set_color(c_red);
		draw_set_halign(fa_center);
		draw_set_valign(fa_top);
		draw_text(GAME_WIDTH / 2, GAME_OVER_Y, STR_GAME_OVER);
	}

	// Reset draw state
	draw_set_halign(fa_left);
	draw_set_valign(fa_top);
	draw_set_font(-1);
}