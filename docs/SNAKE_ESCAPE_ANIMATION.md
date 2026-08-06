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

The remaining game-feel request was that bent and corner paths should not leave as one rigid translated shape. They should flow around their own corners like a snake.

## Intended motion

For an ordered path:

```text
tail → segment → corner → final segment → head
```

The head advances first in the final escape direction. Every sampled body point follows the same route at a fixed distance behind it. A bent path therefore:

1. begins in its authored shape;
2. feeds through its corner;
3. gradually straightens behind the head;
4. exits completely in the arrowhead direction.

Straight paths use the same system and naturally appear as a clean straight escape.

## Implementation

### Shared geometry

`scripts/gameplay/path_visual_geometry.gd` now provides:

- tail-to-head point ordering;
- polyline length calculation;
- point lookup at an arc-length distance;
- dense sampling of long grid segments;
- cumulative sample distances.

### Runtime animation

`scripts/gameplay/puzzle_piece.gd` now:

- builds a tail-to-head route from the ordered cells;
- extends that route beyond the head in the canonical exit direction;
- samples the body at short intervals;
- advances every sample along the route during escape;
- continuously rebuilds the Line2D, tail marker, and arrowhead;
- keeps the arrowhead and movement direction tied to the same final segment;
- uses a short 0.28-second animation so existing completion timing does not regress;
- preserves the previous simple translation/fade when Reduce Motion is enabled.

No level data, occupancy, solver rule, touch-selection rule, hint count, or progression rule changed.

## Automated coverage

`tests/test_path_visual_geometry.gd` now includes a corner-following test that verifies sampled body points move from the horizontal segment, through the corner, and down the final segment.

Expected suite result after this pass:

```text
Ordered path geometry: 7/7 passed
```

## Manual acceptance

- L-shaped paths visibly feed through the bend instead of sliding as a rigid L.
- The head leads and the tail follows.
- The body does not cut across the corner with a large diagonal.
- The path gradually straightens as it exits.
- Straight paths still look clean.
- Arrowhead direction and actual motion remain identical.
- Automatic final clear waits long enough for the escape.
- Restart, refill, hints, failure, and results remain unchanged.
- Reduce Motion still uses the shorter rigid translation rather than deformation.

## Remaining verification

Run the parser and all automated suites again because the animation introduced new geometry helpers. Then visually test at least one L-shaped path in Levels 2, 3, and 5, plus Reduce Motion.
