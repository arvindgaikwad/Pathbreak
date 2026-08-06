# Pathbreak — Master TODO

**Status:** Current execution tracker  
**Last reviewed:** 2026-08-07  
**Active branch:** `codex/vertical-slice-level-review`  
**Draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Read `docs/PROJECT_HANDOFF.md` before continuing after a lost conversation.

## Current objective

Approve a complete, understandable, stable, device-tested vertical slice before building the level-production pipeline, final art, or monetization.

## Latest manual verification — 2026-08-07

The user confirmed the following interaction-clarity behaviours work in the local Godot build:

- [x] Tapping the animated menu board opens the recommended level.
- [x] The normal Start/Continue button opens the same recommended level.
- [x] The travelling blue menu animation plays.
- [x] A hint sends the blue marker toward the arrowhead.
- [x] The final remaining valid path clears automatically.
- [x] Automatic final clear does not add a player Move.
- [x] Reduce Motion provides working alternatives for the menu, hint, and final clear.
- [x] Restart still functions.
- [x] Hint refill still functions.

These checks verify the listed manual flows only. Parser health, automated suites, fresh-save tutorial, revised new-player comprehension, High Contrast, and Android device checks remain open.

---

## P0 — Do next

### A. Run formal parser and automated verification

- [ ] Pull the latest active branch.
- [ ] Run the Godot 4.7.1 headless editor/parser scan.
- [ ] Confirm zero parser errors and no new warnings.
- [ ] Run `tests/test_movement_validator.gd`.
- [ ] Run `tests/test_level_data_validator.gd`.
- [ ] Run `tests/test_vertical_slice_levels.gd`.
- [ ] Record exact test output in the playtest/verification document.

### B. Complete remaining main-menu acceptance

- [x] Confirm tapping the hero board opens the same recommended level as Start/Continue.
- [x] Confirm the travelling direction pulse is visible.
- [ ] Confirm rapid taps do not trigger double navigation.
- [ ] Confirm the state-aware prompt is readable and does not overlap paths at all target sizes.
- [ ] Confirm new-player state says Start Level 1 after a clean save.
- [x] Confirm returning-player state recommends the first uncleared unlocked level.
- [ ] Confirm chapter-complete state remains understandable.
- [ ] Test menu at 360×800 and 800×1280 first.

### C. Complete gameplay-readability acceptance

- [ ] Review larger arrowheads and smaller tail dots on Levels 1–5 with new players.
- [x] Use a hint and confirm the directional marker travels from tail toward arrowhead.
- [ ] Confirm the marker never suggests the wrong direction across all path orientations.
- [x] Clear the second-last path and confirm the final valid path previews and clears automatically.
- [x] Confirm the final path clears automatically exactly once.
- [x] Confirm automatic final clear does not add a player Move.
- [ ] Confirm result timing, stars, hints used, and progression remain correct across repeated attempts.
- [x] Confirm `No path can leave yet` still appears when appropriate.

### D. Accessibility regression

- [x] Enable Reduce Motion and repeat menu animation, hint, and automatic final-clear tests.
- [x] Confirm Reduce Motion remains understandable without travelling animation.
- [ ] Enable High Contrast and verify paths, arrowheads, tail markers, and hints remain readable.
- [ ] Verify Sound and Haptics toggles persist after restarting the app.

### E. Fresh-save tutorial — next manual gate

- [ ] Back up and remove the current save.
- [ ] Confirm Main Menu shows the new-player Start state.
- [ ] Confirm Level 1 displays `FREE`.
- [ ] Confirm the free hint highlights an escapable path.
- [ ] Confirm the free hint does not consume a normal hint.
- [ ] Confirm completing Level 1 marks the tutorial complete.
- [ ] Confirm replaying Level 1 displays the real hint count.

---

## P1 — Repeat external playtesting

Test with at least three players who have not seen the revised menu or path visuals.

For every tester record:

- [ ] First thing tapped on the Main Menu.
- [ ] Whether they understood that the board and Start button both begin play.
- [ ] Whether they identified the arrow direction without verbal explanation.
- [ ] Whether tail dots confused them.
- [ ] Completion time for Levels 1–5.
- [ ] Moves and mistakes.
- [ ] Hint usage.
- [ ] Confusion, boredom, enjoyment, and abandonment points.
- [ ] Reaction to automatic final clear.

Decision rules:

- [ ] Do not increase difficulty until direction readability improves.
- [ ] Keep Level 2 if blocking remains understandable.
- [ ] Keep Level 3 if bent-path reading remains understandable.
- [ ] Tune Levels 4–5 if first-time players still clear them automatically or in roughly 10 seconds.
- [ ] Do not use visual confusion as difficulty.

---

## P1 — Android verification

### Phone

- [ ] Export and install a debug APK.
- [ ] Verify portrait layout.
- [ ] Verify nearest-path touch selection.
- [ ] Verify close paths do not select the wrong path.
- [ ] Verify multi-touch does not create duplicate actions.
- [ ] Verify Android Back closes popup/pause before leaving gameplay.
- [ ] Verify suspend/resume.
- [ ] Verify force-close/reopen save persistence.
- [ ] Verify sound and haptics.

