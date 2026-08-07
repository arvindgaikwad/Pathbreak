# Pathbreak — Project Handoff and Continuation Guide

**Status:** Current project recovery document  
**Last reviewed:** 2026-08-07  
**Repository:** `arvindgaikwad/Pathbreak`  
**Active branch:** `codex/vertical-slice-level-review`  
**Active draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Use this document if the current conversation is lost. Then read `TASKS.md`, `docs/README.md`, `docs/ARROW_SYSTEM_AUDIT.md`, `docs/SNAKE_ESCAPE_ANIMATION.md`, and the latest playtest record.

## 1. Product summary

Pathbreak is an original portrait Android puzzle game built in Godot 4.7.1. Players clear ordered directional paths when their complete escape route is unobstructed.

The current objective is to approve the five-level vertical slice before building the production level pipeline, final art, or monetization.

## 2. Accepted gameplay foundation

The user has confirmed these major gates:

- ordered-arrow parser/automated gate passed;
- movement regression gate passed;
- new-player direction-comprehension gate passed;
- corrected arrow visuals are accepted;
- snake-style corner escape is working as intended.

Canonical path rule:

```text
tail → ... → head
final segment = arrowhead direction = movement direction
```

Do not return to projection-based head placement, per-level rotations, negative-scale direction hacks, or separate visual/movement direction values.

## 3. Snake escape rule

Bent paths must not slide as rigid L-shapes.

Accepted behavior:

```text
head advances
→ tail follows the original path
→ bend travels through the body
→ path becomes straight
→ straight path exits
```

Reduce Motion keeps the simpler translation/fade.

See `docs/SNAKE_ESCAPE_ANIMATION.md`.

## 4. Confirmed working systems

- Main Menu starts the game.
- Hero board and Start/Continue open the same recommended level.
- Level Select and Levels 1–10 load.
- Central nearest-path touch selection.
- Progression, failure, retry, results, Replay, Next Level.
- Hint use and persistent hint bank.
- `Refill +3` flow.
- Restart.
- Automatic final clear without adding a Move.
- Clean-save Level 1 `FREE` hint state.
- Level 2 normal five-hint state.
- Replaying Level 1 shows normal hint inventory.
- `No path can leave yet` feedback.

## 5. Latest change: Level 4–5 difficulty tuning

Earlier playtests showed the game was enjoyable but too easy. Typical early clears were around 10 seconds; Level 4 was cleared in 7 seconds and Level 5 in 16 seconds by the returning tester.

### New Level 4

- 8×8 board;
- 9 pieces;
- 2 opening moves;
- both openings reveal different next safe paths;
- 15 solution orders;
- multiple bent paths;
- target new-player time: 20–35 seconds.

Expected structural checks:

```text
start → [1, 5]
after 1 → [4, 5]
after 5 → [1, 7]
```

### New Level 5

- 8×8 board;
- 10 pieces;
- 1 opening move;
- five-step staged dependency read before the first branch;
- 10 solution orders;
- multiple bent paths;
- target new-player time: 30–45 seconds.

Expected early structure:

```text
start → [5]
after 5 → [6]
after 5,6 → [9]
after 5,6,9 → [7]
after 5,6,9,7 → [4]
after 5,6,9,7,4 → [2, 8]
```

These layouts are implemented but not approved until the current parser/solver and playtest pass.

## 6. Architecture to preserve

- Godot 4.7.1 and typed GDScript.
- Android portrait target.
- Main Menu startup scene.
- Modular gameplay stack:
  - `scenes/game/game_screen.tscn`
  - `scripts/gameplay/level_manager.gd`
  - `scripts/gameplay/board_manager.gd`
  - `scripts/gameplay/puzzle_piece.gd`
- One shared `PuzzlePiece` scene/script for all levels.
- JSON-first level loading.
- Separate `MovementValidator`, `LevelDataValidator`, and `LevelSolver`.
- Central nearest-path touch selection.
- Separate `SaveManager` and `SettingsManager`.

## 7. Immediate next actions

Follow `TASKS.md`. Current order:

1. Pull latest branch.
2. Run parser scan.
3. Run migration preview.
4. Run ordered-path geometry test; expected `7/7`.
5. Run movement/data tests.
6. Run vertical-slice tests; expected `7/7`.
7. Confirm Level 4 = 9 pieces / 2 openings / 15 solutions.
8. Confirm Level 5 = 10 pieces / 1 opening / 10 solutions.
9. Play tuned Level 4 three times.
10. Play tuned Level 5 three times.
11. Run at least one no-explanation player test on the new layouts.
12. Move to Android phone/tablet verification.

## 8. Local paths and commands

Godot:

```text
/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64
```

Project:

```text
/home/silver/Downloads/godot games /projects/arrow puzzle
```

Verification:

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

## 9. Vertical slice exit criteria

- current parser and automated tests pass;
- Levels 1–3 remain regression-free;
- tuned Level 4 produces deliberate choice without confusion;
- tuned Level 5 produces deeper dependency reading without confusion;
- snake motion remains correct;
- Main Menu/layout checks pass;
- High Contrast and Reduce Motion pass;
- Android phone test passes;
- Android tablet test passes;
- remaining defects are documented.

## 10. After approval

Next milestone is the production level pipeline:

- ordered tail-to-head editor;
- schema validation;
- solver integration;
- opening/solution/dependency metrics;
- difficulty/playtest metadata;
- phone/tablet preview;
- versioned JSON export and batch validation.

Final UI/art follows after gameplay and content production foundations are proven.

## 11. New-conversation continuation prompt

```text
Continue development of my Godot project Pathbreak in GitHub repository arvindgaikwad/Pathbreak.

Read these files on branch codex/vertical-slice-level-review:
1. docs/PROJECT_HANDOFF.md
2. TASKS.md
3. docs/ARROW_SYSTEM_AUDIT.md
4. docs/SNAKE_ESCAPE_ANIMATION.md
5. docs/README.md
6. docs/DECISIONS.md
7. docs/AI_ANTI_SLOP_STANDARD.md
8. docs/VERTICAL_SLICE_PLAYTEST_2026-08-06.md
9. docs/TESTING_CHECKLIST.md

The active draft is PR #8. Do not merge it yet. Preserve the modular JSON-first architecture. Ordered cells are tail-to-head; the final segment controls both head and movement direction. Bent paths use the accepted snake uncoil animation. Levels 4 and 5 have just been difficulty-tuned and are pending parser/solver/playtest verification. Continue from the first incomplete P0 task in TASKS.md.
```
