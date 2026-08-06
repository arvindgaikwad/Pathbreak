# Pathbreak — Vertical Slice Playtest Evidence

Date: 2026-08-06 to 2026-08-07  
Branch: `codex/vertical-slice-level-review`

## Evidence sources

1. Returning developer/tester familiar with the game.
2. New players with no menu or rule explanation.
3. Local interaction-clarity verification.
4. Clean-save tutorial verification.
5. Screenshot review after the first simple-triangle cleanup.

## Returning-tester evidence

- Level 4: 7 seconds, 10 moves, 2 mistakes, 0 hints.
- Level 5: 16 seconds, 8 moves, 0 mistakes, 0 hints.
- Failure, retry, result, Replay, Next Level, restart, hint depletion, and refill were exercised.
- Captured boards fit the portrait viewport.

## Initial new-player findings

### Main Menu

- Players were unsure where to begin.
- Some tapped the demonstration arrows rather than Continue.
- They expected path-like motion instead of a simple swoosh.

**Response:** make the board a valid start target, strengthen Start/Continue, and animate direction through the path.

### Path readability

- Level 2 communicated blocking.
- Level 3 communicated bent-path reading.
- Arrowhead and tail-dot language was not consistently understood.

**Response:** strengthen the head, reduce tail prominence, and use restrained directional motion.

### Final path

Players wanted the last obvious path to leave automatically.

**Response:** preview and auto-clear the final valid path without adding a Move.

### Difficulty

- Typical early completion was roughly 10 seconds.
- Zero mistakes were common.
- Hints were used on Levels 9–10.
- Players reported enjoyment.

**Decision:** improve visual comprehension before increasing difficulty.

## Interaction-clarity verification — passed before latest migration

The user confirmed:

- Menu board starts the recommended level.
- Start/Continue starts the same level.
- Travelling menu animation works.
- Hint marker moves toward the arrowhead.
- Final remaining valid path clears automatically.
- Automatic final clear does not add a Move.
- Reduce Motion alternatives work.
- Restart and hint refill work.

## Clean-save tutorial verification — passed

Screenshots confirmed:

- New-player menu and zero stars.
- `Start Level 1`.
- `TAP THE BOARD TO START`.
- Level 1 displays `FREE`.
- Level 2 displays five normal hints.
- Replaying Level 1 displays the real hint count.

## First simple-triangle cleanup — rejected as incomplete

A later Level 5 screenshot showed that replacing the notched head with a triangle did not solve the shared problem.

Observed:

- some triangles remained attached to a side that did not follow the path endpoint;
- some L-shaped heads still pointed in a direction unrelated to their adjacent segment;
- visually “leading” placement and stored movement direction could disagree;
- the result looked systematic across multiple pieces, not like isolated styling defects.

The initial projection-based correction was therefore rejected. A geometric leading edge is not necessarily an ordered path endpoint.

## Expert-prompt correction now implemented — pending verification

The two supplied expert prompts establish the correct model:

```text
ordered cells
→ selected endpoint
→ adjacent endpoint cell
→ derived head direction
→ same movement direction
```

Current canonical Pathbreak rule:

```text
tail → ... → head
cells[-1] - cells[-2]
= head direction
= movement direction
```

Implemented after the screenshot review:

- ordered endpoint helper in `path_visual_geometry.gd`;
- shaft trimming before the triangle;
- `PuzzlePieceData` derives movement direction from ordered cells;
- gameplay and menu use the same endpoint geometry;
- hint marker is a small directional triangle on the final segment;
- validator rejects path/direction mismatches;
- Level Editor cannot assign arbitrary unrelated directions;
- safe preview-only migration scanner;
- Levels 1–5 migrated;
- ordered-path geometry and full-pack tests;
- movement tests migrated to valid ordered paths.

Migration review:

- 10 sequential levels inspected;
- 13 path entries did not match the final-segment convention;
- 7 repaired by reversing cell order;
- 6 required small geometry changes;
- Levels 6–10 already followed the convention.

**Verification boundary:** none of the latest ordered-path changes should be called working until the local parser, migration preview, tests, and screenshots pass.

## Current level status

### Level 1

- Two-opening teaching structure retained.
- Clean-save `FREE` verified.
- One path order was reversed to make the left-facing head canonical.

### Level 2

- Blocking was understood before migration.
- One L-path was reshaped and one path reversed.
- Expected one-opening/one-solution target remains encoded in tests.

### Level 3

- Bent-path reading was understood before migration.
- Three malformed direction/path combinations were replaced with canonical endpoint shapes.
- Expected three openings and 12 solutions remain encoded in tests.

### Level 4

- Failure/retry/result flow exercised.
- One upward path was reversed without changing occupancy or direction.

### Level 5

- Previous screenshot exposed the shared head problem.
- Four paths were reversed and two were minimally reshaped.
- Expected one opening and six solutions remain encoded in tests.

### Levels 9–10

- Hints were used.
- `No path can leave yet` was liked and remains.
- Difficulty labels still need later evidence.

## Technical fixes already verified earlier

- HUD enum warning fixed.
- Hint-refill parse error fixed.
- Hint and Restart use native full-card Buttons.
- Hint refill works.
- Menu-board start, automatic final clear, Reduce Motion, and clean-save tutorial states worked before the ordered-path migration.

## Remaining gates

1. Parser scan.
2. Migration preview reports zero reversible/ambiguous paths.
3. Ordered geometry suite passes.
4. Movement, data, and vertical-slice solver suites pass.
5. Levels 1–5 screenshots show endpoint-aligned heads.
6. Visible head direction equals actual escape movement.
7. Shaft/head overlap looks clean.
8. Hint marker follows the same final segment.
9. Reduce Motion and High Contrast pass.
10. New-player no-explanation test.
11. Android phone/tablet test.

## Current decision

The old arrow data/rendering model was the shared root problem. The new ordered endpoint system is implemented but unverified. Difficulty and final UI work remain deferred until this correction passes.
