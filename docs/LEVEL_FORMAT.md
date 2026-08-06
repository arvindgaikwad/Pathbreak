# Pathbreak — Level Format Specification

**Status:** Current ordered-path loader contract  
**Last reviewed:** 2026-08-07

## 1. Source of truth

`data/levelN.json` is the canonical authored level format.

At runtime, valid JSON becomes typed `PuzzleLevelData` and `PuzzlePieceData`. Existing `.tres` files are compatibility fallback only.

## 2. Canonical path rule

Every path is stored as an ordered list:

```text
tail → intermediate cells → head
```

The final two cells define the arrowhead and movement direction:

```gdscript
exit_direction = cells[-1] - cells[-2]
```

Required invariant:

```text
final segment direction
= arrowhead direction
= movement direction
```

Do not calculate bent-path direction from the first and last cells.

## 3. JSON schema

```json
{
  "difficulty": "Easy",
  "lives": 3,
  "width": 6,
  "height": 6,
  "pieces": [
    {
      "cells": [[1, 2], [2, 2], [2, 3]],
      "direction": [0, 1],
      "head_endpoint": "end"
    }
  ]
}
```

## 4. Root fields

| Field | Type | Required behavior |
|---|---|---|
| `difficulty` | String | Display label; loader supplies a fallback when absent. |
| `lives` | Integer | Starting lives. |
| `width` | Integer | Board width in cells. |
| `height` | Integer | Board height in cells. |
| `pieces` | Array | Ordered path definitions. |

The level ID comes from the sequential filename.

## 5. Piece fields

| Field | Type | Status | Required behavior |
|---|---|---|---|
| `cells` | Array of `[x, y]` | Canonical source | Ordered tail-to-head path cells. |
| `head_endpoint` | String | Current metadata | Use `"end"`; editor reverses cells when the opposite endpoint becomes the head. |
| `direction` | Two integers | Compatibility mirror | Must equal the final segment and is validator-enforced. |

`direction` remains for the current loader, but authors and tools must derive it rather than choose it independently.

## 6. Cell rules

- At least two cells.
- Zero-based coordinates.
- Every cell inside the board.
- No duplicate cells.
- No overlap between different paths.
- Consecutive cells must be exactly one cardinal step apart.
- No diagonal segment.
- No disconnected jump.
- The final cell is the head endpoint.
- The first cell is the tail endpoint.
- The final segment must produce one of `UP`, `DOWN`, `LEFT`, or `RIGHT`.

## 7. Valid compatibility directions

| JSON | Runtime |
|---|---|
| `[0, -1]` | `Vector2i.UP` |
| `[0, 1]` | `Vector2i.DOWN` |
| `[-1, 0]` | `Vector2i.LEFT` |
| `[1, 0]` | `Vector2i.RIGHT` |

For this path:

```json
"cells": [[2, 1], [3, 1], [3, 2]]
```

the only valid compatibility direction is:

```json
"direction": [0, 1]
```

because the final segment goes down.

## 8. Runtime representation

```gdscript
class_name PuzzlePieceData
extends Resource

@export var piece_id: int
@export var cells: Array[Vector2i]
@export var exit_direction: Vector2i
@export var head_endpoint: PathVisualGeometry.HeadEndpoint
```

`PuzzlePieceData.create(...)` derives `exit_direction` from the ordered endpoint. A legacy direction can be checked, but it is not a second source of truth.

## 9. Rendering

The renderer may trim the final `Line2D` segment so the shaft does not pass through the triangle. This is visual only.

The original final grid cell remains unchanged for:

- occupancy;
- movement validation;
- solver logic;
- touch selection;
- save/progression data.

## 10. Validation and migration

`LevelDataValidator` rejects direction mismatches and malformed ordered paths.

Preview legacy levels with:

```bash
godot --headless --path . --script tools/path_level_migration_preview.gd
```

Results:

- `CANONICAL`: final segment matches stored direction.
- `REVERSIBLE`: start endpoint matches; reverse cell order.
- `AMBIGUOUS`: neither endpoint matches; requires level-design review.

The preview tool never writes files.

## 11. File naming

```text
data/level1.json
data/level2.json
data/level3.json
...
```

New content must be exported as ordered JSON paths.
