# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Close the few remaining phone, lifecycle, accessibility/settings, and layout gates for the five-level vertical slice. Levels 1–5 are frozen unless new evidence reveals a regression.

## Approved gameplay foundations

- [x] One shared ordered path system: `tail → ... → head`.
- [x] Final segment = arrowhead direction = escape direction.
- [x] Centralized arrow renderer; no per-level rotation hacks.
- [x] Correct triangle head/tail visual language accepted.
- [x] Gate 1 parser/automated verification passed for the ordered-arrow correction.
- [x] Gate 2 movement regression passed.
- [x] Gate 3 new-player arrow comprehension passed.
- [x] Menu board and Start/Continue both start the recommended level.
- [x] Clean-save Level 1 `FREE` hint behavior works.
- [x] Hint refill, Restart, failure/results, and automatic final clear work.
- [x] Final auto-clear does not add a Move.
- [x] Snake-style bent-path escape manually approved.
- [x] Bent paths visibly uncoil through corners, straighten, then exit.

## Difficulty tuning — accepted for the slice

### Level 4

- [x] 9-piece tuned layout.
- [x] 2 opening moves.
- [x] 15 full-clear solution orders encoded in tests.
- [x] Two-person timing pass: roughly **30–40 seconds**.
- [x] Stop tuning unless later evidence shows confusion or frustration.

### Level 5

- [x] 10-piece tuned layout.
- [x] 1 opening move.
- [x] 10 full-clear solution orders encoded in tests.
- [x] Two-person timing pass: roughly **30–40 seconds**.
- [x] Timing lands inside the intended 30–45 second range.
- [x] Stop tuning unless later evidence shows confusion or frustration.

The two-person pass did not record exact moves, mistakes, hints, or written qualitative notes. Those metrics are useful for broader testing but no longer justify delaying platform QA.

## Android vertical-slice preparation — VERIFIED ON DEVICE

- [x] Added committed `Android Debug` export preset.
- [x] Added `*.json` to the export include filter so canonical levels ship in the APK.
- [x] Enabled ARMv7 and ARM64 for broad physical-device testing.
- [x] Enabled Android vibration permission for Pathbreak haptics.
- [x] Kept Internet permission disabled for the current offline vertical slice.
- [x] Added `tools/android_vertical_slice.sh` for preflight, regression tests, debug APK export, device install, and logcat.
- [x] Added `docs/ANDROID_VERTICAL_SLICE_QA.md` and `docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md`.
- [x] Added `/builds/` to `.gitignore`.
- [x] Verified local Godot 4.7.1 accepts the Android export preset.
- [x] Verified Java OpenJDK 21 and Android SDK environment.
- [x] Exported signed 56MB Debug APK (`builds/android/pathbreak-debug.apk`).
- [x] Installed and launched live on Samsung Galaxy Tab S6 Lite (`SM_P615`, Android 13).
- [x] Physical-device touch selection reported reliable.
- [x] Physical-device snake animation reported smooth at 60 FPS.
- [x] Physical-device audio and haptics reported working.

**Temporary testing package:** `com.pathbreak.verticalslice`. Do not publish this package ID to Google Play. Final package ID waits for final naming and publisher decisions.

---

## P0 — Do next

### A. Final current-head regression + Android preflight — PASSED

- [x] Godot 4.7.1 detected.
- [x] Java detected; current successful export used OpenJDK 21.
- [x] Android SDK + `adb` detected.
- [x] `Android Debug` preset detected.
- [x] Godot 4.7.1 headless editor/parser scan passed with 0 parse errors/warnings reported.
- [x] Path migration preview passed; 10 levels / 83 pieces canonical.
- [x] `tests/test_path_visual_geometry.gd` → `7/7`.
- [x] `tests/test_movement_validator.gd` → `10/10`.
- [x] `tests/test_level_data_validator.gd` → `8/8`.
- [x] `tests/test_vertical_slice_levels.gd` → `7/7`.
- [x] Level 4 structural targets remain encoded: 9 pieces / 2 openings / 15 solutions.
- [x] Level 5 structural targets remain encoded: 10 pieces / 1 opening / 10 solutions.

Evidence: `docs/ANDROID_DEVICE_VERIFICATION_2026-08-07.md`.

### B. Export and install the Android debug build — PASSED

- [x] APK exported successfully.
- [x] APK installed on authorized physical Android hardware.
- [x] Main Menu launched on device.
- [x] Packaged JSON levels loaded successfully in the installed build.

### C. Android phone verification — STILL REQUIRED

A real Android phone has not yet been recorded as tested. Do not substitute viewport simulation for this gate.

