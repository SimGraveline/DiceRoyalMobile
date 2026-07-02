function scr_display_mode(){

}

// Sets up the mobile/PC display toggle. Called once from scr_game_init().
function scr_display_mode_init() {
	global.pc_mode = false;
	global.__display_camera = camera_create();

	view_enabled = true;
	view_visible[0] = true;
	view_camera[0] = global.__display_camera;

	scr_display_mode_apply();
}

// Toggled by F11 — checked every step from scr_game_update(), active from the logo screen onward.
function scr_display_mode_update() {
	if (keyboard_check_pressed(vk_f11)) {
		global.pc_mode = !global.pc_mode;
		scr_display_mode_apply();
	}
}

// Resizes GAME_WIDTH/GAME_HEIGHT/CELL_SIZE for the current mode, and keeps all three
// GameMaker-side pieces in sync so world-space coordinates map 1:1 to the screen:
//   - camera view size   (world-space extent the camera captures)
//   - view viewport size (view_wport/hport — the destination rect on the surface)
//   - application_surface / window size (the actual pixel buffer + OS window)
// PC mode: fullscreen at desktop resolution, grid scaled to PC_GRID_HEIGHT_RATIO of the height.
// Mobile mode: windowed at the original fixed size — unchanged from before this feature.
function scr_display_mode_apply() {
	var _w, _h;

	if (global.pc_mode) {
		window_set_fullscreen(true);
		_w = display_get_width();
		_h = display_get_height();
		global.__cell_size = floor((_h * PC_GRID_HEIGHT_RATIO) / (GRID_ROWS + 1));
		global.__ui_btn_size = global.__cell_size * 0.5;
		global.__ui_btn_margin = global.__cell_size * 0.25;
		global.__font_title   = fnt_bungee_title_pc;
		global.__font_body    = fnt_bungee_pc;
		global.__font_buttons = fnt_bungee_buttons_pc;
	} else {
		window_set_fullscreen(false);
		_w = MOBILE_GAME_WIDTH;
		_h = MOBILE_GAME_HEIGHT;
		global.__cell_size = MOBILE_CELL_SIZE;
		global.__ui_btn_size = MOBILE_UI_BTN_SIZE;
		global.__ui_btn_margin = MOBILE_UI_BTN_MARGIN;
		global.__font_title   = fnt_bungee_title;
		global.__font_body    = fnt_bungee;
		global.__font_buttons = fnt_bungee_buttons;
	}

	global.__game_width = _w;
	global.__game_height = _h;

	window_set_size(_w, _h);
	surface_resize(application_surface, _w, _h);

	camera_set_view_size(global.__display_camera, _w, _h);
	camera_set_view_pos(global.__display_camera, 0, 0);

	view_xport[0] = 0;
	view_yport[0] = 0;
	view_wport[0] = _w;
	view_hport[0] = _h;
}
