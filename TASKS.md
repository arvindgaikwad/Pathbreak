# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Approve the five-level vertical slice, then move to the production level pipeline. Final UI/art and monetization remain deferred.

## Approved gameplay foundations

- [x] One shared ordered path system: `tail → ... → head`.
- [x] Final segment = arrowhead direction = escape direction.
- [x] Centralized arrow renderer; no per-level rotation hacks.
- [x] Correct triangle head/tail visual language accepted.
- [x] Gate 1 parser/automated verification passed for ordered-arrow correction.
- [x] Gate 2 movement regression passed.
- [x] Gate 3 new-player arrow comprehension passed.
- [x] Menu board and Start/Continue both start the recommended level.
- [x] Clean-save Level 1 `FREE` hint behavior works.
- [x] Hint refill, Restart, failure/results, and automatic final clear work.
- [x] Final auto-clear does not add a Move.
- [x] Snake-style bent-path escape manually approved.
- [x] Bent path visibly uncoils through its corner, becomes straight, then exits.

## Latest change — pending verification

Difficulty tuning is now implemented for Levels 4–5.

### Level 4

- [x] Redesigned to 9 pieces.
- [x] Keeps exactly 2 opening moves.
- [x] Each opening reveals a different next safe path.
- [x] Structural target = 15 full-clear sequences.
- [x] Includes multiple bent paths so snake motion remains part of normal play.
- [ ] Parser/solver verification on current head.
- [ ] Director playtest target: 20–35 seconds.

### Level 5

- [x] Redesigned to 10 pieces.
- [x] Keeps exactly 1 opening move.
- [x] Uses a five-step staged dependency read before its first branch.
- [x] Structural target = 10 full-clear sequences.
- [x] Includes multiple bent paths.
- [ ] Parser/solver verification on current head.
- [ ] Director playtest target: 30–45 seconds.

---

## P0 — Do next

### A. Rerun automation after Level 4–5 tuning

- [ ] Run Godot 4.7.1 headless editor/parser scan.
- [ ] Confirm zero parser errors and no new warnings.
- [ ] Run `tools/path_level_migration_preview.gd` and confirm `reversible=0 ambiguous=0`.
- [ ] Run `tests/test_path_visual_geometry.gd`; expected `7/7`.
- [ ] Run `tests/test_movement_validator.gd`.
- [ ] Run `tests/test_level_data_validator.gd`.
- [ ] Run `tests/test_vertical_slice_levels.gd`; expected `7/7`.
- [ ] Confirm Level 4 audit reports 9 pieces, 2 openings, 15 solutions.
- [ ] Confirm Level 5 audit reports 10 pieces, 1 opening, 10 solutions.

### B. Director playtest — tuned Level 4

Play three times and record:

- [ ] completion time;
- [ ] moves;
- [ ] mistakes;
- [ ] hints;
- [ ] first opening selected;
- [ ] whether the second branch was noticed;
- [ ] whether any path felt too close or ambiguous;
- [ ] whether snake motion remains clean.

Acceptance:

- [ ] roughly 20–35 seconds for a new player;
- [ ] increased time comes from dependency reading, not confusion.

### C. Director playtest — tuned Level 5

Play three times and record:

- [ ] completion time;
- [ ] moves;
- [ ] mistakes;
- [ ] hints;
- [ ] whether the early staged chain is understandable;
- [ ] whether the later `[2, 8]` branch feels satisfying rather than random;
- [ ] whether any path is visually ambiguous;
- [ ] whether snake motion remains clean.

Acceptance:

- [ ] roughly 30–45 seconds for a new player;
- [ ] one clear opening without feeling like a tutorial;
- [ ] several board re-evaluations before completion.

### D. One no-explanation retest

- [ ] Give tuned Levels 4–5 to at least one player who has not seen the new layouts.
- [ ] Do not explain the solution.
- [ ] Record time, mistakes, hints, confusion, and enjoyment.
- [ ] Keep the level only if the player understands why successful paths move.

---

## P1 — Android verification

### Phone

- [ ] Export/install debug APK.
- [ ] Verify portrait layout and nearest-path touch selection.
- [ ] Verify close paths do not select incorrectly.
- [ ] Verify multi-touch does not duplicate actions.
- [ ] Verify Android Back closes popup/pause first.
- [ ] Verify suspend/resume and force-close/reopen persistence.
- [ ] Verify sound and haptics.
- [ ] Verify snake animation performance.

### Tablet

- [ ] Install on Samsung Galaxy Tab S6 Lite or another Android tablet.
- [ ] Verify board scale and centring.
- [ ] Verify stylus and finger tolerance.
- [ ] Verify popup/menu sizing.
- [ ] Verify snake animation performance and visual smoothness.

### Accessibility

- [ ] High Contrast keeps shaft/head/tail/marker readable.
- [ ] Reduce Motion keeps the simpler rigid translation/fade.
- [ ] Sound and Haptics settings persist after restart.

---

## P1 — Main-menu/layout closure

- [ ] Rapid taps do not double-navigate.
- [ ] Board prompt does not overlap at 360×800.
- [ ] Verify 800×1280 tablet portrait.
- [ ] Chapter-complete state is understandable.

---

## Vertical slice approval

Approve only when:

- [ ] Current automation passes.
- [ ] Tuned Level 4 passes director/new-player testing.
- [ ] Tuned Level 5 passes director/new-player testing.
- [ ] Android phone test passes.
- [ ] Android tablet test passes.
- [ ] Accessibility regression passes.
- [ ] Remaining defects are documented.

Do not reopen Levels 1–3 unless new evidence reveals a regression.

---

## P2 — After slice approval: production level pipeline

- [ ] Replace experimental editor with production modular editor.
- [ ] Keep ordered tail-to-head authoring as the only output format.
- [ ] Preview and validate before export.
- [ ] Integrate solver metrics.
- [ ] Opening-move count.
- [ ] Solution count.
- [ ] Dead-end check.
- [ ] Dependency-depth/branch metrics.
- [ ] Difficulty notes and playtest fields.
- [ ] Phone/tablet preview.
- [ ] Versioned JSON export and batch validation.

---

## P3 — UI/art after gameplay pipeline is proven

### Main Menu

- [ ] Hybrid redesign using the approved concept hierarchy.
- [ ] Clear Start/Continue hierarchy.
- [ ] Prompt below board without overlap.
- [ ] Better vertical balance.
- [ ] Restrained game-specific iconography.
- [ ] No excessive glow, sparkles, SaaS cards, or generic AI decoration.

### Level Select

- [ ] Four columns on compact phones.
- [ ] Clear Completed / Current / Unlocked / Locked states.
- [ ] Strong recommended-next-level state.
- [ ] More readable stars.

### Final art

- [ ] Logo and app icon.
- [ ] Typography and icon system.
- [ ] Ownable Pathbreak visual motif.
- [ ] Production sound/music/particles.
- [ ] Store screenshots and marketing art.

---

## P4 — Launch preparation

- [ ] Build launch-sized original level pack through the production pipeline.
- [ ] Final name/trademark clearance.
- [ ] Analytics and crash reporting.
- [ ] Privacy/consent/Data Safety.
- [ ] Android signing and target API checks.
- [ ] Closed testing.
- [ ] Store listing.
- [ ] Rewarded hint economy only after retention evidence.

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
