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

*Design note: die values 7, 8 and 9 exist in the underlying implementation (unlock levels, scoring, suites) but are currently disabled. Once Bomb, Mimic, Brick and Junk Drop were in place, "bigger number, longer chain" stopped adding anything the other mechanics didn't already do better, and a 9-sided die didn't fit the game's dice theme. May be revisited.*

Eliminated dice enter a "dying" state with a visible fade-out animation. Dying propagates: any non-dying die orthogonally adjacent to a dying die of the same value also becomes dying, along with all of its connected same-value dice. This propagation cascades until no more dice can be reached. Each die that enters dying gets its own independent timer.

1's are a special case: they never match on their own. A 1 orthogonally adjacent to any dying die (regardless of value) triggers the elimination of all 1's on the grid.

Dying dice do not fall — they float in place if their support is removed. They remain solid (occupy their cell) until their timer expires. Once a dying die's timer expires, it is removed from the grid and its cell becomes empty. Non-dying dice above empty cells fall instantly (gravity). Gravity can create new chains, triggering further dying cycles (combos).

### Mechanics

**Grid:** Column and row count are tunable (see `scr_game_constants.gml` for current values — under active playtesting as of this writing). A dead zone row sits directly above the grid's visible rows, where pairs spawn. If any die remains above the dead zone when the grid is at rest (no active clearing, falling or chain resolution), the game is over.

**Pair movement:** A pair spawns at the top center of the grid, in the dead zone. The left die is the "master"; the right die rotates around it into four orthogonal positions. Pairs move in fixed one-cell increments and snap to the grid. After stacking, the next pair spawns at the previous pair's X position.

**Lock delay:** When one die of a pair touches something (grid floor or stacked die), a lock timer begins. During this window, the player can still move and rotate the pair. Each successful action resets the timer, up to a maximum number of resets. When the timer expires, the pair detaches. Lock delay duration and reset count are tunable difficulty levers.

**Detach:** When the lock delay expires (or a hard drop occurs), the pair detaches. The landed die is written to the grid. The other die snaps instantly to the lowest available position in its column. If either die is adjacent to a dying die of the same value, it joins the dying chain instead of stacking normally. After detach, a new pair spawns immediately — the player does not wait for dying or chain resolution to finish.

**Wall kick:** If rotation is blocked by a wall, the pair shifts one cell to allow it. If the shifted position is also blocked, the rotation is denied. Rotation blocked by a stacked die in the grid is always denied (no kick) to prevent dice from overlapping.

**Soft drop:** Boosts the drop speed while held. The player can still move and rotate during a soft drop.

**Hard drop:** Instantly snaps the pair to the first available stacking position. The player cannot control the pair during a hard drop.

**Hold:** The player can store one pair for later (one swap per active pair). The stored pair resets to horizontal orientation. When swapping, the pair from the hold box takes the active pair's current position and orientation. If the hold box was empty, the next queued pair spawns normally.

**Next:** The screen displays the next pair to spawn.

**Ghost:** A semi-transparent preview shows where the pair would land if hard-dropped. Can be toggled on/off from the pause screen.

### Score

Player scores points by:
- Stacking a die: a small fixed amount per die when it is written to the grid. This applies to every die type, special or not — the stack action itself is what scores, independent of any special effect.
- Eliminating dice: points scale with die value; 1's and Brick are a flat exception since they have no value-based multiplier. Bomb, Clear Row and Clear Column never score points themselves when they finish dying — they're triggers, not targets. A Mimic that dies still unresolved (never copied a value) also scores nothing, since it never became a real die value.
- Suite elimination: forming a consecutive ascending or descending sequence (1–N or N–1) in a row or column, where N is the highest currently unlocked die value, eliminates the whole sequence. A suite at exactly the current maximum unlocked value scores through the normal per-die elimination above — no separate bonus. Suites longer than that maximum (7, 8, 9 — currently disabled) additionally score a flat bonus on top, increasing with length.

Suite dice enter dying state normally and can trigger cascade propagation.

Combo multiplier: each wave of eliminations after gravity is worth less than the previous one, so long combo chains don't explode the score. The combo counter resets when a new pair spawns.

The game saves the high score persistently (may not be displayed in the prototype, TBD).

An online leaderboard feature is to be evaluated.

### Special Dice

Six special die types can appear in pairs, each unlocking at its own level as the game progresses. At most one special die can appear per pair; the other die is always a normal die.

