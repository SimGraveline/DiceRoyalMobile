function scr_save_load() {
	ini_open(STR_INI_FILENAME);
	global.high_score = ini_read_real(STR_INI_SECTION, STR_INI_KEY_SCORE, 0);
	global.high_score_name = ini_read_string(STR_INI_SECTION, STR_INI_KEY_NAME, "");
	ini_close();
}

function scr_save_write() {
	ini_open(STR_INI_FILENAME);
	ini_write_real(STR_INI_SECTION, STR_INI_KEY_SCORE, global.high_score);
	ini_write_string(STR_INI_SECTION, STR_INI_KEY_NAME, global.high_score_name);
	ini_close();
}
