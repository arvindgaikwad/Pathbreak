# Pathbreak — Vertical Slice Director Review

**Status:** Active production gate  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## Purpose

Approve Levels 1–5 as the gameplay-quality reference before mass level production, final art, or monetization. The slice must prove rule clarity, touch trust, path readability, satisfying motion, difficulty progression, persistence, and Android readiness.

## Gates

### Gate 1 — Structure and automation

Required:

- JSON/data validation;
- ordered tail-to-head path validation;
- arrowhead direction equals final path segment and movement direction;
- at least one full-clear solution;
- intended opening-move count;
- no reachable dead-end after legal moves;
- stable level IDs and progression.

**Status before the latest Level 4–5 tuning:** passed by the user for the ordered-arrow correction. Because Levels 4–5 have now changed, the full suite must be rerun once more.

### Gate 2 — Gameplay regression

Verify movement, hints, restart, refill, automatic final clear, failure/result flow, and direction matching.

**Status before latest level-data tuning:** passed. Snake-style corner escape was also manually approved afterward.

### Gate 3 — New-player comprehension

Verify without verbal explanation that players understand:

- which endpoint is the arrowhead;
- which way a path will move;
- blocking;
- bent paths;
- menu start hierarchy.

**Status:** passed for the corrected ordered-path visual language. Levels 4–5 require a difficulty retest because their layouts have changed.

### Gate 4 — Device and accessibility QA

Still required:

- compact phone layout;
- Android phone;
- Android tablet;
- High Contrast;
- Reduce Motion;
- sound/haptic persistence;
- Back/lifecycle behaviour.

### Gate 5 — Final connected-flow approval

Still required after the tuned levels pass.

## Current level structure

| Level | Board | Pieces | Opening moves | Full-clear sequences | Main lesson | Current status |
|---|---:|---:|---:|---:|---|---|
| 1 | 6×6 | 2 | 2 | 2 | Rule discovery | Teaching and fresh-save `FREE` state verified |
| 2 | 6×6 | 3 | 1 | 1 | Blocking | Comprehension verified |
| 3 | 6×6 | 4 | 3 | 12 | Bent-path reading | Comprehension verified |
| 4 | 8×8 | 9 | 2 | 15 | Two meaningful safe chains | Newly tuned; parser/solver/playtest pending |
| 5 | 8×8 | 10 | 1 | 10 | Deeper staged dependency chain | Newly tuned; parser/solver/playtest pending |

## Level 4 direction

The previous Level 4 had eight pieces and seven solution orders, but structurally it behaved mostly like one long forced chain plus an almost-independent extra opening. That made the initial two-choice promise less meaningful than it looked.

The tuned Level 4 now has:

- nine pieces;
- six bent paths, giving the approved snake motion useful but readable exposure;
- exactly two opening moves;
- each opening immediately reveals a different next safe path;
- fifteen complete solution orders;
- constrained branching rather than one disposable side move.

Structural acceptance targets encoded in tests:

```text
initial openings: [1, 5]
after clearing 1: [4, 5]
after clearing 5: [1, 7]
solutions: 15
```

**Director intention:** the player should feel they have two legitimate ways to start, then repeatedly re-read the board as each branch changes.

Target first-time duration: **20–35 seconds**. This is a playtest target, not an automated guarantee.

## Level 5 direction

The previous Level 5 had eight pieces, one opening, and six solution orders. It was structurally authored but still completed too quickly by experienced and new players.

The tuned Level 5 now has:

- ten pieces;
- five bent paths;
- one clear opening;
- a visible forced opening chain that teaches the player to follow dependencies rather than tap randomly;
- the first real branch only after several successful reads;
- ten complete solution orders, allowing some choice without becoming random cleanup.

Structural sequence encoded in tests:

```text
start               → [5]
after 5             → [6]
after 5,6           → [9]
after 5,6,9         → [7]
after 5,6,9,7       → [4]
after 5,6,9,7,4     → [2, 8]
```

**Director intention:** Level 5 should feel like the first small complete Pathbreak puzzle: readable, deliberate, satisfying, and long enough to require several board re-evaluations.

Target first-time duration: **30–45 seconds**. This remains a playtest target.

## Snake escape animation

The bent-path escape language is now part of the slice foundation.

The user manually verified that a corner path:

1. moves head-first;
2. pulls the body through its existing bend;
3. keeps the visible bend until the tail reaches it;
4. becomes straight;
5. exits as a straight path.

Do not regress to rigid L-shape translation.

See `SNAKE_ESCAPE_ANIMATION.md`.

## Difficulty philosophy

Difficulty must come from **understandable dependency reading**, not from:

- misleading arrowheads;
- tiny paths;
- ambiguous taps;
- unnecessary visual clutter;
- random numbers of pieces;
- hidden rules.

A good harder level makes the player stop and inspect the board, then feel confident when the chosen path escapes.

## Next verification sequence

1. Run parser scan on the current head.
2. Run ordered-path geometry tests; expected `7/7`.
3. Run movement validator and level-data validator.
4. Run vertical-slice tests; expected `7/7` with Level 4 = 15 solutions and Level 5 = 10 solutions.
5. Play Level 4 three times and record time/mistakes/hints.
6. Play Level 5 three times and record time/mistakes/hints.
7. Give tuned Levels 4–5 to at least one player without explaining the solution.
8. Keep the layouts only if the extra time comes from reasoning rather than confusion.
9. Proceed to Android phone/tablet verification.

## Approval rule

Do not approve the slice merely because the solver passes. Levels 4–5 must also hit the intended emotional rhythm:

```text
read → decide → satisfying escape → board changes → read again
```

The vertical slice remains open until the tuned levels and Android QA pass.
