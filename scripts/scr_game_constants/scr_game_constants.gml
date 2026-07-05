// --- Display ---
// GAME_WIDTH/HEIGHT/CELL_SIZE are aliases to globals (see scr_display_mode) so the
// PC fullscreen mode can resize them at runtime — mobile mode keeps the values below.
#macro GAME_WIDTH  global.__game_width
#macro GAME_HEIGHT global.__game_height
#macro MOBILE_GAME_WIDTH   384
#macro MOBILE_GAME_HEIGHT  832
#macro MOBILE_CELL_SIZE    50
#macro PC_GRID_HEIGHT_RATIO  0.9
#macro PC_MARGIN  global.__cell_size

// Title/body/button fonts swap to their _pc variant in PC mode (see scr_display_mode)
#macro FONT_TITLE    global.__font_title
#macro FONT_BODY     global.__font_body
#macro FONT_BUTTONS  global.__font_buttons

// --- Grid ---
#macro CELL_SIZE   global.__cell_size
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
#macro SPAWN_COL_RIGHT  3
#macro SPAWN_ROW        GRID_ROWS

// --- Level system ---
#macro LEVEL_COUNT  20
#macro LEVEL_THRESHOLDS  global.__level_thresholds
#macro LEVEL_SPEEDS     global.__level_speeds
// Beyond LEVEL_COUNT, level/threshold become an open-ended progression (see scr_level_update)
#macro LEVEL_ENDLESS_BASE_SCORE  1000000
#macro LEVEL_ENDLESS_SCORE_STEP  100000
#macro LEVEL_ENDLESS_SPEED       0.01
#macro LEVEL_ENDLESS_TIER_LEVEL  21

// --- Gameplay ---
#macro SOFT_DROP_MULTIPLIER  10.00
#macro DAS_DELAY  0.2
#macro DAS_REPEAT 0.05
#macro LOCK_DELAY  0.5
#macro LOCK_RESETS_MAX  10
#macro DYING_DURATION   1.0
#macro DYING_ALPHA_MIN  0.05

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
#macro JUNK_DROP_SPAWN_INTERVAL_LATE_MIN  9  // used from LEVEL_ENDLESS_TIER_LEVEL on
#macro JUNK_DROP_SPAWN_INTERVAL_LATE_MAX  11
#macro JUNK_DROP_MAX_QTY              GRID_COLS
#macro JUNK_PREVIEW_ALPHA             0.5
#macro JUNK_DROP_SPEED                0.1
#macro JUNK_DROP_STEP                 1

// --- Dice colors ---
#macro COLOR_DIE_7      $00A5FF
#macro COLOR_DIE_8      $90536F
#macro COLOR_DIE_9      $6B25E3
#macro COLOR_DIE_BOMB   $606060
#macro COLOR_DIE_MIMIC  $D3D3D3
#macro COLOR_DIE_BRICK  $2222B2

// --- Level up VFX ---
#macro LEVEL_PULSE_DURATION     1.0
#macro LEVEL_PULSE_SCALE_BOOST  0.4

// --- Audio ---
#macro MUSIC_VOLUME              0.4
#macro SPLASH_MUSIC_FADE_MS      700

// --- Animation ---
#macro DIE_BOMB_ANIM_MS          500

// --- Special dice sheet (spr_dice_specials) ---
#macro DICE_SPECIALS_SUB_GHOST    0
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

// --- Touch ---
#macro SWIPE_MIN_DISTANCE  30
#macro DRAG_THRESHOLD  10
#macro DRAG_SENSITIVITY  (CELL_SIZE * 1.5)
#macro TAP_ZONE_SPLIT  0.80
#macro ROTATE_SPLIT  0.5
#macro RESTART_ZONE  0.1

// --- Ghost ---
#macro GHOST_TRAIL_ALPHA  0.075
#macro GHOST_PREVIEW_ALPHA  0.25

// --- Colors ---
#macro COLOR_BG           $662300
#macro COLOR_GRID_BG      $CF8964
#macro COLOR_GRID_OUTLINE $04BFEF
#macro COLOR_BOX_FILL     $8FE6FD
#macro COLOR_BOX_OUTLINE  $CF8964

// --- Background ---
#macro BG_SPEED           0.5
#macro BG_SCALE           0.5
#macro BG_SPACING_X       80
#macro BG_SPACING_Y       90
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
#macro RAIN_SCALE           1.0
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
#macro DIE_PADDING  2
#macro DELTA_TO_SECONDS  1000000
#macro UI_SHADOW_OFFSET    5
#macro GRID_OUTLINE_WIDTH  6
#macro DEAD_ZONE_LINE_WIDTH  2
#macro BOX_OUTLINE_WIDTH   4

// --- UI ---
#macro UI_TITLE_Y      36
#macro UI_SCORE_Y      80
// UI_BTN_SIZE/MARGIN are dynamic (see scr_display_mode) so pause/help stay readable at PC scale
#macro UI_BTN_SIZE     global.__ui_btn_size
#macro UI_BTN_MARGIN   global.__ui_btn_margin
#macro MOBILE_UI_BTN_SIZE    32
#macro MOBILE_UI_BTN_MARGIN  8
// PC mode nudges pause/help a few pixels off their mobile corner anchor — mobile is unaffected.
#macro UI_BTN_PAUSE_OFFSET_X  (global.pc_mode ? -5 : 0)
#macro UI_BTN_PAUSE_OFFSET_Y  (global.pc_mode ? -10 : 0)
#macro UI_BTN_HELP_OFFSET_X   (global.pc_mode ? 5 : 0)
#macro UI_BTN_HELP_OFFSET_Y   (global.pc_mode ? -10 : 0)
#macro UI_BTN_PAUSE_X  (UI_BTN_MARGIN + UI_BTN_PAUSE_OFFSET_X)
#macro UI_BTN_PAUSE_Y  (UI_BTN_MARGIN + UI_BTN_PAUSE_OFFSET_Y)
// PC mode: manual nudge to bring the Next box closer to Hold, and push the QR block down to compensate
#macro PC_NEXT_NUDGE_Y  -(CELL_SIZE * 0.25)
#macro PC_QR_NUDGE_Y     (CELL_SIZE * 0.25)
#macro UI_BTN_HELP_X   (GAME_WIDTH - UI_BTN_SIZE - UI_BTN_MARGIN + UI_BTN_HELP_OFFSET_X)
#macro UI_BTN_HELP_Y   (UI_BTN_MARGIN + UI_BTN_HELP_OFFSET_Y)
#macro BOX_WIDTH       (CELL_SIZE * 3)
#macro BOX_HEIGHT      (CELL_SIZE * 1.5)
#macro BOX_Y           (GRID_Y + GRID_HEIGHT + CELL_SIZE)
#macro BOX_HOLD_X      (GRID_X)
#macro BOX_NEXT_X      (GRID_X + GRID_WIDTH - BOX_WIDTH)
#macro BOX_LABEL_OFFSET  8
#macro UI_MENU_LINE_H_FACTOR      1.8
#macro MENU_OVERLAY_ALPHA         0.9
#macro UI_SCORE_LINE_H_FACTOR     1.5
#macro UI_GAME_OVER_GAP_FACTOR    0.3