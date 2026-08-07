# Pathbreak — Satisfaction Prototype v1

**Status:** Director-reviewed; answer-revealing cue rejected, remaining feel work retained for verification  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/satisfaction-prototype-v1`  
**Base:** `codex/vertical-slice-level-review`

## Purpose

Test whether Pathbreak can become more satisfying to play and watch without weakening the puzzle itself.

Core rule:

> **Clarity first, satisfaction second, spectacle third.**

A second rule is now locked from the first director playtest:

> **The game must not automatically identify the next correct path. Solution-revealing assistance belongs to the explicit Hint system.**

## Director finding — newly-freed path cue REJECTED

The first prototype highlighted a path when it changed from blocked to escapable. Although the causal effect was readable, the director found that it effectively gave away the next answer.

That creates three product problems:

1. it weakens the player's need to inspect the board;
2. it reduces the value and purpose of the Hint button;
3. it turns satisfying feedback into passive guidance rather than earned discovery.

Therefore the automatic newly-freed visual pulse and unlock audio are rejected as normal gameplay behavior.

### Current implementation state

`BoardManager` still contains the dependency-state detection helpers because they may later be useful for:

- level-editor analysis;
- difficulty metrics;
- automated tests;
- internal debugging.

However `play_newly_freed_feedback(...)` now deliberately returns `0` and performs no presentation. The coordinator may still calculate the state during this prototype branch, but the player receives no automatic visual or audio answer reveal.

`AudioManager.play_unlock_sound()` is temporarily a no-op while the prototype coordinator hook is cleaned up after verification.

No level data, solver rule, occupancy rule, movement rule, hint count, or difficulty changed.

## What remains accepted from Satisfaction Prototype v1

### 1. Existing living-path release

The accepted snake/uncoil motion remains the primary satisfying event:

```text
player chooses a path
→ path activates
→ head leads
→ body follows through its corners
→ path straightens
→ path exits
```

This rewards the player's own decision without revealing another decision.

### 2. Blocked-path resistance

Blocked taps keep their restrained recoil, sound, haptic, and life/mistake consequence. The feedback communicates resistance without solving anything for the player.

### 3. Completion settle

The small board settle after the final automatic clear remains in the prototype.

Normal motion:

```text
last path escapes
→ tiny board compress/release
→ neutral scale
→ result screen
```

Reduce Motion skips this scale animation and uses the shorter result transition.

### 4. Existing explicit hints

Hints remain the intentional answer-revealing mechanic.

The distinction is now:

```text
Normal gameplay
= player reads the board and discovers what became possible

Hint
= player explicitly asks the game to identify an escapable path
```

This separation must remain clear in future feel work and monetization design.

## Revised satisfaction design rule

Future satisfaction effects may react to:

- the path the player actually tapped;
- the path currently escaping;
- the whole board after a meaningful event;
- the final completion state;
- non-directional environmental/material responses.

Future satisfaction effects must **not** automatically single out:

- the next correct path;
- a newly escapable path;
- the best branch;
- the intended solution order.

Unless the user explicitly activates a Hint, the player owns the discovery.

## Better replacement directions

Instead of highlighting the answer, future prototypes should explore non-spoiling satisfaction such as:

1. **Release Polish v2** — improve activation timing, path material response, and snake exit feel on the path the player already chose.
2. **Board tension release** — a tiny board-wide response after a successful removal, with no specific remaining path highlighted.
3. **Path trail/material wake** — a short restrained effect behind the escaping path only.
4. **Completion Finish v2** — improve the final mechanism finish without delaying the result screen.
5. **Audio/haptic identity** — richer feedback attached to player actions, not hidden solution state.

## Verification

Pull the branch:

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/satisfaction-prototype-v1
git pull origin codex/satisfaction-prototype-v1
```

Run the normal regression suite before merging any part of this prototype.

Manual acceptance now focuses on:

- no remaining path is highlighted merely because it became escapable;
- no unlock sound reveals a newly available answer;
- Hint still has a clear purpose;
- snake release remains satisfying;
- completion settle remains subtle;
- puzzle readability is unchanged;
- Reduce Motion and High Contrast remain correct;
- Android portrait behavior remains correct.

## Director decision

**Rejected:** automatic blocked → escapable path acknowledgement in normal play.

**Keep testing:** player-action release polish, snake motion, completion settle, audio/haptic feel attached to explicit player actions.

This is an important product constraint for Pathbreak: satisfaction should reward reasoning, not replace it.
