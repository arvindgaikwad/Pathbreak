# Pathbreak — Vertical-Slice Testing Checklist

**Status:** Active manual test matrix  
**Last reviewed:** 2026-08-07  
**Rule:** Do not mark a test complete from code inspection alone. Record the device/build and observed result.

## 1. Automated checks

Run from the project root:

```bash
godot --headless --path . --editor --quit
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

- [ ] Editor scan completes with zero parser errors and zero warnings.
- [ ] Movement validator suite passes.
- [ ] Level data validator suite passes.
- [ ] Vertical-slice structure/solver suite passes.

Every box above must be rerun after the current menu, path-readability, and automatic-final-clear changes.

## 2. Fresh-save tutorial

- [ ] Reset or remove the save before testing.
- [ ] Main Menu starts at Level 1.
- [ ] Main Menu displays `Start Level 1`.
- [ ] Main-menu board displays `TAP THE BOARD TO START`.
- [ ] Tapping the main-menu board starts Level 1.
- [ ] The primary Start button also starts Level 1.
- [ ] Repeated or near-simultaneous taps do not trigger duplicate navigation.
- [ ] Level 1 displays `FREE` in the hint card.
- [ ] Tutorial instruction is visible.
- [ ] A moving accent marker travels from tail toward the arrowhead.
- [ ] Tutorial assistance identifies a valid path without blocking input.
- [ ] Using the free tutorial hint does not reduce the persistent hint bank.
- [ ] Completing Level 1 marks the tutorial complete.
- [ ] Replaying Level 1 displays the real hint count rather than `FREE`.

## 3. Hint inventory and refill

- [ ] A normal hint highlights an escapable path in blue.
- [ ] The moving marker travels from tail to arrowhead on the hinted path.
- [ ] The HUD says `Follow the blue light to the arrow`.
- [ ] Each normal hint decreases the bank exactly once.
- [ ] The decreased count survives returning to Menu and reopening gameplay.
- [ ] At zero, the HUD displays `+3` and the title `Refill`.
- [ ] Tapping the empty hint card opens the refill popup.
- [ ] `Not now`, backdrop tap, and Android/system Back close the popup without adding hints.
- [ ] Gameplay input is blocked while the popup is open.
- [ ] `Refill 3 Hints` restores exactly three hints.
- [ ] The restored count saves immediately.
- [ ] The next hint consumes one and displays two remaining.
- [ ] Result `Hints used` remains correct after a refill during the level.
- [ ] `No path can leave yet` remains visible when a board state has no valid move.

## 4. Gameplay rules and input

- [ ] Valid path tap escapes the selected path.
- [ ] Blocked path tap reduces one life and records one mistake.
- [ ] Rapid repeated taps do not remove or count the same path twice.
- [ ] Close parallel paths select the nearest intended path.
- [ ] Input remains accurate after board scaling.
- [ ] Restart rebuilds the board and clears active animation state.
- [ ] Arrowheads are visually more prominent than tail dots.
- [ ] With two paths remaining, clearing the second-last path locks further board input.
- [ ] The final valid path previews in blue and clears automatically.
- [ ] Automatic final clear does not increase Moves.
- [ ] Automatic final clear triggers completion exactly once.
- [ ] An inconsistent or blocked final state returns control instead of silently completing.
- [ ] Zero lives triggers failure exactly once.

## 5. Connected flow

- [ ] Main Menu recommends the first uncleared unlocked level.
- [ ] Tapping the living board opens that same recommended level.
- [ ] The board prompt names the recommended level for returning players.
- [ ] Level Select locked/current/completed states match save data.
- [ ] Back returns safely without losing hint state.
- [ ] Pause resumes the same board.
- [ ] Pause Restart creates a fresh attempt.
- [ ] Pause Menu returns safely.
- [ ] Failure Retry works.
- [ ] Failure Menu works.
- [ ] Result Replay works.
- [ ] Result Next Level works.
- [ ] Final available level returns to Level Select.

## 6. Accessibility and settings

- [ ] Sound toggle persists after restart.
- [ ] Haptics toggle persists after restart.
- [ ] Reduce Motion stops the travelling menu/path marker.
- [ ] Reduce Motion shortens the automatic final-clear preview.
- [ ] High Contrast changes path rendering.
- [ ] Settings remain independent from progress reset.
- [ ] No information depends only on color.
- [ ] Static arrowhead shape still communicates direction with Reduce Motion enabled.

## 7. Portrait layout matrix

Test the full menu → gameplay → overlay → result loop at each target:

- [ ] 360 × 800 compact phone.
- [ ] 393 × 873 standard phone.
- [ ] 412 × 915 tall phone.
- [ ] 800 × 1280 tablet portrait.
- [ ] 1200 × 1920 high-resolution tablet portrait.

For every size verify:

- [ ] No clipped title, board, board prompt, HUD card, button, or popup.
- [ ] Board remains centered in the playable area.
- [ ] The menu demonstration remains fully tappable.
- [ ] Touch targets remain comfortable.
- [ ] Popup buttons remain visible without scrolling.

## 8. Level review

- [ ] Level 1 fresh-player tutorial test.
- [ ] Level 2 blocking comprehension retest.
- [ ] Level 3 bent-path comprehension retest.
- [ ] Level 4 external playtest after readability changes.
- [ ] Level 5 external difficulty test after readability changes.
- [ ] Three new testers complete or attempt all five levels without verbal explanation.
- [ ] Record first menu tap, completion time, moves, mistakes, hints, confusion points, and abandonment.
- [ ] Ask whether the arrowhead/tail distinction is understood.
- [ ] Ask whether automatic final clear feels satisfying or surprising.

## 9. Android device checks

- [ ] Install debug APK on phone.
- [ ] Install debug APK on tablet.
- [ ] Single-touch path selection.
- [ ] Main-menu board starts the game with touch input.
- [ ] Multi-touch does not produce duplicate actions.
- [ ] System Back closes refill/pause before leaving gameplay.
- [ ] Sound routes correctly.
- [ ] Haptics feel appropriate and respect the toggle.
- [ ] Suspend/resume does not corrupt the level.
- [ ] Closing/reopening preserves save and settings.

## 10. Approval

The slice remains unapproved until:

- [ ] Automated checks pass on the current head commit.
- [ ] Main-menu start hierarchy passes new-player testing.
- [ ] Path direction is understood without verbal explanation.
- [ ] Automatic final clear is manually verified.
- [ ] Hint refill is manually verified.
- [ ] Tutorial is verified from a fresh save.
- [ ] All five levels pass director review.
- [ ] External playtest evidence is recorded.
- [ ] Phone and tablet checks pass.
- [ ] Remaining defects are documented with owners and severity.
