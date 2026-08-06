# Pathbreak — Game Design Document

**Status:** Current vertical-slice design  
**Last reviewed:** 2026-08-07

## 1. Product statement

Pathbreak is an original portrait puzzle game for Android. Players study a board of directional paths and tap paths in an order that lets every path escape without colliding with another path.

The immediate product goal is not a large content library. It is a polished, device-tested vertical slice that proves the core interaction, tutorial, feedback, menus, accessibility, saving, progression, and first-session comprehension.

## 2. Core rules

- A level contains an integer grid and one or more paths.
- Each path occupies one or more cells and may contain orthogonal bends.
- The path's arrowhead defines one cardinal escape direction.
- A path can escape only when every ray extending from its occupied cells in that direction is free of other paths.
- Cells belonging to the same path do not block that path.
- Tapping an escapable path removes its occupancy and animates it off the board.
- Tapping a blocked path records a move and mistake, removes one life, and shows error feedback.
- When exactly one escapable path remains, it previews and clears automatically because no decision remains.
- Automatic final clear does not add another player move.
- The level is completed when every path has escaped.
- The level fails when lives reach zero.

## 3. Player feedback

### Successful tap

- Soft move sound.
- Success haptic when enabled.
- Path changes to blue.
- Path escapes in its arrow direction.
- A short trail is shown unless Reduce Motion is enabled.

### Final automatic clear

- Board input locks after the second-last meaningful move.
- The final valid path turns blue.
- A short directional cue previews its route.
- The path leaves automatically.
- The result screen follows once.
- Reduce Motion uses a shorter static-to-escape transition.
- If the board state is inconsistent or the final path is blocked, automatic clear is cancelled and control returns to the player.

### Blocked tap

- Error sound and haptic.
- Coral path flash.
- Short directional shake.
- Life and mistake count update.
- `That path is blocked` message.

### Hint

- Selects the first currently escapable path.
- Changes the path to blue.
- Moves an accent marker from tail to arrowhead so the direction is explicit.
- Shows `Follow the blue light to the arrow`.
- The first Level 1 tutorial hint is free until the tutorial is completed.
- Other hints consume the persistent hint bank.
- At zero hints, the card becomes a `Refill +3` action and opens a confirmation popup.
- If no path can currently leave, the HUD shows `No path can leave yet` and no hint is consumed.

The current free three-hint refill exists to keep vertical-slice testing unblocked. The launch economy is not yet approved.

## 4. Current connected game loop

1. Open Main Menu.
2. Start from either the primary Start/Continue button or the tappable living-board demonstration.
3. Continue to the first uncleared unlocked level or open Level Select.
4. Play the board using touch or mouse.
5. Use Hint, Restart, Back, or Settings as needed.
6. Fail and retry when lives reach zero, or clear every meaningful dependency until the final path resolves automatically.
7. Review completion time, moves, mistakes, hints used, and stars.
8. Replay or continue to the next level.
9. Persist progress, best results, hint inventory, and settings.

## 5. Main-menu interaction rule

The living-board demonstration looks interactive and is therefore interactive.

- New players see `Start Level 1` and `TAP THE BOARD TO START`.
- Returning players see the recommended level on both the board prompt and Continue button.
- The board demonstration and primary button route through the same guarded navigation path.
- The demonstration uses a moving accent pulse through the path before escape.
- Reduce Motion shows a static accent state instead of the travelling pulse.

## 6. Progression

- Current director-review focus: Levels 1–5.
- The current playable pack contains 10 levels for broader flow testing.
- Level 1: rule discovery and direction cue.
- Level 2: blocking relationship.
- Level 3: bent-path reading.
- Level 4: first representative dependency puzzle.
- Level 5: authored dependency-chain candidate.
- Levels 6–10 remain provisional content and difficulty evidence only.
- Stars are based on mistakes:
  - 3 stars: zero mistakes.
  - 2 stars: one or two mistakes.
  - 1 star: three or more mistakes while still completing the level.
- Completing a level unlocks the next available level.

New-player evidence showed enjoyment but a shallow difficulty curve. Difficulty must be increased through authored dependencies only after arrow and direction comprehension are accepted.

## 7. Current quality gate

The vertical slice is approved only after:

- All automated tests pass without parser warnings.
- Main-menu board and primary button start the same level reliably.
- New players understand where to start without verbal instruction.
- Arrowhead and tail-dot hierarchy communicates direction.
- Tutorial and hint direction cues are understood.
- Automatic final clear completes once and does not increase Moves.
- Fresh-save Level 1 tutorial behavior is verified.
- Levels 1–5 are replayed naturally and recorded.
- At least three people unfamiliar with the boards test the revised slice.
- Android phone and tablet touch are verified.
- Back button, pause, sound, haptics, Reduce Motion, and High Contrast are verified.
- Hint depletion and refill are verified.
- No clipping or unreadable layout appears at target portrait sizes.

## 8. Production roadmap

### Stage A — Approve vertical slice

Finalize gameplay feel, Levels 1–5, start clarity, path readability, tutorial, hint refill, automatic final clear, accessibility, and device behavior.

### Stage B — Build internal content tools

Create a level editor, validator, solver-assisted audit, import/export, and batch test workflow.

### Stage C — Produce launch content

Author and test chapters, difficulty pacing, onboarding, and a launch-sized level pack.

### Stage D — Final art and audio direction

Approve branding, app icon, typography, chapter themes, particles, transitions, sound design, and store presentation.

### Stage E — Commercial systems

Decide and implement ads, purchases, analytics, privacy/consent, crash reporting, and Google Play configuration only after retention and product quality justify them.

## 9. Explicit non-goals for the current branch

- Seventy-five production levels.
- Final monetization economy.
- Online accounts or cloud saves.
- Multiplayer or social features.
- Final logo and marketing campaign.
- Copying another game's boards, visuals, naming, UI, or assets.
