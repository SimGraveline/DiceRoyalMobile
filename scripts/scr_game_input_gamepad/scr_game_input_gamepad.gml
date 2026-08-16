// --- Gamepad rumble ---------------------------------------------------------------------------
// The haptic twin of the grid shake (scr_grid_draw): same two triggers, fired from the same lines,
// running on the same durations. Two independent timers layered exactly like the visual ones —
// a short decaying punch on a hard-drop landing, a flat sustained buzz while a chain is going off.
// The motor takes whichever is currently stronger, so a landing during a chain still reads.

function scr_pad_rumble_init() {
	global.pad_impact_timer = 0;
	global.pad_impact_strength = 0;
	global.pad_chain_timer = 0;
	global.pad_rumble_current = -1; // forces the first apply through, whatever the motor is doing
	scr_pad_rumble_apply(0);
}

// _scale is the same factor the visual punch gets (scr_pair_detach passes one value to both), so a
// soft-drop landing buzzes exactly as much lighter as it looks.
function scr_pad_rumble_impact(_scale) {
	if (!PAD_RUMBLE_ENABLED) return;
	global.pad_impact_timer = PAD_RUMBLE_IMPACT_DURATION;
	global.pad_impact_strength = PAD_RUMBLE_IMPACT_STRENGTH * _scale;
}

function scr_pad_rumble_chain() {
	if (!PAD_RUMBLE_ENABLED) return;
	global.pad_chain_timer = PAD_RUMBLE_CHAIN_DURATION;
}

// Pushes a strength to the motors, skipping the call when nothing changed so the driver isn't fed
// an identical value 60 times a second while idle.
function scr_pad_rumble_apply(_strength) {
	if (_strength == global.pad_rumble_current) return;
	global.pad_rumble_current = _strength;
	if (gamepad_is_connected(GAMEPAD_INDEX)) {
		gamepad_set_vibration(GAMEPAD_INDEX, _strength, _strength);
	}
}

// Called from the TOP of scr_game_update, before any state-specific early return. Unlike a visual
// effect, a motor left spinning is not "frozen" — it keeps buzzing in the player's hands. So this
// has to keep running no matter which screen the game jumps to, and pausing or losing kills it
// outright instead of freezing it mid-buzz.
function scr_pad_rumble_update() {
	var _strength = 0;

	if (global.paused || global.game_over) {
		global.pad_impact_timer = 0;
		global.pad_chain_timer = 0;
	} else {
		var _dt = delta_time / DELTA_TO_SECONDS;

		// Same squared ease-out as the visual punch — hits hard, settles quickly.
		if (global.pad_impact_timer > 0) {
			global.pad_impact_timer -= _dt;
			if (global.pad_impact_timer < 0) global.pad_impact_timer = 0;
			if (PAD_RUMBLE_IMPACT_DURATION > 0) {
				var _t = global.pad_impact_timer / PAD_RUMBLE_IMPACT_DURATION;
				_strength = max(_strength, global.pad_impact_strength * _t * _t);
			}
		}

		// Flat for the whole duration, matching the grid's constant-amplitude jitter.
		if (global.pad_chain_timer > 0) {
			global.pad_chain_timer -= _dt;
			if (global.pad_chain_timer < 0) global.pad_chain_timer = 0;
			_strength = max(_strength, PAD_RUMBLE_CHAIN_STRENGTH);
		}
	}

	scr_pad_rumble_apply(_strength);
}

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
	if (gamepad_button_check_pressed(_pad_index, gp_start)) global.input_pause = true;
	if (gamepad_button_check_pressed(_pad_index, gp_select)) global.input_grid_lines = true;

	// RT + LT = Restart
	if (gamepad_button_check(_pad_index, gp_shoulderrb) && gamepad_button_check_pressed(_pad_index, gp_shoulderlb)) global.input_restart = true;
	if (gamepad_button_check(_pad_index, gp_shoulderlb) && gamepad_button_check_pressed(_pad_index, gp_shoulderrb)) global.input_restart = true;

	// Select + Start = Quit
	if (gamepad_button_check(_pad_index, gp_select) && gamepad_button_check_pressed(_pad_index, gp_start)) {
		global.input_pause = false;
		global.input_exit = true;
	}
}