| Die | Name | Behavior |
|---|---|---|
| Mimic | Dé Mimic | On landing, copies the value of the die directly below it. If no normal die is below (or it lands on the floor), it stays in an idle state until a die falls on top of it or beneath it (gravity). |
| Bomb | Dé Bomb | On landing, reads the value of the die directly below it and eliminates all dice of that value on the grid (including every Brick on the grid, if the value read was a Brick). If no normal die is below, it stays idle until activated by a die landing on top of it or beneath it. The Bomb itself doesn't disappear instantly — it enters the dying state alongside its targets and fades out like they do. While it's fading, a new die placed adjacent to it re-triggers another grid-wide elimination using that new die's value, letting a single Bomb chain multiple clears if the player keeps feeding it. |
| Random | Dé Random | While active in the pair, cycles through all currently unlocked die values (1–N), visible in the pair and the next box. Locks to the current displayed value on landing. |
| Brick | Dé Brick | A solid obstacle. It can never be matched or eliminated through normal chains — the only ways to remove it are a Bomb reading its value, or a Clear Row/Clear Column line passing through it (see below). It falls with gravity like any other die when its support disappears, but otherwise just occupies its cell indefinitely. |
| Clear Row | Dé Clear R | On landing, immediately triggers dying for every die on its entire row (including Bricks), then joins the dying itself. This is a one-time effect — it never stays idle and is never re-triggered afterward. Everything past that point (cascade propagation, 1's rule, joining an in-progress chain) follows the same rules as any other dying die. |
| Clear Column | Dé Clear C | Same as Clear Row, but affects the entire column instead of the row. |

Special die spawn odds are calculated dynamically so each one keeps a consistent probability regardless of how many normal die values are currently unlocked.

Special dice never form matches on their own. A Mimic that stays idle (no normal die resolved) or a Bomb that stays idle are treated as inert until activated. Clear Row and Clear Column are never idle — their effect always fires the instant they land.

### Junk Drop

Periodically, a batch of dice drops onto the grid outside the player's control. The number of pairs between two drops is randomized within a range and re-rolled independently each time, rather than a fixed count — so the player can't just count pairs to predict the next drop. The dice first appear as a translucent preview sitting in the dead zone once the player takes control of their current pair — an early warning before anything actually happens. The drop only becomes real once the board is completely idle (no dying dice, no active pair): each previewed die then falls into its own column (never sharing a column with another die from the same drop, and never targeting a column that would cause an unfair game over), fading in from the preview to full opacity as it lands. The next pair does not spawn until every dropped die has landed — normal "spawn during dying" rules resume immediately after that.

Junk Drop dice are drawn from the same pool as normal spawns (currently unlocked values, plus Brick once unlocked) — never Mimic, Bomb or Random. Because the dice are ordinary values, a drop can just as easily complete a pending match for the player as it can clutter the board — both outcomes are intended.

### Spawn Rules

Pairs of 1:1 and 2:2 can never spawn. Spawn probabilities per die value are adjustable and can evolve as the game progresses. At most one special die can appear per pair.

### Level

Predefined cumulative score thresholds increase the in-game level. Each level increases drop speed, up to a plateau. Past a certain score, the level keeps climbing indefinitely on a recurring threshold, so a skilled player is never permanently capped. The special dice and Junk Drop unlock progressively as the level increases.

### Difficulty Levers

All values are adjustable per level. Default values are starting points for playtesting. Currently only drop speed changes per level.

| Lever | Effect |
|---|---|
| Drop speed | Time between automatic drops (lower = faster), increases per level |
| Lock delay duration | Time before a touching pair detaches |
| Lock delay resets | Max actions that reset the lock timer |
| Spawn odds | Weight per die value, controls spawn probability |
| Special die odds | Probability of each special die (Random, Mimic, Bomb, Brick, Clear Row, Clear Column) appearing, independent of the normal pool |
| Soft drop multiplier | Speed boost factor during soft drop |
| Dying duration | How long eliminated dice stay in "dying" state before being removed (shorter = less time to chain) |
| Junk Drop rate & quantity | How often a Junk Drop triggers, and how many dice it drops each time |

## Screens

### Logo Screens

Two logo screens displayed on launch (timings adjustable):
1. "proudly made with" (fnt_inkfree_logo) + GameMaker logo (spr_logo_gamemaker) — 2 seconds
2. "GRAVE GAMES" + studio logo (spr_logo_gravegames) with shadow + "PRESENTS" (fnt_bebasneue_logo) — 2 seconds

### Splash Screen

Title screen displayed after logos. Shows "DICE ROYAL" (fnt_bungee_splash) centered with "Tap to Stack!" (fnt_inkfree_logo) blinking below, and a "Beta Version" tag (fnt_bebasneue_credits) at the top of the screen. Background features a dice rain effect (spr_dice_rain sprites falling with random speed, alpha fade, and per-die shake). Tap/Enter/Start to begin, triggering a fade transition (die zoom in/out) to the game screen.

### Game Screen

Contains the grid, score, level display, hold box, next box, pause button and help button. Game state is managed via `global.game_state` ("logos" → "splash" → "game").

### Pause Screen

Accessed via pause button (touch), ESC (keyboard), or Start (gamepad). Not available during countdown. Displays "PAUSED" title and menu options on a semi-transparent blue rectangle:
- Resume
- Restart (soft restart, no logos)
- Quit (return to splash)
- [X] Mute Music / [ ] Mute Music (toggle, reflects current state)
- [X] Mute SFX / [ ] Mute SFX (toggle, reflects current state)
- [X] Ghost / [ ] Ghost (toggle, reflects current state)

Navigation: touch tap on option, or keyboard arrows/gamepad stick + Enter/A. Options are white until keyboard/gamepad navigation is detected, then focused option highlights in cream (COLOR_BOX_FILL).

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

## PC / Kiosk Mode

A second display mode, intended for convention booth demos on a PC. Toggled with F11, available from the logo screen onward — no separate build, room or fork, just a runtime switch.

- **Mobile mode** (default): unchanged from before this feature — windowed, fixed portrait size.
- **PC mode**: fullscreen at the desktop's resolution. The grid is rescaled to occupy 90% of the screen height (same column/row count, bigger cells); width follows from that since the grid's proportions don't change.

Layout differences in PC mode (game screen only — logos and splash are unaffected other than filling the wider screen):
- Title ("DICE ROYAL" + "DEMO" label) moves to the top-left, Score/Level to the top-right.
- Hold and Next boxes move to the left side of the screen, stacked, centered between the bottom of the "DEMO" label and the bottom of the screen, and between the screen's left edge and the grid's left edge.
- A "Scan to download mobile demo" prompt + QR code (spr_code_qr) appears bottom-right, mirroring the Hold/Next module's position on the opposite side.
- Pause/help buttons stay in their corners but scale up so they remain readable at PC resolution.
- The Help screen's control instructions switch from mobile touch gestures to keyboard/gamepad bindings.
- Dedicated PC fonts (title, body, buttons) and a dedicated fade transition sprite are used in this mode so text stays legible at the larger scale.

## Controls

The in-game UI displays mobile controls by default, or keyboard/gamepad controls when in PC mode (see PC / Kiosk Mode above).

### Mobile
- Drag horizontal = Move (finger controls pair position directly)
- Swipe up = Hard drop
- Swipe down = Soft drop
- Tap right (upper portion of the screen) = Rotate CW (except pause and help buttons)
- Tap left (upper portion of the screen) = Rotate CCW
- Tap (lower portion of the screen) = Hold / Swap

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
| Die | Square, side length = one grid cell (see `CELL_SIZE` in `scr_game_constants.gml` for the current value) |
| Grid cells | Same size as a die |
| Grid | Column/row count is tunable (see `GRID_COLS`/`GRID_ROWS`), plus one dead zone row above, centered on screen |
| Dead zone line | One cell height above the grid's top row |
| Title | Centered above grid |
| Score | Centered below title |
| Level | Directly below Score |
| Hold / Next boxes | Below grid, with labels underneath |
| Pause button | Top-left corner |
| Help button ("?") | Top-right corner |
| Fonts | Bungee (UI), Bungee title (game title), Bungee buttons (pause/help) |

## Audio

Two versions of the game theme exist: a vocal version for the splash screen and an instrumental version for gameplay. Both loop indefinitely. The player can mute/unmute music (M key, or from pause menu). SFX (stacking, eliminating, combos, beating the high score) are independent from music mute. Sounds cannot overlap to avoid audio clutter.

## Systems Reference

A quick map of the game's key state variables and how they interact — meant to be checked before making a change that touches timing or sequencing, since several of these interact in ways that aren't obvious from any single script.

| State | Meaning | Resets / clears when | Depended on by |
|---|---|---|---|
| Pair active | A pair is currently spawned and player-controlled | Pair detaches | Junk Drop trigger tracking, next-pair spawn gating |
| Grid dying | Any cell is mid fade-out (matched, or eliminated by a Bomb / Clear Row / Clear Column) | Its own dying timer expires | Gravity (dying cells don't fall), Junk Drop's "board idle" check, game over check |
| Combo count | Number of consecutive elimination waves within one resolution | A new pair spawns, or Junk Drop confirms the board is idle | Score multiplier on wave elimination |
| Junk Drop state (idle / telegraph / falling) | Where a pending Junk Drop batch is in its lifecycle | Telegraph → falling once the board goes idle; falling → idle once every die has landed | Next-pair spawn (blocked until back to idle) |
| Lock delay | Time before a touching pair detaches | Player action (move/rotate), up to a max number of resets | Detach trigger |

Sequencing notes worth remembering:
- The next pair never spawns while a Junk Drop is telegraphing or falling — normal "spawn during dying" rules only resume once every dropped die has landed.
- Combo count is tied to *pair spawns*, not to *the board going idle* — the one exception is Junk Drop, which explicitly resets it the moment it detects the board is idle, so a Junk Drop match doesn't inherit a stale multiplier left over from the previous pair's resolution.
- A Bomb doesn't disappear on activation — it fades out like its targets, and can be re-triggered by a new die landing on it before its timer expires.

## Presentation

- **Splash screen:** Rain of dice in the background
- **Game screen:** "DxR" text scrolling diagonally in the background (see mockup)
- **Transitions:** Fade in/out between screens; one transition features a large die zooming in/out before the countdown
- **Dying dice:** Juice effects on elimination
- **High score beaten:** Visual "bling" effect
