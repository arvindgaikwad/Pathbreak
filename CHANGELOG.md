# Pathbreak — Changelog

## [0.3.1] - Unreleased

### Fixed

- Gameplay taps now reach the board instead of being absorbed by the full-screen gameplay `Control`.
- Path selection now converts viewport coordinates through each piece's full canvas transform, preserving accuracy after responsive scaling.
- Slightly increased the mobile path-selection tolerance.
- Level 1 tutorial hints are free and always provide visible feedback.
- Hint count is now visible in the HUD, including the zero-hint state.
- Added temporary HUD guidance for the tutorial, blocked paths, unavailable hints, and highlighted paths.
- Fixed strict Godot 4.7 integer-division warnings in procedural audio generation and result time formatting.

### Verified locally before the gameplay-input follow-up

- Godot 4.7.1 editor scan: 0 parser warnings and 0 errors.
- MovementValidator tests: 10/10 passed.
- LevelDataValidator tests: 8/8 passed.

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
