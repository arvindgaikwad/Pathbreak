# Pathbreak — Project Handoff and Continuation Guide

**Status:** Current project recovery document  
**Last reviewed:** 2026-08-07  
**Repository:** `arvindgaikwad/Pathbreak`  
**Active branch:** `codex/vertical-slice-level-review`  
**Active draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Use this document if the current conversation is lost. Then read `TASKS.md`, `docs/README.md`, `docs/ARROW_SYSTEM_AUDIT.md`, `docs/SNAKE_ESCAPE_ANIMATION.md`, `docs/ANDROID_VERTICAL_SLICE_QA.md`, and the latest playtest record.

## 1. Product summary

Pathbreak is an original portrait Android puzzle game built in Godot 4.7.1. Players clear ordered directional paths when their complete escape route is unobstructed.

The current objective is to close Android/device/accessibility verification for the five-level vertical slice before building the production level pipeline, final art, or monetization.

## 2. Accepted gameplay foundation

The user has confirmed these major gates:

- ordered-arrow parser/automated gate passed;
- movement regression gate passed;
- new-player direction-comprehension gate passed;
- corrected arrow visuals are accepted;
- snake-style corner escape is working as intended;
- Levels 4–5 now take roughly 30–40 seconds in the latest two-person test and are accepted for the slice.

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

## 5. Levels 4–5 are frozen for platform QA

### Level 4

- 8×8 board;
- 9 pieces;
- 2 opening moves;
- 15 solution orders encoded in tests;
- latest two-person completion time: roughly 30–40 seconds.

### Level 5

- 8×8 board;
- 10 pieces;
- 1 opening move;
- 10 solution orders encoded in tests;
- latest two-person completion time: roughly 30–40 seconds.

**Decision:** do not continue increasing difficulty. Reopen Levels 1–5 only when Android/device testing reveals a concrete defect or later player evidence shows confusion/frustration.

## 6. Android preparation now in the repository

Added:

```text
export_presets.cfg
tools/android_vertical_slice.sh
docs/ANDROID_VERTICAL_SLICE_QA.md
```

The committed `Android Debug` preset:

- exports to `builds/android/pathbreak-debug.apk`;
- includes ARMv7 and ARM64;
- explicitly includes `*.json`, which is required because level JSON is the canonical non-resource level format;
- enables Android vibration permission for haptics;
- keeps Internet permission disabled for this offline slice;
- uses temporary package ID `com.pathbreak.verticalslice`.

The temporary package ID is for device testing only. Do not publish it to Google Play. Final package ID follows final name and publisher decisions.

Local Android SDK/JDK paths and keystore credentials are machine-local and must not be committed.

See `docs/ANDROID_VERTICAL_SLICE_QA.md`.

## 7. Architecture to preserve

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

## 8. Immediate next actions

Follow `TASKS.md`. Current sequence:

1. Pull latest branch.
2. Run `bash tools/android_vertical_slice.sh check`.
3. Resolve any missing Java/Android SDK/export-template requirements locally.
4. Run `bash tools/android_vertical_slice.sh test` for the final post-snake/post-difficulty current-head regression.
5. Run `bash tools/android_vertical_slice.sh export`.
6. Connect an authorized Android phone and run `bash tools/android_vertical_slice.sh install`.
7. Execute phone QA from `docs/ANDROID_VERTICAL_SLICE_QA.md`.
8. Install/test on Samsung Galaxy Tab S6 Lite or another Android tablet.
9. Close Reduce Motion, High Contrast, Sound/Haptics persistence, compact-phone, and tablet-layout checks.
10. Approve or reject the vertical slice.

## 9. Local paths and commands

Godot:

```text
/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64
```

Project:

```text
/home/silver/Downloads/godot games /projects/arrow puzzle
```

Pull:

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review
```

Android workflow:

```bash
bash tools/android_vertical_slice.sh check
bash tools/android_vertical_slice.sh test
bash tools/android_vertical_slice.sh export
bash tools/android_vertical_slice.sh install
```

Or:

```bash
bash tools/android_vertical_slice.sh all
```

Device logs:

```bash
bash tools/android_vertical_slice.sh logcat
```

Run the full desktop game with **F5**, not F6.

## 10. Android setup reference

Godot 4.7 desktop Android export requires a local Java SDK, Android SDK, and matching export templates. Godot 4.7 documentation recommends OpenJDK 17 and current Android SDK components.

In Godot configure:

```text
Editor Settings → Export → Android
```

Set:

- Java SDK Path;
- Android SDK Path.

Do not put those machine-specific paths in project files.

## 11. Vertical slice exit criteria

- current post-snake/post-Level-4–5 parser and automated tests pass;
- Levels 1–5 remain regression-free;
- Levels 4–5 remain in the accepted timing/readability range;
- snake motion remains correct;
- Main Menu/layout checks pass;
- High Contrast and Reduce Motion pass;
- Sound/Haptics persistence pass;
- Android phone test passes;
- Android tablet test passes;
- remaining defects are documented.

## 12. After approval

Next milestone is the production level pipeline:

- ordered tail-to-head editor;
- schema validation;
- solver integration;
- opening/solution/dependency metrics;
- difficulty/playtest metadata;
- phone/tablet preview;
- versioned JSON export and batch validation.

Final UI/art follows after gameplay and content production foundations are proven.

Google Play release preparation is later and requires a final globally unique package ID, release keystore outside Git, Gradle/AAB export, final launcher icons, privacy/Data Safety work, and closed testing.

## 13. New-conversation continuation prompt

```text
Continue development of my Godot project Pathbreak in GitHub repository arvindgaikwad/Pathbreak.

Read these files on branch codex/vertical-slice-level-review:
1. docs/PROJECT_HANDOFF.md
2. TASKS.md
3. docs/ARROW_SYSTEM_AUDIT.md
4. docs/SNAKE_ESCAPE_ANIMATION.md
5. docs/ANDROID_VERTICAL_SLICE_QA.md
6. docs/README.md
7. docs/DECISIONS.md
8. docs/AI_ANTI_SLOP_STANDARD.md
9. docs/VERTICAL_SLICE_PLAYTEST_2026-08-06.md
10. docs/TESTING_CHECKLIST.md

The active draft is PR #8. Do not merge it yet. Preserve the modular JSON-first architecture. Ordered cells are tail-to-head; the final segment controls both head and movement direction. Bent paths use the accepted snake-uncoil animation. Levels 1–5 are frozen for Android QA; Levels 4–5 currently take roughly 30–40 seconds in the latest two-person test. The immediate task is Android preflight/export/device QA using tools/android_vertical_slice.sh and docs/ANDROID_VERTICAL_SLICE_QA.md. Continue from the first incomplete P0 task in TASKS.md.
```
