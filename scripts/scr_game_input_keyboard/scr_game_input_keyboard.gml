function scr_game_input_keyboard() {
	// Movement — held down for repeat
	global.input_left  = keyboard_check(ord("A")) || keyboard_check(vk_left);
	global.input_right = keyboard_check(ord("D")) || keyboard_check(vk_right);
	global.input_soft_drop = keyboard_check(ord("S")) || keyboard_check(vk_down);

	// Actions — single press
	global.input_hard_drop  = keyboard_check_pressed(ord("W")) || keyboard_check_pressed(vk_up);
	global.input_rotate_cw  = keyboard_check_pressed(vk_space);
	global.input_rotate_ccw = keyboard_check_pressed(vk_control);
	global.input_hold       = keyboard_check_pressed(vk_shift);
	global.input_pause      = keyboard_check_pressed(vk_escape);
	global.input_pause_alt  = keyboard_check_pressed(vk_enter); // Enter also toggles pause, but never force-closes Help — see scr_game_update
	// Help has no key bound on this build — the touch button is its only entry point. Cleared here
	// anyway because this function runs first and is what resets the shared input flags each frame;
	// without it the flag would latch on and toggle Help every step.
	global.input_help       = false;
	global.input_grid_lines = keyboard_check_pressed(vk_tab);
	global.input_mute_music = keyboard_check_pressed(ord("M"));
	global.input_restart    = keyboard_check_pressed(ord("R")); // DEBUG
	global.input_exit       = keyboard_check_pressed(ord("Q")); // DEBUG
	global.input_reset_highscore = keyboard_check_pressed(vk_f5); // DEBUG
}