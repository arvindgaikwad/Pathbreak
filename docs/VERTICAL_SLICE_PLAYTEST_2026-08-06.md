# Pathbreak — Vertical Slice Playtest Evidence

Date: 2026-08-06 to 2026-08-07  
Branch: `codex/vertical-slice-level-review`

## Evidence sources

Four kinds of evidence were received:

1. A returning developer/tester familiar with the game.
2. New players who interacted without being taught the menu or puzzle rules first.
3. A local interaction-clarity verification pass after the revised menu, direction cues, and automatic final clear were implemented.
4. A clean-save tutorial verification pass.

## Returning-tester evidence

- Level 4 completed in 7 seconds with 10 moves, 2 mistakes, and 0 hints.
- Level 5 completed in 16 seconds with 8 moves, 0 mistakes, and 0 hints.
- Failure, retry, result, Replay, Next Level, restart, hint depletion, and refill were exercised.
- All captured boards fit the portrait viewport without clipping.

## Initial new-player findings

### Main menu

- Players were unsure where to begin.
- Some tapped the demonstration arrows instead of the Continue button.
- They expected the demonstration to animate like a path or snake travelling through its shape, not only perform a swoosh.

**Director response:** make the demonstration board a valid play target, strengthen the primary action, and animate direction through the path before escape.

### Path readability

- Level 2 communicated blocking clearly.
- Level 3 successfully taught bent-path reading.
- Some players struggled with the original arrowhead and tail-dot language.
- Direction was not consistently understood from the shape alone.

**Director response:** reduce the visual importance of the tail dot, strengthen the arrowhead, and use directional motion during tutorial and hint states.

### Final remaining path

- Players felt the final obvious path should leave automatically rather than requiring one more tap.

**Director response:** automatically clear the final valid path after a short preview, without adding another player Move.

### Difficulty and enjoyment

- Typical completion time was roughly 10 seconds per level.
- Players made zero mistakes because the boards were easy.
- Hints were used on Levels 9 and 10.
- Players reported enjoying the levels.

**Director decision:** the interaction has positive enjoyment evidence, but the difficulty curve is too shallow. Increase decision depth only after revised path readability is accepted by new players.

## Local interaction-clarity verification — 2026-08-07

The user confirmed these behaviours work in the local Godot build:

- Tapping the animated menu board opens the recommended level.
- The normal Start/Continue button opens the same recommended level.
- The travelling blue menu animation plays.
- A hint moves the blue marker toward the arrowhead.
- The final remaining valid path clears automatically.
- The result Move count excludes the automatic final clear.
- Reduce Motion provides working alternatives for the menu, hint, and final clear.
- Restart still functions.
- Hint refill still functions.

**Verification boundary:** this confirms the listed manual flows. Exact parser output and automated test output were not supplied with this report, so formal parser/test verification remains open. New-player comprehension of the revised arrow/tail language also remains open.

## Clean-save tutorial verification — 2026-08-07

The user reset the save and supplied screenshots confirming:

- Main Menu entered the new-player state.
- Star count started at zero.
- Main CTA displayed `Start Level 1`.
- Hero prompt displayed `TAP THE BOARD TO START`.
- Level 1 displayed `FREE` in the Hint card.
- Level 2 displayed the normal five-hint inventory.
- Replaying Level 1 displayed the real hint count instead of `FREE`.

**Status:** the clean-save tutorial hint-state gate is approved.

## Arrow visual defects observed in the clean-save screenshots

The latest screenshots revealed visual-language issues even though the underlying interactions worked:

1. The travelling blue hint marker could overlap or sit directly beside the arrowhead, making the endpoint resemble a second tail dot.
2. The notched four-point arrowhead could read like a fish tail, fork, or decorative shape instead of a clean directional arrow, especially on left-facing paths.
3. Arrowhead size and line weight felt inconsistent across straight and bent paths.
4. Some bent-path arrowheads met the line awkwardly and appeared oversized at compact board scales.
5. The menu demonstration temporarily mixed blue and navy across one path in a way that looked visually split rather than clearly animated.

## Arrow-language cleanup implementation — pending local verification

The branch now contains the targeted path-glyph cleanup:

- gameplay and menu arrowheads use a simple filled triangle with no notch;
- triangle proportions are consistent across left, right, up, and down;
- tail dots are slightly smaller;
- hint/tutorial markers stop before the arrowhead region;
- the complete path turns blue after the travelling marker reaches its stopping point;
- the menu demonstration uses one travelling marker rather than a partially blue path segment;
- marker size remains below the main line width so it reads as motion rather than another endpoint;
- movement rules, touch selection, solver, level data, progression, and hint inventory were not changed.

**Verification boundary:** this code has not yet been parsed or visually reviewed in the user's local Godot 4.7.1 build.

## Level review

### Level 1

- The two opening paths remain suitable for rule discovery.
- Clean-save `FREE` behaviour is verified.
- Replaying Level 1 correctly uses the normal persistent hint count.

**Status:** tutorial state approved; cleaned path glyph requires visual review.

### Level 2

- Blocking was understood by new players.
- The tightened 6×6 board is readable.
- Normal hint inventory correctly displayed after Level 1.

**Status:** teaching purpose provisionally approved; confirm cleaned arrow language with new players.

### Level 3

- Bent-path reading was understood.

**Status:** teaching purpose provisionally approved; confirm cleaned direction cue with new players.

### Levels 4–5

- Functional and enjoyable.
- Too quick to represent the intended middle-game challenge.

**Status:** retain mechanics; tune after cleaned path comprehension is accepted.

### Levels 9–10

- Players used hints, showing more uncertainty than earlier levels.
- The `No path can leave yet` message was liked and should remain.
- The current Hard label is not supported by completion-time evidence.

**Status:** keep the no-move feedback; review late-level structure and labels later.

## Technical issues found and resolved

- Godot enum warning in `hud.gd` fixed with explicit enum typing.
- Hint-refill popup parse error fixed with explicit `bool` typing.
- Hint and Restart cards moved from custom `gui_input` parsing to native Button hit targets.
- Hint refill was confirmed working after the native-button correction.
- Menu board start interaction, directional hint cue, automatic final clear, and Reduce Motion alternatives were manually confirmed working.
- Clean-save tutorial hint-state behaviour was manually confirmed.

## Remaining vertical-slice gates

1. Run and record the current parser scan and all automated suites.
2. Verify the simple-triangle glyph in all four directions.
3. Verify the marker stops before the arrowhead and never resembles a second endpoint.
4. Verify the menu path no longer appears split between navy and blue.
5. Verify rapid menu taps do not double-navigate.
6. Verify prompt placement and layout at compact phone and tablet sizes.
7. Verify High Contrast, Sound persistence, and Haptics persistence.
8. Repeat no-explanation testing with new players using the cleaned arrowhead, tail dot, and direction motion.
9. Tune Levels 4–5 only after readability is accepted.
10. Complete Android phone/tablet input, Back, lifecycle, performance, sound, and haptic testing.

## Current decision

The clean-save tutorial and interaction-clarity behaviours are manually functional. The cleaned path language is implemented and awaits parser, visual, and new-player verification. The vertical slice remains unapproved until those gates pass.
