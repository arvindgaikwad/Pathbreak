# Pathbreak — Level Format Specification

**Status:** Current loader contract  
**Last reviewed:** 2026-08-06

## 1. Source of truth

`data/levelN.json` is the canonical authored level format.

At runtime, the loader converts valid JSON into typed `PuzzleLevelData` and `PuzzlePieceData` objects. Existing `data/levels/level_N.tres` files are a temporary fallback and should not be edited as the primary version of a level.

Levels are loaded sequentially starting at Level 1. The pack stops at the first number for which neither a JSON file nor a fallback resource exists.

## 2. Canonical JSON schema

```json
{
  "difficulty": "Easy",
  "lives": 3,
  "width": 6,
  "height": 6,
  "pieces": [
    {
      "cells": [[1, 2], [2, 2], [3, 2], [3, 3]],
      "direction": [0, -1]
    }
  ]
}
```

## 3. Root fields

| Field | Type | Required behavior |
|---|---|---|
| `difficulty` | String | Display label. Loader supplies a level-range fallback when missing. |
| `lives` | Integer | Starting lives. Current gameplay clamps practical use to at least one. |
| `width` | Integer | Board width in cells. |
| `height` | Integer | Board height in cells. |
| `pieces` | Array | Ordered piece definitions. Must produce at least one valid path. |

The level identifier is derived from the filename and loading order, not authored inside the current JSON.

## 4. Piece fields

| Field | Type | Required behavior |
|---|---|---|
| `cells` | Array of `[x, y]` pairs | Ordered path cells from tail to arrowhead. |
| `direction` | Two-integer array | Cardinal escape direction of the complete path. |

Piece identifiers are assigned sequentially by the loader beginning at 1.

## 5. Valid directions

| JSON | Runtime value | Meaning |
|---|---|---|
| `[0, -1]` | `Vector2i.UP` | Escape upward |
| `[0, 1]` | `Vector2i.DOWN` | Escape downward |
| `[-1, 0]` | `Vector2i.LEFT` | Escape left |
| `[1, 0]` | `Vector2i.RIGHT` | Escape right |

Diagonal and zero directions are invalid.

## 6. Cell rules

- Coordinates are zero-based.
- Every cell must be inside the board.
- A path must contain at least one cell.
- Cells within one path must be unique.
- Different paths may not occupy the same cell.
- Consecutive cells should describe an orthogonally connected path.
- The final ordered cell is the visual arrowhead location.
- The first ordered cell is the visual tail-dot location.

## 7. Runtime representation

```gdscript
class_name PuzzleLevelData
extends Resource

@export var level_id: int
@export var board_size: Vector2i
@export var difficulty: String
@export var starting_lives: int
@export var pieces: Array[PuzzlePieceData]
```

```gdscript
class_name PuzzlePieceData
extends Resource

@export var piece_id: int
@export var cells: Array[Vector2i]
@export var exit_direction: Vector2i
```

These Resources are runtime typed data containers. They do not make `.tres` the canonical authoring format.

## 8. Validation and solvability

`LevelDataValidator` checks structural correctness before a level enters the playable list.

`LevelSolver` is used by the vertical-slice test to count opening moves and complete clear sequences. A structurally valid level may still be rejected by design review when it is trivial, confusing, overly open, or poorly paced.

## 9. File naming

```text
data/level1.json
data/level2.json
data/level3.json
...
```

Temporary fallback resources currently use:

```text
data/levels/level_1.tres
data/levels/level_2.tres
...
```

New production content should be authored or exported as JSON.
