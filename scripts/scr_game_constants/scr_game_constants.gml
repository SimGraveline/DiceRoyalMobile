// --- Enums ---
// Typed states instead of bare strings: a typo in an enum member is a compile error, where a typo
// in a string is a state that silently never matches.

// Junk Drop lifecycle: idle -> telegraphed in the dead zone -> actually falling -> idle again.
enum JUNK_STATE { NONE, TELEGRAPH, FALLING }

// What confirming a pause menu row does. The row list itself lives in scr_pause_menu_items.
enum PAUSE_ACTION { RESUME, RESTART, HELP, MUTE_MUSIC, MUTE_SFX, SHOW_GRID, SHOW_QUEUE, HOLD_SWAP, GHOST, QUIT }

// Same idea for the Game Over menu — see scr_game_over_menu_items.
enum GAME_OVER_ACTION { RESTART, QUIT }

// How a pair reached the stack. Only drives the weight of the landing impact (see scr_grid_shake_impact) —
// nothing about the actual placement changes.
enum DROP_TYPE { NORMAL, SOFT, HARD }

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

// --- Grid ---
#macro CELL_SIZE   floor((GAME_HEIGHT * GRID_HEIGHT_RATIO) / (GRID_ROWS + 1))
#macro GRID_COLS   7
#macro GRID_ROWS   7
#macro GRID_WIDTH  (GRID_COLS * CELL_SIZE)
#macro GRID_HEIGHT ((GRID_ROWS + 1) * CELL_SIZE)

// --- Grid position (centered horizontally) ---
#macro GRID_X      ((GAME_WIDTH - GRID_WIDTH) / 2)
#macro GRID_Y      ((GAME_HEIGHT - GRID_HEIGHT) / 2)
// Where grid CONTENT actually gets drawn: the resting position plus the current shake offset.
// Anything that belongs to the grid — its frame, the stacked dice, the falling pair, the ghost —
// draws from these. Anything anchored to the grid but not part of it (HUD columns, the pause and
// game over panels) keeps using the static GRID_X/GRID_Y above so it never shakes along.
#macro GRID_DRAW_X  (GRID_X + global.grid_shake_x)
#macro GRID_DRAW_Y  (GRID_Y + global.grid_shake_y)

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
// Lowest value that forms a matchable color group. 1 sits below it because it's wild: it dies by
// its own rule (any chain-dying neighbor clears every 1 on the board), never by grouping, and it
// has no color of its own to drive the background tint with.
#macro MATCH_MIN_VALUE  2
// Shortest run of consecutive values that counts as a suite. Doubles as the gate: if the highest
// unlocked value is below this, no suite can exist at all (see scr_grid_check_suite).
#macro SUITE_MIN_LENGTH  6

// --- Spawn restrictions ---
#macro PAIR_MIN_VALUE   1
#macro PAIR_MAX_VALUE   9
#macro SPAWN_RETRY_MAX  20
// A pair of identical dice at or below this value gets rerolled at spawn — a pair of 2's is
// already a finished match the moment it lands, and 1's are wild.
#macro PAIR_NO_DOUBLE_MAX_VALUE  2
// How many columns a pair occupies while horizontal — used to clamp the master column so the
// slave still has a column to sit in.
#macro PAIR_WIDTH  2

// --- Special die values ---
#macro DIE_BOMB      10
#macro DIE_MIMIC     11
#macro DIE_RANDOM    12
#macro DIE_BRICK     13
#macro DIE_CLEAR_R   14
#macro DIE_CLEAR_C   15

// --- Dice unlock levels ---
// Dice 7-8-9 are fully wired but kept dormant — see DICE_HIGH_VALUES_ENABLED below.
#macro DICE_RANDOM_UNLOCK_LEVEL   1
#macro DICE_CLEAR_R_UNLOCK_LEVEL  2
#macro DICE_CLEAR_C_UNLOCK_LEVEL  2
#macro DICE_BOMB_UNLOCK_LEVEL     3
#macro DICE_JUNK_UNLOCK_LEVEL     4
#macro DICE_BRICK_UNLOCK_LEVEL    5
#macro DICE_MIMIC_UNLOCK_LEVEL    6
#macro DICE_7_UNLOCK_LEVEL        7
#macro DICE_8_UNLOCK_LEVEL        8
#macro DICE_9_UNLOCK_LEVEL        9

// Intentional fallback switch — dice 7-8-9 are fully implemented (unlock levels,
// colors, scoring, suites) but deliberately never activated. Flip to re-enable;
// do not remove the surrounding logic as "dead code" without checking this flag.
#macro DICE_HIGH_VALUES_ENABLED  false

