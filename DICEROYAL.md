# DICE ROYAL - DESKTOP

Dice Royal is a falling block puzzle game, inspired by Tetris, Puyo Puyo and Devil Dice. Built in GameMaker Studio, this build targets PC (Steam), fullscreen, with keyboard and gamepad controls. A mobile version is planned as a follow-up port once the PC version ships.

The build currently runs logo, splash, game, pause, help and game over screens. The full menu structure described below is designed but not yet built, and achievements, leaderboards and rewards are not in yet.

## Project History

Several prior attempts at making this game ended in failure. The two recurring blockers were the pair detach logic and the chain drop behavior. Both have been resolved with the following decisions:

1. **Pair: Hybrid approach.** The pair is a logical entity that handles movement and rotation while active. As soon as one die lands on something (grid floor or stacked die), the pair detaches and each die becomes autonomous for the falling/resolution phase.
2. **Grid: Simulation approach.** The grid is the single source of truth. All logic (matching, clearing, gravity) operates on it directly, not on what's visually drawn.

This document and the mockup (DICEROYAL.jpg) are sources of truth for design. When they contradict each other, this document prevails; the mockup is not systematically kept in sync.

## Gameplay

### Rules

Players eliminate dice by chaining identical values orthogonally (up, down, left, right — no diagonals). A chain is valid when the number of connected dice is equal to or greater than the die value: two or more 2's, three or more 3's, four or more 4's, five or more 5's, six or more 6's.

*Design note: values 7, 8 and 9 are currently disabled. Once Bomb, Mimic, Brick and Junk Drop were in place, "bigger number, longer chain" stopped adding anything the other mechanics didn't already do better, and a 9-sided die didn't fit the game's dice theme. May be revisited.*

Eliminated dice enter a "dying" state with a visible fade-out. A die dying as part of a genuine chain reaction (see below) also shakes, and the screen background tints to the color of the value being eliminated — both signal an active chain rather than a one-off elimination. Dying propagates: any non-dying die orthogonally adjacent to a dying die of the same value also becomes dying, along with all of its connected same-value dice — but only when that neighbor is dying as part of a chain reaction (the original elimination, or anything that already joined or cascaded into it, or a suite). A die eliminated by Bomb or Clear Row/Column is never part of a chain: it stays calm and doesn't shake, it leaves the background untinted, it never propagates, and nothing can join it — see their entries below. This propagation cascades until no more dice can be reached. Each die that enters dying gets its own independent timer.

1's are a special case: they never match on their own. A 1 orthogonally adjacent to a chain-dying die (any value, but only if that neighbor is dying as part of a chain reaction — not Bomb or Clear, see above) triggers the elimination of all 1's on the grid.

Dying dice do not fall — they float in place if their support is removed. They remain solid (occupy their cell) until their timer expires. Once a dying die's timer expires, it is removed from the grid and its cell becomes empty. Non-dying dice above empty cells fall instantly (gravity). Gravity can create new chains, triggering further dying cycles — each such cycle is one "wave", and consecutive waves are what the game counts and rewards as a chain (see Score).

### Mechanics

**Grid:** Column and row count are tunable and still being playtested. A dead zone row sits directly above the grid's visible rows, where pairs spawn. If any die is left resting in the dead zone once the grid is at rest (no active clearing, falling or chain resolution), the game is over — the stack has reached the spawn row.

**Pair movement:** A pair spawns at the top center of the grid, in the dead zone. The left die is the "master"; the right die rotates around it into four orthogonal positions. Pairs move in fixed one-cell increments and snap to the grid. After stacking, the next pair spawns at the previous pair's X position.

**Lock delay:** When one die of a pair touches something (grid floor or stacked die), a lock timer begins. During this window, the player can still move and rotate the pair. Each successful action resets the timer, up to a maximum number of resets. When the timer expires, the pair detaches.

**Detach:** When the lock delay expires (or a hard drop occurs), the pair detaches. The landed die is written to the grid. The other die always snaps instantly to the lowest available position in its column first — reaching solid ground (including a still-dying die) always happens before anything else is decided. Once it lands, if it's adjacent to a chain-dying die of the same value, it also joins that chain (see Rules above for what counts as a chain). After detach, a new pair spawns immediately — the player does not wait for dying or chain resolution to finish.

**Wall kick:** If rotation is blocked by a wall, the pair shifts one cell to allow it. If the shifted position is also blocked, the rotation is denied. Rotation blocked by a stacked die is always denied (no kick) to prevent dice from overlapping.

**Soft drop:** Boosts the drop speed while held. The player can still move and rotate during a soft drop. Holding Down also shortens the lock delay considerably, so a pair driven into the stack commits close to the moment of contact instead of idling out the full delay. Releasing Down before it locks hands the full delay back.

