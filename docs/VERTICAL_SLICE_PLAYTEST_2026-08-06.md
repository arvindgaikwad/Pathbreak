# Pathbreak — Vertical Slice Playtest Evidence

**Evidence window:** 2026-08-06 to 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## Current status

The ordered-path correction is accepted as the gameplay foundation.

The user has confirmed:

- Gate 1 parser/automated verification passed for the ordered-arrow correction.
- Gate 2 movement regression passed.
- Gate 3 new-player comprehension passed.
- The corrected arrowheads are visually much better.
- The final snake-style corner escape animation is working as intended.
- Tuned Levels 4 and 5 each take roughly **30–40 seconds** for two tested players.

The latest difficulty evidence is strong enough to stop tuning Levels 4–5 for now. Do not make them harder merely to increase duration.

## Early playtest evidence

### Main Menu

New players initially did not know where to start and sometimes tapped the decorative demonstration arrows.

Response implemented and later verified:

- the board itself starts the recommended level;
- Start/Continue starts the same level;
- the board has a travelling direction cue;
- clean-save state explicitly says `Start Level 1`.

### Core rule readability

Initial players:

- understood Level 2 blocking;
- understood Level 3 bent-path reading;
- struggled with the old arrowhead/tail-dot language.

The renderer was subsequently rebuilt around ordered paths:

```text
tail → ... → head
final segment = head direction = movement direction
```

Representative screenshots of Levels 2 and 5 were accepted by the user as much better.

### Tutorial and hints

Verified:

- clean-save Level 1 shows `FREE`;
- Level 2 starts with five normal hints;
- replaying Level 1 uses the real persistent hint count;
- hint refill works;
- `No path can leave yet` feedback is useful and should remain.

### Final path

New players did not want to tap the last obvious path manually.

Implemented and verified:

- final valid path previews and clears automatically;
- the automatic clear does not add a Move.

## Snake-style corner motion

The first attempt was rejected because a bent L could visually appear to translate rather than uncoil.

The corrected implementation was then tested by the user and described as working perfectly.

Accepted motion:

```text
head advances
→ tail follows original path
→ bend travels through body
→ body becomes straight
→ straight path exits
```

Do not regress to rigid L translation or diagonal corner cutting.

See `SNAKE_ESCAPE_ANIMATION.md`.

## Difficulty evidence before tuning

Earlier builds were enjoyable but too easy:

- typical early levels were around 10 seconds;
- zero mistakes were common;
- returning tester Level 4: 7 seconds, 10 moves, 2 mistakes;
- returning tester Level 5: 16 seconds, 8 moves, 0 mistakes;
- hints were mainly needed on Levels 9–10.

The problem was not rule confusion after the arrow correction. It was insufficient dependency depth.

## Level 4 tuning — timing accepted

Current structure:

- 8×8 board;
- 9 pieces;
- 6 bent paths;
- 2 opening moves;
- both openings reveal different next moves;
- 15 full-clear solution orders.

Encoded branch expectations:

```text
start → [1, 5]
after 1 → [4, 5]
after 5 → [1, 7]
```

Original director target was **20–35 seconds** for a first-time player.

Latest evidence:

- tested on two people;
- completion time was roughly **30–40 seconds**;
- overall play was reported as good.

**Decision:** accept this timing range for the slice. The small amount above the original 35-second upper target does not justify another redesign without evidence of confusion or frustration.

## Level 5 tuning — timing accepted

Current structure:

- 8×8 board;
- 10 pieces;
- 5 bent paths;
- 1 opening move;
- staged forced dependency reading before the first branch;
- 10 full-clear solution orders.

Encoded early sequence:

```text
start → [5]
after 5 → [6]
after 5,6 → [9]
after 5,6,9 → [7]
after 5,6,9,7 → [4]
after 5,6,9,7,4 → [2, 8]
```

Director target was **30–45 seconds** for a first-time player.

Latest evidence:

- tested on two people;
- completion time was roughly **30–40 seconds**;
- overall play was reported as good.

**Decision:** the current Level 5 timing lands inside the intended range. Do not increase difficulty for the vertical slice.

## Current evidence boundary

The two-person timing pass is enough to stop level tuning for now, but the report does not include exact per-player moves, mistakes, hints, or written qualitative notes. Those metrics can be collected later during broader closed testing instead of blocking current platform QA.

Because shared animation and Level 4–5 data changed after earlier automation runs, the current branch should still receive one final parser/test rerun before the vertical slice is considered regression-closed.

## Next evidence required

1. Final parser/test rerun on the current head.
2. Android phone verification.
3. Android tablet verification.
4. High Contrast and Reduce Motion regression on device.
5. Sound/Haptics persistence after app restart.
6. Main-menu compact-phone/tablet layout closure.

## Director decision

Levels 1–5 are now good enough to freeze for the vertical slice unless a regression appears.

The next phase is not more difficulty tuning. It is **platform and accessibility closure**:

```text
final automated regression
→ Android phone
→ Android tablet
→ accessibility/settings
→ approve vertical slice
```
