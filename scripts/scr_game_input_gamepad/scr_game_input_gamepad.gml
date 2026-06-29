function scr_game_input_gamepad() {
	var _pad_index = GAMEPAD_INDEX;
	var _stick_deadzone = GAMEPAD_DEADZONE;

	if (!gamepad_is_connected(_pad_index)) return;

	// Movement — held
	var _lx = gamepad_axis_value(_pad_index, gp_axislh);
	var _ly = gamepad_axis_value(_pad_index, gp_axislv);
	if (_lx < -_stick_deadzone || gamepad_button_check(_pad_index, gp_padl)) global.input_left = true;
	if (_lx > _stick_deadzone || gamepad_button_check(_pad_index, gp_padr)) global.input_right = true;
	if (_ly > _stick_deadzone || gamepad_button_check(_pad_index, gp_padd)) global.input_soft_drop = true;

	// Stick up — simulate "pressed" for hard drop
	var _stick_up = (_ly < -_stick_deadzone);
	if (_stick_up && !global.gamepad_stick_up_prev) global.input_hard_drop = true;
	global.gamepad_stick_up_prev = _stick_up;

	// Actions — single press
	if (gamepad_button_check_pressed(_pad_index, gp_padu)) global.input_hard_drop = true;
	if (gamepad_button_check_pressed(_pad_index, gp_face2) || gamepad_button_check_pressed(_pad_index, gp_face4)) global.input_rotate_cw = true;
	if (gamepad_button_check_pressed(_pad_index, gp_face1) || gamepad_button_check_pressed(_pad_index, gp_face3)) global.input_rotate_ccw = true;
	if (gamepad_button_check_pressed(_pad_index, gp_shoulderl) || gamepad_button_check_pressed(_pad_index, gp_shoulderr)) global.input_hold = true;
	if (gamepad_button_check_pressed(_pad_index, gp_start)) { global.input_pause = true; global.input_confirm = true; }
	if (gamepad_button_check_pressed(_pad_index, gp_select)) global.input_help = true;

	// RT + LT = Restart
	if (gamepad_button_check(_pad_index, gp_shoulderrb) && gamepad_button_check_pressed(_pad_index, gp_shoulderlb)) global.input_restart = true;
	if (gamepad_button_check(_pad_index, gp_shoulderlb) && gamepad_button_check_pressed(_pad_index, gp_shoulderrb)) global.input_restart = true;

	// Select + Start = Quit
	if (gamepad_button_check(_pad_index, gp_select) && gamepad_button_check_pressed(_pad_index, gp_start)) {
		global.input_pause = false;
		global.input_exit = true;
	}
}