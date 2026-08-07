# Pathbreak — Satisfaction Prototype v1

**Status:** Release Polish v2 implemented; pending local Godot and director verification  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/satisfaction-prototype-v1`  
**Base:** `codex/vertical-slice-level-review`

## Purpose

Test whether Pathbreak can become more satisfying to play and watch without weakening the puzzle itself.

Core rule:

> **Clarity first, satisfaction second, spectacle third.**

A second rule is locked from the first director playtest:

> **The game must not automatically identify the next correct path. Solution-revealing assistance belongs to the explicit Hint system.**

## Director finding — newly-freed path cue REJECTED

The first prototype highlighted a path when it changed from blocked to escapable. Although the causal effect was readable, the director found that it effectively gave away the next answer.

That created three product problems:

1. it weakened the player's need to inspect the board;
2. it reduced the value and purpose of the Hint button;
3. it turned satisfying feedback into passive guidance rather than earned discovery.

Therefore the automatic newly-freed visual pulse and unlock audio are rejected as normal gameplay behavior.

`BoardManager` still contains dependency-state detection helpers because they may later be useful for level-editor analysis, difficulty metrics, automated tests, and internal debugging. `play_newly_freed_feedback(...)` deliberately returns `0` and performs no presentation.

No level data, solver rule, occupancy rule, movement rule, hint count, or difficulty changed.

## Locked satisfaction rule

Normal gameplay:

```text
player reads the board
→ player chooses a path
→ game rewards that chosen action
→ player inspects the changed board
→ player discovers the next move
```

Hint:

```text
player explicitly asks for help
→ game identifies an escapable path
```

Future feel work may enhance the selected path, the escaping motion, whole-board completion, sound, haptics, or non-directional material response. It must not automatically single out an unchosen correct path.

---

## Release Polish v2 — IMPLEMENTED, PENDING VERIFICATION

Release Polish v2 focuses only on the path the player already selected.

### Target sequence

```text
correct tap
→ ~45 ms tactile visual activation
→ blue release state
→ head leads
→ body follows authored corners
→ body straightens
→ slight late acceleration off-board
→ board is immediately readable again
```

### Implementation

`scripts/gameplay/puzzle_piece.gd` now adds:

- a 30 ms activation rise;
- a 15 ms activation settle;
- a small temporary shaft-width increase on the selected path only;
- selected-path navy → blue activation;
- no scale pulse on neighbouring paths;
- no particles or trail system yet;
- the existing ordered snake geometry remains unchanged;
- bent paths keep the accepted linear corner-uncoil phase;
- acceleration begins only after a bent path has straightened;
- straight paths use a very mild full-release acceleration curve;
- Reduce Motion keeps the previous short translation/fade path.

Full-motion release timing is intentionally kept within roughly **270–300 ms total** so the effect does not delay the player's next reasoning step.

### Rejected cleanup

The old `PuzzlePiece.play_newly_freed_feedback()` implementation and its dedicated visual tween were removed from the path renderer. The board-level presentation safeguard remains the authority that normal gameplay must not reveal newly escapable paths.

### Why no particles yet

Particles, wakes, glow trails, and larger material effects are deliberately postponed. The selected path's own movement must feel strong before decorative effects are considered.

---

## Existing accepted feel systems

### Living-path release

```text
player chooses a path
→ head leads
→ body follows through its corners
→ path straightens
→ path exits
```

### Blocked-path resistance

Blocked taps keep their restrained recoil, sound, haptic, and life/mistake consequence. The feedback communicates resistance without solving anything for the player.

### Completion settle

The small board settle after the final automatic clear remains in the prototype.

```text
last path escapes
→ tiny board compress/release
→ neutral scale
→ result screen
```

Reduce Motion skips this scale animation and uses the shorter result transition.

---

## Automated verification

New test:

```text
tests/test_release_polish.gd
```

It checks:

1. full-motion release remains inside the 270–300 ms budget;
2. a bent path completes its authored uncoil before off-board acceleration begins;
3. Reduce Motion remains a 0.18 second simple escape.

The existing satisfaction safeguard also remains required:

```text
tests/test_satisfaction_feedback.gd
```

It verifies that internal blocked → escapable analysis can exist without producing any player-facing answer reveal.

### Run

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/satisfaction-prototype-v1
git pull origin codex/satisfaction-prototype-v1

GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

"$GODOT" --headless --path . --editor --quit
"$GODOT" --headless --path . --script tests/test_release_polish.gd
"$GODOT" --headless --path . --script tests/test_satisfaction_feedback.gd
"$GODOT" --headless --path . --script tests/test_path_visual_geometry.gd
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
"$GODOT" --headless --path . --script tests/test_mobile_project_settings.gd
```

Expected new results:

```text
Release polish: 3/3 passed
Satisfaction safeguard: 1/1 passed
```

Do not describe Release Polish v2 as verified until the user's Godot output confirms this.

---

## Manual director pass

Use **F5** and play Levels 3, 4, and 5.

Judge these points:

1. Correct tap feels acknowledged immediately.
2. The selected path briefly feels more alive before movement without looking like a button animation.
3. Snake geometry still follows every authored corner correctly.
4. Bent paths do not accelerate until their bend has travelled out of the body.
5. The final straight exit feels a little faster and cleaner than the uncoil phase.
6. Straight paths remain crisp rather than sluggish.
7. No unchosen path changes color, width, motion, or sound because it became escapable.
8. Hint remains clearly useful.
9. The next board-reading decision is not delayed.
10. Reduce Motion still feels immediate and readable.
11. High Contrast remains readable.
12. Completion settle remains subtle.

### Director acceptance criterion

Keep Release Polish v2 only if the selected action feels noticeably better **and** the player can immediately return to reasoning.

Reject or reduce it if:

- the activation pause feels sluggish;
- the width change looks like a hint or selection state that lingers;
- late acceleration looks like a teleport;
- snake corner readability regresses;
- the effect attracts more attention than the puzzle itself.

## Current decision state

**Rejected:** automatic blocked → escapable path acknowledgement in normal play.

**Pending verification:** Release Polish v2.

**Still accepted:** snake/uncoil geometry, blocked resistance, final automatic clear, completion settle, explicit hints.

The product constraint remains: **satisfaction should reward reasoning, not replace it.**
