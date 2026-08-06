# Pathbreak — Art Direction and UI System

**Status:** Provisional vertical-slice baseline  
**Last reviewed:** 2026-08-06  
**Important:** This document describes the current playable build. It is not the final launch art direction. Final branding, iconography, typography, effects, and store presentation remain subject to a dedicated art-direction pass after the five-level vertical slice is approved.

## 1. Visual objective

Pathbreak should feel calm, precise, readable, and premium on Android phones and tablets. The game must remain visually original and must not imitate another puzzle game's branding, screen composition, icon set, level layouts, or trade dress.

The current build uses a light interface so path readability and touch clarity can be evaluated before heavier visual production begins.

## 2. Current palette

| Role | Value | Current use |
|---|---|---|
| App background | `#F8F6F0` | Warm neutral canvas |
| Elevated surface | `#FFFFFF` | Cards, dialogs, result panels |
| Primary path and heading | `#1B2538` | Puzzle paths and main text |
| High-contrast path | `#07101F` | Accessibility mode |
| Primary accent | `#3B82F6` | Successful movement, hints, primary buttons |
| Pressed accent | `#2563EB` | Pressed primary actions |
| Secondary text | `#717D93` | Supporting labels and descriptions |
| Border | `#E7EBF1` | Card and dialog outlines |
| Error | `#EF5B5B` | Blocked-path feedback and mistakes |
| Reward | `#F5A623` | Stars and completion emphasis |

These values are implementation constants, not a locked brand palette.

## 3. Puzzle-path language

Paths are rendered programmatically rather than as copied raster assets.

- Rounded `Line2D` segments and joints.
- Circular tail marker at the first occupied cell.
- Directional arrowhead at the exit end.
- Deep navy idle state.
- Blue successful-escape and hint state.
- Coral blocked-tap state.
- Optional high-contrast path color.
- Reduced-motion mode removes or shortens decorative motion.

## 4. Current screen hierarchy

### Main menu

- Small provisional arrow mark.
- Pathbreak title and one-line value statement.
- Progress summary.
- Primary Continue/Play action.
- Secondary Level Select action.

The arrow mark is temporary and must not be treated as the final logo.

### Level select

- Chapter label and completion summary.
- Compact numbered level cards.
- Locked, unlocked, current, and completed states.
- Stars shown only where completion data exists.

### Gameplay HUD

- Top row: Back, level title/difficulty, Settings.
- Supporting instruction line.
- Bottom cards: Lives, Hint/Refill, Restart.
- Empty hint state changes to a visible `+3` refill action rather than becoming disabled.

### Completion and utility overlays

- Result popup with level result, stars, time, moves, mistakes, hints used, Replay, and Next Level.
- Pause/settings overlay for Sound, Haptics, Reduce Motion, High Contrast, Restart, and Menu.
- Hint-refill popup with a focused `+3 Hints` action.

## 5. Interaction feedback

- Valid path: blue transition, escape movement, soft trail when motion is enabled, sound, and success haptic.
- Blocked path: coral flash, directional shake, sound, haptic, mistake/life update.
- Hint: valid path pulses blue and the HUD says `Tap the blue path`.
- Buttons/cards: small press-scale response and clear disabled states.
- Overlays: dimmed backdrop and centered elevated panel.

## 6. Accessibility requirements

- Persistent Sound and Haptics controls.
- Persistent Reduce Motion setting.
- Persistent High Contrast setting.
- Touch targets should remain comfortable on compact phones.
- Information must not depend only on color.
- Text must remain readable from 360×800 through tablet portrait sizes.

## 7. Deferred final-art work

The following are intentionally not approved yet:

- Final logo and app icon.
- Final font family and licensing choice.
- Final background treatment and chapter themes.
- Production particle system and screen transitions.
- Final sound library and music direction.
- Store screenshots, feature graphic, trailer, and marketing key art.
- Monetization-specific visuals.

The next art-direction pass begins only after gameplay, tutorial, hint refill, device input, and Levels 1–5 pass the vertical-slice quality gate.
