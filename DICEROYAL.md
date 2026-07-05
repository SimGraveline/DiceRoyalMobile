# DICE ROYAL

Dice Royal is a falling block puzzle game for mobile platforms, inspired by Tetris, Puyo Puyo and Devil Dice. Built in GameMaker Studio, it targets mobile via GX.games while also supporting keyboard and gamepad for browser play. The game is locked to portrait orientation.

This is a proof of concept / prototype with only logo, splash, game, pause, help and game over screens — no ads, monetization or achievements yet.

## Project History

Several prior attempts at making this game ended in failure. The two recurring blockers were the pair detach logic and the chain drop behavior. Both have been resolved with the following decisions:

1. **Pair: Hybrid approach.** The pair is a logical entity that handles movement and rotation while active. As soon as one die lands on something (grid floor or stacked die), the pair detaches and each die becomes autonomous for the falling/resolution phase.
2. **Grid: Simulation approach.** The grid is the single source of truth. All logic (matching, clearing, gravity) operates on it directly, not on what's visually drawn.

This document and the mockup (DICEROYAL.jpg) are sources of truth for design. When they contradict each other, this document prevails; the mockup is not systematically kept in sync.

## Gameplay

### Rules

Players eliminate dice by chaining identical values orthogonally (up, down, left, right — no diagonals). A chain is valid when the number of connected dice is equal to or greater than the die value: two or more 2's, three or more 3's, four or more 4's, five or more 5's, six or more 6's.

*Design note: values 7, 8 and 9 are currently disabled. Once Bomb, Mimic, Brick and Junk Drop were in place, "bigger number, longer chain" stopped adding anything the other mechanics didn't already do better, and a 9-sided die didn't fit the game's dice theme. May be revisited.*

Eliminated dice enter a "dying" state with a visible fade-out. Dying propagates: any non-dying die orthogonally adjacent to a dying die of the same value also becomes dying, along with all of its connected same-value dice. This propagation cascades until no more dice can be reached. Each die that enters dying gets its own independent timer.

1's are a special case: they never match on their own. A 1 orthogonally adjacent to any dying die (regardless of value) triggers the elimination of all 1's on the grid.

Dying dice do not fall — they float in place if their support is removed. They remain solid (occupy their cell) until their timer expires. Once a dying die's timer expires, it is removed from the grid and its cell becomes empty. Non-dying dice above empty cells fall instantly (gravity). Gravity can create new chains, triggering further dying cycles (combos).

### Mechanics

**Grid:** Column and row count are tunable and still being playtested. A dead zone row sits directly above the grid's visible rows, where pairs spawn. If any die remains above the dead zone when the grid is at rest (no active clearing, falling or chain resolution), the game is over.

**Pair movement:** A pair spawns at the top center of the grid, in the dead zone. The left die is the "master"; the right die rotates around it into four orthogonal positions. Pairs move in fixed one-cell increments and snap to the grid. After stacking, the next pair spawns at the previous pair's X position.

**Lock delay:** When one die of a pair touches something (grid floor or stacked die), a lock timer begins. During this window, the player can still move and rotate the pair. Each successful action resets the timer, up to a maximum number of resets. When the timer expires, the pair detaches.

**Detach:** When the lock delay expires (or a hard drop occurs), the pair detaches. The landed die is written to the grid. The other die snaps instantly to the lowest available position in its column. If either die is adjacent to a dying die of the same value, it joins the dying chain instead of stacking normally. After detach, a new pair spawns immediately — the player does not wait for dying or chain resolution to finish.

**Wall kick:** If rotation is blocked by a wall, the pair shifts one cell to allow it. If the shifted position is also blocked, the rotation is denied. Rotation blocked by a stacked die is always denied (no kick) to prevent dice from overlapping.

**Soft drop:** Boosts the drop speed while held. The player can still move and rotate during a soft drop.

**Hard drop:** Instantly snaps the pair to the first available stacking position. The player cannot control the pair during a hard drop.

**Hold:** The player can store one pair for later (one swap per active pair). The stored pair resets to horizontal orientation. When swapping, the pair from the hold box takes the active pair's current position and orientation. If the hold box was empty, the next queued pair spawns normally.

**Next:** The screen displays the next pair to spawn.

**Ghost:** A semi-transparent preview shows where the pair would land if hard-dropped. Can be toggled on/off from the pause screen.

### Score

