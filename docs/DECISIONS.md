# Pathbreak — Architecture & Design Decisions

## Record 001: Data Decoupling via Resource Classes (`PuzzleLevelData` & `PuzzlePieceData`)
- **Date**: 2026-08-06
- **Context**: The game needs a clean, robust data architecture separated from UI and rendering nodes.
- **Decision**: Define `PuzzleLevelData` and `PuzzlePieceData` as exported Godot `Resource` classes (`class_name PuzzleLevelData extends Resource`, `class_name PuzzlePieceData extends Resource`).
- **Rationale**: Enables direct inspection in Godot editor, native `.tres` serialization, level editor export, and clean unit testing.

## Record 002: Standalone Movement Validator Unit Test Engine
- **Date**: 2026-08-06
- **Context**: Escape validation requires reliable handling of edge cases (bends, self-cells, board bounds, blocking paths).
- **Decision**: Decouple ray-casting validation logic into a pure static helper class (`MovementValidator` in `scripts/gameplay/movement_validator.gd`) and create automated test runner (`tests/test_movement_validator.gd`).
- **Rationale**: Guarantees zero regressions when extending level layouts or path shapes.

## Record 003: Light-Mode Palette & Programmatic Vector Art
- **Date**: 2026-08-06
- **Context**: The game requires a clean, premium light-mode visual design.
- **Decision**: Use `#F7F7F4` background, `#FFFFFF` board surface card with rounded corners, `#172033` dark navy paths, `#3978F6` primary accent blue, and `#EF5B5B` coral red error flashes. Programmatic rendering with `Line2D` and `Polygon2D`.
- **Rationale**: High visual polish, low storage footprint, sharp vector scaling on all device resolutions.
