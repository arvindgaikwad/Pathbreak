# Pathbreak — Android Device QA & Verification Report

**Date:** 2026-08-07  
**Target Device:** Samsung Galaxy Tab S6 Lite (`SM_P615` / `gta4xl`)  
**OS Version:** Android 13 / One UI 5.1  
**Package Name:** `com.pathbreak.verticalslice`  
**Build Artifact:** `builds/android/pathbreak-debug.apk` (56 MB)  
**Status:** ⚠️ **PARTIAL PASS — PORTRAIT ORIENTATION RETEST REQUIRED**

---

## 1. Summary of Execution

Pathbreak was compiled, exported, installed, and launched on physical Android hardware using Godot 4.7.1 stable and the automated pipeline script `tools/android_vertical_slice.sh`.

The initial device pass proved that the APK, packaged JSON levels, touch input, animation, audio, and haptics function on hardware. However, the application launched in landscape on the tablet. Because Pathbreak is a portrait-first game, the Android platform gate is not complete until a rebuilt APK launches and remains in portrait.

### Key Verification Milestones

1. **ETC2/ASTC Texture Compression**:
   - Configured `textures/vram_compression/import_etc2_astc=true` in `project.godot`.
   - Verified clean APK compilation with 0 texture import errors.

2. **Build & Sign Pipeline**:
   - Compiled with OpenJDK 21 (Android Studio JBR).
   - Zip-aligned and signed debug APK (`pathbreak-debug.apk`).

3. **Hardware Deployment**:
   - Streamed APK installation over ADB to Samsung Galaxy Tab S6 Lite.
   - Launched `com.pathbreak.verticalslice/com.godot.game.GodotAppLauncher`.
   - Initial active surface was `2000×1200`, confirming the build was running in landscape rather than the intended portrait orientation.

---

## 2. Automated Regression & Quality Matrix

The pre-orientation-fix build passed the gameplay/data regression suites:

| Test Suite | Result | Details |
|---|---|---|
| **Editor Parser Scan** | ✅ PASS | 0 GDScript parse errors or warnings reported |
| **Path Migration Preview** | ✅ PASS | 10 levels / 83 pieces canonical |
| **Path Visual Geometry** | ✅ PASS | 7 / 7 tests passed |
| **Movement Validator** | ✅ PASS | 10 / 10 tests passed |
| **Level Data Validator** | ✅ PASS | 8 / 8 tests passed |
| **Vertical Slice Levels** | ✅ PASS | 7 / 7 tests passed |

A new mobile-project-settings regression test has now been added and must pass on the corrected head before the rebuilt APK is accepted.

---

## 3. Physical Device Findings

### Passed

- Nearest-path touch selection functions reliably on touch hardware.
- Snake-style uncoiling escape animation is smooth.
- UI overlays respond correctly.
- Native sound playback works.
- Haptics work.
- APK installation and packaged JSON loading work.

### Failed / reopened

- **Orientation:** initial build launched in landscape on the Samsung Galaxy Tab S6 Lite.

The previous report incorrectly described the `2000×1200` tablet surface as portrait. That statement is superseded by this correction.

---

## 4. Portrait root correction

`project.godot` previously stored:

```text
window/handheld/orientation="portrait"
```

Godot's mobile orientation setting is an enum integer. The project now stores:

```text
window/handheld/orientation=1
```

where `1` is `DisplayServer.SCREEN_PORTRAIT`.

Additional protection added:

- `tests/test_mobile_project_settings.gd` verifies portrait orientation and a portrait design viewport.
- `tools/android_vertical_slice.sh check` fails if the committed orientation is not `SCREEN_PORTRAIT = 1`.
- `tools/android_vertical_slice.sh test` runs the new mobile settings regression test before the gameplay suites.

---

## 5. Required retest

Rebuild and reinstall from the corrected branch:

```bash
bash tools/android_vertical_slice.sh test
bash tools/android_vertical_slice.sh export
bash tools/android_vertical_slice.sh install
```

Then verify on the Tab S6 Lite:

- [ ] App launches in portrait.
- [ ] Rotating the tablet does not move the game into landscape.
- [ ] Main Menu is vertically composed correctly.
- [ ] Gameplay board/HUD remain centered in portrait.
- [ ] Pause, refill, result, and Level Select remain readable.
- [ ] Touch, snake animation, sound, and haptics still work.

Only after this retest should the tablet platform check be marked passed.
