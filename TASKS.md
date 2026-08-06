# Pathbreak — Task Tracker

## Current phase: Vertical Slice Foundation

### In progress

- [ ] Open the project in Godot 4.7.1 and fix any parser/runtime errors from the foundation branch.
- [ ] Manually validate levels 1–5 on Android.
- [ ] Verify pause, settings, Android back, save/load, failure, and completion flows.
- [ ] Tune the first five levels to the quality gate in `docs/VERTICAL_SLICE.md`.

### Implemented in the current foundation pass

- [x] Route the product through the modular gameplay stack.
- [x] Remove obsolete `Main.tscn`, duplicate `PuzzlePiece.tscn`, legacy `GameManager.gd`, and legacy victory flow.
- [x] Add responsive board positioning and scaling.
- [x] Replace overlapping per-piece input with nearest-path touch selection.
- [x] Restrict automatic valid-move pulsing to the unfinished tutorial.
- [x] Add persistent sound, haptics, reduce-motion, and high-contrast settings.
- [x] Add a functional pause/settings overlay.
- [x] Add haptic feedback hooks for success, errors, hints, and completion.
- [x] Track moves and mistakes independently.
- [x] Version save data and record best moves, mistakes, and completion times.
- [x] Make JSON the canonical runtime level format with `.tres` fallback.
- [x] Add reusable level schema validation and automated tests.
- [x] Stop level-pack loading when an invalid level would shift progression indexes.
- [x] Document the five-level vertical-slice acceptance criteria.

### Testing pending

- [ ] Run `godot --headless --script tests/test_movement_validator.gd`.
- [ ] Run `godot --headless --script tests/test_level_data_validator.gd`.
- [ ] Test 360×800, 393×873, 412×915, 800×1280, and 1200×1920.
- [ ] Test touch ambiguity near two closely spaced paths.
- [ ] Test rapid repeated input during escape and blocked animations.
- [ ] Test pause/resume, background/resume, and Android back.
- [ ] Test corrupt save and settings files.

---

## Next milestones

### Milestone 1 — Approve the vertical slice

- [ ] Final tutorial presentation.
- [ ] Five polished and manually reviewed levels.
- [ ] Final-quality interaction sounds for the slice.
- [ ] Device-tested haptics and motion.
- [ ] No critical gameplay or progress bugs.

### Milestone 2 — Level production tools

- [ ] Replace the old experimental editor with a modular level editor.
- [ ] Add schema validation in the editor.
- [ ] Add a solvability solver.
- [ ] Add difficulty measurements and playtest notes.
- [ ] Export versioned JSON level packs.

### Milestone 3 — Content production

- [ ] 5 tutorial/showcase levels.
- [ ] 20 easy levels.
- [ ] 25 normal levels.
- [ ] 20 hard levels.
- [ ] 5 mechanic showcase levels.

### Milestone 4 — Launch preparation

- [ ] Final name, icon, logo, store artwork, audio, and copy.
- [ ] Analytics and crash reporting.
- [ ] Android performance and interruption testing.
- [ ] Signed Android App Bundle.
- [ ] Privacy policy, Data Safety, content rating, and closed testing.
- [ ] Rewarded ads and optional remove-ads purchase only after retention validation.
