# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Approve a complete, understandable, stable, device-tested vertical slice before building the level-production pipeline, final art, or monetization.

## Latest verified manual behaviours

- [x] Tapping the animated menu board opens the recommended level.
- [x] Start/Continue opens the same recommended level.
- [x] Travelling blue menu animation plays.
- [x] Hint direction cue moves toward the arrowhead.
- [x] Final valid path clears automatically.
- [x] Automatic final clear does not add a Move.
- [x] Reduce Motion alternatives work for menu, hint, and final clear.
- [x] Restart and hint refill work.
- [x] Clean-save menu shows `Start Level 1`.
- [x] First Level 1 hint shows `FREE`.
- [x] Level 2 starts with the normal five-hint inventory.
- [x] Replaying Level 1 shows the real hint count rather than `FREE`.

## Latest implemented work — pending local verification

The shared arrow/path renderer was corrected at the root:

- [x] Added `scripts/gameplay/path_visual_geometry.gd`.
- [x] Arrowhead anchor now comes from the movement-leading edge, not `cells[-1]`.
- [x] Tail anchor now comes from the movement-trailing edge, not `cells[0]`.
- [x] Menu and gameplay share the same triangle/anchor rules.
- [x] Hint/tutorial marker is now a small directional triangle near the resolved head.
- [x] Added non-destructive visual orientation audit.
- [x] Added `tests/test_path_visual_geometry.gd`.
- [x] Added `docs/ARROW_SYSTEM_AUDIT.md`.

These items are implemented but are not verified until the parser, automated suite, and manual visual checks pass.

---

## P0 — Do next

### A. Formal parser and automated verification

- [ ] Pull the latest active branch.
- [ ] Run the Godot 4.7.1 headless editor/parser scan.
- [ ] Confirm zero parser errors and no new warnings.
- [ ] Run `tests/test_path_visual_geometry.gd`.
- [ ] Run `tests/test_movement_validator.gd`.
- [ ] Run `tests/test_level_data_validator.gd`.
- [ ] Run `tests/test_vertical_slice_levels.gd`.
- [ ] Record exact output in the playtest/verification document.

### B. Centralized arrow/path visual acceptance

- [ ] Confirm Level 5 arrowheads attach to the true movement-leading side.
- [ ] Confirm JSON first/last cell order no longer controls head placement.
- [ ] Confirm left, right, up, and down heads use identical proportions.
- [ ] Confirm bent paths remain readable.
- [ ] Confirm the tail marker is on the movement-trailing side.
- [ ] Confirm the hint marker cannot be mistaken for a second tail dot.
- [ ] Confirm the marker points in the actual escape direction.
- [ ] Confirm the menu demonstration uses the same visual rules.
- [ ] Confirm movement, touch selection, hints, restart, and automatic final clear did not regress.
- [ ] Review projection-tie warnings produced by the visual audit.

### C. Remaining main-menu acceptance

- [x] Hero board and Start/Continue open the same recommended level.
- [x] Travelling direction cue is visible.
- [x] Clean-save state says `Start Level 1`.
- [x] Returning-player state recommends the first uncleared unlocked level.
- [ ] Confirm rapid taps do not trigger double navigation.
- [ ] Confirm the board prompt does not overlap at target sizes.
- [ ] Confirm chapter-complete state is understandable.
- [ ] Test 360×800 and 800×1280 first.

### D. Accessibility regression

- [x] Reduce Motion alternatives work for the interaction-clarity pass.
- [ ] Verify Reduce Motion after the centralized arrow resolver.
- [ ] Enable High Contrast and verify line, head, tail, and hint marker readability.
- [ ] Verify Sound and Haptics toggles persist after restarting the app.

---

## P1 — Repeat external playtesting

Test with at least three players who have not seen the corrected arrow system.

For every tester record:

- [ ] First Main Menu target tapped.
- [ ] Whether board and Start button were both understood.
- [ ] Whether arrow direction was identified without explanation.
- [ ] Whether tail markers caused confusion.
- [ ] Completion time for Levels 1–5.
- [ ] Moves and mistakes.
- [ ] Hint usage.
- [ ] Confusion, boredom, enjoyment, and abandonment points.
- [ ] Reaction to automatic final clear.

Decision rules:

- [ ] Do not create difficulty through unclear arrow visuals.
- [ ] Keep Level 2 if blocking remains understandable.
- [ ] Keep Level 3 if bent-path reading remains understandable.
- [ ] Tune Levels 4–5 if new players still clear them automatically or in roughly 10 seconds.

