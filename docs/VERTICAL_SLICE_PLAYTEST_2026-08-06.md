# Pathbreak — Vertical Slice Playtest Evidence

Date: 2026-08-06 to 2026-08-07  
Branch: `codex/vertical-slice-level-review`

## Evidence sources

Two kinds of evidence were received:

1. A returning developer/tester familiar with the game.
2. New players who interacted without being taught the menu or puzzle rules first.

## Returning-tester evidence

- Level 4 completed in 7 seconds with 10 moves, 2 mistakes, and 0 hints.
- Level 5 completed in 16 seconds with 8 moves, 0 mistakes, and 0 hints.
- Failure, retry, result, Replay, Next Level, restart, hint depletion, and refill were exercised.
- All captured boards fit the portrait viewport without clipping.

## New-player findings

### Main menu

- Players were unsure where to begin.
- Some tapped the demonstration arrows instead of the Continue button.
- They expected the demonstration to animate like a path or snake travelling through its shape, not only perform a swoosh.

**Director decision:** the current menu hierarchy is not approved. The demonstration creates an interaction expectation but does not respond. The next iteration must make the start action unmistakable and either make the demonstration a valid start target or clearly non-interactive.

### Path readability

- Level 2 communicated blocking clearly.
- Level 3 successfully taught bent-path reading.
- Some players struggled with the current arrowhead and tail-dot language.
- Direction was not consistently understood from the shape alone.

**Director decision:** retain the core rule but revise the path visual language. The next prototype should reduce the visual importance of the tail dot, strengthen the arrowhead, and use directional motion during tutorial/hint states.

### Final remaining path

- Players felt the final obvious path should leave automatically rather than requiring one more tap.

**Director decision:** prototype automatic final clear when exactly one path remains and it is escapable. It should highlight briefly, leave automatically, not count as another player move, and respect Reduce Motion.

### Difficulty and enjoyment

- Typical completion time was roughly 10 seconds per level.
- Players made zero mistakes because the boards were easy.
- Hints were used on Levels 9 and 10.
- Players reported enjoying the levels.

**Director decision:** the interaction has positive enjoyment evidence, but the difficulty curve is too shallow. Increase decision depth only after path readability is improved, so difficulty does not come from visual confusion.

## Level review

### Level 1

- The two opening paths remain suitable for rule discovery.
- `FREE` did not appear in the captured run.
- The supplied menu showed Level 10 progress and 26 stars, proving this was not a clean save.
- The current rule only shows `FREE` while `tutorial_completed` is false.

**Status:** no Level 1 hint bug is proven by this screenshot. A clean-save test remains required.

### Level 2

- Blocking was understood by new players.
- The tightened 6×6 board is readable.

**Status:** teaching purpose provisionally approved.

### Level 3

- Bent-path reading was understood.

**Status:** teaching purpose provisionally approved.

### Levels 4–5

- Functional and enjoyable.
- Too quick to represent the intended middle-game challenge.

**Status:** retain mechanics; tune after path-visual revision.

### Levels 9–10

- Players used hints, showing more uncertainty than earlier levels.
- The `No path can leave yet` message was liked and should remain.
- The current Hard label is not supported by completion time evidence.

**Status:** keep the no-move feedback; review late-level structure and labels later.

## Technical issues found and resolved

- Godot enum warning in `hud.gd` fixed with explicit enum typing.
- Hint-refill popup parse error fixed with explicit `bool` typing.
- Hint and Restart cards moved from custom `gui_input` parsing to native Button hit targets.
- Hint refill was confirmed working after the native-button correction.

## Next iteration gates

The vertical slice is not approved yet. The next build must address these in order:

1. Main-menu start clarity.
2. Demonstration animation and interaction expectation.
3. Arrowhead/tail-dot readability.
4. Automatic final-path clear prototype.
5. Clean-save Level 1 `FREE` verification.
6. Difficulty tuning for Levels 4–5 after readability is stable.
7. Repeat new-player testing with no verbal explanation.
8. Android phone/tablet input and lifecycle testing.

## Current decision

The core puzzle is enjoyable and Levels 2–3 teach their intended ideas. The blockers are now interaction clarity, path visual language, menu hierarchy, and insufficient challenge—not basic functionality.