# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Fix and re-verify Android portrait orientation, then close the remaining phone, lifecycle, accessibility/settings, and layout gates for the five-level vertical slice. Levels 1–5 are frozen unless new evidence reveals a regression.

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

## Android vertical-slice preparation

- [x] Android Debug export preset committed.
- [x] Canonical `*.json` files included in APK export.
- [x] ARMv7 and ARM64 enabled.
- [x] Vibration permission enabled for haptics.
- [x] Internet permission remains disabled for the offline slice.
- [x] `tools/android_vertical_slice.sh` handles preflight, tests, export, install, and logcat.
- [x] APK exported, installed, and launched on Samsung Galaxy Tab S6 Lite.
- [x] Touch selection, snake animation, sound, and haptics worked on physical hardware.
- [!] Initial tablet build launched in **landscape**, so the portrait platform gate is reopened.
- [x] Corrected `project.godot` orientation to `SCREEN_PORTRAIT = 1`.
- [x] Added `tests/test_mobile_project_settings.gd`.
- [x] Added portrait guard to `tools/android_vertical_slice.sh`.

**Temporary testing package:** `com.pathbreak.verticalslice`. Do not publish this package ID to Google Play.

---

## P0 — Do next

### A. Portrait-orientation regression

- [ ] Pull the latest active branch.
- [ ] Run `bash tools/android_vertical_slice.sh test`.
- [ ] Confirm `tests/test_mobile_project_settings.gd` reports portrait and passes.
- [ ] Re-export the Android debug APK.
- [ ] Reinstall on the Samsung Galaxy Tab S6 Lite.
- [ ] Confirm app launches in portrait.
- [ ] Confirm rotating the tablet does not switch Pathbreak into landscape.
- [ ] Confirm Main Menu, gameplay, Pause, Refill, Result, and Level Select remain correctly composed in portrait.

### B. Current-head automated regression

The pre-orientation gameplay/data suites already passed. Rerun them once with the portrait fix because `tools/android_vertical_slice.sh test` now includes the new mobile-settings guard.

- [ ] Editor/parser scan passes with no new warnings.
- [ ] Mobile project settings test passes.
- [ ] Path migration preview remains canonical.
- [ ] Ordered geometry remains `7/7`.
- [ ] Movement validator remains `10/10`.
- [ ] Level data validator remains `8/8`.
- [ ] Vertical-slice level suite remains `7/7`.

### C. Android phone verification — STILL REQUIRED

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

### D. Android tablet verification — RETEST REQUIRED AFTER PORTRAIT FIX

Physical device: Samsung Galaxy Tab S6 Lite (`SM_P615`, Android 13).

- [ ] App launches and stays in portrait.
- [x] Touch/nearest-path selection reported reliable in the first hardware pass.
- [x] Snake animation reported smooth at 60 FPS in the first hardware pass.
- [x] Sound playback verified.
- [x] Haptics integration verified.
- [ ] Board/UI scaling rechecked in actual portrait orientation.
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

- [ ] Recheck compact portrait composition after orientation correction.
- [ ] Rapid-tap double-navigation check recorded on Android.
- [ ] Chapter-complete state recorded and understandable.

---

## Vertical slice approval

Approve only when:

- [ ] Portrait-orientation rebuild/retest passes.
- [ ] Current-head automation including mobile-settings guard passes.
- [x] Levels 4–5 have acceptable two-person timing evidence.
- [ ] Android phone test passes.
- [ ] Remaining Android tablet lifecycle/Back/persistence checks pass.
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

Or:

```bash
bash tools/android_vertical_slice.sh all
```

Run the complete desktop game with **F5**, not F6.
