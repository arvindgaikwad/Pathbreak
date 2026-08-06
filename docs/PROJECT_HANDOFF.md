# Pathbreak — Project Handoff and Continuation Guide

**Status:** Current project recovery document  
**Last reviewed:** 2026-08-07  
**Repository:** `arvindgaikwad/Pathbreak`  
**Active branch:** `codex/vertical-slice-level-review`  
**Active draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Use this document to continue the project if the current chat is lost. Read it together with `TASKS.md`, `docs/README.md`, `docs/ARROW_SYSTEM_AUDIT.md`, `docs/DECISIONS.md`, and the latest playtest record.

## 1. Product summary

Pathbreak is an original portrait Android puzzle game built in Godot 4.7.1. The player clears ordered directional paths in a sequence that lets each path escape without colliding with another path.

The current gate is a complete, tested vertical slice. Do not build the full level pack, final art, or monetization before this gate passes.

## 2. Confirmed working before the latest arrow migration

- Main Menu launches and recommends the first uncleared level.
- Menu hero board and Start/Continue open the same level.
- Travelling menu cue works.
- Level Select and Levels 1–10 load.
- Progression, failure, retry, results, Replay, and Next Level work.
- Central nearest-path touch selection works.
- Hint depletion and `Refill +3` work.
- Restart works.
- Automatic final clear works and does not add a Move.
- Reduce Motion alternatives work.
- `No path can leave yet` is useful.
- Clean-save menu shows `Start Level 1`.
- Level 1 shows `FREE` once.
- Level 2 starts with five normal hints.
- Replaying Level 1 shows the real hint inventory.

## 3. Latest implemented correction — pending local verification

Two expert prompts were combined:

1. Fix the shared system rather than manually rotating each level.
2. Treat every object as an ordered grid path whose head direction comes from its selected endpoint and adjacent cell.

Current canonical rule:

```text
cells are tail → ... → head
cells[-1] - cells[-2]
= arrowhead direction
= movement direction
```

Implemented:

- `scripts/gameplay/path_visual_geometry.gd`
- ordered endpoint direction and head/tail helpers;
- one triangle generator for menu and gameplay;
- shaft trimming before the triangle;
- directional triangle hint marker;
- `PuzzlePieceData` derives movement from ordered cells;
- `LevelDataValidator` rejects direction mismatches;
- Level Editor authors only ordered tail-to-head paths;
- preview-only legacy migration scanner;
- Levels 1–5 migrated;
- all-level geometry tests;
- movement tests updated for the ordered-path model.

Read `docs/ARROW_SYSTEM_AUDIT.md` for the root cause, files, migration counts, and acceptance checks.

## 4. Migration summary

Ten sequential levels were inspected.

Before migration:

- 13 paths did not match the final-segment convention;
- 7 could be repaired by reversing cell order;
- 6 matched neither endpoint and required small geometry changes;
- Levels 6–10 already followed the final-segment convention.

The Level 1–5 geometry changes were chosen to preserve the metric targets already encoded in `tests/test_vertical_slice_levels.gd`. They are not verified until the local solver test passes.

## 5. Architecture to preserve

- Godot 4.7.1 and typed GDScript.
- Android portrait target.
- Main Menu startup scene.
- Modular gameplay stack:
  - `scenes/game/game_screen.tscn`
  - `scripts/gameplay/level_manager.gd`
  - `scripts/gameplay/board_manager.gd`
  - `scripts/gameplay/puzzle_piece.gd`
- One shared `PuzzlePiece` scene/script for every level.
- JSON-first sequential level loading.
- `MovementValidator`, `LevelDataValidator`, and `LevelSolver` remain separate.
- Central nearest-path selection.
- `SaveManager` and `SettingsManager` remain separate.

Do not reintroduce the removed legacy gameplay stack, per-direction arrow scenes, negative-scale direction hacks, or per-level head rotations.

## 6. Current UI direction

### Main Menu

- Start/Continue must be obvious within one second.
- Board and primary button start the same level.
- Prompt must not overlap the board.
- Use restrained directional motion, not decorative sparkles.

### Level Select

- Keep four columns on compact phones.
- Completed, Current, Unlocked, and Locked states must be distinct.
- The recommended next level must be obvious.

Final art direction remains deferred.

## 7. Immediate next actions

Follow `TASKS.md`. Current order:

1. Pull the active branch.
2. Run the parser scan.
3. Run the migration preview.
4. Run the ordered-path geometry test.
5. Run movement, data, and vertical-slice solver tests.
6. Confirm the migration preview reports zero reversible and ambiguous paths.
7. Inspect Levels 1–5 visually.
8. Verify head direction equals movement direction.
9. Verify Reduce Motion and High Contrast.
10. Repeat no-explanation testing with new players.
11. Test Android phone and tablet.
12. Approve or reject the slice.

## 8. Local paths and commands

Godot:

```text
/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64
```

Project:

```text
/home/silver/Downloads/godot games /projects/arrow puzzle
```

Pull and verify:

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review

GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

"$GODOT" --headless --path . --editor --quit
"$GODOT" --headless --path . --script tools/path_level_migration_preview.gd
"$GODOT" --headless --path . --script tests/test_path_visual_geometry.gd
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
```

Run the full game with **F5**, not F6.

## 9. Ordered-path manual acceptance

- Head is a true endpoint.
- Head follows the adjacent final segment.
- Head and movement direction match.
- Bent paths do not use first-to-last direction.
- Shaft stops cleanly under the triangle.
- Tail is at the opposite endpoint.
- Hint marker points toward the same head.
- Menu and gameplay use the same rules.
- Touch, hint, restart, refill, failure, and automatic final clear do not regress.

## 10. Vertical-slice exit criteria

- Parser clean.
- All automated tests pass.
- Migration preview clean.
- Main Menu understandable without explanation.
- Ordered arrow/path language understood by new players.
- Hint/refill/restart/pause/navigation/save work.
- Reduce Motion and High Contrast work.
- Levels 1–5 pass director review.
- At least three new players provide evidence.
- Android phone/tablet checks pass.

## 11. Work after approval

- Production modular level editor.
- Solver and difficulty metrics inside the editor.
- Launch-sized original level pack.
- Final art/audio.
- Analytics, privacy, signing, testing, and store launch systems.

## 12. New-conversation continuation prompt

```text
Continue development of my Godot project Pathbreak in GitHub repository arvindgaikwad/Pathbreak.

Read these files on branch codex/vertical-slice-level-review:
1. docs/PROJECT_HANDOFF.md
2. TASKS.md
3. docs/ARROW_SYSTEM_AUDIT.md
4. docs/README.md
5. docs/DECISIONS.md
6. docs/AI_ANTI_SLOP_STANDARD.md
7. docs/VERTICAL_SLICE_PLAYTEST_2026-08-06.md
8. docs/TESTING_CHECKLIST.md

The active draft is PR #8. Do not merge it yet. Preserve the modular JSON-first architecture. The current arrow system uses ordered tail-to-head cells and derives both head and movement direction from the final segment. Treat all untested changes as unverified. Continue from the first incomplete P0 task in TASKS.md.
```
