# Pathbreak — Satisfaction Prototype v1

**Status:** Implemented on isolated prototype branch; pending local Godot verification  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/satisfaction-prototype-v1`  
**Base:** `codex/vertical-slice-level-review`

## Purpose

Test whether Pathbreak can become more satisfying to play and watch without weakening puzzle clarity.

This branch is deliberately isolated from the vertical-slice integration branch. Do not merge it until the remaining vertical-slice platform/accessibility gates are closed and this prototype passes its own verification.

Core rule:

> **Clarity first, satisfaction second, spectacle third.**

## Implemented prototype systems

### 1. Newly-freed dependency detection

`BoardManager` now exposes the set of currently escapable piece IDs and can compare the post-removal board against the pre-removal state.

Only pieces that actually change from:

```text
blocked → escapable
```

are eligible for presentation feedback.

The movement rule remains owned by the existing `MovementValidator` through `BoardManager.can_piece_escape(...)`. No second gameplay truth was introduced.

### 2. One-shot newly-freed path feedback

`PuzzlePiece.play_newly_freed_feedback()` applies one restrained acknowledgement:

- brief navy → blue-accent lift;
- very small shaft-width increase;
- one return to normal state;
- no looping glow;
- no automatic selection;
- no repeated pulsing of paths that were already free.

Reduce Motion uses a shorter static color acknowledgement instead of the animated pulse.

### 3. Unravel rhythm

`LevelManager` captures escapable state before a valid removal, updates occupancy, then determines which remaining pieces became newly free.

A short delayed acknowledgement follows the successful escape so the sequence reads as:

```text
choose
→ release
→ board changes
→ newly freed path acknowledges the dependency
→ choose again
```

The game does not automatically play the newly available path.

### 4. Dependency unlock audio cue

`AudioManager.play_unlock_sound()` adds one deliberately quiet prototype tone when at least one newly freed path is successfully signalled.

There is no extra haptic for this event in v1. The user action keeps the haptic; the causal board response stays quieter.

The current procedural audio remains prototype material, not final production sound design.

### 5. Completion settle

When a level completes, the board performs one very small center-based settle before the result popup appears.

Normal motion:

```text
slight compress
→ slight release
→ neutral board scale
→ result popup
```

Reduce Motion skips the board-scale settle and uses a much shorter result delay.

No camera shake, confetti, fireworks, or unrelated UI bounce was added.

## Files changed

```text
scripts/gameplay/board_manager.gd
scripts/gameplay/puzzle_piece.gd
scripts/gameplay/level_manager.gd
scripts/AudioManager.gd
tests/test_satisfaction_feedback.gd
docs/SATISFACTION_PROTOTYPE_V1.md
```

## Automated test added

`tests/test_satisfaction_feedback.gd` constructs a small deterministic two-piece board:

- piece 1 is blocked by piece 2;
- piece 2 is initially escapable;
- after piece 2 occupancy is removed, piece 1 must be detected as newly escapable.

Expected result:

```text
Satisfaction feedback: 1/1 passed
```

This test and the modified runtime scripts have not yet been executed in the user's local Godot 4.7.1 build.

## Required local verification

Pull the branch:

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/satisfaction-prototype-v1
git pull origin codex/satisfaction-prototype-v1
```

Run:

```bash
GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

"$GODOT" --headless --path . --editor --quit
"$GODOT" --headless --path . --script tests/test_satisfaction_feedback.gd
"$GODOT" --headless --path . --script tests/test_path_visual_geometry.gd
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
"$GODOT" --headless --path . --script tests/test_mobile_project_settings.gd
```

Do not describe the prototype as working until these pass.

## Manual acceptance pass

Use **F5** and focus on Levels 4–5 first because their dependency chains make the new feedback easiest to judge.

Check:

1. A path that was already escapable before the move does **not** pulse again.
2. A genuinely newly freed path receives exactly one acknowledgement.
3. The feedback happens after the cause is readable, not before the escaping path has visibly moved.
4. The pulse does not look like a hint arrow or a command to tap.
5. Multiple newly freed paths can acknowledge without visual chaos.
6. Snake escape geometry is unchanged.
7. Blocked taps are unchanged.
8. Hint/tutorial feedback still works.
9. Automatic final clear remains correct.
10. Completion settle feels calm and does not delay the result screen excessively.
11. High Contrast remains readable.
12. Reduce Motion removes the animated pulse/board settle while preserving the state change.
13. Sound-off disables the unlock cue.
14. Android portrait orientation remains locked.

## Director acceptance criteria

Keep the system only if it makes cause-and-effect feel better without turning the game into an auto-hint experience.

Reject or reduce it if:

- players stare at the blue pulse instead of reading the board;
- newly freed feedback gives away too much of the solution;
- several simultaneous pulses feel noisy;
- the result delay feels slow;
- High Contrast or Reduce Motion becomes less clear;
- Android performance regresses.

## Player test after technical verification

Use three players without explaining the new feedback.

Ask afterward:

1. Did you notice when another path became available?
2. Did that feel satisfying, helpful, neutral, or distracting?
3. Which release felt best?
4. Did any effect make the puzzle harder to understand?
5. Would you watch another 5–10 second clip of the board unravelling?

Do not tell the player that the blue lift is supposed to mean “newly free” before the test.