**Hard drop:** Instantly snaps the pair to the first available stacking position. The player cannot control the pair during a hard drop.

**Hold:** The player can store one pair for later (one swap per active pair). The stored pair resets to horizontal orientation. When swapping, the pair from the hold box takes the active pair's current position and orientation. If the hold box was empty, the next queued pair spawns normally. The whole feature can be switched off from the pause screen, which hides the hold box and disables the action.

**Next:** The screen displays the next pair to spawn.

**Ghost:** A semi-transparent preview shows where the pair would land if hard-dropped, with a trail connecting it to the falling pair. Can be toggled on/off from the pause screen, where it's called "Enable Preview". A Junk Drop never shows one.

**Match preview:** While the player moves the pair around, any chain it would complete on landing lights up — the whole group on the stack, plus the die still in the player's hands, so the connection between the two is explicit. It reads the board exactly as it stands at that moment and never anticipates what the board will become: dice already fading count as solid ground to land on, but can't be part of the group, since a die on its way out can't join a new chain. Only ordinary same-value chains are shown; suites, the 1's rule and the special dice have no preview.

### Score

Player scores points by:
- Stacking a die: a small fixed amount per die when it lands on the grid. This applies to every die type, special or not — the stack action itself is what scores, independent of any special effect. A die delivered by a Junk Drop is the one exception: it scores nothing on landing, only on elimination, since by that point it's just an ordinary die on the board.
- Eliminating dice: every die scores the same way on elimination, special or not — there's no separate scoring rule for specials, only a different base amount. A die showing a real face is worth an amount proportional to that face, so higher values pay more. A die that dies while still holding a special identity (Bomb, Brick, Clear Row/Column, a Mimic that never found a value to copy) pays a single flat amount instead, the same for all of them. A Random or a Mimic that resolved has a real face by the time it dies, so it scores as the die it became.
- Suite elimination: forming a consecutive ascending or descending sequence (1–N or N–1) in a row or column, where N is the highest currently unlocked die value, eliminates the whole sequence. On top of what those dice score individually, a suite pays a bonus that grows with the length the suite had to be — recognition that a full ascending run is the hardest formation in the game to build on purpose. That bonus is deliberately flat: it does not go through the chain multiplier below.

Suite dice enter dying state normally and can trigger cascade propagation.

**Chain multiplier:** each successive wave of eliminations within the same chain is worth *more* than the one before it, on a hand-tuned curve with widening steps — the deeper a player carries a cascade, the more each remaining die pays. The curve is a fixed table with one entry per wave; past the last entry it holds at its highest value rather than climbing forever.

The counter feeding this multiplier is the same one shown as "Chains" on screen: it counts waves that are part of a genuine chain reaction only. Eliminations from a Bomb or a Clear Row/Column never advance it, so the reward and the number the player reads always tell the same story. It resets once the grid has fully settled.

The game saves the high score persistently.

Scores are also posted to an online leaderboard, presented as the player's own standing and as a global ranking.

### Special Dice

Six special die types can appear in pairs, each unlocking at its own level as the game progresses. At most one special die can appear per pair; the other die is always a normal die. Odds are calculated so each special keeps a consistent probability regardless of how many normal die values are currently unlocked, and stay constant for good once unlocked — no further change later in a run.

| Die | Behavior |
|---|---|
| Mimic | On landing, copies the value of the die directly below it. If no normal die is below (or it lands on the floor), it stays idle ("unresolved") until a die lands on top of it or beneath it. |
| Bomb | On landing, reads whatever is directly below it and eliminates every matching thing on the grid: a value (all dice of that value), a Brick (every Brick), or another Bomb (every Bomb). An unresolved Mimic is never a valid target. If nothing valid is below, it stays idle until something valid lands on top of it or beneath it. The Bomb itself doesn't disappear instantly — it fades out alongside its targets, and while it's fading, a new die placed directly on it re-triggers another grid-wide elimination on that die's value, letting a single Bomb chain multiple clears if the player keeps feeding it. Each re-trigger also restarts its fade, so a well-fed Bomb stays alive longer. That's the only way to add to a Bomb's kill, though — like Clear Row/Column, none of its eliminated targets can be joined by a new die placed near them while they fade; they're not part of a chain.<br><br>*Design note: dropping a vertical pair with the Bomb on the bottom fires it twice for free — the Bomb resolves against whatever it lands on, then its own partner falls onto it and re-triggers it on a second value. This is a known, deliberately kept exploit: the player still has to hold the pair vertical, orient the Bomb downward, pick a worthwhile column, and spend the upper die as a detonator rather than playing it.* |
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
| Lock delay duration | Time before a touching pair detaches, with a separate shorter value while the player holds Down |
| Lock delay resets | Max actions that reset the lock timer |
| Spawn odds | Weight per die value, controls spawn probability |
| Special die odds | Probability of each special die appearing, independent of the normal pool |
| Soft drop multiplier | Speed boost factor during soft drop |
| Dying duration | How long eliminated dice stay in "dying" state before being removed (shorter = less time to chain) |
| Junk Drop rate & quantity | How often a Junk Drop triggers, and how many dice it drops each time |

