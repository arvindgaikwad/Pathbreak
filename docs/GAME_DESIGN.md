# Pathbreak — Game Design Document

**Status:** Current vertical-slice design  
**Last reviewed:** 2026-08-06

## 1. Product statement

Pathbreak is an original portrait puzzle game for Android. Players study a board of directional paths and tap paths in an order that lets every path escape without colliding with another path.

The immediate product goal is not a large content library. It is a polished, device-tested five-level vertical slice that proves the core interaction, tutorial, feedback, menus, accessibility, saving, and progression.

## 2. Core rules

- A level contains an integer grid and one or more paths.
- Each path occupies one or more cells and may contain orthogonal bends.
- The path's arrowhead defines one cardinal escape direction.
- A path can escape only when every ray extending from its occupied cells in that direction is free of other paths.
- Cells belonging to the same path do not block that path.
- Tapping an escapable path removes its occupancy and animates it off the board.
- Tapping a blocked path records a move and mistake, removes one life, and shows error feedback.
- The level is completed when every path has escaped.
- The level fails when lives reach zero.

## 3. Player feedback

### Successful tap

- Soft move sound.
- Success haptic when enabled.
- Path changes to blue.
- Path escapes in its arrow direction.
- A short trail is shown unless Reduce Motion is enabled.

### Blocked tap

- Error sound and haptic.
- Coral path flash.
- Short directional shake.
- Life and mistake count update.
- `That path is blocked` message.

### Hint

- Selects the first currently escapable path.
- Pulses that path in blue.
- Shows `Tap the blue path`.
- The first Level 1 tutorial hint is free until the tutorial is completed.
- Other hints consume the persistent hint bank.
- At zero hints, the card becomes a `Refill +3` action and opens a confirmation popup.

The current free three-hint refill exists to keep vertical-slice testing unblocked. The launch economy is not yet approved.

## 4. Current connected game loop

1. Open Main Menu.
2. Continue to the first uncleared unlocked level or open Level Select.
3. Play the board using touch or mouse.
4. Use Hint, Restart, Back, or Settings as needed.
5. Fail and retry when lives reach zero, or clear all paths.
6. Review completion time, moves, mistakes, hints used, and stars.
7. Replay or continue to the next level.
8. Persist progress, best results, hint inventory, and settings.

## 5. Progression

- Current slice: Levels 1–5.
- Level 1: tutorial board with two obvious safe openings.
- Levels 2–3: compact introductory dependency patterns.
- Level 4: representative mid-slice puzzle and failure/retry test.
- Level 5: single-opening dependency-chain candidate.
- Stars are based on mistakes:
  - 3 stars: zero mistakes.
  - 2 stars: one or two mistakes.
  - 1 star: three or more mistakes while still completing the level.
- Completing a level unlocks the next available level.

Exact final difficulty, star thresholds, hint economy, and chapter pacing remain subject to playtesting.

## 6. Current quality gate

The five-level slice is approved only after:

- All automated tests pass without parser warnings.
- Fresh-save Level 1 tutorial behavior is verified.
- Levels 1–5 are replayed naturally and recorded.
- At least three people unfamiliar with the boards test the slice.
- Android phone and tablet touch are verified.
- Back button, pause, sound, haptics, Reduce Motion, and High Contrast are verified.
- Hint depletion and refill are verified.
- No clipping or unreadable layout appears at target portrait sizes.

## 7. Production roadmap

### Stage A — Approve vertical slice

Finalize gameplay feel, Levels 1–5, tutorial, hint refill, accessibility, and device behavior.

### Stage B — Build internal content tools

Create a level editor, validator, solver-assisted audit, import/export, and batch test workflow.

### Stage C — Produce launch content

Author and test chapters, difficulty pacing, onboarding, and a launch-sized level pack.

### Stage D — Final art and audio direction

Approve branding, app icon, typography, chapter themes, particles, transitions, sound design, and store presentation.

### Stage E — Commercial systems

Decide and implement ads, purchases, analytics, privacy/consent, crash reporting, and Google Play configuration only after retention and product quality justify them.

## 8. Explicit non-goals for the current branch

- Seventy-five production levels.
- Final monetization economy.
- Online accounts or cloud saves.
- Multiplayer or social features.
- Final logo and marketing campaign.
- Copying another game's boards, visuals, naming, UI, or assets.