### Tablet

- [ ] Install on Samsung Galaxy Tab S6 Lite or another available Android tablet.
- [ ] Verify board scale and centring.
- [ ] Verify touch tolerance with stylus and finger.
- [ ] Verify popup and menu sizing.
- [ ] Verify performance and lifecycle behaviour.

---

## P1 — Vertical-slice level direction

### Level 1

- [x] Two clear opening moves implemented.
- [ ] Fresh-save tutorial approved.

### Level 2

- [x] Tightened to a 6×6 board.
- [x] New players understood blocking in the recorded test.
- [ ] Confirm revised arrow/tail language does not reduce comprehension.

### Level 3

- [x] Tightened to a 6×6 board.
- [x] New players understood bent-path reading in the recorded test.
- [ ] Confirm revised direction cue with new players.

### Level 4

- [x] Failure/retry/result flow exercised.
- [ ] Retest with new players after readability revision.
- [ ] Increase decision depth only if evidence supports it.

### Level 5

- [x] Redesigned around an authored dependency chain.
- [ ] Retest with new players after readability revision.
- [ ] Target a meaningful first-time solve rather than visual busyness.

---

## P2 — UI direction after slice approval

### Main Menu

- [ ] Keep clear Start/Continue hierarchy.
- [ ] Keep the board as a valid start target.
- [ ] Place tap instruction below the board without overlap.
- [ ] Improve vertical balance and reduce unused lower space.
- [ ] Add restrained game-specific iconography.
- [ ] Avoid excessive glow, sparkles, shadows, and repeated cards.

### Level Select

- [ ] Keep four columns on compact phones.
- [ ] Make Completed, Current, Unlocked, and Locked states unmistakable.
- [ ] Make the recommended next level easy to identify.
- [ ] Increase star readability.
- [ ] Use a dedicated Continue action when it improves touch clarity.
- [ ] Avoid five narrow columns and repetitive status labels.

### Final art-direction work deferred

- [ ] Final logo and app icon.
- [ ] Ownable Pathbreak motif.
- [ ] Final typography and iconography.
- [ ] Chapter themes and backgrounds.
- [ ] Production particles and transitions.
- [ ] Final sound and music direction.
- [ ] Store screenshots and marketing art.

---

## P2 — Level-production pipeline

Start only after the vertical slice is approved.

- [ ] Replace the experimental editor with a modular level editor.
- [ ] Create, move, rotate, and delete paths.
- [ ] Validate schema before export.
- [ ] Integrate `LevelSolver`.
- [ ] Show opening-move count.
- [ ] Show full-clear solution count.
- [ ] Detect reachable dead ends.
- [ ] Add dependency-depth measurements.
- [ ] Add difficulty notes and playtest fields.
- [ ] Preview at phone/tablet scales.
- [ ] Export versioned JSON.
- [ ] Batch validate level packs.

---

## P3 — Content production

Do not manually produce the full pack before the editor and solver workflow are reliable.

- [ ] Finalise chapter and mechanic plan.
- [ ] Produce teaching levels for every new mechanic.
- [ ] Produce combination levels.
- [ ] Tune difficulty from solver measurements and player evidence.
- [ ] Remove levels that solve through random tapping.
- [ ] Verify originality and avoid competitor layouts.
- [ ] Build the launch-sized level pack.

---

## P3 — Commercial and launch preparation

- [ ] Final name and trademark clearance.
- [ ] Analytics event implementation.
- [ ] Crash reporting.
- [ ] Privacy policy and Data Safety form.
- [ ] Consent flow where required.
- [ ] Android target/API and store configuration.
- [ ] Signed Android App Bundle and signing-key backup.
- [ ] Closed testing.
- [ ] Store listing, screenshots, feature graphic, and trailer.
- [ ] Customer support and incident plan.
- [ ] Rewarded hints and optional remove-ads purchase only after retention validation.

---

## Verified or accepted foundations

- [x] Modular gameplay architecture is the only supported runtime architecture.
- [x] Main Menu is the project startup scene.
- [x] JSON is the canonical level format.
- [x] Movement rules are separated into `MovementValidator`.
- [x] Reusable level validation exists.
- [x] `LevelSolver` and vertical-slice tests exist.
- [x] Central nearest-path touch selection exists.
- [x] Save data is versioned.
- [x] Sound, Haptics, Reduce Motion, and High Contrast persist separately.
- [x] Moves and mistakes are tracked independently.
- [x] Hint inventory is persistent.
- [x] Zero hints remain actionable through the refill flow.
- [x] Hint refill was confirmed working after the native-button correction.
- [x] Restart was moved to the same reliable native-button system.
- [x] Menu board and primary CTA both start the recommended level.
- [x] Directional menu and hint cues work in the local build.
- [x] Automatic final clear works and excludes the automatic move.
- [x] Reduce Motion alternatives work for the latest interaction pass.
- [x] AI anti-slop standard is active.
- [x] Current light UI is explicitly provisional.

---

## Commands

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review

GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

"$GODOT" --headless --path . --editor --quit
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
```

Run the complete game with **F5**, not F6.