- [ ] Portrait layout fits correctly on a physical phone.
- [ ] Main-menu board and Start/Continue work with touch.
- [ ] Rapid taps do not double-navigate.
- [ ] Nearest-path touch selection remains accurate.
- [ ] Close paths do not select incorrectly.
- [ ] Multi-touch does not duplicate actions.
- [ ] Android Back closes refill/pause before leaving gameplay.
- [ ] Suspend/resume preserves a valid state.
- [ ] Force-close/reopen preserves save and settings.
- [ ] Sound works.
- [ ] Haptics work and respect the toggle.
- [ ] Snake animation remains smooth.

### D. Android tablet verification — SUBSTANTIAL PASS

Physical device: Samsung Galaxy Tab S6 Lite (`SM_P615`, Android 13).

- [x] APK installs and launches.
- [x] Touch/nearest-path selection reported reliable.
- [x] Board/UI scaling reported correct on physical hardware.
- [x] Snake animation reported smooth at 60 FPS.
- [x] Sound playback verified.
- [x] Haptics integration verified.
- [ ] Explicit stylus-versus-finger comparison recorded.
- [ ] Android Back behavior recorded for pause/refill overlays.
- [ ] Suspend/resume behavior recorded.
- [ ] Force-close/reopen save persistence recorded.

### E. Accessibility/settings regression

- [ ] High Contrast keeps shaft/head/tail/marker readable.
- [ ] Reduce Motion keeps the simpler rigid translation/fade after the final snake implementation.
- [ ] Sound toggle persists after restart.
- [ ] Haptics toggle persists after restart.
- [x] Core direction is communicated by shape, not color alone.

### F. Main-menu/layout closure

- [x] Responsive layout was reported clean at compact 360×800 simulation and on the physical tablet.
- [ ] Rapid-tap double-navigation check recorded on Android.
- [ ] Chapter-complete state recorded and understandable.

---

## Vertical slice approval

Approve only when:

- [x] Current-head automation passes.
- [x] Levels 4–5 have acceptable two-person timing evidence.
- [ ] Android phone test passes.
- [ ] Remaining Android tablet lifecycle/Back persistence checks pass.
- [ ] Accessibility/settings regression passes.
- [ ] Remaining menu closure checks pass.
- [ ] Remaining defects are documented.

Do not reopen Levels 1–5 merely to add difficulty.

---

## P2 — After slice approval: production level pipeline

- [ ] Replace the experimental editor with a production modular editor.
- [ ] Keep ordered tail-to-head authoring as the only output format.
- [ ] Preview and validate before export.
- [ ] Integrate solver metrics.
- [ ] Opening-move count.
- [ ] Solution count.
- [ ] Dead-end check.
- [ ] Dependency-depth/branch metrics.
- [ ] Difficulty notes and playtest fields.
- [ ] Phone/tablet preview.
- [ ] Versioned JSON export and batch validation.

---

## P3 — UI/art after gameplay pipeline is proven

### Main Menu

- [ ] Hybrid redesign using the approved concept hierarchy.
- [ ] Clear Start/Continue hierarchy.
- [ ] Prompt below board without overlap.
- [ ] Better vertical balance.
- [ ] Restrained game-specific iconography.
- [ ] No excessive glow, sparkles, SaaS cards, or generic AI decoration.

### Level Select

- [ ] Four columns on compact phones.
- [ ] Clear Completed / Current / Unlocked / Locked states.
- [ ] Strong recommended-next-level state.
- [ ] More readable stars.

### Final art

- [ ] Logo and app icon.
- [ ] Typography and icon system.
- [ ] Ownable Pathbreak visual motif.
- [ ] Production sound/music/particles.
- [ ] Store screenshots and marketing art.

---

## P4 — Launch preparation

- [ ] Build launch-sized original level pack through the production pipeline.
- [ ] Final name/trademark clearance.
- [ ] Choose final globally unique Android package identifier.
- [ ] Analytics and crash reporting.
- [ ] Privacy/consent/Data Safety.
- [ ] Android signing and target API checks.
- [ ] Release keystore stored securely outside Git.
- [ ] Gradle/AAB release export.
- [ ] Closed testing.
- [ ] Store listing.
- [ ] Rewarded hint economy only after retention evidence.

---

## Commands

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review

bash tools/android_vertical_slice.sh check
bash tools/android_vertical_slice.sh test
bash tools/android_vertical_slice.sh export
bash tools/android_vertical_slice.sh install
```

Or run the full path:

```bash
bash tools/android_vertical_slice.sh all
```

Run the complete desktop game with **F5**, not F6.