---

## P1 — Android verification

### Phone

- [ ] Export and install a debug APK.
- [ ] Verify portrait layout and nearest-path touch selection.
- [ ] Verify close paths do not select the wrong path.
- [ ] Verify multi-touch does not create duplicate actions.
- [ ] Verify Android Back closes popup/pause first.
- [ ] Verify suspend/resume and force-close/reopen persistence.
- [ ] Verify sound and haptics.

### Tablet

- [ ] Install on Samsung Galaxy Tab S6 Lite or another Android tablet.
- [ ] Verify board scale and centring.
- [ ] Verify stylus and finger touch tolerance.
- [ ] Verify popup/menu sizing, performance, and lifecycle behaviour.

---

## P1 — Vertical-slice level direction

### Level 1

- [x] Two clear openings.
- [x] Fresh-save `FREE` state verified.
- [ ] Confirm corrected arrow system with a new player.

### Level 2

- [x] Tightened to 6×6.
- [x] Initial testers understood blocking.
- [ ] Confirm corrected arrow system does not reduce comprehension.

### Level 3

- [x] Tightened to 6×6.
- [x] Initial testers understood bent-path reading.
- [ ] Review paths with zero projection span reported by visual audit.
- [ ] Confirm direction cue with new players.

### Level 4

- [x] Failure/retry/result flow exercised.
- [ ] Retest after arrow correction.
- [ ] Increase decision depth only if evidence supports it.

### Level 5

- [x] Authored dependency-chain redesign exists.
- [ ] Confirm every head is attached to the movement-leading edge.
- [ ] Retest difficulty after visual comprehension passes.

---

## P2 — UI direction after slice approval

### Main Menu

- [ ] Keep clear Start/Continue hierarchy and board start target.
- [ ] Place prompt below the board without overlap.
- [ ] Improve vertical balance and reduce empty lower space.
- [ ] Add restrained game-specific iconography.
- [ ] Avoid excessive glow, sparkles, shadows, and repeated cards.

### Level Select

- [ ] Keep four columns on compact phones.
- [ ] Make Completed, Current, Unlocked, and Locked states unmistakable.
- [ ] Make the recommended next level obvious.
- [ ] Increase star readability.
- [ ] Use a dedicated Continue action when it improves touch clarity.

### Final art work deferred

- [ ] Final logo, app icon, typography, and iconography.
- [ ] Ownable Pathbreak motif and chapter themes.
- [ ] Production particles, transitions, sound, and music.
- [ ] Store screenshots and marketing art.

---

## P2 — Level-production pipeline

Start only after the vertical slice is approved.

- [ ] Modular level editor with create/move/rotate/delete.
- [ ] Schema and visual-orientation validation before export.
- [ ] `LevelSolver` integration.
- [ ] Opening-move, solution-count, dead-end, and dependency-depth metrics.
- [ ] Difficulty notes and playtest fields.
- [ ] Phone/tablet preview.
- [ ] Versioned JSON export and batch validation.

---

## P3 — Content and launch

- [ ] Finalise chapter/mechanic plan.
- [ ] Produce teaching and combination levels through the toolchain.
- [ ] Remove random-tap and visually confusing levels.
- [ ] Build the launch-sized original level pack.
- [ ] Final name/trademark clearance.
- [ ] Analytics, crash reporting, privacy, consent, and Data Safety.
- [ ] Android target/API, signing, closed testing, and store listing.
- [ ] Rewarded hints and optional remove-ads only after retention validation.

---

## Preserved foundations

- [x] One modular gameplay architecture.
- [x] One shared `PuzzlePiece` scene/script for all levels.
- [x] Main Menu is the project startup scene.
- [x] JSON is canonical level data.
- [x] Movement rules are isolated in `MovementValidator`.
- [x] `LevelSolver`, structural validator, and headless tests exist.
- [x] Central nearest-path touch selection.
- [x] Versioned saves and persistent hint inventory.
- [x] Separate persistent Sound, Haptics, Reduce Motion, and High Contrast.
- [x] AI anti-slop standard is active.
- [x] Current light UI remains provisional.

---

## Commands

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review

GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

"$GODOT" --headless --path . --editor --quit
"$GODOT" --headless --path . --script tests/test_path_visual_geometry.gd
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
```

Run the complete game with **F5**, not F6.
