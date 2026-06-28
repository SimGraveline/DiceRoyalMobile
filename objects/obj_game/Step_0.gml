scr_game_input_keyboard();
scr_game_input_touch();

if (global.input_restart) {
	room_restart();
	exit;
}

if (global.input_exit) {
	game_end();
	exit;
}

if (global.pair_active) {
	scr_pair_update();
} else if (global.solo_active) {
	scr_solo_update();
} else {
	scr_pair_spawn_next();
}