# Dice Royal

A falling block puzzle game inspired by Tetris, Puyo Puyo and Devil Dice, developed by Grave Games.

## About

Dice Royal is a mobile puzzle game where players align dice of the same value to eliminate them and score points. Match two 2's, three 3's, four 4's, five 5's or six 6's to clear them from the grid. Chain reactions and combos create deeper strategic gameplay.

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
- Start = Pause
- Select = Restart
- Select + Start = Quit

### Keyboard
- A/D or Arrows = Move
- W or Up = Hard drop
- S or Down = Soft drop
- Space = Rotate CW
- Ctrl = Rotate CCW
- Shift = Hold
- ESC = Pause
- M = Mute/unmute music
- Tab = Toggle grid lines

## Levels

The game has 11 levels. Drop speed increases with each level.

| Level | Score | Drop speed |
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

## License

All rights reserved.
