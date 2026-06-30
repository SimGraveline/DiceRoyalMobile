# Dice Royal

A falling block puzzle game inspired by Tetris, Puyo Puyo and Devil Dice, developed by Grave Games.

## About

Dice Royal is a mobile puzzle game where players align dice of the same value to eliminate them and score points. Match two 2's, three 3's, four 4's, five 5's or six 6's to clear them from the grid. Chain reactions and combos create deeper strategic gameplay. Special dice — Mimic, Bomb and Random — unlock as the level increases and add new ways to clear the grid.

This repository contains the mobile version, built in GameMaker with GX.games as the target export platform.

## Status

Prototype / Proof of concept.

## Tech Stack

- **Engine:** GameMaker (GML)
- **Target:** Mobile (GX.games export)
- **Graphics:** 2D vector art

## Controls

The game supports mobile touch, gamepad and keyboard inputs.

### Mobile
- Drag horizontal = Move
- Swipe up = Hard drop
- Swipe down = Soft drop
- Tap right (top 3/4) = Rotate CW
- Tap left (top 3/4) = Rotate CCW
- Tap (bottom 1/4) = Hold / Swap

### Gamepad (Xbox scheme)
- Left stick / D-Pad = Move / Soft drop / Hard drop (up)
- B / Y = Rotate CW
- A / X = Rotate CCW
- LB / RB = Hold
- Start = Pause / Confirm
- Select = Help
- RT + LT = Restart
- Select + Start = Quit

### Keyboard
- A/D or Arrows = Move
- W or Up = Hard drop
- S or Down = Soft drop
- Space = Rotate CW
- Ctrl = Rotate CCW
- Shift = Hold
- ESC = Pause
- Enter = Confirm
- F1 = Help
- M = Mute/unmute music
- Tab = Toggle grid lines

## Levels

The game has 11 levels. Drop speed increases with each level.

| Level | Score | Drop speed | Unlock |
|---|---|---|---|
| 1 | 0 | 0.75s | Dice 1–6 |
| 2 | 5,000 | 0.60s | Random |
| 3 | 10,000 | 0.50s | Bomb |
| 4 | 15,000 | 0.40s | Mimic |
| 5 | 20,000 | 0.30s | — |
| 6 | 25,000 | 0.25s | — |
| 7 | 30,000 | 0.20s | Die 7 |
| 8 | 35,000 | 0.15s | Die 8 |
| 9 | 40,000 | 0.10s | Die 9 |
| 10 | 45,000 | 0.05s | — |
| 11 | 50,000 | 0.01s | — |

## License

All rights reserved.
