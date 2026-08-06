# Pathbreak — Vertical Slice Playtest Evidence

Date: 2026-08-06
Branch: `codex/vertical-slice-level-review`
Tester context: returning developer/tester familiar with the game. This is not a clean first-time-player test.

## Evidence received

Screenshots were provided for Levels 1–5, the Level 4 failure screen, the Level 4 result screen, the Level 5 result screen, and the zero-hint Level 2 state.

Observed result data:

- Level 4 completed in 7 seconds with 10 moves, 2 mistakes, and 0 hints.
- Level 5 completed in 16 seconds with 8 moves, 0 mistakes, and 0 hints.
- Level 4 failure state appeared after lives reached zero and exposed functional Try Again and Back to Menu actions.
- Level 4 and Level 5 result cards displayed time, moves, mistakes, hints, rating, Replay, and Next Level.
- All five boards fit the captured portrait viewport without clipping the header or bottom controls.
- The zero-hint state displayed `+3` and `Refill`, but tapping the card did not open the refill popup in the observed build.

## Director review by level

### Level 1

- The two opposing paths are immediately readable.
- Both intended opening choices are visually obvious.
- The board composition is balanced and appropriate for rule discovery.
- The Hint badge displayed `0`, so the fresh-save `FREE` tutorial-hint state was not verified in this run.

Status: structurally approved; fresh-save tutorial test still required.

### Level 2

- The blocker relationship and bent path are readable.
- The original 8×8 board left excessive unused space around only three pieces.
- Board dimensions were reduced to 6×6 without changing the dependency sequence.
- The tightened board rendered correctly in the supplied screenshot.

Status: composition accepted provisionally; refill interaction retest required.

### Level 3

- The bend-reading lesson is visible.
- The original 8×10 board placed all content in the upper section and left a large empty lower area.
- Board dimensions were reduced to 6×6 without changing openings or solution count.

Status: composition tuned; replay required after pull.

### Level 4

- The straight-path layout is readable despite higher piece count.
- Failure and retry flow were successfully exercised.
- The 7-second result is not valid first-time difficulty evidence because the tester already understands the mechanic and deliberately tested blocked taps.
- No clipping or obvious touch overlap is visible in the screenshot.

Status: keep pending an external first-time playtest.

### Level 5

- The redesigned board is visually balanced and contains a clear mixture of bent and straight paths.
- The player completed it perfectly in 16 seconds.
- This is below the original 45–90 second first-time target, but the run came from a returning tester. One experienced run is insufficient evidence for another redesign.
- The level should be tested with at least three players who have not seen its structure. Redesign only if first-time median completion remains below 25 seconds or players describe it as automatic cleanup.

Status: retain provisionally; external first-time difficulty test required.

## Technical issues found

### HUD enum warning

Godot reported:

```text
Integer used when an enum value is expected.
INT_AS_ENUM_WITHOUT_CAST
hud.gd:56
```

The HUD descendant mouse-filter assignment was replaced as part of the later native-button input fix.

### Hint refill card did not respond

Observed behaviour:

- the HUD correctly changed to `+3` / `Refill`;
- tapping the refill card produced no visible popup or state change.

Director diagnosis:

- the card relied on manually parsing `gui_input` events from a `PanelContainer`;
- this created an unnecessary custom input path for behaviour that Godot already supports through `Button`.

Implemented correction, pending local verification:

- Hint and Restart cards now use full-card native `Button` hit targets;
- activation now uses the engine `pressed` signal instead of custom mouse/touch expression parsing;
- the popup is opened after a completed button press rather than during a raw press event;
- this also avoids the new backdrop receiving the same opening press.

This is an anti-slop correction: the generic custom event layer was removed rather than patched with more special cases.

## Additional visual notes

- The current fail-screen light-bulb emoji is a placeholder and does not match the otherwise controlled monochrome visual language. Replace it during the final art-direction pass.
- The current UI is sufficient for structural testing but remains intentionally non-final.
- Early levels should use tighter boards so paths remain large and readable rather than floating inside unnecessary empty space.

## Remaining approval evidence

- Clean parser scan after the native HUD button change.
- Movement validator suite.
- Level data validator suite.
- Vertical-slice solver suite.
- Zero-hint refill popup opens from the full card.
- `Not now`, backdrop tap, and Back close the popup without changing hints.
- `Refill 3 Hints` updates the HUD to `×3` and persists after menu navigation.
- Fresh-save Level 1 test showing `FREE` and consuming no hint.
- Replay of the tightened Level 3 board.
- Natural, non-deliberate completion times for Levels 1–5.
- At least three first-time external testers.
- Android phone and tablet touch test.
- High contrast and Reduce Motion test.

## Current decision

The slice remains in review. Level 1 structure and the redesigned Level 5 structure are not rejected by this evidence. Level 2 and Level 3 receive composition-only tuning. The hint refill display state exists, but the interaction is not approved until the native-button correction passes local testing. Final approval remains blocked by fresh-save, automated, external-player, and Android-device evidence.