## Menus

*Designed, not yet built. This section is the authority on navigation — not on layout, which is still being mocked up screen by screen.*

### Shared Template

Navigation screens share one page: the page title top left, a large "selection preview" frame filling the left side, the list of items right-aligned on the right, a one-line subtitle for the highlighted item below the list, and the input prompt bottom right.

Each item in the list carries a die, and the face it shows is the item's rank in the list — first item is a 1, second is a 2, and so on. That caps a list at six items. The one exception is the main menu's Quit row, which sits outside the series and carries a blank die face.

The preview frame is deliberately generic: it holds whatever the current screen needs it to hold — a block of text, a score table, an animated demonstration of a rule, a control diagram. A few screens (options, leaderboards, controls, customize) will need a layout of their own rather than this one.

Menus are navigable by mouse, keyboard and gamepad. The mouse is never used to play.

### Boot Sequence

GameMaker logo, studio logo, language selection, a notice screen, the splash screen, then the main menu.

Language selection appears on the first launch only; afterwards the language is changed from the options. The notice screen — telling the player the game saves automatically when a given icon appears, and carrying a photosensitivity warning — appears on every launch.

### Structure

- **Main Menu** — Select Mode, Rewards, Stats, Achievements, Help, Options, Quit
- **Select Mode** — Arcade, Challenge, Casual
  - **Arcade** is the standard mode. **Casual** is the gentler one: a lower difficulty curve, no Junk Drop, no Bricks. **Challenge** is a set of unlockable set-piece runs, still to be designed.
  - Arcade offers Start, Customize, Leaderboards and Options. Casual offers the same minus Leaderboards — it isn't a competitive mode. Challenge offers only a challenge picker: confirming a challenge starts it, and its settings are dictated by the challenge itself rather than by the player, so it has no options of its own.
- **Customize** — pick a visual theme, or let it change on its own as the player levels up
- **Stats** — per mode
- **Rewards** — to be designed
- **Leaderboards** — the player's own standing, and the global ranking
- **Achievements** — the full list with completion state
- **Help** — the rules, a dice index covering the specials, and the control schemes for keyboard and gamepad
- **Options** — split in two. Global settings (language, music, sound effects, rumble, grid shake, credits) apply everywhere. Gameplay settings (dice preview, chain preview, next preview, hold, grid lines) belong to each mode separately and are saved that way, so a player can run Arcade bare and Casual fully assisted.

## Screens

### Logo Screens

Two logo screens displayed on launch (timings adjustable): a "proudly made with" GameMaker credit, followed by the studio logo with a "presents" tag.

### Splash Screen

Title screen shown after the logos: game title centered, with a blinking "Press Any Key / Buttons" prompt below, a "Beta Version" tag above and a credits line at the bottom of the screen. Background features a falling dice rain effect. Almost any input starts the game — keyboard, mouse click, or a gamepad face/shoulder/Start/Select button, but deliberately not the D-Pad or the analog sticks, so a resting hand can't launch a run. Confirming leads to the main menu via a fade transition.

### Game Screen

The grid sits centered, with the HUD split into two columns of boxes flanking it. All boxes share the same frame, with their label inside at the top and their content below.

- **Left column:** Score, High Score, Level, Chains. The High Score box updates live during the run, the moment the current score passes it. The Chains box shows the current chain length ("Last", live as the cascade unfolds) and the best chain of the run ("Best").
- **Right column:** Unlocks, Next, Hold / Swap. The Unlocks box shows one tile per special mechanic — dimmed while locked, full color once unlocked — with a line underneath naming the next thing to unlock and the level it arrives at, or "ALL UNLOCKED" once everything is in.

There is no on-screen pause or help button — both are keyboard/gamepad only (see Controls).

### Pause Screen

Accessed via ESC or Enter (keyboard), or Start (gamepad). Not available during the countdown. Shows, in three groups:
- Resume / Restart (soft restart, no logos) / Help
- Mute Music toggle / Mute SFX toggle
- Show Grid / Show Queue / Enable Hold / Swap / Enable Preview toggles
- Quit (return to splash)

The three display toggles change the game screen directly: Show Queue hides the Next box, Enable Hold / Swap hides the Hold box *and* disables the action itself, and Enable Preview turns off the landing ghost. Once the mode structure is in, these settings will belong to the mode being played rather than to the game as a whole — changing one mid-run will change it for that mode only.

