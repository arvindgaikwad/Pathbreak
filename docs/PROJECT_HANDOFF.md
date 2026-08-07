# Pathbreak — Project Handoff and Continuation Guide

**Status:** Current project recovery document  
**Last reviewed:** 2026-08-07  
**Repository:** `arvindgaikwad/Pathbreak`  
**Active branch:** `codex/vertical-slice-level-review`  
**Active draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Use this document if the current conversation is lost. Then read `TASKS.md`, `docs/README.md`, `docs/ARROW_SYSTEM_AUDIT.md`, `docs/SNAKE_ESCAPE_ANIMATION.md`, `docs/SATISFACTION_BLUEPRINT.md`, `docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md`, `docs/ANDROID_VERTICAL_SLICE_QA.md`, and the latest playtest record.

## 1. Product summary

Pathbreak is an original portrait Android puzzle game built in Godot 4.7.1. Players clear ordered directional paths when their complete escape route is unobstructed.

The five-level gameplay slice is stable enough that the remaining production gate is platform/accessibility closure. Do not reopen Levels 1–5 unless a concrete regression appears.

Product direction after the slice:

> **Pathbreak is the satisfying living-path puzzle: a calm logic game where correct decisions visibly release tension from readable mechanisms.**

Quality hierarchy:

> **Clarity first, satisfaction second, spectacle third.**

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

Physical-device evidence exists on Samsung Galaxy Tab S6 Lite (`SM_P615`, Android 13):

- parser/data regression passed;
- APK exported/installed/launched;
- touch selection worked;
- snake animation was smooth;
- audio and haptics worked;
- initial landscape launch exposed an orientation defect;
- `project.godot` was corrected to portrait (`SCREEN_PORTRAIT = 1`);
- mobile-settings guard was added;
- user confirmed the corrected build now opens in portrait.

Still open:

- real Android phone test;
- tablet rotation-lock/full-flow portrait confirmation;
- Android Back for pause/refill;
- suspend/resume;
- force-close/reopen persistence;
- stylus-versus-finger comparison;
- High Contrast regression;
- Reduce Motion regression after final snake implementation;
- Sound/Haptics toggle persistence;
- rapid-tap Android navigation;
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

1. Close remaining Android/tablet portrait and lifecycle checks.
2. Test the debug APK on one physical Android phone.
3. Verify Android Back, background/resume, force-close/reopen persistence.
4. Verify stylus vs finger on tablet.
5. Verify High Contrast and Reduce Motion on the final snake build.
6. Restart the app and confirm Sound/Haptics toggles persist.
7. Verify rapid-tap navigation and chapter-complete state.
8. Record remaining defects with severity.
9. Approve the vertical slice if all gates pass.
10. Start `Satisfaction Prototype v1` from `docs/SATISFACTION_BLUEPRINT.md`.
11. Only after the satisfaction prototype is accepted, build the Production Level Studio.

## 9. Satisfaction Prototype v1

This milestone exists to prove Pathbreak's differentiation before mass-producing levels.

Prototype only:

- successful-release polish;
- one-shot feedback when a path becomes newly available;
- readable dependency-unravel rhythm;
- improved final clear/completion settle;
- small success/resistance/completion audio pack;
- accessibility parity;
- Android performance check;
- three-person satisfaction/readability test;
- three genuine 5–10 second gameplay clips.

Do not build fake ad-only mechanics. Do not add spectacle that reduces puzzle clarity.

See `docs/SATISFACTION_BLUEPRINT.md`.

## 10. Local paths and commands

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

## 11. Vertical slice exit criteria

Already passed:

- core gameplay/readability gates;
- Levels 1–5 gameplay review;
- Levels 4–5 timing/readability target;
- snake motion;
- physical Android tablet build/install/run with positive touch/performance evidence;
- corrected Android portrait launch.

Still required:

- physical Android phone test;
- remaining tablet Back/lifecycle/persistence/rotation checks;
- High Contrast and Reduce Motion;
- Sound/Haptics persistence;
- remaining menu closure checks;
- remaining defects documented.

## 12. Production order after approval

```text
Approve vertical slice
→ Satisfaction Prototype v1
→ Three-person satisfaction/readability test
→ Real gameplay clip test
→ Lock Pathbreak feel language
→ Production Level Studio
→ First 20 polished levels
→ Wider playtest
→ Final UI/art/audio identity
→ Scale content
→ Retention/monetization
→ Google Play launch preparation
```

Google Play release preparation later requires a final globally unique package ID, release keystore outside Git, Gradle/AAB export, final launcher icons, privacy/Data Safety work, and closed testing.

## 13. New-conversation continuation prompt

```text
Continue development of my Godot project Pathbreak in GitHub repository arvindgaikwad/Pathbreak.

Read these files on branch codex/vertical-slice-level-review:
1. docs/PROJECT_HANDOFF.md
2. TASKS.md
3. docs/SATISFACTION_BLUEPRINT.md
4. docs/ARROW_SYSTEM_AUDIT.md
5. docs/SNAKE_ESCAPE_ANIMATION.md
6. docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md
7. docs/ANDROID_VERTICAL_SLICE_QA.md
8. docs/README.md
9. docs/DECISIONS.md
10. docs/AI_ANTI_SLOP_STANDARD.md
11. docs/VERTICAL_SLICE_PLAYTEST_2026-08-06.md
12. docs/TESTING_CHECKLIST.md

The active draft is PR #8. Do not merge it yet. Preserve the modular JSON-first architecture. Ordered cells are tail-to-head; the final segment controls both head and movement direction. Bent paths use the accepted snake-uncoil animation. Levels 1–5 are frozen. Pathbreak's approved differentiation is 'the satisfying living-path puzzle' with the rule 'clarity first, satisfaction second, spectacle third.' Finish the remaining Android/accessibility gates first. After vertical-slice approval, build Satisfaction Prototype v1 before the Production Level Studio.
```
