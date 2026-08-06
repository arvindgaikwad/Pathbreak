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

The counts below were derived from the current JSON data using the same directional ray-blocking rule as `MovementValidator`.

| Level | Board | Pieces | Valid opening moves | Full-clear sequences | Intended lesson | Director verdict |
|---|---:|---:|---:|---:|---|---|
| 1 | 6×6 | 2 | 1 | 1 | Learn the exit rule with two clearly available moves | Reject for redesign: current level teaches a forced move, not choice between obvious valid moves. |
| 2 | 8×8 | 3 | 1 | 1 | Understand one obvious blocker | Conditional: clean forced sequence, but the blocker lesson must be verified visually and through first-time play. |
| 3 | 8×10 | 4 | 3 | 12 | Read a bent path | Conditional: introduces a bend, but three openings may dilute the lesson and make the level feel less authored. |
| 4 | 8×8 | 8 | 2 | 7 | Choose between valid moves | Promising: two openings and limited solution variety fit the intended lesson. Requires touch-density review. |
| 5 | 8×8 | 8 | 6 | 13,440 | Representative 45–90 second challenge | Reject for redesign: too many immediate choices and too many clear sequences; likely feels like cleanup rather than a representative puzzle. |

## Immediate decisions

### Level 1

Redesign before approval.

Target:

- 2–3 pieces;
- exactly two obvious opening moves;
- both openings safe;
- final piece becomes clear after either opening;
- completion in roughly 5–15 seconds;
- tutorial text limited to one sentence;
- free Hint remains demonstrative rather than necessary.

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

Keep as the strongest current candidate.

Target:

- two valid openings are both readable;
- different orders feel meaningfully different but remain safe;
- no accidental taps on the denser board;
- completion in roughly 25–50 seconds.

### Level 5

Redesign before approval.

Target:

- 7–10 pieces;
- 1–3 valid opening moves;
- several authored dependencies;
- limited but meaningful route variety;
- no new mechanic;
- completion in roughly 45–90 seconds for a new player;
- satisfying final chain of removals;
- serves as the benchmark for future standard levels.

## Slice difficulty curve

Expected progression:

| Level | Cognitive load | Opening choice | Expected first-time duration |
|---|---|---:|---:|
| 1 | Rule discovery | 2 obvious | 5–15 s |
| 2 | Blocking | 1 | 10–20 s |
| 3 | Shape reading | 1–2 | 15–30 s |
| 4 | Safe choice | 2 | 25–50 s |
| 5 | Combined reasoning | 1–3 | 45–90 s |

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

- Level 1: redesign required.
- Level 2: playtest required.
- Level 3: playtest and likely tuning required.
- Level 4: playtest required; strongest current candidate.
- Level 5: redesign required.
- Final UI/art direction: deferred.
- Mass level production: blocked until all five levels pass.

## Next implementation sequence

1. Add automated vertical-slice structure and solvability checks.
2. Redesign Level 1.
3. Redesign Level 5.
4. Run parser and validator tests.
5. Conduct a full five-level director playtest.
6. Tune Levels 2–4 using recorded evidence.
7. Test on Android phone and tablet.
8. Approve or reject the slice as a complete package.
