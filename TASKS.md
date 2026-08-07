# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Finish vertical-slice gameplay quality, tune Levels 4–5, then complete Android/device acceptance before final UI/art and the level-production pipeline.

## Verified manual behaviours

- [x] Menu board and Start/Continue open the recommended level.
- [x] Travelling menu cue works.
- [x] Hint cue moves toward the arrowhead.
- [x] Final valid path clears automatically without adding a Move.
- [x] Reduce Motion alternatives worked before the latest snake-animation pass.
- [x] Restart and hint refill work.
- [x] Clean-save menu shows `Start Level 1`.
- [x] First Level 1 hint shows `FREE`.
- [x] Level 2 starts with five normal hints.
- [x] Replaying Level 1 shows the real hint inventory.
- [x] Ordered arrow/head correction passed Gate 1 formal verification.
- [x] Ordered arrow/head movement regression passed Gate 2.
- [x] New-player direction comprehension passed Gate 3.
- [x] Bent paths now animate like a snake: head leads, tail feeds through the bend, body becomes straight, then exits.

## Accepted technical foundations

- [x] One shared path system; no per-level rotation offsets.
- [x] Authored cells use `tail → ... → head`.
- [x] Head and movement direction derive from the final two cells.
- [x] Validator rejects direction/final-segment mismatches.
- [x] Gameplay and menu share path geometry helpers.
- [x] Hint marker uses a directional triangle.
- [x] Level editor cannot save arbitrary unrelated direction values.
- [x] Existing Levels 1–5 were migrated to the ordered-path model.
- [x] Full-pack ordered-path tests exist.
- [x] Snake escape uses a constant-length body window through the exact polyline.
- [x] `docs/ARROW_SYSTEM_AUDIT.md` and `docs/SNAKE_ESCAPE_ANIMATION.md` document the accepted model.

---

## P0 — Do next

### A. Post-snake regression rerun

The earlier formal gate passed before the final snake-animation correction. Rerun only because shared geometry changed afterward.

- [ ] Run the Godot 4.7.1 headless editor/parser scan on current head.
- [ ] Confirm zero parser errors and no new warnings.
- [ ] Run `tests/test_path_visual_geometry.gd` and confirm `7/7`.
- [ ] Run `tests/test_movement_validator.gd`.
- [ ] Run `tests/test_level_data_validator.gd`.
- [ ] Run `tests/test_vertical_slice_levels.gd`.
- [ ] Quick-check Reduce Motion still uses the simpler escape.

### B. Difficulty tuning — Levels 4 and 5

Do not change Levels 1–3 unless new evidence shows a teaching failure.

#### Level 4

- [ ] Audit current opening moves and solution count.
- [ ] Make the player intentionally choose an order rather than clear obvious free paths.
- [ ] Keep the board readable with the corrected arrow language.
- [ ] Target roughly 20–35 seconds for a first-time player.
- [ ] Avoid artificial difficulty from crowded geometry.
- [ ] Re-run solver/dead-end checks after every geometry change.

#### Level 5

- [ ] Audit current dependency chain after ordered-path migration.
- [ ] Increase meaningful decision depth without making direction ambiguous.
- [ ] Target roughly 30–45 seconds for a first-time player.
- [ ] Keep at least one satisfying bent-path snake escape visible during normal solving.
- [ ] Re-run opening, solution-count, and dead-end metrics after every change.

### C. Difficulty retest

- [ ] Give revised Levels 4–5 to at least three players without hints or explanation.
- [ ] Record completion time, moves, mistakes, hints, and confusion points.
- [ ] Reject a revision if difficulty comes from unreadable arrows rather than sequencing.
- [ ] Keep the version that produces deliberate thought while preserving enjoyment.

---

## P1 — Main-menu/layout acceptance

- [x] Hero board and Start/Continue open the same level.
- [x] Travelling direction cue is visible.
- [x] Clean-save state says `Start Level 1`.
- [x] Returning state recommends the first uncleared level.
- [ ] Confirm rapid taps do not double-navigate.
- [ ] Confirm prompt does not overlap at target sizes.
- [ ] Confirm chapter-complete state is understandable.
- [ ] Test 360×800 and 800×1280 first.

## P1 — Accessibility regression

- [ ] Verify Reduce Motion after the final snake-animation implementation.
- [ ] Enable High Contrast and verify shaft, head, tail, and marker readability.
- [ ] Verify Sound and Haptics persist after restart.

## P1 — Android verification

### Phone

- [ ] Export and install a debug APK.
- [ ] Verify portrait layout and nearest-path touch selection.
- [ ] Verify close paths do not select incorrectly.
- [ ] Verify snake animation remains smooth at mobile framerate.
- [ ] Verify multi-touch does not duplicate actions.
- [ ] Verify Android Back closes popup/pause first.
- [ ] Verify suspend/resume and force-close/reopen persistence.
- [ ] Verify sound and haptics.

### Tablet

- [ ] Install on Samsung Galaxy Tab S6 Lite or another Android tablet.
- [ ] Verify board scale and centring.
- [ ] Verify stylus and finger tolerance.
- [ ] Verify snake animation at tablet scale.
- [ ] Verify popup/menu sizing, performance, and lifecycle behaviour.

---

## P1 — Vertical-slice level status

### Level 1

- [x] Two clear openings.
- [x] Fresh-save `FREE` state verified.
- [x] Ordered heads accepted.

### Level 2

- [x] Tightened to 6×6.
- [x] Blocking understood by players.
- [x] L-path visually accepted.
- [x] L-path snake escape accepted.

### Level 3

- [x] Tightened to 6×6.
- [x] Bent-path reading understood.
- [x] Ordered-path direction model accepted.

### Level 4

- [x] Failure/retry/result flow exercised.
- [ ] Tune decision depth.
- [ ] Retest with new players.

### Level 5

- [x] Ordered-path heads visually accepted.
- [x] Snake-style bent-path movement accepted.
- [ ] Tune meaningful difficulty.
- [ ] Retest with new players.

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
"$GODOT" --headless --path . --script tests/test_path_visual_geometry.gd
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
```

Run the complete game with **F5**, not F6.
