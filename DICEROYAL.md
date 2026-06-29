# DICE ROYAL

Dice Royal is a falling block puzzle game for mobile platforms, inspired by Tetris, Puyo Puyo and Devil Dice. Built in GameMaker Studio, it targets mobile via GX.games while also supporting keyboard and gamepad for browser play. The game is locked to portrait orientation.

This is a proof of concept / prototype with only logo, splash, game, pause, help and game over screens. It is coded clean — no magic numbers, no magic strings — so it can evolve into a releasable product with ads, microtransactions and achievements.

## Project History

Several prior attempts at making this game ended in failure. The two recurring blockers were the pair detach logic and the chain drop behavior. Both have been resolved with the following architectural decisions:

1. **Pair: Hybrid approach.** The pair is a logical entity that handles movement and rotation while active. As soon as one die lands on something (grid floor or stacked die), the pair detaches and each die becomes autonomous for the falling/resolution phase.
2. **Grid: Simulation approach.** A 2D array is the single source of truth. Visual objects only represent the array's state. All logic (matching, clearing, gravity) operates on the array, not on sprite positions.

## Graphics

The game uses 2D vector graphics from prior attempts, added as needed. For ease of visualization, dimensions are discussed in pixels. Draw functions are used for everything during prototyping; proper sprites will be implemented once gameplay is validated.

## Good Practices

Game logic lives in standalone scripts. Objects contain minimal code and delegate to scripts. This document and the mockup (DICEROYAL.jpg) are sources of truth. When design decisions contradict either, the GDD is updated; the mockup is not systematically kept in sync.

## Gameplay

### Rules

Players eliminate dice by chaining identical values orthogonally (up, down, left, right — no diagonals). A chain is valid when the number of connected dice is equal to or greater than the die value: two or more 2's, three or more 3's, four or more 4's, five or more 5's, six or more 6's.

Eliminated dice enter a "dying" state with a visible fade-out animation. Dying propagates: any non-dying die orthogonally adjacent to a dying die of the same value also becomes dying, along with all of its connected same-value dice. This propagation cascades until no more dice can be reached. Each die that enters dying gets its own independent timer.

1's are a special case: they never match on their own. A 1 orthogonally adjacent to any dying die (regardless of value) triggers the elimination of all 1's on the grid.

Dying dice do not fall — they float in place if their support is removed. They remain solid (occupy their cell) until their timer expires. Once a dying die's timer expires, it is removed from the grid and its cell becomes empty. Non-dying dice above empty cells fall instantly (gravity). Gravity can create new chains, triggering further dying cycles (combos).

### Mechanics

**Grid:** 8 cells wide by 12 cells high. A dead zone line sits between the 12th and a 13th cell where pairs spawn. If any die remains above the dead zone when the grid is at rest (no active clearing, falling or chain resolution), the game is over.

**Pair movement:** A pair spawns at the top center of the grid (positions 4,13 and 5,13). The left die is the "master"; the right die rotates around it into four orthogonal positions. Pairs move in fixed one-cell increments and snap to the grid. After stacking, the next pair spawns at the previous pair's X position.

**Lock delay:** When one die of a pair touches something (grid floor or stacked die), a lock timer begins (default: 0.5s, adjustable). During this window, the player can still move and rotate the pair. Each successful action resets the timer, up to a maximum number of resets (default: 10, adjustable). When the timer expires, the pair detaches. Lock delay duration and reset count are potential levers for difficulty scaling.

**Detach:** When the lock delay expires (or a hard drop occurs), the pair detaches. The landed die is written to the grid. The other die snaps instantly to the lowest available position in its column. If either die is adjacent to a dying die of the same value, it joins the dying chain instead of stacking normally. After detach, a new pair spawns immediately — the player does not wait for dying or chain resolution to finish.

**Wall kick:** If rotation is blocked by a wall, the pair shifts one cell to allow it. If the shifted position is also blocked, the rotation is denied. Rotation blocked by a stacked die in the grid is always denied (no kick) to prevent dice from overlapping.

