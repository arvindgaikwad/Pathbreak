# Pathbreak — Technical Plan

**Status:** Current vertical-slice architecture  
**Last reviewed:** 2026-08-06

## 1. Runtime target

- Engine: Godot 4.7.1 Stable.
- Language: typed GDScript.
- Primary platform: Android portrait.
- Development verification: Linux desktop and headless Godot.
- Renderer: Compatibility.
- Gameplay network dependency: none.

## 2. Supported application flow

```text
MainMenu.tscn
  → LevelSelect.tscn or game/game_screen.tscn
  → gameplay board + HUD
  → pause/settings, failure, result, or hint refill overlay
  → next level, replay, level select, or main menu
```

The removed legacy monolithic gameplay stack is not supported.

## 3. Core gameplay modules

| Module | Responsibility |
|---|---|
| `scripts/gameplay/level_manager.gd` | Connected game loop, level loading, counters, progression, hints, overlays |
| `scripts/gameplay/board_manager.gd` | Board construction, occupancy, centralized touch selection, candidate queries |
| `scripts/gameplay/puzzle_piece.gd` | Programmatic path visuals and path feedback animations |
| `scripts/gameplay/movement_validator.gd` | Pure escape-rule validation |
| `scripts/gameplay/level_data_validator.gd` | Structural validation of loaded level data |
| `scripts/gameplay/level_solver.gd` | Structural slice analysis and complete solution enumeration |

## 4. Level data pipeline

1. Search sequentially for `data/levelN.json` or fallback `.tres` definitions.
2. Prefer JSON when present.
3. Parse JSON into typed `PuzzleLevelData` and `PuzzlePieceData` runtime objects.
4. Validate board dimensions, piece identifiers, cells, directions, and overlaps.
5. Stop loading the pack at the first missing or invalid sequential level.
6. Pass typed data to the board.

JSON is canonical. `.tres` remains a temporary compatibility fallback.

## 5. Occupancy and movement

- Occupancy maps each `Vector2i` cell to a piece identifier.
- `MovementValidator.can_escape(...)` scans from every occupied path cell in the path's exit direction.
- Cells owned by the same path are ignored.
- A different occupying piece blocks the escape.
- Occupancy is removed before successful escape animation begins.
- Restart rebuilds a fresh board and occupancy map.

## 6. Input model

- The board receives touch/mouse input centrally.
- It computes distance to each available path.
- The nearest path within a scale-adjusted acceptance radius is selected.
- Removing or animating paths are excluded.
- Gameplay input is locked while pause, failure, result, or hint-refill flows are active.
- HUD card descendants ignore mouse input so the parent card receives a reliable single activation.

## 7. Hint system

- `SaveManager.hint_count` is the persistent source of truth between sessions.
- `level_manager.gd` keeps the active level's `hints_left` synchronized with the save.
- The incomplete Level 1 tutorial receives a free hint.
- Normal hints decrement and save immediately.
- At zero, the HUD shows `Refill +3` and opens `hint_refill_popup.tscn`.
- Confirming the current testing refill restores three hints, synchronizes the active level, updates the HUD, and saves immediately.
- The final commercial refill provider is intentionally abstracted from this vertical-slice rule and has not been selected.

## 8. Persistence

### Progress save

Managed by `scripts/SaveManager.gd`:

- Save version.
- Current level.
- Maximum unlocked level.
- Hint inventory.
- Lives default.
- Difficulty string.
- Tutorial completion.
- Per-level stars, best time, best moves, and best mistakes.

Invalid or missing save data falls back to safe defaults.

### Settings save

Managed independently by `SettingsManager`:

- Sound.
- Haptics.
- Reduce Motion.
- High Contrast.

## 9. Responsive layout

- Gameplay reserves top and bottom HUD regions and scales the board into the remaining portrait area.
- The board pivot is centered within the available area.
- UI screens use Control containers and anchors.
- Manual target checks include compact phones through high-resolution portrait tablets.

## 10. Automated verification

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

The editor scan checks parser and warning cleanliness. The script tests check movement rules, data validation, and slice structure/solvability.

## 11. Required manual verification

- Fresh-save tutorial and free-hint behavior.
- Hint depletion, `Refill +3`, cancel, confirm, persistence, and subsequent hint use.
- Level failure, retry, replay, and next-level flow.
- Android touch selection and system Back behavior.
- Phone/tablet layout.
- Sound/haptic toggles.
- Reduce Motion and High Contrast.
- Save persistence after closing and reopening the game.

## 12. Next architecture work after slice approval

- Internal level editor.
- Batch level validation and difficulty reporting.
- Explicit save migrations for future versions.
- Analytics event contract.
- Android export/signing configuration.
- Production hint economy provider.
- Crash reporting and release diagnostics.