Navigable by mouse, keyboard or gamepad, all live at once. One row is always highlighted, starting on the first. The mouse only takes the highlight on an actual mouse movement past a small threshold — a hand resting on the desk can't steal the selection from the keyboard — and keyboard/gamepad always win on the frame they move.

### Help Screen

Reached only from the pause menu's Help row. Shows "HOW TO PLAY" with the elimination rules and a "CONTROLS" list, plus a Back row to return to the pause menu. Game stays paused while help is open.

Future: auto-show on first game after launch with a "Don't show again" option.

### Game Over Screen

Displayed when the grid is at rest and a die is left resting in the dead zone. A short delay prevents accidental input. Shows:
- "GAME OVER" title
- "NEW BEST!" — only if the high score was beaten
- Current score and high score
- Restart / Quit menu

### Countdown

A "3-2-1-STACK!" countdown plays before gameplay begins, at game start and after a soft restart.

### Fade Transition

A zoom-in/zoom-out die transition used between the splash and game screens. The countdown starts only after the fade completes.

## Display

Fullscreen at the desktop's resolution. The grid is rescaled to occupy most of the screen height (same column/row count, bigger cells); width follows from that since the grid's proportions don't change.

## Controls

### Gamepad (Xbox scheme)
- Left stick or D-Pad = Move / Soft drop / Hard drop (up)
- B or Y = Rotate CW
- A or X = Rotate CCW
- LB or RB = Hold
- Start = Pause / Confirm
- Select = Toggle grid lines
- RT + LT = Restart
- Select + Start = Quit

### Keyboard
- A/D or arrows = Move
- W or up = Hard drop
- S or down = Soft drop
- Space = Rotate CW
- Ctrl (L/R) = Rotate CCW
- Shift (L/R) = Hold
- ESC or Enter = Pause
- Enter or Space = Confirm
- M = Mute/unmute music
- Tab = Toggle grid lines

Help has no direct key — it's opened from the pause menu.

### Mouse
- Click menu items (splash, pause, help, game over)
- Not used to control the falling pair — that's keyboard/gamepad only

## Layout

The mockup (DICEROYAL.jpg) communicates layout intent from an earlier mobile-oriented pass, not the current PC layout or exact dimensions.

| Element | Position |
|---|---|
| Die / grid cell | Square, one cell per die, size is tunable |
| Grid | Centered on screen, with one dead zone row above the visible rows |
| Left HUD column | Score, High Score, Level, Chains — stacked between the grid's left edge and the screen edge |
| Right HUD column | Unlocks, Next, Hold / Swap — stacked, mirroring the left column |

Both columns are sized to start and end at the same height on screen, whichever one holds more content; the shorter column stretches its gaps to match rather than leaving one side visibly short.

## Audio

Two versions of the game theme exist: a vocal version for the splash screen and an instrumental version for gameplay. Both loop indefinitely. The player can mute/unmute music (M key, or from the pause menu). SFX are independent from music mute, and have their own toggle in the pause menu. Elimination has two distinct sounds: one for a die dying as part of a genuine chain, another, calmer one for a die removed artificially by a Bomb or a Clear Row/Column — the same split that decides which dice shake. Sounds cannot overlap to avoid audio clutter.

## Presentation

- **Splash screen:** Rain of dice in the background
- **Game screen:** Scrolling background pattern
- **Transitions:** Fade in/out between screens; one transition features a large die zooming in/out before the countdown
- **Dying dice:** Juice effects on elimination
- **High score beaten:** Visual "bling" effect
- **Impact:** The grid itself takes a downward punch when a landing is the player's own doing, easing back to rest. Only the grid and its contents move — the HUD boxes and menu panels stay perfectly still around it, and nothing about the shake can affect where a die actually lands. A hard drop punches at full weight; a soft drop punches lighter. A pair that simply times out on the lock delay gets nothing, and neither does a Junk Drop: the punch and the rumble are feedback for an action the player took, so an event they merely receive stays silent. The timing matters as much as the weight — a hit that arrives long after the dice visibly settled reads as a random jolt instead of an impact, which is why a soft drop commits on a much shorter lock delay than a pair left to time out.
- **Chain shake:** While a chain is going off, the grid jitters on both axes, re-triggered by each new wave, so a long cascade shakes continuously.
- **Match preview glow:** The dice about to be eliminated light up from within and breathe slowly, rather than being outlined — the group reads as one glowing mass. Tinted to the value going out, brightened enough that even the darkest values carry light. Visual direction not final.
- **Gamepad rumble:** Mirrors both effects on the same triggers and durations — a short decaying punch on landing, a sustained buzz through a chain, the stronger of the two winning if they overlap. It cuts out immediately on pause or game over rather than being left buzzing.
