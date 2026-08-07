# Pathbreak — Technical Plan

**Status:** Current vertical-slice architecture  
**Last reviewed:** 2026-08-07

## 1. Runtime target

- Godot 4.7.1 Stable.
- Typed GDScript.
- Android portrait.
- Linux desktop/headless verification.
- Offline gameplay.

## 2. Supported flow

```text
MainMenu.tscn
  → LevelSelect.tscn or game/game_screen.tscn
  → board + HUD
  → pause/settings, failure, result, or hint refill
  → next, replay, select, or menu
```

The removed monolithic legacy stack is unsupported.

## 3. Core modules

| Module | Responsibility |
|---|---|
| `level_manager.gd` | Connected loop, loading, counters, progression, hints, overlays |
| `board_manager.gd` | Board construction, occupancy, centralized touch selection |
| `puzzle_piece.gd` | Shared path rendering and feedback |
| `path_visual_geometry.gd` | Ordered endpoint direction, triangle geometry, shaft trimming, migration helpers |
| `movement_validator.gd` | Pure escape-rule validation |
| `level_data_validator.gd` | Structural and ordered-path validation |
| `level_solver.gd` | Solution enumeration and dead-end analysis |

## 4. Ordered path model

Every path is authored:

```text
tail → intermediate cells → head
```

Current canonical head endpoint is the final cell.

```gdscript
exit_direction = cells[-1] - cells[-2]
```

The same derived value controls:

- triangle orientation;
- escape validation;
- escape animation;
- hint direction;
- editor preview;
- solver behavior.

The compatibility JSON `direction` field must mirror this derived value and is not an independent source of truth.

## 5. Data pipeline

1. Load sequential `data/levelN.json` or fallback `.tres`.
2. Parse cells into typed `PuzzlePieceData`.
3. Derive direction from the ordered endpoint.
4. Compare any compatibility direction.
5. Validate dimensions, IDs, ordered cells, direction invariant, bounds, and overlaps.
6. Stop at the first invalid sequential level.
7. Pass typed data to the board.

## 6. Rendering

- `Line2D` renders the ordered shaft.
- `Polygon2D` renders one generated triangle.
- The final rendered shaft point is shortened before the triangle.
- Grid cells remain unchanged for occupancy and puzzle logic.
- The tail marker remains at the opposite endpoint.
- Menu and gameplay use the same geometry helper.
- No imported directional sprites, negative-scale flips, or per-level rotations.

## 7. Occupancy and movement

- Occupancy maps every path cell to a piece ID.
- `MovementValidator` scans from every occupied cell in the derived exit direction.
- Self-owned cells are ignored.
- Another piece blocks escape.
- Occupancy is removed before successful escape animation.
- Restart rebuilds occupancy from typed level data.

## 8. Input

- Board receives touch/mouse centrally.
- Nearest eligible path within a scale-adjusted radius wins.
- Removed/animating paths are excluded.
- Input locks during overlays and automatic final clear.
- UI cards use native Button targets.

## 9. Hint system

- Persistent count lives in `SaveManager`.
- Incomplete Level 1 tutorial receives a free hint.
- Normal hints consume and save immediately.
- Zero opens `Refill +3` in the testing build.
- Hint marker is a small directional triangle moving along the final segment.
- Reduce Motion uses a static full-path highlight.

## 10. Persistence

### Progress

- Save version.
- Current/unlocked level.
- Hint inventory.
- Tutorial completion.
- Per-level stars, time, moves, and mistakes.

### Settings

- Sound.
- Haptics.
- Reduce Motion.
- High Contrast.

## 11. Level authoring and migration

The current experimental Level Editor now:

- records cells in draw order;
- derives direction from the final segment;
- reverses the path when the opposite endpoint is selected;
- rejects arbitrary unrelated direction choices;
- exports ordered JSON.

Preview old level data without writing files:

```bash
godot --headless --path . --script tools/path_level_migration_preview.gd
```

## 12. Automated verification

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tools/path_level_migration_preview.gd
godot --headless --path . --script tests/test_path_visual_geometry.gd
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

## 13. Manual verification

- Levels 1–5 head placement and movement direction.
- Four cardinal and four L-shaped final segments.
- Shaft/head overlap.
- Hint marker direction.
- Fresh-save tutorial.
- Refill, restart, pause, failure, result, and progression.
- Reduce Motion and High Contrast.
- Android touch, Back, lifecycle, phone/tablet layout.

## 14. Next architecture work after slice approval

- Production modular level editor.
- Batch level metrics and validation.
- Save migrations.
- Analytics contract.
- Android export/signing.
- Production hint economy.
- Crash reporting.
