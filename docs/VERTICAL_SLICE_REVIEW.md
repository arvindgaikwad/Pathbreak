# Pathbreak — Vertical Slice Director Review

Status: active production gate
Branch: `codex/vertical-slice-level-review`

## Purpose

Approve or reject Levels 1–5 as the quality reference for all future Pathbreak content. This review focuses on teaching order, puzzle structure, touch fairness, difficulty, pacing, feedback, and complete player flow. Final visual identity is deliberately deferred.

## Review process

### Gate 1 — Static level audit

For each level, record:

- board dimensions;
- piece count;
- bent-piece count;
- number of valid opening moves;
- number of possible full-clear sequences;
- intended lesson;
- whether the data actually teaches that lesson;
- density and likely touch ambiguity.

### Gate 2 — Automated validation

Required:

- JSON schema/data validation;
- no overlapping or disconnected cells;
- at least one complete solution;
- intended opening-move count;
- no state that can become permanently unsolvable after a legal move;
- stable level order and IDs.

Implemented automation:

- `scripts/gameplay/level_solver.gd` counts complete clear orders, finds one solution, reports opening moves, and detects reachable dead ends.
- `tests/test_vertical_slice_levels.gd` loads the five canonical JSON levels and checks their structure, opening curve, solution counts, and solvability.

Local verification command:

```bash
godot --headless --path . --script tests/test_vertical_slice_levels.gd
```

### Gate 3 — Director playtest

Each level is played three times:

1. first-time player behaviour;
2. deliberate wrong-tap and recovery behaviour;
3. replay for speed and optimal moves.

Record:

- time to first move;
- completion time;
- mistakes;
- hints;
- restarts;
- confusing paths;
- accidental selections;
- emotional rhythm: clear, satisfying, dull, frustrating, or surprising.

### Gate 4 — Device and accessibility QA

Test at minimum:

- 360 × 800 phone;
- 393 × 873 phone;
- 412 × 915 phone;
- one Android phone;
- one Android tablet;
- high contrast on/off;
- reduce motion on/off;
- sound and haptics on/off.

### Gate 5 — Flow QA

Verify:

- F5 starts at Main Menu;
- Continue selects the intended level;
- Levels opens and returns correctly;
- gameplay back, pause, resume, restart, and Main Menu work;
- Hint highlights a valid path and consumes the correct amount;
- failure, replay, completion, Next Level, and final-level exit work;
- progress survives restart.

## Current static audit

The counts below were derived from the JSON data using the same directional ray-blocking rule as `MovementValidator`.

| Level | Board | Pieces | Valid opening moves | Full-clear sequences | Intended lesson | Director verdict |
|---|---:|---:|---:|---:|---|---|
| 1 | 6×6 | 2 | 2 | 2 | Learn the exit rule with two clearly available moves | Redesigned: structurally matches the lesson. Visual tutorial playtest remains required. |
| 2 | 8×8 | 3 | 1 | 1 | Understand one obvious blocker | Conditional: clean forced sequence, but the blocker lesson must be verified visually and through first-time play. |
| 3 | 8×10 | 4 | 3 | 12 | Read a bent path | Conditional: introduces a bend, but three openings may dilute the lesson and make the level feel less authored. |
| 4 | 8×8 | 8 | 2 | 7 | Choose between valid moves | Promising: two openings and limited solution variety fit the intended lesson. Requires touch-density review. |
| 5 | 8×8 | 8 | 1 | 6 | Representative 45–90 second challenge | Redesigned: one clear entry move and a limited dependency chain. Timing, readability, and satisfaction remain unverified. |

## Level decisions

### Level 1

The data redesign is complete.

Current structure:

- two straight paths;
- both are immediately safe;
- either can be selected first;
- the other remains available;
- exactly two full-clear orders;
- target completion time remains 5–15 seconds.

Approval still requires observing a first-time player without explaining the rule.

### Level 2

Keep temporarily and playtest.

Target observation:

- player notices the blocked path;
- one wrong tap clearly communicates blocking;
- no explanation beyond concise feedback is required;
- completion in roughly 10–20 seconds.

### Level 3

Revise only after playtest evidence.

Target:

- bent path is the visual focus;
- at most two strong opening candidates unless three choices are intentionally taught;
- no close overlapping touch regions;
- completion in roughly 15–30 seconds.

### Level 4

Keep as the strongest existing candidate.

Target:

- two valid openings are both readable;
- different orders feel meaningfully different but remain safe;
- no accidental taps on the denser board;
- completion in roughly 25–50 seconds.

### Level 5

The structural redesign is complete.

Current structure:

- eight pieces;
- one initial valid move;
- six complete solution orders rather than 13,440;
- an authored chain with a small amount of safe branching;
- several bent paths using only previously introduced rules;
- target completion time remains 45–90 seconds.

Approval still depends on whether the chain is understandable and satisfying on a real phone. Structural difficulty must not become visual confusion.

## Slice difficulty curve

Expected progression:

| Level | Cognitive load | Opening choice | Expected first-time duration |
|---|---|---:|---:|
| 1 | Rule discovery | 2 obvious | 5–15 s |
| 2 | Blocking | 1 | 10–20 s |
| 3 | Shape reading | 1–2 preferred; currently 3 | 15–30 s |
| 4 | Safe choice | 2 | 25–50 s |
| 5 | Combined reasoning | 1 | 45–90 s |

A level is not harder merely because it has more pieces. Difficulty should come from understandable dependencies, not visual clutter or ambiguous taps.

## Player test script

Do not explain the controls before Level 1.

Ask after each level:

1. What did you think the rule was?
2. Which path did you expect to move?
3. Did any tap select something you did not intend?
4. Did the mistake feel fair?
5. Was the level too easy, right, or confusing?

Do not correct the player during the first attempt unless the game becomes unusable.

## Approval scorecard

Score each item from 0 to 2:

- rule clarity;
- touch trust;
- visual readability;
- difficulty fit;
- satisfying feedback;
- restart/hint usefulness;
- completion flow;
- replay value;
- phone layout;
- tablet layout.

Interpretation:

- 18–20: approved;
- 15–17: approved with minor changes;
- 11–14: revise and retest;
- 0–10: redesign.

## Current gate status

- Automated solver and slice-specific test suite: implemented, local Godot verification pending.
- Level 1: structurally redesigned; playtest required.
- Level 2: playtest required.
- Level 3: playtest and likely tuning required.
- Level 4: playtest required; strongest existing candidate.
- Level 5: structurally redesigned; playtest required.
- Final UI/art direction: deferred.
- Mass level production: blocked until all five levels pass.

## Next implementation sequence

1. Run the Godot parser scan and all three test suites.
2. Conduct a complete five-level director playtest from Main Menu.
3. Record screenshots, completion times, mistakes, hints, and confusing moments for each level.
4. Tune Levels 2–4 using the recorded evidence.
5. Repeat automated tests after every level-data change.
6. Test on Android phone and tablet.
7. Approve or reject the slice as a complete package.
