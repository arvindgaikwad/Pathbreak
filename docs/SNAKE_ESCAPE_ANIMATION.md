# Pathbreak — Snake Escape Animation

**Status:** Manually verified; post-animation automated rerun still required  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## Verified input before this pass

The user previously confirmed:

- Gate 1 formal parser and automated verification passed for the ordered-path correction.
- Gate 2 movement regression passed.
- Gate 3 new-player comprehension passed.
- The ordered path-head system is visually accepted.

The remaining game-feel requirement was specific: a bent path must not translate as a rigid L. Its head must pull the body through the bend until the whole path becomes straight, then the straightened path exits.

## Exact intended motion

For an ordered path:

```text
tail → segment → corner → final segment → head
```

The escape has two visual phases.

### Phase 1 — Uncoil

The head advances in the final escape direction while the body keeps a constant arc length behind it.

A moving window of exactly one body-length is taken from:

```text
original path + straight exit extension
```

The window starts at the original tail and advances forward. Because the exact original corner vertex remains inside that window until the tail reaches it:

1. the head moves first;
2. the tail slides along its original segment;
3. the bend visibly travels backward through the body;
4. the path preserves the exact 90-degree corner rather than cutting diagonally;
5. when the tail finally reaches the old head position, the entire body is straight.

### Phase 2 — Exit

After the body is completely straight, the straight path continues out of the board.

The current escape intentionally spends most of its visible progress on the uncoil phase for bent paths. The remaining progress is the straight exit. Straight paths skip the special uncoil weighting because they have no corner to demonstrate.

## Implementation

### Shared geometry

`scripts/gameplay/path_visual_geometry.gd` provides:

- tail-to-head point ordering;
- polyline length calculation;
- point lookup at an arc-length distance;
- exact polyline slicing between two distances while preserving interior corner vertices.

### Runtime animation

`scripts/gameplay/puzzle_piece.gd` now:

- builds a tail-to-head route from the ordered cells;
- extends it beyond the head in the canonical escape direction;
- keeps the visible body length constant;
- advances a body-length window through the route;
- preserves corners exactly while they are still inside the body;
- progressively removes the bend only when the tail passes through it;
- trims the shaft under the head without changing movement geometry;
- keeps arrowhead and movement direction tied to the same final segment;
- uses a short final straight-exit phase after the body has fully uncoiled;
- preserves the simpler translation/fade when Reduce Motion is enabled.

No level data, occupancy, solver rule, touch-selection rule, hint count, or progression rule changed.

## Why the first snake attempt was rejected

The first attempt moved sampled body points along the complete route, but the total travel included a very long off-screen extension in a single normalized tween. As a result, the body could complete its corner-straightening in only the first small fraction of the animation and visually look like it simply moved downward.

The corrected version separates the perceptual timing:

```text
bend removal gets most of the visible animation
→ then the already-straight body exits
```

It also slices the exact polyline rather than reconnecting sparse moved samples, avoiding diagonal shortcuts across corners.

## Automated coverage

`tests/test_path_visual_geometry.gd` includes a corner-body-window test.

It verifies that an L-shaped route at partial travel contains the moving tail, exact corner, final segment, and moving head, and that after one complete body-length of travel the body becomes a straight segment of the same length.

Expected suite result:

```text
Ordered path geometry: 7/7 passed
```

## Manual acceptance — PASSED

The user confirmed the corrected animation is working as intended.

Accepted behaviour:

- [x] L-shaped path feeds through its bend rather than translating as a rigid L.
- [x] Arrowhead visibly leads.
- [x] Tail follows its original segment into the corner.
- [x] Corner travels through the body.
- [x] No large diagonal shortcut appears across the bend.
- [x] Full path becomes straight before the final exit.
- [x] Snake motion is visually understandable and satisfying enough to keep.

## Remaining verification

Because this animation changed shared geometry after the previous Gate 1 run, rerun the parser and automated suites on the current head before calling the implementation fully regression-tested. Also retain a quick Reduce Motion regression check.
