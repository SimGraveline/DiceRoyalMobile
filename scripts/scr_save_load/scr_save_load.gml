// Called once, at true game launch only (scr_game_init) — never on a soft restart, so in-session
// option changes survive scr_game_restart(). Options are read-only here: toggling one in the
// pause menu never writes back to the ini (see scr_pause_menu_select) — only a fresh game launch
// ever re-reads these defaults.
function scr_save_load() {
	ini_open(STR_INI_FILENAME);
	global.high_score = ini_read_real(STR_INI_SECTION, STR_INI_KEY_SCORE, 0);
	global.high_score_name = ini_read_string(STR_INI_SECTION, STR_INI_KEY_NAME, "");
	global.music_muted = ini_read_real(STR_INI_SECTION, STR_INI_KEY_MUSIC_MUTED, 1) == 1;
	global.sfx_muted = ini_read_real(STR_INI_SECTION, STR_INI_KEY_SFX_MUTED, 0) == 1;
	global.grid_lines = ini_read_real(STR_INI_SECTION, STR_INI_KEY_GRID_LINES, 0) == 1;
	global.show_queue = ini_read_real(STR_INI_SECTION, STR_INI_KEY_SHOW_QUEUE, 1) == 1;
	global.hold_swap_enabled = ini_read_real(STR_INI_SECTION, STR_INI_KEY_HOLD_SWAP, 1) == 1;
	global.ghost_enabled = ini_read_real(STR_INI_SECTION, STR_INI_KEY_GHOST_ENABLED, 1) == 1;
	ini_close();
}

function scr_save_write() {
	ini_open(STR_INI_FILENAME);
	ini_write_real(STR_INI_SECTION, STR_INI_KEY_SCORE, global.high_score);
	ini_write_string(STR_INI_SECTION, STR_INI_KEY_NAME, global.high_score_name);
	ini_close();
}
