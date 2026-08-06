# Pathbreak — Centralized Path Arrow System Audit

**Status:** Implemented, pending local Godot verification  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## 1. Root cause

Pathbreak does not use imported arrow sprites, per-level arrow scenes, root rotation, negative scale, or an `AnimationPlayer` to orient arrows.

The actual flow is:

```text
data/levelN.json
  → level_manager.gd parses direction + ordered cells
  → board_manager.gd instantiates scenes/game/puzzle_piece.tscn
  → puzzle_piece.gd draws Line2D, TailDot, ArrowHead, and hint marker
  → MovementValidator and escape animation use exit_direction
```

Every gameplay path already uses one shared scene and one shared script.

The defect was inside that shared renderer:

- the tail was always placed at `cells[0]`;
- the arrowhead was always placed at `cells[-1]`;
- the direction marker travelled from the first authored cell toward the last authored cell;
- the arrowhead triangle itself was rotated from `exit_direction`.

JSON cell order describes a connected path, but it is not guaranteed to place the movement-leading side at the final array element. Therefore the triangle could point in the correct direction while being attached to the wrong side of the shape. The same assumption also made the hint marker travel toward an authored endpoint rather than the true movement-leading edge.

Example from Level 5:

```json
{
  "cells": [[2, 1], [2, 0], [1, 0]],
  "direction": [0, 1]
}
```

The path moves down. The leading cell is `[2, 1]`, but the old renderer attached the head to `[1, 0]` because that cell happened to be last in the array.

This is a shared renderer defect, not ten separate level defects.

## 2. Affected files

### Shared runtime

- `scenes/game/puzzle_piece.tscn`
- `scripts/gameplay/puzzle_piece.gd`
- `scripts/gameplay/board_manager.gd`
- `scripts/gameplay/level_manager.gd`
- `scripts/gameplay/movement_validator.gd`
- `scripts/gameplay/level_data_validator.gd`

### Shared menu demonstration

- `scripts/ui/living_board.gd`

### Authored data

- `data/level1.json` through the currently available sequential level pack

The level files are affected only as input data. They do not contain separate drawing or rotation code.

### Items investigated and not present in the active architecture

- imported arrow sprite orientation offsets;
- negative root scale or sprite flipping;
- parent/child rotation conflicts;
- inherited arrow scenes with transform overrides;
- animation tracks modifying rotation or scale;
- per-level arrow controllers;
- per-level collision shapes;
- duplicate active arrow scenes.

`Area2D` exists in the shared piece scene, but legacy child collisions are removed and input is handled centrally through nearest-path distance in `board_manager.gd`.

## 3. Centralized fix

Added:

```text
scripts/gameplay/path_visual_geometry.gd
```

This is the single source of truth for:

- movement-leading cell selection;
- movement-trailing cell selection;
- movement-leading point selection for the main-menu demonstration;
- movement-trailing point selection;
- consistent triangle construction;
- projection-span audit information.

The resolver projects every occupied cell onto `exit_direction`:

- maximum projection = movement-leading edge;
- minimum projection = movement-trailing edge.

When several cells share the same projection, the resolver prefers an authored endpoint and then uses a deterministic perpendicular-centre fallback. This avoids arbitrary per-level fixes while preserving stable visuals for projection ties.

## 4. Runtime implementation

### Gameplay paths

`scripts/gameplay/puzzle_piece.gd` now:

- asks `PathVisualGeometry` for the leading and trailing anchors;
- places the arrowhead on the actual movement-leading edge;
- places the tail marker on the movement-trailing edge;
- uses one shared filled-triangle generator for all four cardinal directions;
- uses a small directional triangle for tutorial/hint motion rather than a dot that can resemble another endpoint;
- moves the marker locally toward the resolved head;
- keeps the full-path blue confirmation after the marker reaches the head;
- leaves movement, occupancy, touch selection, saves, levels, solver behaviour, and escape rules unchanged.

### Main-menu demonstration

`scripts/ui/living_board.gd` now uses the same leading/trailing selection and triangle construction rules as gameplay. The menu no longer owns a separate endpoint assumption.

## 5. Level migration

No destructive level migration is required.

All current levels already instantiate the same shared `PuzzlePiece` scene through `board_manager.gd`. Once the centralized renderer is updated, every existing and future JSON level automatically receives the corrected visual anchors.

Level geometry, direction values, solution counts, dependencies, and occupancy are not rewritten.

## 6. Validation

`LevelDataValidator.audit_visual_orientation(level)` now reports non-fatal visual warnings for:

- unresolved visual anchors;
- head and tail resolving to the same cell;
- paths with no cell-to-cell extent along their movement axis.

The normal structural validator remains unchanged in severity so the audit does not silently invalidate existing puzzle logic.

Projection ties are reported because they may still deserve later level-design cleanup, even though the renderer now resolves them deterministically.

## 7. Automated tests

Added:

```text
tests/test_path_visual_geometry.gd
```

The suite checks:

- right, left, up, and down leading-edge selection;
- authored cell order does not control the arrowhead side;
- triangle tip direction matches movement direction;
- projection ties remain deterministic;
- every currently authored sequential JSON level resolves valid, distinct head and tail anchors;
- resolved anchors are truly leading/trailing by projection.

Run:

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tests/test_path_visual_geometry.gd
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

## 8. Manual acceptance checks

- Level 5 arrows attach to the side that leads in their actual escape direction.
- Left/right/up/down heads use the same triangle proportions.
- Bent paths do not depend on JSON first/last order for head placement.
- Hint marker is visibly directional and cannot be mistaken for another tail dot.
- Menu and gameplay use the same visual rules.
- Movement direction remains unchanged.
- Touch selection remains unchanged.
- Automatic final clear remains unchanged.
- High Contrast and Reduce Motion remain understandable.

## 9. Remaining problems

- The implementation has not yet been parsed or executed in the user's local Godot 4.7.1 build.
- Paths whose occupied cells have zero projection span along the movement direction remain visually more abstract. The centralized resolver handles them deterministically, but later playtesting may justify redesigning those specific level shapes.
- Android device and aspect-ratio verification remains pending.
- No collision-rotation migration was needed because the active game does not use per-piece collision shapes for selection.
