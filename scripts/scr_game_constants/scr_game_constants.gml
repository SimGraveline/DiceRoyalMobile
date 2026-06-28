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

// --- Gameplay ---
#macro DROP_SPEED_INITIAL  0.75
#macro SOFT_DROP_MULTIPLIER  10.00
#macro DAS_DELAY  0.2
#macro DAS_REPEAT 0.05
#macro LOCK_DELAY  0.5
#macro LOCK_RESETS_MAX  10
#macro DYING_DURATION  1.0

// --- Spawn restrictions ---
#macro PAIR_MIN_VALUE  1
#macro PAIR_MAX_VALUE  6

// --- Score ---
#macro SCORE_STACK     10
#macro SCORE_BASE      100
#macro COMBO_MULTIPLIER  1.5

// --- Touch ---
#macro SWIPE_MIN_DISTANCE  30
#macro DRAG_THRESHOLD  10
#macro DRAG_SENSITIVITY  (CELL_SIZE * 1.5)
#macro TAP_ZONE_SPLIT  0.75
#macro ROTATE_SPLIT  0.5
#macro RESTART_ZONE  0.1

// --- Ghost ---
#macro GHOST_TRAIL_ALPHA  0.2
#macro GHOST_PREVIEW_ALPHA  0.4

// --- Drawing ---
#macro DIE_PADDING  2
#macro DELTA_TO_SECONDS  1000000
#macro GAME_OVER_Y  16

// --- UI ---
#macro UI_TITLE_Y      (UI_BTN_MARGIN + UI_BTN_SIZE + UI_BTN_MARGIN)
#macro UI_SCORE_Y      (UI_TITLE_Y + UI_BTN_SIZE)
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