// --- Special dice spawn chances (1 in N) --- constant for life once unlocked, no endless-tier change
#macro DICE_MIMIC_CHANCE     33
#macro DICE_BOMB_CHANCE      33
#macro DICE_RANDOM_CHANCE    44
#macro DICE_BRICK_CHANCE     33
#macro DICE_CLEAR_R_CHANCE   33
#macro DICE_CLEAR_C_CHANCE   33
// How fast a Random die cycles its face, as a fraction of the current drop period — 0.5 means it
// flips twice for every step the pair falls, so it tracks the level's speed automatically.
#macro DICE_RANDOM_CYCLE_FACTOR  0.5

// --- Junk Drop ---
// Trigger interval is randomized per cycle (see scr_junk_drop_roll_target) instead of a fixed count,
// so the player can't just count pairs to predict the next drop.
#macro JUNK_DROP_SPAWN_INTERVAL_MIN       4
#macro JUNK_DROP_SPAWN_INTERVAL_MAX       6
#macro JUNK_DROP_MAX_QTY              GRID_COLS
#macro JUNK_PREVIEW_ALPHA             0.5
#macro JUNK_DROP_SPEED                0.1
#macro JUNK_DROP_STEP                 1

// --- Dice colors --- The one palette per die value, served by scr_die_color: used by both the
// DXR background tint during a chain and the ghost trail/preview. GML literals are $BBGGRR,
// reversed from the CSS #RRGGBB Sim tunes these against.
#macro COLOR_DIE_2      $00FFFF
#macro COLOR_DIE_3      $0000FF
#macro COLOR_DIE_4      $00FF00
#macro COLOR_DIE_5      $FF0000
#macro COLOR_DIE_6      $000000
#macro COLOR_DIE_7      $00A5FF
#macro COLOR_DIE_8      $90536F
#macro COLOR_DIE_9      $6B25E3

// --- Audio ---
#macro MUSIC_VOLUME              0.4
#macro SPLASH_MUSIC_FADE_MS      700

// --- Special dice sheet (spr_dice_specials) ---
#macro DICE_SPECIALS_SUB_CLEAR_R  1
#macro DICE_SPECIALS_SUB_CLEAR_C  2
#macro DICE_SPECIALS_SUB_BOMB     3
#macro DICE_SPECIALS_SUB_BRICK    4
#macro DICE_SPECIALS_SUB_MIMIC    5
// HUD-only icons (Unlocks Tracker) — never used for the actual in-game die, only to represent it
// in the box: Random's live cycling animation is distracting there, Junk Drop has no die value of
// its own, and Clear R/Clear C unlock together so they share one combined icon.
#macro DICE_SPECIALS_SUB_RANDOM_ICON  6
#macro DICE_SPECIALS_SUB_JUNK_ICON    7
#macro DICE_SPECIALS_SUB_CLEAR_ICON   8

// --- Score ---
#macro SCORE_STACK       10
// A regular die is worth SCORE_BASE x its face value (1-9). Anything still holding a special
// value when it dies (Bomb, Brick, Clear R/C, an unresolved Mimic) is worth SCORE_SPECIAL flat —
// see scr_die_score_value. Deliberately NOT derived from the DIE_* constants: what a special pays
// out is a design decision, not a side effect of the order they happen to be declared in.
#macro SCORE_BASE        100
#macro SCORE_SPECIAL     1000
// Chain reward, one entry per wave within a single chain (index = waves already resolved, so
// wave 1 = x1, wave 2 = x1.5, wave 3 = x2.25...). A deep chain is the hardest thing to pull off
// in the game, so the reward climbs — and the step between entries grows as it goes (+0.5, +0.75,
// +1.0, +1.25...), which accelerates without the runaway of a straight doubling. Hand-tunable on
// purpose: change any single entry without reshaping the rest of the curve.
// Values live in scr_game_init — a macro can't hold an array literal, same pattern as
// LEVEL_THRESHOLDS. Past the last entry the table holds; see scr_combo_multiplier.
#macro COMBO_MULTIPLIERS  global.__combo_multipliers
// Flat bonus for completing a run of every unlocked value in order (1-2-3-...-N, ascending or
// descending, in a line). Awarded on top of what the dice themselves score when they die — a suite
// is the hardest formation in the game to build on purpose, so it can't just pay like an ordinary
// group of the same size. Which one applies depends on the highest unlocked value (see
// scr_grid_check_suite); with dice 7-9 dormant, SCORE_SUITE_6 is the live one.
#macro SCORE_SUITE_6     6000
#macro SCORE_SUITE_7     7000
#macro SCORE_SUITE_8     8000
#macro SCORE_SUITE_9     10000

// --- Ghost ---
// Trail/preview color for special dice only (regular 1-9 dice keep their own die color instead).
// GML color literals are $BBGGRR (reversed from CSS #RRGGBB) — this is #FF9D00 (orange).
#macro GHOST_COLOR  $009DFF
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