**Soft drop:** Boosts the drop speed while held (default: 10x, adjustable). The player can still move and rotate during a soft drop.

**Hard drop:** Instantly snaps the pair to the first available stacking position. The player cannot control the pair during a hard drop.

**Hold:** The player can store one pair for later (one swap per active pair). The stored pair resets to horizontal orientation. When swapping, the pair from the hold box takes the active pair's current position and orientation. If the hold box was empty, the next queued pair spawns normally.

**Next:** The screen displays the next pair to spawn.

**Ghost:** A semi-transparent preview shows where the pair would land if hard-dropped. Can be toggled on/off from the pause screen.

### Score

Player scores points by:
- Stacking a die: 10 points per die when it is written to the grid
- Eliminating dice: 100 points per die, multiplied by die value (except 1's: flat 100 points)

Combo multiplier: each wave of eliminations after gravity increases the multiplier exponentially (×1 first wave, ×1.5 second, ×2.25 third, etc.). The combo counter resets when a new pair spawns.

The game saves the high score persistently (may not be displayed in the prototype, TBD).

An online leaderboard feature is to be evaluated.

### Spawn Rules

Pairs of 1:1 and 2:2 can never spawn. All other combinations have even odds. Spawn probabilities must be adjustable variables that can evolve as the game progresses.

### Level

Predefined cumulative score thresholds increase the in-game level. Each level increases drop speed. The cost to reach the next level scales with the current level number (level N requires N × 10,000 additional points). Speed decreases by an accelerating delta for levels 1-6 (-0.05, -0.10, -0.15, -0.20, -0.25), then uses manual values for levels 7-11.

| Level | Score threshold | Drop speed |
|---|---|---|
| 1 | 0 | 1.00s |
| 2 | 10,000 | 0.95s |
| 3 | 30,000 | 0.85s |
| 4 | 60,000 | 0.70s |
| 5 | 100,000 | 0.50s |
| 6 | 150,000 | 0.25s |
| 7 | 210,000 | 0.10s |
| 8 | 280,000 | 0.075s |
| 9 | 360,000 | 0.05s |
| 10 | 450,000 | 0.025s |
| 11 | 550,000 | 0.01s |

### Difficulty Levers

All values are adjustable per level. Default values are starting points for playtesting. Currently only drop speed changes per level.

| Lever | Effect | Default |
|---|---|---|
| Drop speed | Time between automatic drops (lower = faster) | Per level table above |
| Lock delay duration | Time before a touching pair detaches | 0.5s |
| Lock delay resets | Max actions that reset the lock timer | 10 |
| Spawn odds | Weight per die value (1-6), controls spawn probability | Equal (1 each) |
| Soft drop multiplier | Speed boost factor during soft drop | 10x |
| Dying duration | How long eliminated dice stay in "dying" state before being removed (shorter = less time to chain) | 1.0s |

## Screens

### Logo Screens

Two logo screens displayed on launch (timings adjustable):
1. "proudly made with" (fnt_inkfree_logo) + GameMaker logo (spr_logo_gamemaker) — 2 seconds
2. "GRAVE GAMES" + studio logo (spr_logo_gravegames) with shadow + "PRESENTS" (fnt_bebasneue_logo) — 2 seconds

### Splash Screen

Title screen displayed after logos. Shows "DICE ROYAL" (fnt_bungee_splash) centered with "Tap to Stack!" (fnt_inkfree_logo) blinking below. Background features a dice rain effect (spr_dice_rain sprites falling with random speed, alpha fade, and per-die shake). Tap/Enter/Start to begin, triggering a fade transition (die zoom in/out) to the game screen.

### Game Screen

Contains the grid, score, level display, hold box, next box, pause button and help button. Game state is managed via `global.game_state` ("logos" → "splash" → "game").

### Pause Screen

Accessed via pause button (touch), ESC (keyboard), or Start (gamepad). Not available during countdown. Displays "PAUSED" title and menu options on a semi-transparent blue rectangle:
- Resume
- Restart (soft restart, no logos)
- Quit (return to splash)
- [X] Mute Music / [ ] Mute Music (toggle, reflects current state)

Navigation: touch tap on option, or keyboard arrows/gamepad stick + Enter/A. Options are white until keyboard/gamepad navigation is detected, then focused option highlights in cream (COLOR_BOX_FILL).

Future additions: Ghost on/off, Hold on/off.

### Help Screen

Accessed via "?" button (touch), F1 (keyboard), or Select (gamepad). The "?" button becomes "X" when help is active. Displays "HOW TO PLAY" (fnt_bungee_title) with rules (cream color) and mobile controls (white) on a semi-transparent blue rectangle. Closes via X button, F1, Select, or ESC. Game is paused while help is open.

Future: auto-show on first game after launch with "Don't show again" checkbox + persistence.

### Game Over Screen

Displayed when the grid is at rest and a die remains above the dead zone. A 1-second delay prevents accidental input. Shows on a semi-transparent blue rectangle:
- "GAME OVER" title (fnt_bungee_title, red)
- "NEW BEST!" (yellow, pulsing) — only if high score was beaten
- Current Score (cream label + white value)
- High Score (cream label + white value)
- Restart / Quit menu (same navigation as pause)

### Countdown

A "3-2-1-STACK!" countdown plays before gameplay begins. Each step lasts 0.5s with a scale animation (zoom in 0.1→1, zoom out 1→0.1) using fnt_bungee_countdown. Plays at game start and after soft restart.

### Fade Transition

A die sprite (spr_screen_fade, 1664×1664) zooms in while fading to opaque, then zooms out while fading to transparent. Used between splash and game screens. The countdown starts only after the fade completes.

## Controls

The in-game UI only displays mobile controls.

### Mobile
- Drag horizontal = Move (finger controls pair position directly)
- Swipe up = Hard drop
- Swipe down = Soft drop
- Tap right (top three-quarters) = Rotate CW (except pause and help buttons)
- Tap left (top three-quarters) = Rotate CCW
- Tap bottom quarter = Hold / Swap

### Gamepad (Xbox scheme)
- Left stick or D-Pad = Move / Soft drop / Hard drop (up)
- B or Y = Rotate CW
- A or X = Rotate CCW
- LB or RB = Hold
- Start = Pause / Confirm
- Select = Help
- RT + LT = Restart
- Select + Start = Quit

### Keyboard
- A/D or arrows = Move
- W or up = Hard drop
- S or down = Soft drop
- Space = Rotate CW
- Ctrl (L/R) = Rotate CCW
- Shift (L/R) = Hold
- ESC = Pause
- Enter = Confirm
- F1 = Help
- M = Mute/unmute music
- Tab = Toggle grid lines

## Dimensions

The mockup (DICEROYAL.jpg) communicates layout intent, not exact dimensions.

| Element | Size / Position |
|---|---|
| Die | 32 x 32 px |
| Grid cells | 32 x 32 px |
| Grid | 256 x 416 px (including 13th cell), centered on screen |
| Dead zone line | 32 px from top of grid |
| Title | Centered above grid |
| Score | Centered below title |
| Hold / Next boxes | 72 x 48 px, below grid, with labels underneath |
| Level display | Centered between Hold and Next boxes |
| Pause button | Top-left corner |
| Help button ("?") | Top-right corner |
| Fonts | Bungee (UI), Bungee title (game title), Bungee buttons (pause/help) |

## Audio

Two versions of the game theme exist: a vocal version for the splash screen and an instrumental version for gameplay. Both loop indefinitely. The player can mute/unmute music (M key, or from pause menu). SFX (stacking, eliminating, combos, beating the high score) are independent from music mute. Sounds cannot overlap to avoid audio clutter.

## Presentation

- **Splash screen:** Rain of dice in the background
- **Game screen:** "DxR" text scrolling diagonally in the background (see mockup)
- **Transitions:** Fade in/out between screens; one transition features a large die zooming in/out before the countdown
- **Dying dice:** Juice effects on elimination
- **High score beaten:** Visual "bling" effect
