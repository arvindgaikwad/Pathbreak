# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Close the remaining regression, Android, accessibility, and layout gates for the five-level vertical slice. Levels 1–5 are frozen unless new evidence reveals a regression.

## Approved gameplay foundations

- [x] One shared ordered path system: `tail → ... → head`.
- [x] Final segment = arrowhead direction = escape direction.
- [x] Centralized arrow renderer; no per-level rotation hacks.
- [x] Correct triangle head/tail visual language accepted.
- [x] Gate 1 parser/automated verification passed for the ordered-arrow correction.
- [x] Gate 2 movement regression passed.
- [x] Gate 3 new-player arrow comprehension passed.
- [x] Menu board and Start/Continue both start the recommended level.
- [x] Clean-save Level 1 `FREE` hint behavior works.
- [x] Hint refill, Restart, failure/results, and automatic final clear work.
- [x] Final auto-clear does not add a Move.
- [x] Snake-style bent-path escape manually approved.
- [x] Bent paths visibly uncoil through corners, straighten, then exit.

## Difficulty tuning — accepted for the slice

### Level 4

- [x] 9-piece tuned layout.
- [x] 2 opening moves.
- [x] 15 full-clear solution orders encoded in tests.
- [x] Two-person timing pass: roughly **30–40 seconds**.
- [x] Stop tuning unless later evidence shows confusion or frustration.

### Level 5

- [x] 10-piece tuned layout.
- [x] 1 opening move.
- [x] 10 full-clear solution orders encoded in tests.
- [x] Two-person timing pass: roughly **30–40 seconds**.
- [x] Timing lands inside the intended 30–45 second range.
- [x] Stop tuning unless later evidence shows confusion or frustration.

The two-person pass did not record exact moves, mistakes, hints, or written qualitative notes. Those metrics are useful for broader testing but no longer justify delaying platform QA.

---

## P0 — Do next

### A. Final automated regression on the current head

Run once after the snake-animation and Level 4–5 changes:

- [ ] Godot 4.7.1 headless editor/parser scan.
- [ ] Zero parser errors and no new warnings.
- [ ] `tools/path_level_migration_preview.gd` → `reversible=0 ambiguous=0`.
- [ ] `tests/test_path_visual_geometry.gd` → expected `7/7`.
- [ ] `tests/test_movement_validator.gd` passes.
- [ ] `tests/test_level_data_validator.gd` passes.
- [ ] `tests/test_vertical_slice_levels.gd` → expected `7/7`.
- [ ] Confirm Level 4 = 9 pieces / 2 openings / 15 solutions.
- [ ] Confirm Level 5 = 10 pieces / 1 opening / 10 solutions.

### B. Android phone verification

- [ ] Export/install debug APK.
- [ ] Portrait layout fits correctly.
- [ ] Nearest-path touch selection remains accurate.
- [ ] Close paths do not select incorrectly.
- [ ] Multi-touch does not duplicate actions.
- [ ] Android Back closes refill/pause before leaving gameplay.
- [ ] Suspend/resume preserves a valid state.
- [ ] Force-close/reopen preserves save and settings.
- [ ] Sound works.
- [ ] Haptics work and respect the toggle.
- [ ] Snake animation remains smooth.

### C. Android tablet verification

- [ ] Install on Samsung Galaxy Tab S6 Lite or another Android tablet.
- [ ] Board scale and centring are correct.
- [ ] Stylus and finger selection both feel accurate.
- [ ] Popup/menu sizing is comfortable.
- [ ] Snake animation remains smooth.
- [ ] Suspend/resume and save persistence work.

### D. Accessibility/settings regression

- [ ] High Contrast keeps shaft/head/tail/marker readable.
- [ ] Reduce Motion keeps the simpler rigid translation/fade.
- [ ] Sound toggle persists after restart.
- [ ] Haptics toggle persists after restart.
- [ ] No core direction information depends only on color.

### E. Main-menu/layout closure

- [ ] Rapid taps do not double-navigate.
- [ ] Board prompt does not overlap at 360×800.
- [ ] Full loop works at 800×1280 tablet portrait.
- [ ] Chapter-complete state remains understandable.

---

## Vertical slice approval

Approve only when:

- [ ] Current-head automation passes.
- [x] Levels 4–5 have acceptable two-person timing evidence.
- [ ] Android phone test passes.
- [ ] Android tablet test passes.
- [ ] Accessibility/settings regression passes.
- [ ] Main-menu/layout closure passes.
- [ ] Remaining defects are documented.

Do not reopen Levels 1–5 merely to add difficulty.

---

## P2 — After slice approval: production level pipeline

- [ ] Replace the experimental editor with a production modular editor.
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
