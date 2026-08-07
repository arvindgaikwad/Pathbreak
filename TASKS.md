# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Close the remaining Android phone, lifecycle, accessibility/settings, and layout gates for the five-level vertical slice. After approval, prove Pathbreak's satisfying living-path identity before building the production level pipeline. Levels 1–5 are frozen unless new evidence reveals a regression.

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
- [x] Product direction locked: **the satisfying living-path puzzle**.
- [x] Quality rule locked: **clarity first, satisfaction second, spectacle third**.

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
- [x] Corrected `project.godot` orientation to `SCREEN_PORTRAIT = 1`.
- [x] Added `tests/test_mobile_project_settings.gd` and portrait guard to the Android helper.
- [x] User confirmed the corrected Android build now opens in portrait.

**Temporary testing package:** `com.pathbreak.verticalslice`. Do not publish this package ID to Google Play.

---

## P0 — Finish vertical-slice closure

### A. Portrait and current-head regression

- [ ] Confirm rotating the tablet does not switch Pathbreak into landscape.
- [ ] Confirm Main Menu, gameplay, Pause, Refill, Result, and Level Select remain correctly composed in portrait.
- [ ] Editor/parser scan passes with no new warnings.
- [ ] Mobile project settings test passes.
- [ ] Path migration preview remains canonical.
- [ ] Ordered geometry remains `7/7`.
- [ ] Movement validator remains `10/10`.
- [ ] Level data validator remains `8/8`.
- [ ] Vertical-slice level suite remains `7/7`.

### B. Android phone verification — STILL REQUIRED

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

### C. Android tablet closure

Physical device: Samsung Galaxy Tab S6 Lite (`SM_P615`, Android 13).

- [x] App launches in portrait after correction.
- [x] Touch/nearest-path selection reliable.
- [x] Snake animation smooth.
- [x] Sound playback verified.
- [x] Haptics integration verified.
- [ ] Rotation remains portrait.
- [ ] Board/UI scaling rechecked across the full flow in portrait.
- [ ] Explicit stylus-versus-finger comparison recorded.
- [ ] Android Back behavior recorded for pause/refill overlays.
- [ ] Suspend/resume behavior recorded.
- [ ] Force-close/reopen save persistence recorded.

### D. Accessibility/settings and menu closure

- [ ] High Contrast keeps shaft/head/tail/marker readable.
- [ ] Reduce Motion keeps the simpler rigid translation/fade after the final snake implementation.
- [ ] Sound toggle persists after restart.
- [ ] Haptics toggle persists after restart.
- [x] Core direction is communicated by shape, not color alone.
- [ ] Recheck compact portrait composition.
- [ ] Rapid-tap double-navigation check recorded on Android.
- [ ] Chapter-complete state recorded and understandable.

---

## Vertical slice approval

Approve only when:

- [ ] Portrait/device regression fully passes.
- [ ] Current-head automation including mobile-settings guard passes.
- [x] Levels 4–5 have acceptable two-person timing evidence.
- [ ] Android phone test passes.
- [ ] Remaining Android tablet lifecycle/Back/persistence checks pass.
- [ ] Accessibility/settings regression passes.
- [ ] Remaining menu closure checks pass.
- [ ] Remaining defects are documented.

Do not reopen Levels 1–5 merely to add difficulty.

---

## P2 — Satisfaction Prototype v1

Start only after vertical-slice approval. Source of truth: `docs/SATISFACTION_BLUEPRINT.md`.

- [ ] Polish successful release timing while preserving accepted snake geometry.
- [ ] Add one restrained activation response before escape.
- [ ] Add one subtle trail/material response and reject it if readability drops.
- [ ] Detect which remaining paths become newly available after a successful move using the existing movement rules.
- [ ] Give only newly available paths one restrained acknowledgement; never repeatedly highlight every valid move.
- [ ] Preserve the `choose → release → board changes → notice → choose` unravel rhythm.
- [ ] Polish the automatic final clear and add a restrained board-settle response.
- [ ] Prototype one success sound, one resistance sound, and one completion sound.
- [ ] Keep Sound/Haptics toggles respected.
- [ ] Define Reduce Motion and High Contrast behavior for every new effect.
- [ ] Verify Android performance on tablet and phone.
- [ ] Test with at least three uncoached players.
- [ ] Reject any effect that makes direction, obstacles, or cause-and-effect harder to understand.
- [ ] Capture three genuine 5–10 second clips: bent-path uncoil, dependency reveal, and final unravel.
- [ ] Lock the Pathbreak feel language before mass content production.

---

## P3 — Production Level Studio

Build only after Satisfaction Prototype v1 is accepted.

- [ ] Replace the experimental editor with a production modular editor.
- [ ] Keep ordered tail-to-head authoring as the only output format.
- [ ] Preview and validate before export.
- [ ] Preview the locked Pathbreak presentation language.
- [ ] Integrate solver metrics.
- [ ] Opening-move count.
- [ ] Solution count.
- [ ] Dead-end check.
- [ ] Dependency-depth/branch metrics.
- [ ] Difficulty notes and playtest fields.
- [ ] Phone/tablet preview.
- [ ] Versioned JSON export and batch validation.
- [ ] Produce the first **20 polished levels**, not a large random pack.

---

## P4 — Final UI / art / production audio

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

### Final identity

- [ ] Logo and app icon.
- [ ] Typography and icon system.
- [ ] Ownable Pathbreak motif built around living-path release.
- [ ] Final path/board material treatment.
- [ ] Production sound/music/feedback.
- [ ] Store screenshots and marketing art.

---

## P5 — Launch preparation

- [ ] Scale the original level pack only through the production pipeline.
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
