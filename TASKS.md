# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Approve a complete, understandable, stable, device-tested vertical slice before building the level-production pipeline, final art, or monetization.

## Verified manual behaviours

- [x] Menu board and Start/Continue open the recommended level.
- [x] Travelling menu cue works.
- [x] Hint cue moves toward the arrowhead.
- [x] Final valid path clears automatically without adding a Move.
- [x] Reduce Motion alternatives work.
- [x] Restart and hint refill work.
- [x] Clean-save menu shows `Start Level 1`.
- [x] First Level 1 hint shows `FREE`.
- [x] Level 2 starts with five normal hints.
- [x] Replaying Level 1 shows the real hint inventory.

## Latest implementation — pending local verification

The two expert prompts were combined into one correction:

- [x] Keep one shared path system; do not patch levels with rotation offsets.
- [x] Standardise authored cells as `tail → ... → head`.
- [x] Derive head and movement direction from the final two cells.
- [x] Reject direction values that do not match the final segment.
- [x] Trim only the rendered shaft before the triangle.
- [x] Use the same geometry helper in gameplay and the menu.
- [x] Make the hint marker a small directional triangle.
- [x] Update the level editor so arbitrary unrelated directions cannot be saved.
- [x] Add a safe preview-only migration scanner.
- [x] Migrate Levels 1–5 while preserving the vertical-slice metric targets.
- [x] Add full-pack ordered-path tests.
- [x] Document the root cause and migration in `docs/ARROW_SYSTEM_AUDIT.md`.

These items remain unverified until the local parser, migration preview, tests, and screenshots pass.

---

## P0 — Do next

### A. Formal parser and automated verification

- [ ] Pull the latest active branch.
- [ ] Run the Godot 4.7.1 headless editor/parser scan.
- [ ] Confirm zero parser errors and no new warnings.
- [ ] Run `tools/path_level_migration_preview.gd`.
- [ ] Confirm the preview reports `reversible=0 ambiguous=0`.
- [ ] Run `tests/test_path_visual_geometry.gd`.
- [ ] Run `tests/test_movement_validator.gd`.
- [ ] Run `tests/test_level_data_validator.gd`.
- [ ] Run `tests/test_vertical_slice_levels.gd`.
- [ ] Confirm the vertical-slice opening and solution counts remain unchanged.
- [ ] Record exact output in the playtest document.

### B. Ordered-path visual acceptance

- [ ] Confirm every Level 1–5 triangle is attached to the final path endpoint.
- [ ] Confirm each triangle follows the adjacent final segment.
- [ ] Confirm left, right, up, and down triangles have identical proportions.
- [ ] Confirm bent paths never use first-to-last diagonal direction.
- [ ] Confirm the rendered shaft stops cleanly under the triangle.
- [ ] Confirm the tail remains on the opposite endpoint.
- [ ] Confirm hint marker direction matches the final segment.
- [ ] Confirm movement direction matches the visible head.
- [ ] Confirm menu demonstration uses the same rules.
- [ ] Confirm touch selection, restart, refill, failure, and automatic final clear did not regress.

### C. Main-menu acceptance

- [x] Hero board and Start/Continue open the same level.
- [x] Travelling direction cue is visible.
- [x] Clean-save state says `Start Level 1`.
- [x] Returning state recommends the first uncleared level.
- [ ] Confirm rapid taps do not double-navigate.
- [ ] Confirm prompt does not overlap at target sizes.
- [ ] Confirm chapter-complete state is understandable.
- [ ] Test 360×800 and 800×1280 first.

### D. Accessibility regression

- [ ] Verify Reduce Motion after the ordered-path migration.
- [ ] Enable High Contrast and verify shaft, head, tail, and marker readability.
- [ ] Verify Sound and Haptics persist after restart.

---

## P1 — New-player retest

Use at least three players who have not seen the corrected arrow system.

Record:

- [ ] First Main Menu target tapped.
- [ ] Whether board and Start button were understood.
- [ ] Whether arrow direction was identified without explanation.
- [ ] Whether tail markers caused confusion.
- [ ] Completion time for Levels 1–5.
- [ ] Moves, mistakes, and hints.
- [ ] Confusion, boredom, enjoyment, or abandonment.
- [ ] Reaction to automatic final clear.

Decision rules:

- [ ] Do not create difficulty through unclear arrow visuals.
- [ ] Keep Level 2 if blocking remains understandable.
- [ ] Keep Level 3 if bent-path reading remains understandable.
- [ ] Tune Levels 4–5 only after readability passes.

---

## P1 — Android verification

### Phone

- [ ] Export and install a debug APK.
- [ ] Verify portrait layout and nearest-path touch selection.
- [ ] Verify close paths do not select incorrectly.
- [ ] Verify multi-touch does not duplicate actions.
- [ ] Verify Android Back closes popup/pause first.
- [ ] Verify suspend/resume and force-close/reopen persistence.
- [ ] Verify sound and haptics.

### Tablet

- [ ] Install on Samsung Galaxy Tab S6 Lite or another Android tablet.
- [ ] Verify board scale and centring.
- [ ] Verify stylus and finger tolerance.
- [ ] Verify popup/menu sizing, performance, and lifecycle behaviour.

---

## P1 — Vertical-slice level direction

### Level 1

- [x] Two clear openings.
- [x] Fresh-save `FREE` state verified.
- [ ] Confirm migrated left/right heads visually.

### Level 2

- [x] Tightened to 6×6.
- [x] Initial testers understood blocking.
- [ ] Confirm the migrated L-path still teaches blocking.

### Level 3

- [x] Tightened to 6×6.
- [x] Initial testers understood bent-path reading.
- [ ] Confirm all migrated final segments remain understandable.

### Level 4

- [x] Failure/retry/result flow exercised.
- [ ] Confirm reversed upward path renders and moves correctly.
- [ ] Retest difficulty only after readability passes.

### Level 5

- [x] Dependency-chain metric target remains encoded in tests.
- [ ] Confirm all eight ordered heads visually.
- [ ] Retest difficulty after the migration passes.

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

- [ ] Replace the experimental editor with the production modular editor.
- [ ] Keep ordered tail-to-head authoring as the only output format.
- [ ] Add preview, schema validation, solver metrics, and batch export.
- [ ] Add opening-move, solution-count, dead-end, and dependency-depth metrics.
- [ ] Add difficulty notes and playtest fields.
- [ ] Add phone/tablet preview.

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
- [x] `LevelSolver`, validator, and headless tests exist.
- [x] Central nearest-path touch selection.
- [x] Versioned saves and persistent hints.
- [x] Separate Sound, Haptics, Reduce Motion, and High Contrast settings.
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
"$GODOT" --headless --path . --script tools/path_level_migration_preview.gd
"$GODOT" --headless --path . --script tests/test_path_visual_geometry.gd
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
```

Run the complete game with **F5**, not F6.
