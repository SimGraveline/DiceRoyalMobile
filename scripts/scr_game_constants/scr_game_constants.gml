// --- Display ---
#macro GAME_WIDTH  384
#macro GAME_HEIGHT 832

// --- Grid ---
#macro CELL_SIZE   40
#macro GRID_COLS   8
#macro GRID_ROWS   12
#macro GRID_WIDTH  (GRID_COLS * CELL_SIZE)
#macro GRID_HEIGHT ((GRID_ROWS + 1) * CELL_SIZE)

// --- Grid position (centered horizontally) ---
#macro GRID_X      ((GAME_WIDTH - GRID_WIDTH) / 2)
#macro GRID_Y      ((GAME_HEIGHT - GRID_HEIGHT) / 2)

// --- Dead zone ---
#macro DEAD_ZONE_ROW  12

// --- Pair spawn ---
#macro SPAWN_COL_LEFT   3
#macro SPAWN_COL_RIGHT  4
#macro SPAWN_ROW        12

// --- Level system ---
#macro LEVEL_COUNT  20
#macro LEVEL_THRESHOLDS  global.__level_thresholds
#macro LEVEL_SPEEDS     global.__level_speeds
// Beyond LEVEL_COUNT, level/threshold become an open-ended progression (see scr_level_update)
#macro LEVEL_ENDLESS_BASE_SCORE  1000000
#macro LEVEL_ENDLESS_SCORE_STEP  250000
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
#macro DIE_BOMB    10
#macro DIE_MIMIC   11
#macro DIE_RANDOM  12
#macro DIE_BRICK   13

// --- Dice unlock levels ---
// Dice 7-8-9 are fully wired but kept dormant — see DICE_HIGH_VALUES_ENABLED below.
#macro DICE_7_UNLOCK_LEVEL        7
#macro DICE_8_UNLOCK_LEVEL        8
#macro DICE_9_UNLOCK_LEVEL        9
#macro DICE_MIMIC_UNLOCK_LEVEL    3
#macro DICE_BOMB_UNLOCK_LEVEL     4
#macro DICE_RANDOM_UNLOCK_LEVEL   2
#macro DICE_BRICK_UNLOCK_LEVEL    5
#macro DICE_JUNK_UNLOCK_LEVEL     3

// Intentional fallback switch — dice 7-8-9 are fully implemented (unlock levels,
// colors, scoring, suites) but deliberately never activated. Flip to re-enable;
// do not remove the surrounding logic as "dead code" without checking this flag.
#macro DICE_HIGH_VALUES_ENABLED  false

// --- Special dice spawn chances (1 in N) ---
#macro DICE_MIMIC_CHANCE   15
#macro DICE_BOMB_CHANCE    15
#macro DICE_RANDOM_CHANCE  15
#macro DICE_BRICK_CHANCE   15
// From LEVEL_ENDLESS_TIER_LEVEL on, Mimic/Bomb/Brick odds tighten to 1/N (Random unaffected)
#macro DICE_ENDLESS_CHANCE  10

// --- Junk Drop ---
#macro JUNK_DROP_SPAWN_INTERVAL       5
#macro JUNK_DROP_SPAWN_INTERVAL_LATE  10 // used from LEVEL_ENDLESS_TIER_LEVEL on
#macro JUNK_DROP_MAX_QTY              8
#macro JUNK_PREVIEW_ALPHA             0.5
#macro JUNK_DROP_SPEED                0.1
#macro JUNK_DROP_STEP                 1
#macro JUNK_TRACK_TIMEOUT             2.0

// --- Random cycle speed ---
#macro RANDOM_CYCLE_SPEED_BASE        1.00
#macro RANDOM_CYCLE_SPEED_FAST        0.50
#macro RANDOM_CYCLE_SPEED_FAST_LEVEL  11

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

// --- Score ---
#macro SCORE_STACK       10
#macro SCORE_BASE        100
#macro COMBO_MULTIPLIER  0.10
#macro SCORE_SUITE_6     6000
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
#macro GHOST_TRAIL_ALPHA  0.05
#macro GHOST_PREVIEW_ALPHA  0.1
#macro BRICK_GHOST_SUBIMAGE  1

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
#macro UI_BTN_SIZE     32
#macro UI_BTN_MARGIN   8
#macro UI_BTN_PAUSE_X  UI_BTN_MARGIN
#macro UI_BTN_PAUSE_Y  UI_BTN_MARGIN
#macro UI_BTN_HELP_X   (GAME_WIDTH - UI_BTN_SIZE - UI_BTN_MARGIN)
#macro UI_BTN_HELP_Y   UI_BTN_MARGIN
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