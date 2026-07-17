// --- Display ---
// GAME_WIDTH/HEIGHT follow the room's own size directly (the fullscreen render target —
// see scr_game_update, which resizes application_surface to this or WINDOW_WIDTH/HEIGHT
// depending on window_get_fullscreen()). Window mode itself (windowed vs fullscreen,
// default at launch) is managed by Sim via GameMaker's project options, not GML.
#macro GAME_WIDTH  room_width
#macro GAME_HEIGHT room_height
// Fixed windowed size — matches the room's 16:9 aspect at a smaller scale.
#macro WINDOW_WIDTH   1600
#macro WINDOW_HEIGHT  900
#macro LOGO_SCALE_REFERENCE_WIDTH  400
#macro GRID_HEIGHT_RATIO  0.75

#macro FONT_TITLE    fnt_bungee_title
#macro FONT_BODY     fnt_bungee

// --- Grid ---
#macro CELL_SIZE   floor((GAME_HEIGHT * GRID_HEIGHT_RATIO) / (GRID_ROWS + 1))
#macro GRID_COLS   7
#macro GRID_ROWS   7
#macro GRID_WIDTH  (GRID_COLS * CELL_SIZE)
#macro GRID_HEIGHT ((GRID_ROWS + 1) * CELL_SIZE)

// --- Grid position (centered horizontally) ---
#macro GRID_X      ((GAME_WIDTH - GRID_WIDTH) / 2)
#macro GRID_Y      ((GAME_HEIGHT - GRID_HEIGHT) / 2)

// --- Dead zone ---
#macro DEAD_ZONE_ROW  GRID_ROWS

// --- Pair spawn ---
#macro SPAWN_COL_LEFT   2
#macro SPAWN_ROW        GRID_ROWS

// --- Level system ---
#macro LEVEL_COUNT  20
#macro LEVEL_THRESHOLDS  global.__level_thresholds
#macro LEVEL_SPEEDS     global.__level_speeds
// Single knob to scale drop speed across every level (and the endless tier) without
// reshaping the per-level curve — 1.0 = values below as-is, <1 faster, >1 slower.
#macro DROP_SPEED_MULTIPLIER  1
// Beyond LEVEL_COUNT, level/threshold become an open-ended progression (see scr_level_update)
#macro LEVEL_ENDLESS_BASE_SCORE  1000000
#macro LEVEL_ENDLESS_SCORE_STEP  100000
#macro LEVEL_ENDLESS_SPEED       (0.01)

// --- Gameplay ---
#macro SOFT_DROP_MULTIPLIER  10.00
#macro DAS_DELAY  0.2
#macro DAS_REPEAT 0.05
#macro LOCK_DELAY  0.5
#macro LOCK_RESETS_MAX  10
#macro DYING_DURATION   1.1
#macro DYING_ALPHA_MIN  0.1

// --- Spawn restrictions ---
#macro PAIR_MIN_VALUE   1
#macro PAIR_MAX_VALUE   9
#macro SPAWN_RETRY_MAX  20

// --- Special die values ---
#macro DIE_BOMB      10
#macro DIE_MIMIC     11
#macro DIE_RANDOM    12
#macro DIE_BRICK     13
#macro DIE_CLEAR_R   14
#macro DIE_CLEAR_C   15

// --- Dice unlock levels ---
// Dice 7-8-9 are fully wired but kept dormant — see DICE_HIGH_VALUES_ENABLED below.
#macro DICE_7_UNLOCK_LEVEL        7
#macro DICE_8_UNLOCK_LEVEL        8
#macro DICE_9_UNLOCK_LEVEL        9
#macro DICE_MIMIC_UNLOCK_LEVEL    5
#macro DICE_BOMB_UNLOCK_LEVEL     3
#macro DICE_RANDOM_UNLOCK_LEVEL   1
#macro DICE_BRICK_UNLOCK_LEVEL    4
#macro DICE_JUNK_UNLOCK_LEVEL     4
#macro DICE_CLEAR_R_UNLOCK_LEVEL  2
#macro DICE_CLEAR_C_UNLOCK_LEVEL  2

// Intentional fallback switch — dice 7-8-9 are fully implemented (unlock levels,
// colors, scoring, suites) but deliberately never activated. Flip to re-enable;
// do not remove the surrounding logic as "dead code" without checking this flag.
#macro DICE_HIGH_VALUES_ENABLED  false

// --- Special dice spawn chances (1 in N) --- constant for life once unlocked, no endless-tier change
#macro DICE_MIMIC_CHANCE     20
#macro DICE_BOMB_CHANCE      20
#macro DICE_RANDOM_CHANCE    20
#macro DICE_BRICK_CHANCE     20
#macro DICE_CLEAR_R_CHANCE   20
#macro DICE_CLEAR_C_CHANCE   20

// --- Junk Drop ---
// Trigger interval is randomized per cycle (see scr_junk_drop_roll_target) instead of a fixed count,
// so the player can't just count pairs to predict the next drop.
#macro JUNK_DROP_SPAWN_INTERVAL_MIN       4
#macro JUNK_DROP_SPAWN_INTERVAL_MAX       6
#macro JUNK_DROP_MAX_QTY              GRID_COLS
#macro JUNK_PREVIEW_ALPHA             0.5
#macro JUNK_DROP_SPEED                0.1
#macro JUNK_DROP_STEP                 1

// --- Dice colors ---
#macro COLOR_DIE_7      $00A5FF
#macro COLOR_DIE_8      $90536F
#macro COLOR_DIE_9      $6B25E3

// --- Level up VFX ---
#macro LEVEL_PULSE_DURATION     1.0
#macro LEVEL_PULSE_SCALE_BOOST  0.4

