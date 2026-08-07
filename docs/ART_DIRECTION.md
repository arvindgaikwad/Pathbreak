# Pathbreak — Art Direction and UI System

**Status:** Provisional vertical-slice baseline  
**Last reviewed:** 2026-08-07  
**Important:** This document describes the current playable build. It is not the final launch art direction. Final branding, iconography, typography, effects, and store presentation remain subject to a dedicated art-direction pass after the vertical slice is approved.

## 1. Visual objective

Pathbreak should feel calm, precise, readable, and premium on Android phones and tablets. The game must remain visually original and must not imitate another puzzle game's branding, screen composition, icon set, level layouts, or trade dress.

The current build uses a light interface so path readability, touch clarity, and first-session comprehension can be evaluated before heavier visual production begins.

## 2. Current palette

| Role | Value | Current use |
|---|---|---|
| App background | `#F8F6F0` | Warm neutral canvas |
| Elevated surface | `#FFFFFF` | Cards, dialogs, result panels |
| Primary path and heading | `#1B2538` | Puzzle paths and main text |
| High-contrast path | `#07101F` | Accessibility mode |
| Primary accent | `#3B82F6` | Direction cues, successful movement, hints, primary buttons |
| Pressed accent | `#2563EB` | Pressed primary actions |
| Secondary text | `#717D93` | Supporting labels and descriptions |
| Border | `#E7EBF1` | Card and dialog outlines |
| Error | `#EF5B5B` | Blocked-path feedback and mistakes |
| Reward | `#F5A623` | Stars and completion emphasis |

These values are implementation constants, not a locked brand palette.

## 3. Puzzle-path language

Paths are rendered programmatically rather than as copied raster assets.

- Rounded `Line2D` segments and joints.
- Small circular tail marker at the first occupied cell.
- Larger directional arrowhead at the exit end.
- The arrowhead must carry more visual weight than the tail dot.
- Deep navy idle state.
- Blue successful-escape and hint state.
- Coral blocked-tap state.
- Optional high-contrast path color.
- A moving blue marker travels from tail to arrowhead during tutorial and hint guidance.
- Reduced-motion mode replaces travelling guidance with static blue emphasis and shorter transitions.

The moving marker is instructional, not ambient decoration. It should appear only where direction comprehension or a selected hint benefits from it.

## 4. Current screen hierarchy

### Main menu

- Small provisional arrow mark.
- Pathbreak title and one-line value statement.
- Tappable living-board demonstration.
- Explicit board prompt: Start, Continue, or Replay depending on save state.
- Progress summary.
- Primary Start/Continue action.
- Secondary Level Select and How to Play actions.

The living board now behaves like the game-like object it appears to be. A blue segment travels through one path before that path escapes. Tapping anywhere on the board starts the same recommended level as the primary button.

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
- Final path: blue preview and automatic escape after the last meaningful player decision.
- Blocked path: coral flash, directional shake, sound, haptic, mistake/life update.
- Hint: valid path turns blue and a marker travels toward the arrowhead.
- No valid move: retain the plain-language `No path can leave yet` message.
- Buttons/cards: small press-scale response and clear disabled states.
- Overlays: dimmed backdrop and centered elevated panel.

## 6. AI anti-slop visual rules

- Do not treat more cards, larger shadows, gradients, or glow as automatic polish.
- Do not use emoji as final production icons.
- Do not add motion without a communication or feedback purpose.
- Do not let decorative demonstrations compete with primary actions unless they are genuinely interactive.
- Do not hide weak hierarchy behind visual polish.
- The final identity must introduce an ownable Pathbreak motif beyond warm white surfaces and blue accents.

## 7. Accessibility requirements

- Persistent Sound and Haptics controls.
- Persistent Reduce Motion setting.
- Persistent High Contrast setting.
- Touch targets should remain comfortable on compact phones.
- Information must not depend only on color.
- Arrowhead shape must remain readable without motion.
- Text must remain readable from 360×800 through tablet portrait sizes.

## 8. Deferred final-art work

The following are intentionally not approved yet:

- Final logo and app icon.
- Final font family and licensing choice.
- Final background treatment and chapter themes.
- Production particle system and screen transitions.
- Final sound library and music direction.
- Store screenshots, feature graphic, trailer, and marketing key art.
- Monetization-specific visuals.

The next final-art pass begins only after gameplay, menu start clarity, path direction comprehension, tutorial, automatic final clear, hint refill, device input, and Levels 1–5 pass the vertical-slice quality gate.