Player scores points by:
- Stacking a die: a small fixed amount per die when it lands on the grid. This applies to every die type, special or not — the stack action itself is what scores, independent of any special effect. A die delivered by a Junk Drop is the one exception: it scores nothing on landing, only on elimination, since by that point it's just an ordinary die on the board.
- Eliminating dice: points scale with die value; 1's are a flat exception since they have no value-based multiplier. Every die scores the same way on elimination, special or not — there's no separate scoring rule for specials.
- Suite elimination: forming a consecutive ascending or descending sequence (1–N or N–1) in a row or column, where N is the highest currently unlocked die value, eliminates the whole sequence. A suite at exactly the current maximum unlocked value scores through the normal per-die elimination above — no separate bonus. Suites longer than that maximum (7, 8, 9 — currently disabled) additionally score a flat bonus on top, increasing with length.

Suite dice enter dying state normally and can trigger cascade propagation.

Combo multiplier: each wave of eliminations after gravity is worth less than the previous one, so long combo chains don't explode the score. The combo counter resets when a new pair spawns.

The game saves the high score persistently.

An online leaderboard feature is to be evaluated.

### Special Dice

Six special die types can appear in pairs, each unlocking at its own level as the game progresses. At most one special die can appear per pair; the other die is always a normal die. Odds are calculated so each special keeps a consistent probability regardless of how many normal die values are currently unlocked, and stay constant for good once unlocked — no further change later in a run.

| Die | Behavior |
|---|---|
| Mimic | On landing, copies the value of the die directly below it. If no normal die is below (or it lands on the floor), it stays idle ("unresolved") until a die lands on top of it or beneath it. |
| Bomb | On landing, reads whatever is directly below it and eliminates every matching thing on the grid: a value (all dice of that value), a Brick (every Brick — and as a bonus side effect, every Bomb on the grid too), another Bomb (every Bomb), or an unresolved Mimic (every unresolved Mimic). If nothing valid is below, it stays idle until something valid lands on top of it or beneath it. The Bomb itself doesn't disappear instantly — it fades out alongside its targets, and while it's fading, a new die placed on it re-triggers another grid-wide elimination, letting a single Bomb chain multiple clears if the player keeps feeding it. |
| Random | While active in the pair, cycles through all currently unlocked die values, visible in the pair and the next box. Locks to the current displayed value on landing, after which it behaves exactly like a normal die of that value. |
| Brick | A solid obstacle. It can never be matched or eliminated through normal chains — the only ways to remove it are a Bomb reading its value, or a Clear Row/Clear Column passing through it. It falls with gravity like any other die when its support disappears, but otherwise just occupies its cell indefinitely. |
| Clear Row | On landing, eliminates every die on its entire row (Bricks included), then joins the dying itself. One-time effect — never idle, never re-triggered. Unlike a normal match or a Bomb, this elimination is self-contained: it never spreads to same-value dice sitting outside that row, and nothing can join it later while it's still fading. If it's not yet resting on solid ground when it lands (still shifting down because of something dying below it), its effect waits until it truly settles before firing. |
| Clear Column | Same as Clear Row, but affects the entire column instead of the row. |

Special dice never form matches on their own — a Mimic or Bomb sitting idle is inert until activated. Clear Row and Clear Column are never idle; their effect always fires (once settled — see above).

### Junk Drop

Periodically, a batch of dice drops onto the grid outside the player's control. The number of pairs between two drops is randomized within a range and re-rolled independently each time, rather than a fixed count — so the player can't just count pairs to predict the next drop. The dice first appear as a translucent preview sitting in the dead zone once the player takes control of their current pair — an early warning before anything actually happens. The drop only becomes real once the board is completely idle (no dying dice, no active pair): each previewed die then falls into its own column, fading in from the preview to full opacity as it lands. The next pair does not spawn until every dropped die has landed.

Junk Drop dice are drawn from the same pool as normal spawns (currently unlocked values, plus Brick once unlocked) — never Mimic, Bomb, Random, or either Clear. Because the dice are ordinary values, a drop can just as easily complete a pending match for the player as it can clutter the board — both outcomes are intended. The quantity per drop ramps up over several levels after Junk Drop unlocks, then holds steady for the rest of the run — the trigger frequency itself never changes.

### Spawn Rules

Pairs of 1:1 and 2:2 can never spawn. Spawn probabilities per die value are adjustable and can evolve as the game progresses. At most one special die can appear per pair.

### Level