// --- Audio ---
#macro MUSIC_VOLUME              0.4
#macro SPLASH_MUSIC_FADE_MS      700

// --- Special dice sheet (spr_dice_specials) ---
#macro DICE_SPECIALS_SUB_CLEAR_R  1
#macro DICE_SPECIALS_SUB_CLEAR_C  2
#macro DICE_SPECIALS_SUB_BOMB     3
#macro DICE_SPECIALS_SUB_BRICK    4
#macro DICE_SPECIALS_SUB_MIMIC    5

// --- Score ---
#macro SCORE_STACK       10
#macro SCORE_BASE        100
#macro COMBO_MULTIPLIER  0.10
#macro SCORE_SUITE_7     7000
#macro SCORE_SUITE_8     8000
#macro SCORE_SUITE_9     10000

// --- Ghost ---
#macro GHOST_TRAIL_ALPHA  0.08
#macro GHOST_PREVIEW_ALPHA  0.2
// Fixed corner radius for the trail — draw_roundrect_ext keeps this constant regardless of the
// trail's aspect ratio, unlike plain draw_roundrect whose auto radius makes short/near-square
// trails (small drop distance) look almost circular.
#macro GHOST_TRAIL_CORNER_RADIUS  20

// --- Squash & Stretch (purely visual, no effect on grid/collision) ---
#macro SQUASH_STRETCH_ENABLED  true
#macro STRETCH_SCALE_X  0.5   // narrower while airborne (soft/hard drop, Junk Drop fall)
#macro STRETCH_SCALE_Y  1.25  // taller while airborne
#macro SQUASH_SCALE_X   1.25  // wider at the instant of landing
#macro SQUASH_SCALE_Y   0.5   // shorter at the instant of landing
#macro SQUASH_DURATION  0.12  // seconds to ease back to normal after landing

// --- Background combo feel (bg dice tint to the active dying chain's color) ---
#macro BG_COMBO_ENABLED  true
#macro BG_COMBO_ALPHA    1.0  // full opacity while a chain is dying (vs. the default BG_ALPHA)

// --- Colors ---
#macro COLOR_BG           $662300
#macro COLOR_GRID_BG      $CF8964
#macro COLOR_GRID_OUTLINE $04BFEF
#macro COLOR_BOX_FILL     $8FE6FD
#macro COLOR_BOX_OUTLINE  $CF8964

// --- Background ---
#macro BG_SPEED           0.5
#macro BG_SCALE           0.6
#macro BG_SPACING_X       90
#macro BG_SPACING_Y       100
#macro BG_ALPHA           0.25
#macro BG_CHANGE_RATE     3
#macro BG_SHAKE_ODDS      100
#macro BG_SHAKE_THRESHOLD 95
#macro BG_SHAKE_MIN       0.95
#macro BG_SHAKE_MAX       1.05
#macro BG_SHAKE_RESET_RATE 1

// --- Splash dice rain ---
#macro RAIN_SPAWN_RATE     0.05
#macro RAIN_MAX_DICE       50
#macro RAIN_ALPHA_MIN      0.33
#macro RAIN_ALPHA_MAX      0.66
#macro RAIN_FADE_RATE      0.005
#macro RAIN_SPEED_MIN      1
#macro RAIN_SPEED_MAX      5
#macro RAIN_SCALE           1.5
#macro RAIN_SHAKE_ODDS     100
#macro RAIN_SHAKE_CHANCE   20
#macro RAIN_SHAKE_MIN      0.90
#macro RAIN_SHAKE_MAX      1.10
#macro RAIN_DESTROY_BUFFER 100

// --- Splash credits ---
#macro CREDITS_MARGIN_BOTTOM  20
#macro BETA_VERSION_MARGIN_TOP  20

// --- Fade transition ---
#macro FADE_SCALE_RATE   0.06
#macro FADE_ALPHA_RATE   0.08
#macro FADE_SCALE_START  3.0
#macro FADE_SCALE_MID    0.5
#macro FADE_SCALE_END    4.0

// --- Logos ---
#macro LOGO_DURATION_1   2.0
#macro LOGO_DURATION_2   2.0
#macro LOGO_TEXT_OFFSET   20
#macro LOGO_COUNT         2
#macro LOGO_SCALE_GM      0.7
#macro LOGO_SCALE_GG      0.5

// --- Game over ---
#macro GAME_OVER_TAP_DELAY  1.0

// --- Countdown ---
#macro COUNTDOWN_STEPS      3
#macro COUNTDOWN_STEP_DUR   0.5
#macro COUNTDOWN_SCALE_MIN  0.1
#macro COUNTDOWN_SCALE_MAX  1.0

// --- Gamepad ---
#macro GAMEPAD_INDEX     0
#macro GAMEPAD_DEADZONE  0.5

// --- Drawing ---
#macro DELTA_TO_SECONDS  1000000
#macro UI_SHADOW_OFFSET    5
#macro GRID_OUTLINE_WIDTH  6
#macro DEAD_ZONE_LINE_WIDTH  2
#macro BOX_OUTLINE_WIDTH   4

// --- UI ---
// Margin between screen-edge UI (Score/Level) and the window edge
#macro UI_SCREEN_MARGIN   (CELL_SIZE * 0.5)
#macro BOX_WIDTH       (CELL_SIZE * 3)
#macro BOX_HEIGHT      (CELL_SIZE * 1.5)
#macro BOX_LABEL_OFFSET  8
#macro UI_MENU_LINE_H_FACTOR      1.8
#macro MENU_OVERLAY_ALPHA         0.9
#macro UI_SCORE_LINE_H_FACTOR     1.5
#macro UI_GAME_OVER_GAP_FACTOR    0.3