# Pathbreak — Production Level Studio v1

**Status:** Next production milestone  
**Branch:** `codex/production-level-studio-v1`  
**Base:** `codex/satisfaction-prototype-v1`

## Goal

Build a reliable in-project level-authoring tool so Pathbreak can create excellent levels deliberately instead of hand-editing JSON or generating large amounts of unmeasured content.

The first content target is **20 polished levels**, not 100 random levels.

## Core workflow

```text
NEW LEVEL
→ choose board size
→ draw paths tail → head
→ validate
→ solve
→ inspect difficulty metrics
→ preview on phone/tablet proportions
→ export canonical JSON
```

## Non-negotiable authoring rules

- A path is authored in ordered cells from **tail → head**.
- Arrow direction is derived from the final ordered segment.
- Bent-path direction must never be inferred from first cell → last cell.
- Export must fail on invalid schema or ambiguous direction data.
- JSON remains the canonical production format.
- The tool must use the same movement rules as the real game.
- The tool must not silently repair invalid levels during export.

## V1 editor features

### 1. Board setup

- choose width and height;
- clear/reset level;
- load an existing canonical JSON level;
- edit level difficulty label and starting lives.

### 2. Ordered path drawing

- click/drag grid cells in tail → head order;
- every new cell must be cardinally adjacent to the previous cell;
- no duplicate cell inside one path;
- no overlapping occupied cells across paths;
- visible tail and arrow head while editing;
- reverse-path action when the author wants to swap head/tail intentionally.

### 3. Validation panel

Before export, show clear pass/fail checks for:

- minimum two cells per path;
- cardinal adjacency;
- duplicate cells;
- overlapping cells;
- out-of-bounds cells;
- ordered final-segment direction;
- direction compatibility field;
- at least one opening move;
- full level solvability.

### 4. Solver analysis

Use the shared `MovementValidator` and reusable `LevelSolver` rather than duplicating puzzle logic.

Report:

- piece count;
- opening move count;
- total full-clear solution count, with a practical cap if enumeration becomes expensive;
- whether the level is solvable;
- whether any dead state can be reached from a legal-looking branch;
- forced-move count;
- branch points;
- longest dependency chain.

## Difficulty model v1

Difficulty should be measured from structure, not visual busyness alone.

Initial signals:

- **Openings:** fewer starting moves usually increases constraint.
- **Forced moves:** longer forced sequences can teach structure but may reduce choice.
- **Branches:** more meaningful branches increase decision load.
- **Dependency depth:** longer blocker chains increase planning depth.
- **Solution count:** too many solutions can make a level trivial; exactly one is not automatically better.
- **Bent-path load:** bends increase visual reading cost and should be considered separately from logical depth.

The editor should expose raw metrics first. Do not invent a magical single difficulty number until playtest data exists.

## Preview requirements

V1 should provide a gameplay-style preview using the real path rendering rules.

Preview must preserve:

- ordered arrow heads;
- tail markers;
- current path thickness/readability;
- portrait board proportions;
- Pathbreak snake/uncoil behavior when testing a level.

Phone/tablet preview presets can be simple viewport-size buttons initially; they do not need device mockups.

## Export requirements

Export canonical JSON matching the runtime loader.

Export is allowed only when validation passes.

Each exported level should include at minimum:

```json
{
  "width": 8,
  "height": 8,
  "difficulty": "Normal",
  "lives": 3,
  "pieces": [
    {
      "cells": [[0, 0], [1, 0], [1, 1]],
      "direction": [0, 1]
    }
  ]
}
```

The compatibility `direction` field must be derived from the ordered path endpoint, never independently authored.

## Production content rules

The editor exists to help design levels with a teaching purpose.

Suggested first 20-level arc:

- **1–5:** reading direction, blocking, bent-path basics;
- **6–10:** two-step dependency chains and controlled choice;
- **11–15:** longer bends, branch evaluation, mixed path lengths;
- **16–20:** deeper dependency chains and multiple meaningful candidate moves.

Levels 1–5 already exist and should be treated as the current foundation unless regression evidence appears.

## V1 implementation order

1. Audit the existing experimental level editor and solver APIs.
2. Make ordered tail→head drawing the only normal authoring path.
3. Add shared validator integration and clear error display.
4. Add solver analysis: solvable, openings, solution count.
5. Add dependency/branch metrics.
6. Add real-game preview.
7. Add guarded canonical JSON export.
8. Author Levels 6–10 with the studio and playtest them before scaling further.

## Acceptance gate

Production Level Studio v1 is accepted when we can create a new level from an empty board and complete this flow without hand-editing data:

```text
create board
→ draw every path
→ validation passes
→ solver proves full clear
→ metrics appear
→ preview works
→ JSON exports
→ exported JSON loads in Pathbreak unchanged
```

Additionally, the tool must reject at least these deliberately broken cases:

- overlapping paths;
- disconnected path cells;
- invalid final direction;
- unsolvable board;
- board with no opening move.

## Product constraint carried forward

Pathbreak feel is now locked from the three-person satisfaction/readability test.

Do not use this milestone as an excuse to redesign release motion, hints, completion effects, or the vertical-slice visual language. The Level Studio should serve content production, not reopen settled feel work.