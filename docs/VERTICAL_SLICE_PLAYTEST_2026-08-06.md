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

After those approvals, Levels 4–5 were tuned for greater decision depth. Those new layouts now require a fresh parser/solver/playtest pass.

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

## Level 4 tuning — implemented, pending verification

Previous Level 4 behaved mostly like one forced chain plus an almost-independent second opening.

New target structure:

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

Director target: **20–35 seconds** for a first-time player, with time spent re-reading dependencies rather than fighting the UI.

## Level 5 tuning — implemented, pending verification

Previous Level 5 had 8 pieces and was still cleared too quickly.

New target structure:

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

Director target: **30–45 seconds** for a first-time player.

## Next evidence required

Run the current branch after the Level 4–5 changes and record:

1. parser scan result;
2. ordered geometry result, expected `7/7`;
3. movement validator result;
4. level-data validator result;
5. vertical-slice result, expected `7/7`;
6. Level 4 completion time, moves, mistakes, hints;
7. Level 5 completion time, moves, mistakes, hints;
8. whether either board feels confusing rather than thoughtful;
9. whether snake motion remains correct on the new bent paths;
10. one no-explanation player attempt on the tuned Levels 4–5.

## Director decision rule

Keep the new layouts only when the increased duration comes from:

```text
read → decide → satisfying escape → board changes → read again
```

Reject or simplify them if the extra time comes from tiny paths, ambiguous taps, unclear direction, or visual clutter.

Android phone/tablet QA remains the final major slice gate after the tuned difficulty pass.
