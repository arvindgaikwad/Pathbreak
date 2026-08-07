# Pathbreak — Project Handoff and Continuation Guide

**Status:** Current project recovery document  
**Last reviewed:** 2026-08-07  
**Repository:** `arvindgaikwad/Pathbreak`  
**Active branch:** `codex/vertical-slice-level-review`  
**Active draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Use this document if the current conversation is lost. Then read `TASKS.md`, `docs/README.md`, `docs/ARROW_SYSTEM_AUDIT.md`, `docs/SNAKE_ESCAPE_ANIMATION.md`, `docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md`, `docs/ANDROID_VERTICAL_SLICE_QA.md`, and the latest playtest record.

## 1. Product summary

Pathbreak is an original portrait Android puzzle game built in Godot 4.7.1. Players clear ordered directional paths when their complete escape route is unobstructed.

The five-level gameplay slice is now stable enough that the remaining production gate is almost entirely platform/accessibility closure. Do not reopen Levels 1–5 unless a concrete regression appears.

## 2. Accepted gameplay foundation

The user has confirmed:

- ordered-arrow parser/automated gate passed;
- movement regression gate passed;
- new-player direction-comprehension gate passed;
- corrected arrow visuals are accepted;
- snake-style corner escape is working as intended;
- Levels 4–5 take roughly 30–40 seconds in the latest two-person test and are accepted for the slice.

Canonical path rule:

```text
tail → ... → head
final segment = arrowhead direction = movement direction
```

Do not return to projection-based head placement, per-level rotations, negative-scale direction hacks, or separate visual/movement direction values.

## 3. Snake escape rule

Accepted bent-path motion:

```text
head advances
→ tail follows the original path
→ bend travels through the body
→ path becomes straight
→ straight path exits
```

Reduce Motion keeps the simpler translation/fade.

## 4. Confirmed working systems

- Main Menu and recommended-level flow.
- Level Select and Levels 1–10 loading.
- Central nearest-path touch selection.
- Progression, failure, retry, results, Replay, Next Level.
- Persistent hints and `Refill +3`.
- Restart.
- Automatic final clear without adding a Move.
- Clean-save Level 1 `FREE` hint state.
- Level 2 normal five-hint state.
- Replaying Level 1 shows normal hint inventory.
- `No path can leave yet` feedback.
- Ordered path visuals and snake escape motion.

## 5. Frozen vertical-slice difficulty

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

Do not increase difficulty further without new evidence.

## 6. Android verification status

Android QA infrastructure in the repository:

```text
export_presets.cfg
tools/android_vertical_slice.sh
docs/ANDROID_VERTICAL_SLICE_QA.md
docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md
```

Testing preset:

- output: `builds/android/pathbreak-debug.apk`;
- ARMv7 + ARM64;
- explicit `*.json` export inclusion;
- vibration permission enabled;
- Internet permission disabled;
- temporary package ID `com.pathbreak.verticalslice`.

### Passed on 2026-08-07

Physical device: Samsung Galaxy Tab S6 Lite (`SM_P615`, Android 13).

Recorded evidence:

- Godot parser scan passed with no parse errors/warnings reported;
- migration preview passed, 10 levels / 83 pieces canonical;
- ordered geometry `7/7`;
- movement validator `10/10`;
- level-data validator `8/8`;
- vertical-slice level suite `7/7`;
- debug APK exported successfully;
- APK installed and launched on physical hardware;
- touch selection reported reliable;
- responsive scaling reported correct;
- snake animation reported smooth at 60 FPS;
- audio and haptics reported working.

PR #9 integrated this device-verification evidence back into the active branch.

### Still open

- real Android phone test;
- explicit Android Back behavior for pause/refill;
- suspend/resume;
- force-close/reopen persistence;
- stylus-versus-finger comparison on tablet;
- High Contrast regression;
- Reduce Motion regression after final snake implementation;
- Sound/Haptics toggle persistence;
- rapid-tap double-navigation on Android;
- chapter-complete menu state.

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

1. Test the debug APK on one physical Android phone.
2. On phone, verify touch accuracy, close paths, multi-touch, rapid menu taps, snake animation, sound, and haptics.
3. Verify Android Back closes refill/pause correctly.
4. Verify background/resume and force-close/reopen persistence.
5. On tablet, explicitly compare stylus and finger input and repeat Back/lifecycle checks.
6. Verify High Contrast and Reduce Motion on the final snake build.
7. Restart the app and confirm Sound/Haptics toggles persist.
8. Verify chapter-complete menu state.
9. Record any defects with severity.
10. If all remaining gates pass, approve the vertical slice and begin the production level pipeline.

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

Device logs:

```bash
bash tools/android_vertical_slice.sh logcat
```

Run the full desktop game with **F5**, not F6.

## 10. Vertical slice exit criteria

Already passed:

- current parser and automated regression;
- Levels 1–5 gameplay review;
- Levels 4–5 timing/readability target;
- snake motion;
- one physical Android tablet build/install/run with positive touch/performance evidence.

Still required:

- physical Android phone test;
- remaining tablet Back/lifecycle/persistence checks;
- High Contrast and Reduce Motion;
- Sound/Haptics persistence;
- remaining menu closure checks;
- remaining defects documented.

## 11. After approval

Next milestone is the production level pipeline:

- ordered tail-to-head editor;
- schema validation;
- solver integration;
- opening/solution/dependency metrics;
- difficulty/playtest metadata;
- phone/tablet preview;
- versioned JSON export and batch validation.

Final UI/art follows after gameplay and content-production foundations are proven.

Google Play release preparation is later and requires a final globally unique package ID, release keystore outside Git, Gradle/AAB export, final launcher icons, privacy/Data Safety work, and closed testing.

## 12. New-conversation continuation prompt

```text
Continue development of my Godot project Pathbreak in GitHub repository arvindgaikwad/Pathbreak.

Read these files on branch codex/vertical-slice-level-review:
1. docs/PROJECT_HANDOFF.md
2. TASKS.md
3. docs/ARROW_SYSTEM_AUDIT.md
4. docs/SNAKE_ESCAPE_ANIMATION.md
5. docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md
6. docs/ANDROID_VERTICAL_SLICE_QA.md
7. docs/README.md
8. docs/DECISIONS.md
9. docs/AI_ANTI_SLOP_STANDARD.md
10. docs/VERTICAL_SLICE_PLAYTEST_2026-08-06.md
11. docs/TESTING_CHECKLIST.md

The active draft is PR #8. Do not merge it yet. Preserve the modular JSON-first architecture. Ordered cells are tail-to-head; the final segment controls both head and movement direction. Bent paths use the accepted snake-uncoil animation. Levels 1–5 are frozen. Current-head automated regression passed, and the debug APK was successfully verified on a Samsung Galaxy Tab S6 Lite. The remaining gates are physical Android phone testing, tablet Back/lifecycle/persistence, High Contrast, Reduce Motion, settings persistence, rapid-tap Android navigation, and chapter-complete state. Continue from the first incomplete P0 task in TASKS.md.
```