Predefined cumulative score thresholds increase the in-game level. Each level increases drop speed, up to a plateau. Past a certain score, the level keeps climbing indefinitely on a recurring threshold, so a skilled player is never permanently capped — this endless tier is meant as an endurance mode for high-score chasers, reached once everything is already unlocked and running at its fastest, most demanding pace. The special dice and Junk Drop unlock progressively as the level increases.

### Difficulty Levers

All values are adjustable per level. Default values are starting points for playtesting.

| Lever | Effect |
|---|---|
| Drop speed | Time between automatic drops (lower = faster), increases per level |
| Lock delay duration | Time before a touching pair detaches |
| Lock delay resets | Max actions that reset the lock timer |
| Spawn odds | Weight per die value, controls spawn probability |
| Special die odds | Probability of each special die appearing, independent of the normal pool |
| Soft drop multiplier | Speed boost factor during soft drop |
| Dying duration | How long eliminated dice stay in "dying" state before being removed (shorter = less time to chain) |
| Junk Drop rate & quantity | How often a Junk Drop triggers, and how many dice it drops each time |

## Screens

### Logo Screens

Two logo screens displayed on launch (timings adjustable): a "proudly made with" GameMaker credit, followed by the studio logo with a "presents" tag.

### Splash Screen

Title screen shown after the logos: game title centered, with a blinking "Tap to Stack!" prompt below and a "Beta Version" tag. Background features a falling dice rain effect. Tapping/confirming begins the game via a fade transition.

### Game Screen

Contains the grid, score, level display, hold box, next box, pause button and help button.

### Pause Screen

Accessed via the pause button (touch), ESC (keyboard), or Start (gamepad). Not available during the countdown. Shows:
- Resume
- Restart (soft restart, no logos)
- Quit (return to splash)
- Mute Music toggle
- Mute SFX toggle
- Ghost toggle

Navigable by touch tap, or keyboard/gamepad.

### Help Screen

Accessed via the "?" button (touch), F1 (keyboard), or Select (gamepad). Shows "HOW TO PLAY" with the rules and controls. Closes the same way it opens, or via ESC. Game is paused while help is open.

Future: auto-show on first game after launch with a "Don't show again" option.

### Game Over Screen

Displayed when the grid is at rest and a die remains above the dead zone. A short delay prevents accidental input. Shows:
- "GAME OVER" title
- "NEW BEST!" — only if the high score was beaten
- Current score and high score
- Restart / Quit menu

### Countdown

A "3-2-1-STACK!" countdown plays before gameplay begins, at game start and after a soft restart.

### Fade Transition

A zoom-in/zoom-out die transition used between the splash and game screens. The countdown starts only after the fade completes.

## PC / Kiosk Mode

A second display mode, intended for convention booth demos on a PC. Toggled with F11, available from the logo screen onward — no separate build, room or fork, just a runtime switch.

- **Mobile mode** (default): windowed, fixed portrait size.
- **PC mode**: fullscreen at the desktop's resolution. The grid is rescaled to occupy most of the screen height (same column/row count, bigger cells); width follows from that since the grid's proportions don't change.

Layout differences in PC mode (game screen only — logos and splash are unaffected other than filling the wider screen):
- Title moves to the top-left, Score/Level to the top-right.
- Hold and Next boxes move to the left side of the screen, stacked.
- A "Scan to download mobile demo" prompt with a QR code appears bottom-right.
- Pause/help buttons scale up so they remain readable at PC resolution.
- The Help screen's control instructions switch from mobile touch gestures to keyboard/gamepad bindings.

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

## Layout

The mockup (DICEROYAL.jpg) communicates layout intent, not exact dimensions.

| Element | Position |
|---|---|
| Die / grid cell | Square, one cell per die, size is tunable |
| Grid | Centered on screen, with one dead zone row above the visible rows |
| Title | Centered above grid |
| Score | Centered below title |
| Level | Directly below Score |
| Hold / Next boxes | Below grid, with labels underneath |
| Pause button | Top-left corner |
| Help button ("?") | Top-right corner |

## Audio

Two versions of the game theme exist: a vocal version for the splash screen and an instrumental version for gameplay. Both loop indefinitely. The player can mute/unmute music (M key, or from the pause menu). SFX (stacking, eliminating, combos, beating the high score) are independent from music mute. Sounds cannot overlap to avoid audio clutter.

## Presentation

- **Splash screen:** Rain of dice in the background
- **Game screen:** Scrolling background pattern
- **Transitions:** Fade in/out between screens; one transition features a large die zooming in/out before the countdown
- **Dying dice:** Juice effects on elimination
- **High score beaten:** Visual "bling" effect
