function scr_audio(){

}

function scr_audio_init() {
	// music_muted/sfx_muted are NOT set here — they're session-long options loaded once by
	// scr_save_load() at true game launch and left untouched by restarts (see scr_game_init).
	global.splash_music_id = -1;
	global.music_id = -1;
}

function scr_audio_start_game_music() {
	global.music_id = audio_play_sound(snd_theme_instrumental, 1, true);
	audio_sound_gain(global.music_id, global.music_muted ? 0 : MUSIC_VOLUME, 0);
}

// Mute is a gain change, not a pause — the track keeps playing (and stays in sync) underneath,
// it's just silent. Pausing/resuming would restart perceptibly from wherever it happened to be.
// Splash plays at its natural full gain (never explicitly scaled), the in-game track at MUSIC_VOLUME.
function scr_audio_toggle_music() {
	global.music_muted = !global.music_muted;
	if (global.music_id != -1 && audio_exists(global.music_id)) {
		audio_sound_gain(global.music_id, global.music_muted ? 0 : MUSIC_VOLUME, 0);
	}
	if (global.splash_music_id != -1 && audio_exists(global.splash_music_id)) {
		audio_sound_gain(global.splash_music_id, global.music_muted ? 0 : 1, 0);
	}
}

function scr_audio_toggle_sfx() {
	global.sfx_muted = !global.sfx_muted;
}

function scr_audio_play_sfx(_snd) {
	if (global.sfx_muted) return;
	audio_play_sound(_snd, 0, false);
}
