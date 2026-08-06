# Pathbreak — Vertical-Slice Testing Checklist

**Status:** Active manual test matrix  
**Last reviewed:** 2026-08-07  
**Rule:** Do not mark a test complete from code inspection alone. Record the device/build and observed result.

## 1. Automated checks

Run from the project root:

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tools/path_level_migration_preview.gd
godot --headless --path . --script tests/test_path_visual_geometry.gd
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

- [ ] Editor scan completes with zero parser errors and zero warnings.
- [ ] Migration preview reports `reversible=0 ambiguous=0`.
- [ ] Ordered path geometry suite passes.
- [ ] Movement validator suite passes.
- [ ] Level data validator suite passes.
- [ ] Vertical-slice structure/solver suite passes.
- [ ] Level 1–5 opening and solution counts remain at the expected values.

## 2. Ordered path and arrow invariant

For every inspected path:

- [ ] Cells form one ordered non-branching cardinal path.
- [ ] First cell is the tail endpoint.
- [ ] Final cell is the head endpoint.
- [ ] Head direction equals `cells[-1] - cells[-2]`.
- [ ] Movement direction equals the visible head direction.
- [ ] Bent paths do not use first-to-last direction.
- [ ] Triangle is attached to the final endpoint.
- [ ] Shaft stops cleanly beneath the triangle.
- [ ] Tail marker is on the opposite endpoint.
- [ ] No per-level rotation offset or negative-scale flip is present.

Check at least one path for each final segment:

- [ ] Right.
- [ ] Down.
- [ ] Left.
- [ ] Up.
- [ ] L-shape ending right.
- [ ] L-shape ending down.
- [ ] L-shape ending left.
- [ ] L-shape ending up.

## 3. Fresh-save tutorial

Already verified before the latest migration; rerun once after the ordered-path correction:

- [ ] Reset or remove the save.
- [ ] Main Menu displays `Start Level 1`.
- [ ] Main-menu board displays `TAP THE BOARD TO START`.
- [ ] Board and primary button both start Level 1.
- [ ] Repeated taps do not trigger duplicate navigation.
- [ ] Level 1 displays `FREE`.
- [ ] Tutorial instruction is visible.
- [ ] Directional marker follows the final segment toward the head.
- [ ] Tutorial assistance identifies a valid path.
- [ ] Free hint does not reduce the persistent bank.
- [ ] Completing Level 1 marks the tutorial complete.
- [ ] Replaying Level 1 displays the real hint count.

## 4. Hint inventory and refill

- [ ] Normal hint highlights an escapable path.
- [ ] Small marker triangle points toward the same head used by movement.
- [ ] Marker cannot be mistaken for another tail dot.
- [ ] HUD message remains understandable.
- [ ] Each normal hint decreases the bank exactly once.
- [ ] Count persists through Menu and reopen.
- [ ] At zero, HUD displays `+3 / Refill`.
- [ ] Popup opens and blocks gameplay input.
- [ ] Cancel/backdrop/Back closes without adding hints.
- [ ] Refill restores exactly three and saves immediately.
- [ ] Next hint consumes one.
- [ ] Result `Hints used` remains correct after refill.
- [ ] `No path can leave yet` still appears when appropriate.

## 5. Gameplay and input

- [ ] Valid path escapes in its visible head direction.
- [ ] Blocked path loses one life and records one mistake.
- [ ] Rapid repeated taps do not count twice.
- [ ] Close paths select the nearest intended path.
- [ ] Input remains accurate after scaling.
- [ ] Restart rebuilds the board and clears active animation state.
- [ ] Arrowhead is more prominent than the tail.
- [ ] Final valid path previews and clears automatically.
- [ ] Automatic final clear adds no Move.
- [ ] Completion triggers exactly once.
- [ ] Blocked/inconsistent final state returns control.
- [ ] Zero lives triggers failure exactly once.

## 6. Connected flow

- [ ] Main Menu recommends the first uncleared level.
- [ ] Living board opens the same level as Continue.
- [ ] Returning prompt names the recommended level.
- [ ] Level Select states match save data.
- [ ] Back preserves hint state.
- [ ] Pause Resume, Restart, and Menu work.
- [ ] Failure Retry and Menu work.
- [ ] Result Replay and Next Level work.
- [ ] Final available level returns to Level Select.

## 7. Accessibility and settings

- [ ] Sound persists after restart.
- [ ] Haptics persist after restart.
- [ ] Reduce Motion removes travelling cues without hiding direction.
- [ ] Reduce Motion shortens final-clear preview.
- [ ] High Contrast keeps shaft, triangle, tail, and hint marker readable.
- [ ] Settings remain independent from progress reset.
- [ ] Direction does not depend only on color.

## 8. Portrait layout matrix

Test menu → gameplay → overlay → result at:

- [ ] 360 × 800.
- [ ] 393 × 873.
- [ ] 412 × 915.
- [ ] 800 × 1280.
- [ ] 1200 × 1920.

Verify:

- [ ] No clipped title, board, prompt, HUD, button, or popup.
- [ ] Board is centered.
- [ ] Menu board remains tappable.
- [ ] Touch targets remain comfortable.
- [ ] Popup buttons remain visible.

## 9. Level review after migration

- [ ] Level 1 left/right heads and two openings.
- [ ] Level 2 migrated L-path still teaches blocking.
- [ ] Level 3 migrated paths still teach bent-path reading.
- [ ] Level 4 reversed upward path renders and moves correctly.
- [ ] Level 5 all eight heads follow their final segments.
- [ ] Three new testers attempt Levels 1–5 without explanation.
- [ ] Record first menu tap, time, moves, mistakes, hints, confusion, and abandonment.
- [ ] Ask whether head/tail distinction is understood.
- [ ] Ask whether automatic final clear feels satisfying.

## 10. Android checks

- [ ] Install debug APK on phone.
- [ ] Install debug APK on tablet.
- [ ] Single-touch path selection.
- [ ] Menu board starts with touch.
- [ ] Multi-touch does not duplicate actions.
- [ ] System Back closes refill/pause first.
- [ ] Sound routes correctly.
- [ ] Haptics respect the toggle.
- [ ] Suspend/resume remains stable.
- [ ] Close/reopen preserves save and settings.

## 11. Approval

The slice remains unapproved until:

- [ ] Current head passes parser, migration preview, and all suites.
- [ ] Ordered path/head invariant is visually confirmed.
- [ ] Main-menu hierarchy passes new-player testing.
- [ ] Direction is understood without explanation.
- [ ] Hint refill and automatic final clear remain verified.
- [ ] Fresh-save tutorial passes after migration.
- [ ] Levels 1–5 pass director review.
- [ ] Phone and tablet checks pass.
- [ ] Remaining defects have severity and owner.
