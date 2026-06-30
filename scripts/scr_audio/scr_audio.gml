function scr_audio(){

}

function scr_audio_init() {
	global.music_muted = true;
	global.sfx_muted = false;
	global.splash_music_id = -1;
	global.music_id = -1;
}

function scr_audio_start_game_music() {
	global.music_id = audio_play_sound(snd_theme_instrumental, 1, true);
	audio_sound_gain(global.music_id, MUSIC_VOLUME, 0);
	if (global.music_muted) audio_pause_sound(global.music_id);
}

function scr_audio_toggle_music() {
	global.music_muted = !global.music_muted;
	if (global.music_muted) {
		if (global.music_id != -1 && audio_exists(global.music_id)) audio_pause_sound(global.music_id);
		if (global.splash_music_id != -1 && audio_exists(global.splash_music_id)) audio_pause_sound(global.splash_music_id);
	} else {
		if (global.music_id != -1 && audio_exists(global.music_id)) audio_resume_sound(global.music_id);
		if (global.splash_music_id != -1 && audio_exists(global.splash_music_id)) audio_resume_sound(global.splash_music_id);
	}
}

function scr_audio_toggle_sfx() {
	global.sfx_muted = !global.sfx_muted;
}

function scr_audio_play_sfx(_snd) {
	if (global.sfx_muted) return;
	audio_play_sound(_snd, 0, false);
}
