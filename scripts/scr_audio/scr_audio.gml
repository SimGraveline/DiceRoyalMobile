function scr_audio(){

}

function scr_audio_init() {
	global.music_muted = true;
	global.music_id = audio_play_sound(snd_theme_instrumental, 1, true);
	audio_pause_sound(global.music_id);
}

function scr_audio_toggle_music() {
	global.music_muted = !global.music_muted;
	if (global.music_muted) {
		audio_pause_sound(global.music_id);
	} else {
		audio_resume_sound(global.music_id);
	}
}
