# Dice Royal

A falling block puzzle game inspired by Tetris, Puyo Puyo and Devil Dice, developed by Grave Games.

## About

Dice Royal is a mobile puzzle game where players align dice of the same value to eliminate them and score points. The number of dice needed to clear a chain scales with the die's value (e.g. two 2's, three 3's, and so on). Chain reactions and combos create deeper strategic gameplay. Special dice — Mimic, Bomb, Random and Brick — unlock as the level increases and add new ways to clear (or complicate) the grid. Periodic Junk Drops also add dice outside the player's control once unlocked.

This repository contains the mobile version, built in GameMaker with GX.games as the target export platform. It also includes a PC/kiosk display mode (toggle with F11) for convention booth demos — fullscreen, rescaled layout, keyboard/gamepad-oriented UI, and a QR code linking to the mobile version.

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
- Tap right (upper portion of the screen) = Rotate CW
- Tap left (upper portion of the screen) = Rotate CCW
- Tap (lower portion of the screen) = Hold / Swap

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

The game has multiple levels of increasing difficulty, with no hard cap for skilled players. Drop speed increases with each level, and special dice and the Junk Drop mechanic unlock progressively as you level up.

## License

All rights reserved.
