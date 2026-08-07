# Pathbreak — Snake Escape Animation

**Status:** Implemented, pending local Godot verification  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## Verified input before this pass

The user confirmed:

- Gate 1 formal parser and automated verification passed.
- Gate 2 movement regression passed.
- Gate 3 new-player comprehension passed.
- The ordered path-head system is visually accepted.

The remaining game-feel requirement is specific: a bent path must not translate as a rigid L. Its head must pull the body through the bend until the whole path becomes straight, then the straightened path exits.

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

The current 0.28-second escape intentionally spends about 72% of its visual progress on the uncoil phase for bent paths. The remaining progress is the straight exit. This makes the snake behaviour visible without changing existing gameplay timers.

Straight paths skip the special uncoil weighting because they have no corner to demonstrate.

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
- preserves the previous simple translation/fade when Reduce Motion is enabled.

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

It verifies that an L-shaped route at partial travel contains:

```text
moving tail
→ exact original corner
→ final-segment corner
→ moving head
```

and that after one complete body-length of travel the body is a straight segment of the same length.

Expected suite result:

```text
Ordered path geometry: 7/7 passed
```

## Manual acceptance

- L-shaped paths visibly feed through the bend instead of sliding as a rigid L.
- The arrowhead leads.
- The tail follows its original segment into the bend.
- The corner visibly travels through the body.
- The body does not cut diagonally across the corner.
- The full path becomes straight before the final exit.
- Body length does not visibly shrink during uncoiling.
- Straight paths remain clean.
- Visible head direction equals actual movement direction.
- Restart, refill, hints, failure, results, and automatic final clear do not regress.
- Reduce Motion keeps the simpler rigid translation/fade instead of shape deformation.

## Remaining verification

Run the parser and all automated suites again, then visually test at least one L-shaped path in Levels 2, 3, and 5. The key acceptance check is not merely that the path exits correctly; the user must be able to see the bend travel through the body and disappear before the final straight exit.
