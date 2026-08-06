# Pathbreak — Changelog

## [0.3.0] - Unreleased

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

### Verification required before merge

- Open the branch in Godot 4.7.1 and fix all parser/runtime errors.
- Run both headless test suites.
- Test touch input, pause/settings, Android back, save/load, failure, and completion on devices.
- Validate levels 1–5 against `docs/VERTICAL_SLICE.md`.

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
