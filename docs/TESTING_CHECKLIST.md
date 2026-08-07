# Pathbreak — Vertical-Slice Testing Checklist

**Status:** Active manual test matrix  
**Last reviewed:** 2026-08-07  
**Rule:** Do not mark a test complete from code inspection alone. Record the device/build and observed result.

## 1. Automated checks

The ordered-arrow Gate 1 passed before the later snake-animation and Level 4–5 tuning changes. Run the current head once more before platform approval.

Preferred command:

```bash
bash tools/android_vertical_slice.sh test
```

Equivalent individual commands:

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tools/path_level_migration_preview.gd
godot --headless --path . --script tests/test_path_visual_geometry.gd
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

- [ ] Current-head editor scan completes with zero parser errors and no new warnings.
- [ ] Migration preview reports `reversible=0 ambiguous=0`.
- [ ] Ordered path geometry suite passes; expected `7/7`.
- [ ] Movement validator suite passes.
- [ ] Level data validator suite passes.
- [ ] Vertical-slice structure/solver suite passes.
- [ ] Level 4 remains 9 pieces / 2 openings / 15 solutions.
- [ ] Level 5 remains 10 pieces / 1 opening / 10 solutions.

## 2. Ordered path and arrow invariant

Accepted from the ordered-arrow visual/comprehension gates:

- [x] Cells form one ordered non-branching cardinal path.
- [x] First cell is the tail endpoint.
- [x] Final cell is the head endpoint.
- [x] Head direction equals `cells[-1] - cells[-2]`.
- [x] Movement direction equals the visible head direction.
- [x] Bent paths do not use first-to-last direction.
- [x] Triangle is attached to the final endpoint.
- [x] Shaft stops cleanly beneath the triangle.
- [x] Tail marker is on the opposite endpoint.
- [x] No per-level rotation offset or negative-scale flip is used.
- [x] Right, down, left, and up head directions were visually accepted.
- [x] Bent-path direction comprehension passed with new players.

## 3. Fresh-save tutorial

Verified in the current gameplay direction before Android packaging:

- [x] Main Menu displays `Start Level 1` on a clean save.
- [x] Main-menu board displays `TAP THE BOARD TO START`.
- [x] Board and primary button both start Level 1.
- [x] Level 1 displays `FREE`.
- [x] Free tutorial state transitions to normal hint inventory after completion.
- [x] Replaying Level 1 displays the real hint count.

Still close on-device:

- [ ] Repeated touch taps do not trigger duplicate navigation.
- [ ] Tutorial marker remains readable on a physical phone.

## 4. Hint inventory and refill

- [x] Normal hint highlights an escapable path.
- [x] Marker points toward the same head used by movement.
- [x] Marker does not read as another tail dot in the accepted visual pass.
- [x] Each normal hint decreases the bank exactly once.
- [x] At zero, HUD displays `+3 / Refill`.
- [x] Refill popup opens.
- [x] Refill restores exactly three hints.
- [x] Restart works.
- [x] `No path can leave yet` remains useful feedback.

On-device regression:

- [ ] Cancel/backdrop/Android Back closes refill without adding hints.
- [ ] Hint count survives force-close/reopen.
- [ ] Result `Hints used` remains correct after refill.

## 5. Gameplay, input, and snake escape

- [x] Valid path escapes in its visible head direction.
- [x] Blocked path loses one life and records one mistake.
- [x] Restart rebuilds the board.
- [x] Final valid path previews and clears automatically.
- [x] Automatic final clear adds no Move.
- [x] Snake-style bent-path escape is manually accepted.
- [x] Head leads, tail follows through the corner, bend travels through body, then body becomes straight and exits.
- [x] No large diagonal shortcut appears across the bend.

Physical-device checks:

- [ ] Rapid repeated taps do not count twice.
- [ ] Close paths select the nearest intended path.
- [ ] Input remains accurate after Android scaling.
- [ ] Multi-touch does not duplicate actions.
- [ ] Snake animation remains smooth under repeated play.
- [ ] Completion triggers exactly once.
- [ ] Zero lives triggers failure exactly once.

## 6. Connected flow

- [x] Main Menu recommends the first uncleared level.
- [x] Living board opens the same level as Continue.
- [x] Level Select and Levels 1–10 load in desktop/manual testing.
- [x] Pause/Restart/failure/result flows were exercised earlier.

Android/device closure:

