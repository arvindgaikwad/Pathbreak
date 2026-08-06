# Pathbreak — Vertical Slice Playtest Evidence

Date: 2026-08-06 to 2026-08-07  
Branch: `codex/vertical-slice-level-review`

## Evidence sources

Three kinds of evidence were received:

1. A returning developer/tester familiar with the game.
2. New players who interacted without being taught the menu or puzzle rules first.
3. A local interaction-clarity verification pass after the revised menu, direction cues, and automatic final clear were implemented.

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

## Level review

### Level 1

- The two opening paths remain suitable for rule discovery.
- `FREE` did not appear in the captured run.
- The supplied menu showed Level 10 progress and 26 stars, proving this was not a clean save.
- The current rule only shows `FREE` while `tutorial_completed` is false.

**Status:** no Level 1 hint bug is proven. A clean-save test remains required.

### Level 2

- Blocking was understood by new players.
- The tightened 6×6 board is readable.

**Status:** teaching purpose provisionally approved; confirm revised arrow/tail language with new players.

### Level 3

- Bent-path reading was understood.

**Status:** teaching purpose provisionally approved; confirm revised direction cue with new players.

### Levels 4–5

- Functional and enjoyable.
- Too quick to represent the intended middle-game challenge.

**Status:** retain mechanics; tune after revised path comprehension is accepted.

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

## Remaining vertical-slice gates

1. Run and record the current parser scan and all automated suites.
2. Perform a clean-save Level 1 test showing `FREE` and no normal-hint consumption.
3. Verify rapid menu taps do not double-navigate.
4. Verify prompt placement and layout at compact phone and tablet sizes.
5. Verify High Contrast, Sound persistence, and Haptics persistence.
6. Repeat no-explanation testing with new players using the revised arrowhead, tail dot, and direction motion.
7. Tune Levels 4–5 only after readability is accepted.
8. Complete Android phone/tablet input, Back, lifecycle, performance, sound, and haptic testing.

## Current decision

The interaction-clarity implementation is manually functional. The next process is formal parser/test evidence and a clean-save tutorial pass, followed by revised new-player comprehension and Android-device testing. The vertical slice remains unapproved until those gates pass.
