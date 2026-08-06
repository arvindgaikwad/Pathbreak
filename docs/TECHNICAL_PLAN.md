# Pathbreak — Technical Plan

## 1. Engine & Environment
- **Engine**: Godot 4.7.1 Stable
- **Language**: Typed GDScript
- **Target Platform**: Android (Portrait) + Desktop testing
- **Renderer**: Compatibility Mode
- **Offline Capable**: Zero external server dependencies for gameplay

## 2. Resource & Data Specification
- `PuzzlePieceData` (`Resource`):
  - `piece_id`: `int`
  - `cells`: `Array[Vector2i]`
  - `exit_direction`: `Vector2i` (`Vector2i.UP`, `Vector2i.DOWN`, `Vector2i.LEFT`, `Vector2i.RIGHT`)
- `PuzzleLevelData` (`Resource`):
  - `level_id`: `int`
  - `board_size`: `Vector2i`
  - `difficulty`: `String`
  - `starting_lives`: `int`
  - `pieces`: `Array[PuzzlePieceData]`

## 3. Occupancy System & Movement Validator
- **Occupancy Dictionary**: `Dictionary[Vector2i, int]` mapping grid cell positions to occupying `piece_id`.
- **`MovementValidator` (`scripts/gameplay/movement_validator.gd`)**:
  - Exposes `can_escape(piece_id: int, cells: Array[Vector2i], exit_direction: Vector2i, board_size: Vector2i, occupancy: Dictionary) -> bool`.
  - Traverses rays from every cell of the piece in the `exit_direction` until out of bounds.
  - Returns `false` if an occupied cell contains a `piece_id` different from `piece.piece_id`.
  - Completely handles straight paths, 90-degree bends, edge-touching paths, and overlapping ray paths.

## 4. Input & Concurrency Safeguards
- **Input Locking**: When a path is tapped and validated for escape, its collision input is instantly disabled and marked as `removed = true`.
- **Rapid Tapping Protection**: Board input manager ignores duplicate taps on removing or already processed paths.
- **Restart Protection**: Resetting or reloading a level immediately kills active tweens and reconstructs fresh occupancy.

## 5. Responsive UI Layout
- Uses Control containers (`MarginContainer`, `VBoxContainer`, `HBoxContainer`) with anchor presets `PRESET_FULL_RECT` to support aspect ratios from 360×800 to 1200×1920.
