# Pathbreak — Architecture & Design Decisions

## Record 001: Data decoupling through custom resources

- **Date:** 2026-08-06
- **Context:** Gameplay data must remain separate from UI and rendering nodes.
- **Decision:** Keep `PuzzleLevelData` and `PuzzlePieceData` as typed resource classes used by gameplay code.
- **Rationale:** Levels can be inspected, validated, tested, and converted without instantiating gameplay scenes.

## Record 002: Pure movement validation

- **Date:** 2026-08-06
- **Context:** Escape logic must consistently handle bends, self-cells, board bounds, and blockers.
- **Decision:** Keep movement checking inside the pure static `MovementValidator` helper with headless tests.
- **Rationale:** Gameplay rules remain deterministic and independent of physics or frame timing.

## Record 003: Light-mode programmatic rendering

- **Date:** 2026-08-06
- **Context:** The game requires a clean visual identity that scales across Android screens.
- **Decision:** Render paths, arrowheads, dots, highlights, and board surfaces programmatically using the Pathbreak light palette.
- **Rationale:** Vector-like rendering remains sharp, compact, themeable, and independent from copied raster assets.

## Record 004: One modular gameplay architecture

- **Date:** 2026-08-06
- **Context:** The repository contained an older monolithic game manager and a newer modular stack.
- **Decision:** Support only `scenes/game/game_screen.tscn`, `scripts/gameplay/level_manager.gd`, `board_manager.gd`, and the modular puzzle-piece scene.
- **Rationale:** Two competing implementations cause agents and developers to modify the wrong files, duplicate bugs, and break progression.

## Record 005: JSON is the canonical level format

- **Date:** 2026-08-06
- **Context:** Levels existed simultaneously as JSON and `.tres`, with no guaranteed synchronization.
- **Decision:** Load versionable JSON first and treat existing `.tres` files as a temporary fallback until migration is complete.
- **Rationale:** JSON is easier to diff, generate, validate, migrate, and export from an internal level editor.

## Record 006: Central nearest-path touch selection

- **Date:** 2026-08-06
- **Context:** Independent enlarged collision areas can overlap and punish the player for an ambiguous tap.
- **Decision:** The board receives touch input, measures distance to every available path, and selects only the nearest path inside a scale-adjusted acceptance radius.
- **Rationale:** Selection remains deterministic, fair, and consistent when the board scales on different devices.

## Record 007: Accessibility settings are persistent and independent from progress

- **Date:** 2026-08-06
- **Context:** Sound, haptics, motion, and contrast settings should survive restarts without complicating progression saves.
- **Decision:** Use a dedicated `SettingsManager` autoload and separate settings file.
- **Rationale:** Settings can evolve independently, apply globally, and recover safely if the file is invalid.

## Record 008: The vertical slice is the production quality gate

- **Date:** 2026-08-06
- **Context:** Expanding to 75 levels before controls and game feel are approved would multiply rework.
- **Decision:** Complete and device-test five representative levels before building the level editor and full content pack.
- **Rationale:** The slice defines the final standard for touch handling, feedback, UI, audio, haptics, saving, and level difficulty.
