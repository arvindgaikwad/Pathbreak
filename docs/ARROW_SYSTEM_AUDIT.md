# Pathbreak — Centralized Ordered-Path Arrow System

**Status:** Implemented, pending local Godot verification  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## 1. Direction model

Pathbreak is not a projectile-arrow game. Every puzzle object is an ordered grid path rendered with a thick shaft and a triangular head.

The canonical invariant is now:

```text
ordered cells: tail → ... → head
final segment direction
= arrowhead direction
= movement direction
```

For a path ending at `cells[-1]`, direction is derived only from:

```gdscript
cells[-1] - cells[-2]
```

The first and last cells are never subtracted to orient a bent path.

## 2. Actual project flow

```text
data/levelN.json
  → level_manager.gd creates PuzzlePieceData
  → board_manager.gd instantiates scenes/game/puzzle_piece.tscn
  → puzzle_piece.gd renders Line2D + Polygon2D head/tail
  → MovementValidator uses PuzzlePieceData.exit_direction
  → successful escape animation uses PuzzlePiece.exit_direction
```

All levels already use the same `PuzzlePiece` scene and script. There are no active per-direction scenes or per-level rendering scripts.

## 3. Root cause

The project had two separate assumptions:

1. `direction` in level JSON controlled movement.
2. first/last cell order controlled visual head and tail placement.

Many paths did not satisfy both assumptions. Some level entries stored a movement direction that matched neither endpoint segment. This produced combinations such as:

- triangle attached to the wrong endpoint;
- triangle pointing away from the final segment;
- L-shaped paths whose head direction ignored their last segment;
- hint motion travelling toward a different location from the escape direction.

A previous projection-based correction was also rejected. Selecting the geometrically leading cell can place a head on the side of a shape, but it does not guarantee that the head is a path endpoint or that it follows the adjacent segment. The corrected expert model requires an ordered endpoint system, not a projection workaround.

## 4. Investigation results

The active architecture does **not** use:

- imported arrow sprites with mixed default orientation;
- negative root scale or sprite flipping;
- parent/child rotation stacks;
- animation tracks that modify head rotation;
- separate scenes for left/right/up/down;
- per-level collision shapes for touch selection;
- manual per-level head transforms.

`Area2D` remains in the shared scene, but legacy child collision shapes are cleared. Selection uses the board's centralized nearest-path distance test.

The shared defect was therefore fixed in data, renderer, editor, and validation rather than by editing scene rotations.

## 5. Centralized implementation

### `scripts/gameplay/path_visual_geometry.gd`

This is now the shared geometry source for:

- endpoint and adjacent-point lookup;
- final-segment direction;
- optional start-endpoint support;
- shaft trimming near the triangle;
- triangle generation;
- ordered-cell validation;
- safe legacy migration classification.

### `scripts/gameplay/puzzle_piece_data.gd`

`PuzzlePieceData.create(...)` now derives `exit_direction` from the selected ordered endpoint. A supplied legacy direction is only checked for compatibility; it is no longer allowed to become a separate visual/movement truth.

### `scripts/gameplay/puzzle_piece.gd`

The shared renderer now:

- places the head at the selected ordered endpoint;
- calculates direction from the endpoint and its adjacent cell;
- trims only the rendered shaft, not grid occupancy;
- uses the derived direction for escape movement;
- uses one triangle proportion for all cardinal directions;
- places the tail at the opposite endpoint;
- uses a small directional triangle for hints/tutorials;
- moves the hint marker along the final segment toward the head;
- preserves touch selection, occupancy, saves, and animation flows.

### `scripts/ui/living_board.gd`

The main-menu demonstration uses the same ordered endpoint and triangle helpers as gameplay.

### `scripts/LevelEditor.gd`

The editor now authors paths tail-to-head:

- drawing order defines the path order;
- movement is calculated from the final two cells;
- direction buttons may keep the current endpoint or reverse the path;
- they cannot assign an arbitrary direction unrelated to an endpoint;
- saved output includes the derived compatibility direction and `"head_endpoint": "end"`;
- ambiguous legacy paths are rejected instead of guessed.

## 6. Existing-level migration

Ten sequential levels were reviewed.

Before migration, 13 paths had stored directions that did not match their final ordered segment:

- 7 paths were safely repaired by reversing cell order;
- 6 paths matched neither endpoint and required small geometry corrections;
- no per-level rotation offsets were added;
- no unrelated gameplay scripts were rewritten.

The migrated vertical-slice files are:

- `data/level1.json`
- `data/level2.json`
- `data/level3.json`
- `data/level4.json`
- `data/level5.json`

The six geometry corrections were selected to keep each path connected, non-branching, inside the board, non-overlapping, and aligned with its existing intended movement direction. The existing vertical-slice tests still define the required opening and solution counts; local execution is required before those metrics are considered verified.

Levels 6–10 already followed the final-segment direction convention and are protected by the full-pack audit test.

## 7. Safe migration preview

Added:

```text
tools/path_level_migration_preview.gd
```

It scans sequential level JSON files and classifies every path as:

- `CANONICAL` — stored direction matches the final segment;
- `REVERSIBLE` — stored direction matches the start endpoint and cell order can be reversed;
- `AMBIGUOUS` — stored direction matches neither endpoint and requires design review.

The tool is preview-only and never writes files.

## 8. Validation

`LevelDataValidator` now rejects:

- fewer than two cells;
- duplicate cells;
- disconnected or diagonal consecutive cells;
- invalid final-segment direction;
- movement direction that differs from the ordered head segment;
- out-of-bounds cells;
- overlaps and duplicate piece IDs.

The required invariant is enforced before a level enters the playable pack.

## 9. Automated tests

### Ordered geometry

```text
tests/test_path_visual_geometry.gd
```

Covers:

- four straight endpoint directions;
- four L-shaped endpoint directions;
- head at start and head at end;
- triangle tip orientation;
- shaft trimming without changing the logic endpoint;
- every sequential authored level;
- every stored/derived direction pair.

### Existing suites

Movement tests were updated so all test paths are valid ordered paths with at least two cells. The vertical-slice solver tests retain the expected opening and solution counts.

Run:

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tools/path_level_migration_preview.gd
godot --headless --path . --script tests/test_path_visual_geometry.gd
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

Expected migration preview after this correction:

```text
reversible=0 ambiguous=0
```

## 10. Manual acceptance

- Every triangle is attached to a true path endpoint.
- Every triangle follows the adjacent final segment.
- Bent paths never use first-to-last diagonal direction.
- Head direction and escape movement match.
- Shaft no longer visibly runs through the triangle.
- Hint marker points toward the same head used by movement.
- Menu demonstration follows the same rules.
- Restart, refill, automatic final clear, Reduce Motion, and High Contrast do not regress.

## 11. Remaining risks

- The current branch has not yet been parsed or executed in the user's local Godot 4.7.1 build after this migration.
- Levels 1–5 require visual screenshots and solver-test confirmation after the geometry edits.
- The compatibility `direction` field remains in JSON for the current loader. It is derived and validator-enforced; a future schema migration may remove it after the loader reads only ordered cells/head endpoint.
- Android phone/tablet testing remains pending.
