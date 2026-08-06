# Pathbreak — Task Tracker

## Current phase: Living Board Menu & Vertical Slice QA

### In progress

- [ ] Pull and parse-test `codex/vertical-slice-ui-polish` in Godot 4.7.1.
- [ ] Review the new Living Board main menu at phone and tablet viewports.
- [ ] Verify new-player, returning-player, and chapter-complete menu states.
- [ ] Verify Start/Continue, Levels, How to Play, and Settings navigation.
- [ ] Manually complete levels 2–5 and record layout, difficulty, and progression issues.
- [ ] Verify pause, Android back, save/load, failure, replay, and next-level flows.
- [ ] Tune the first five levels to the quality gate in `docs/VERTICAL_SLICE.md`.

### Verified foundation

- [x] Godot 4.7.1 parser scan passed with 0 warnings and 0 errors before the latest menu pass.
- [x] MovementValidator test suite passed 10/10.
- [x] LevelDataValidator test suite passed 8/8.
- [x] Level 1 accepts precise path taps and ignores empty-board taps.
- [x] Level 1 completion popup displays Replay and Next Level.
- [x] Main-menu Continue selects the first unlocked uncleared level.

### Implemented in the Living Board pass

- [x] Document the final main-menu and player-flow direction.
- [x] Replace random decorative arrows with an original animated mini puzzle board.
- [x] Add explicit new-player, returning-player, and chapter-complete states.
- [x] Add total-star display and chapter progress.
- [x] Add dominant Start/Continue action.
- [x] Add Levels and How to Play secondary actions.
- [x] Add a dedicated How to Play overlay.
- [x] Add a dedicated main-menu settings overlay.
- [x] Make Reduce Motion stop the Living Board demonstration.
- [x] Preserve `MainMenu.tscn` as the project startup scene.

### Implemented in the UI-polish pass

- [x] Make level-select progress reflect completed levels.
- [x] Add distinct NEXT, PLAY, completed, and LOCKED level-card states.
- [x] Remove the dead level-select settings button.
- [x] Compact the gameplay HUD for small phone screens.
- [x] Replace inconsistent emoji HUD icons with monochrome symbols.
- [x] Clarify free tutorial hints and zero-hint states.
- [x] Rebuild the completion card hierarchy and statistics panel.
- [x] Replace unclear pause toggles with explicit ON/OFF controls.
- [x] Remove the unfinished music control until a real music system exists.

### Implemented in the foundation pass

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

### Testing pending after the menu changes

- [ ] Run a Godot 4.7.1 headless editor/parser scan.
- [ ] Run `godot --headless --path . --script tests/test_movement_validator.gd`.
- [ ] Run `godot --headless --path . --script tests/test_level_data_validator.gd`.
- [ ] Test 360×800, 393×873, 412×915, 800×1280, and 1200×1920.
- [ ] Test Living Board motion and Reduce Motion.
- [ ] Test How to Play and Settings overlays.
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