// --- Grid shake (purely visual — the grid's DRAWN position only, never its logic or collision) ---
// Only grid content moves (frame, dice, ghost). The HUD boxes and the pause/help/game over panels
// keep reading the static GRID_X/GRID_Y, so they stay put while the grid shakes underneath them.
#macro GRID_SHAKE_ENABLED  true
// Landing impact: the grid punches DOWN (+Y is down) the instant a die stacks, then eases back to
// rest over the duration. HARD DROPS ONLY — see scr_pair_detach for why a normal or soft landing
// deliberately gets no punch at all.
// Expressed as a fraction of CELL_SIZE, not raw pixels: an early pass used 1-2px, which is ~1% of
// a cell and was invisible in play. A fraction also keeps the punch feeling the same on any
// desktop resolution, since CELL_SIZE derives from screen height. A stack is small feedback, not
// a celebration, so this stays well under a fifth of a cell.
#macro GRID_IMPACT_OFFSET    (CELL_SIZE * 0.12)
#macro GRID_IMPACT_DURATION  0.75
// Chain rumble: the whole grid jitters on both axes for as long as a chain is firing. Retriggered
// by every new chain wave, so a long cascade keeps the grid shaking throughout.
#macro GRID_RUMBLE_AMOUNT    1.5
#macro GRID_RUMBLE_DURATION  1.0

// --- Gamepad rumble ---
// Deliberately mirrors the grid shake: same two triggers, same moments, and the durations are the
// grid's own constants so the motor can never drift out of sync with what's on screen. Only the
// strengths are separate, because a motor and a pixel offset don't scale the same way.
// The impact ramps down on the same squared curve as the visual punch; the chain rumble holds a
// flat, lower strength for as long as the grid is jittering.
#macro PAD_RUMBLE_ENABLED           true
#macro PAD_RUMBLE_IMPACT_STRENGTH   0.35
#macro PAD_RUMBLE_IMPACT_DURATION   GRID_IMPACT_DURATION
#macro PAD_RUMBLE_CHAIN_STRENGTH    0.20
#macro PAD_RUMBLE_CHAIN_DURATION    GRID_RUMBLE_DURATION

// --- Background combo feel (bg dice tint to the active dying chain's color) ---
#macro BG_COMBO_ENABLED  true
#macro BG_COMBO_ALPHA    1.0  // full opacity while a chain is dying (vs. the default BG_ALPHA)

// --- Colors ---
#macro COLOR_BG           $662300
// #F5A600 (CSS) — GML color literals are $BBGGRR, reversed from CSS #RRGGBB.
#macro COLOR_GOLD         $00A6F5
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
// Faces available on spr_dice_rain — the rain is decorative, so it stays on real 1-6 die faces
// regardless of which values are unlocked in the actual game.
#macro RAIN_DICE_FACES     6
// "Press Any Key" blink: full cycles per second of sin(t * pi * this).
#macro SPLASH_BLINK_SPEED  2

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
// "NEW BEST!" pulse rate, same sin(t * pi * this) form as SPLASH_BLINK_SPEED — faster than the
// splash blink so it reads as excitement rather than an idle prompt.
#macro GAME_OVER_PULSE_SPEED  3

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
#macro BOX_WIDTH       (CELL_SIZE * 3)
// --- HUD side-column boxes (Score/High Score/Level/Chains left, Next/Hold/Unlocks right) ---
#macro UI_BOX_PADDING        (CELL_SIZE * 0.15)
#macro UI_BOX_TITLE_GAP      (CELL_SIZE * 0.08)
#macro UI_HUD_BOX_GAP        (CELL_SIZE * 0.35)
#macro UI_UNLOCKS_TILE_SIZE  (CELL_SIZE * 0.55)
#macro UI_UNLOCKS_TILE_GAP   (CELL_SIZE * 0.12)
#macro UI_UNLOCKS_COLS       4
#macro UI_UNLOCKS_LOCKED_ALPHA  0.35
#macro UI_MENU_LINE_H_FACTOR      1.8
// "-space-" gap between menu groups — smaller than an actual line, shared by Pause/Help/Game Over.
#macro UI_MENU_BLANK_LINE_FACTOR  0.8
#macro MENU_OVERLAY_ALPHA         0.9
#macro UI_SCORE_LINE_H_FACTOR     1.5
// Tighter gap used only between a score label and its own value (Game Over), so the value sits
// closer to its label than to the next label below it.
#macro UI_SCORE_VALUE_GAP_FACTOR  0.9
// Minimum pixel delta before mouse movement counts as "the player is using the mouse" in a menu —
// filters out sensor jitter from a resting hand so it never fights keyboard/gamepad navigation.
#macro MENU_MOUSE_MOVE_THRESHOLD  4