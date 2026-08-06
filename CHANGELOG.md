# Pathbreak — Changelog

## [0.3.3] - Unreleased

### Added

- Replaced the temporary landing-page menu with the `Living Board` game-menu concept.
- Added a lightweight animated mini-board that demonstrates the core path-clearing rule without copied artwork.
- Added explicit new-player, returning-player, and chapter-complete menu states.
- Added total-star display, chapter progress, a dominant Start/Continue action, and clear secondary navigation.
- Added a dedicated How to Play overlay.
- Added a dedicated main-menu settings overlay for sound, haptics, reduced motion, and high contrast.

### Changed

- Removed random full-screen floating-arrow decoration from the main menu.
- Removed store-style marketing copy from the primary player flow.
- The main-menu primary action now recommends the first unlocked uncleared level and handles completed content honestly.
- Main-menu motion now uses purposeful section fades and the Living Board demonstration only.

### Verification required

- Run the Godot 4.7.1 parser scan and both validator suites.
- Verify F5 and packaged launch open `MainMenu.tscn`.
- Test new-player, returning-player, and all-levels-complete menu states.
- Test Start/Continue, Levels, How to Play, and Settings.
- Review the composition at 360×800, 393×873, 412×915, 800×1280, and 1200×1920.
- Verify Reduce Motion stops the Living Board animation.

## [0.3.2] - Unreleased

### Changed

- Rebalanced the main-menu composition with a compact original mark, progress-aware copy, and clearer primary and secondary actions.
- Changed level-select progress to measure completed levels instead of merely unlocked levels.
- Added clear `NEXT`, `PLAY`, completed-star, and `LOCKED` states to level cards.
- Removed the non-functional level-select settings button and restored a clear back-navigation pattern.
- Reduced gameplay HUD height and converted the oversized bottom cards into compact, responsive controls.
- Replaced platform-dependent emoji icons in the gameplay HUD and result screen with consistent monochrome symbols.
- Clarified the free Level 1 tutorial hint state in the HUD.
- Rebuilt the completion card with a compact stat panel, a proper circular star badge, performance copy, and cleaner button hierarchy.
- Replaced unclear pause-menu switch graphics with explicit `ON` and `OFF` capsule controls.
- Removed the unfinished music row from the pause menu until a real music system exists.

## [0.3.1] - 2026-08-06

### Fixed

- Gameplay taps now reach the board instead of being absorbed by the full-screen gameplay `Control`.
- Path selection now converts viewport coordinates through each piece's full canvas transform, preserving accuracy after responsive scaling.
- Slightly increased the mobile path-selection tolerance.
- Level 1 tutorial hints are free and always provide visible feedback.
- Hint count is now visible in the HUD, including the zero-hint state.
- Added temporary HUD guidance for the tutorial, blocked paths, unavailable hints, and highlighted paths.
- Fixed strict Godot 4.7 integer-division warnings in procedural audio generation and result time formatting.

### Verified locally

- Godot 4.7.1 editor scan: 0 parser warnings and 0 errors.
- MovementValidator tests: 10/10 passed.
- LevelDataValidator tests: 8/8 passed.
- Level 1 gameplay, completion, replay, and next-level button rendered successfully.

## [0.3.0] - 2026-08-06

### Added

- Responsive gameplay-board positioning and uniform scaling for phone and tablet viewports.
- Central nearest-path touch selection with scale-adjusted tap tolerance.
- Persistent `SettingsManager` for sound, music state, haptics, reduced motion, and high contrast.
- Pause/settings overlay with resume, restart, and main-menu actions.
- Haptic hooks for path escape, blocked taps, hints, and level completion.
- Independent tracking for moves, mistakes, hints used, and completion time.
- Version 2 save data with tutorial state and best-move records.
- Canonical JSON-first level loading with resource fallback.
- `LevelDataValidator` and a headless validation test suite.
- Five-level vertical-slice production specification.

### Changed

- Automatic valid-move pulsing is now limited to the unfinished tutorial.
- Completion results display moves and mistakes separately.
- Audio playback respects the sound setting.
- Invalid level packs stop loading instead of silently shifting level indexes.
- Gameplay uses the modular `scenes/game/` and `scripts/gameplay/` architecture only.

### Removed

- Obsolete monolithic `scenes/Main.tscn`.
- Duplicate root-level `scenes/PuzzlePiece.tscn`.
- Legacy `scripts/GameManager.gd` and its UID.
- Legacy victory scene/controller and its UID.

## [0.2.0] - 2026-08-06

### Added

- Path tail dots at the start of each line.
- Three-card bottom action bar for lives, hint, and restart.
- Centered level header, difficulty label, back control, settings control, and objective subtitle.
- Level-selection progress card and level grid.
- Light-mode completion card with time, mistakes, hints, rating, replay, and next-level actions.
- Warm cream, white, navy, and blue visual palette.

### Fixed

- Corrected HUD node paths.
- Initial multi-viewport layout checks for common portrait sizes.
