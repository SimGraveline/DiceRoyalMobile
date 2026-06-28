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

Players eliminate dice by chaining identical values orthogonally (up, down, left, right — no diagonals): two 2's, three 3's, four 4's, five 5's or six 6's.

Eliminated dice play a "dying" animation. During that animation, any die placed orthogonally to a dying die of the same value is also eliminated (along with all connected dice of that value). 1's are a special case: a single 1 placed orthogonally to any dying die eliminates all 1's on the grid.

Dice sitting on dying dice fall once the dying dice are removed, creating chain reactions and combos.

### Mechanics

**Grid:** 8 cells wide by 12 cells high. A dead zone line sits between the 12th and a 13th cell where pairs spawn. If any die remains above the dead zone when the grid is at rest (no active clearing, falling or chain resolution), the game is over.

**Pair movement:** A pair spawns at the top center of the grid (positions 4,13 and 5,13). The left die is the "master"; the right die rotates around it into four orthogonal positions. Pairs move in fixed one-cell increments and snap to the grid. After stacking, the next pair spawns at the previous pair's X position.

**Lock delay:** When one die of a pair touches something (grid floor or stacked die), a lock timer begins (default: 0.5s, adjustable). During this window, the player can still move and rotate the pair. Each successful action resets the timer, up to a maximum number of resets (default: 10, adjustable). When the timer expires, the pair detaches. Lock delay duration and reset count are potential levers for difficulty scaling.

**Detach:** When the lock delay expires, the pair detaches. The landed die is written to the grid. The other die continues falling independently as a "solo faller" with no player control. After detach, the player loses control of both dice.

**Wall kick:** If rotation is blocked by a wall, the pair shifts one cell to allow it. If the shifted position is also blocked, the rotation is denied. Rotation blocked by a stacked die in the grid is always denied (no kick) to prevent dice from overlapping.

**Soft drop:** Temporarily boosts the drop speed (default: 125%, adjustable). The player can still move and rotate during a soft drop but cannot trigger another until the current one ends.

**Hard drop:** Instantly snaps the pair to the first available stacking position. The player cannot control the pair during a hard drop.

**Hold:** The player can store one pair for later (one swap per active pair). The stored pair resets to horizontal orientation. When swapping, the pair from the hold box takes the active pair's current position and orientation. If the hold box was empty, the next queued pair spawns normally.

**Next:** The screen displays the next pair to spawn.

**Ghost:** A semi-transparent preview shows where the pair would land if hard-dropped. Can be toggled on/off from the pause screen.

### Score

Player scores points by:
- Stacking a pair: X points
- Eliminating dice: Y points per die, multiplied by dice value (except 1's: flat Y points)

Combo multiplier: all subsequent eliminations in a chain are multiplied by Z x dice value.

The game saves the high score persistently (may not be displayed in the prototype, TBD).

An online leaderboard feature is to be evaluated.

### Spawn Rules

Pairs of 1:1 and 2:2 can never spawn. All other combinations have even odds. Spawn probabilities must be adjustable variables that can evolve as the game progresses.

### Level

Predefined score thresholds increase the in-game level, which increases drop speed (adjustable). Spawn odds may also be adjusted per level based on playtesting.

## Screens

### Logo Screens

Studio and game logos displayed on launch.

### Splash Screen

Title screen displayed after logos. Game theme music starts here and loops indefinitely.

### Game Screen

Contains the grid, score, level display, hold box, next box, pause button and help button.

### Pause Screen

Accessed via the pause button. Displays current score and high score. Options:
- Resume
- Restart
- Quit (return to splash)
- Ghost on/off
- Hold on/off

**Note:** UI adjustment needed if hold is disabled (hold box becomes empty). To be addressed later.

### Help Screen

Accessed via the "?" button. Displays mobile controls only (swipe directions, tap zones), even though gamepad and keyboard are supported.

On the first game after each app launch, the help screen appears automatically with a "Don't show again" checkbox. Once checked, the automatic display is permanently disabled. The checkbox is not shown when the help screen is accessed manually via "?".

### Game Over Screen

Displayed when the grid is at rest and a die remains above the dead zone. Contains:
- "Game Over" title
- Current score
- High score
- A mention if the high score was beaten
- Replay button (starts a new game)
- Quit button (return to splash)

### Countdown

A "3-2-1-STACK" countdown plays before gameplay begins:
- Splash to game
- Pause to game (resume)
- Help to game
- Returning from lost focus (low priority)

## Controls

The in-game UI only displays mobile controls.

### Mobile
- Swipe left/right = Move
- Swipe up = Hard drop
- Swipe down = Soft drop
- Tap top two-thirds = Rotate CW (except pause and help buttons)
- Tap bottom third = Hold / Swap

### Gamepad (Xbox scheme)
- Left stick or D-Pad = Move / Hard drop / Soft drop
- A = Rotate CW
- X = Rotate CCW
- LB or RB = Hold
- Start = Pause

### Keyboard
- A/D or arrows = Move
- W or up = Hard drop
- S or down = Soft drop
- Space = Rotate CW
- Shift (L/R) = Rotate CCW
- H = Hold
- ESC = Pause

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
| Fonts | TBD |

## Audio

A game theme starts at the splash screen and loops indefinitely. Other sounds: stacking a pair, eliminating dice, combos, beating the high score. Sounds cannot overlap to avoid audio clutter.

## Presentation

- **Splash screen:** Rain of dice in the background
- **Game screen:** "DxR" text scrolling diagonally in the background (see mockup)
- **Transitions:** Fade in/out between screens; one transition features a large die zooming in/out before the countdown
- **Dying dice:** Juice effects on elimination
- **High score beaten:** Visual "bling" effect