- [ ] Back preserves hint state.
- [ ] Pause Resume, Restart, and Menu work with touch/system Back.
- [ ] Failure Retry and Menu work.
- [ ] Result Replay and Next Level work.
- [ ] Final available level returns to Level Select.

## 7. Accessibility and settings

- [ ] Sound persists after app restart on Android.
- [ ] Haptics persist after app restart on Android.
- [ ] Haptics are physically felt and respect the toggle.
- [ ] Reduce Motion removes snake deformation and keeps the simpler short translation/fade.
- [ ] Reduce Motion does not hide direction.
- [ ] High Contrast keeps shaft, triangle, tail, and hint marker readable.
- [ ] Settings remain independent from progress reset.
- [ ] Direction does not depend only on color.

## 8. Portrait layout matrix

Desktop/viewport review should be confirmed on real target classes:

- [ ] 360 × 800 compact phone.
- [ ] 393 × 873 standard phone.
- [ ] 412 × 915 tall phone.
- [ ] 800 × 1280 tablet.
- [ ] 1200 × 1920 high-resolution tablet.

Verify:

- [ ] No clipped title, board, prompt, HUD, button, or popup.
- [ ] Board is centered.
- [ ] Menu board remains tappable.
- [ ] Touch targets remain comfortable.
- [ ] Popup buttons remain visible.
- [ ] Chapter-complete menu state remains understandable.

## 9. Level review

Accepted for the current vertical slice:

- [x] Levels 1–3 teaching role accepted.
- [x] Level 2 blocking comprehension accepted.
- [x] Level 3 bent-path comprehension accepted.
- [x] Level 4 tuned layout accepted for platform QA.
- [x] Level 5 tuned layout accepted for platform QA.
- [x] Latest two-person Level 4 timing: roughly 30–40 seconds.
- [x] Latest two-person Level 5 timing: roughly 30–40 seconds.

Do not reopen difficulty unless a new defect or player-comprehension problem is observed.

## 10. Android export preflight

Repository preparation:

- [x] `export_presets.cfg` contains `Android Debug`.
- [x] `*.json` is explicitly included in export packaging.
- [x] ARMv7 + ARM64 are enabled for testing.
- [x] Vibration permission is enabled.
- [x] Internet permission is disabled for the offline slice.
- [x] Local APK output is ignored by Git.

Run:

```bash
bash tools/android_vertical_slice.sh check
```

- [ ] Godot 4.7.1 detected.
- [ ] Java SDK detected.
- [ ] Android SDK detected.
- [ ] `adb` detected.
- [ ] Matching Godot export templates installed.
- [ ] At least one authorized device appears in `adb devices -l`.

## 11. Android APK and phone checks

Export/install:

```bash
bash tools/android_vertical_slice.sh export
bash tools/android_vertical_slice.sh install
```

- [ ] `builds/android/pathbreak-debug.apk` is created.
- [ ] APK installs successfully.
- [ ] Main Menu launches.
- [ ] Packaged JSON Levels 1–10 load.
- [ ] Single-touch path selection works.
- [ ] Menu board starts with touch.
- [ ] Multi-touch does not duplicate actions.
- [ ] System Back closes refill/pause first.
- [ ] Sound routes correctly.
- [ ] Haptics respect the toggle.
- [ ] Suspend/resume remains stable.
- [ ] Force-close/reopen preserves save and settings.
- [ ] Snake animation remains smooth.

For logs:

```bash
bash tools/android_vertical_slice.sh logcat
```

## 12. Android tablet checks

- [ ] Install the same debug APK on Samsung Galaxy Tab S6 Lite or another Android tablet.
- [ ] Board scale and centering are correct.
- [ ] Finger selection is accurate.
- [ ] Stylus selection is accurate.
- [ ] Popup/menu sizing is comfortable.
- [ ] Snake animation remains smooth.
- [ ] Suspend/resume remains stable.
- [ ] Save/settings persist.

## 13. Approval

The slice remains unapproved until:

- [ ] Current post-snake/post-Level-4–5 head passes parser and all automated suites.
- [x] Ordered path/head invariant is visually confirmed.
- [x] Main-menu hierarchy/direction comprehension passed new-player testing.
- [x] Hint refill and automatic final clear are manually verified.
- [x] Fresh-save tutorial is manually verified.
- [x] Levels 1–5 pass current director review.
- [ ] Android phone checks pass.
- [ ] Android tablet checks pass.
- [ ] Accessibility/settings checks pass.
- [ ] Main-menu/layout target sizes pass.
- [ ] Remaining defects have severity and owner.
