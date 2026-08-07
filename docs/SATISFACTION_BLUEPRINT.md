# Pathbreak — Satisfaction and Differentiation Blueprint

**Status:** Approved product direction; implementation starts after vertical-slice closure  
**Last reviewed:** 2026-08-07  
**Branch:** `codex/vertical-slice-level-review`

## 1. Product position

Pathbreak must not compete as “another arrow puzzle with different art.” Its ownable direction is:

> **A calm logic puzzle where correct decisions visibly release tension from living paths.**

The desired player reaction is not only “I solved it.” It is:

> **I understood the dependency, I released it, and watching the board unravel felt satisfying.**

This creates a distinct product promise:

- logic remains primary;
- path motion becomes the signature presentation;
- successful decisions create visible release and chain reactions;
- controls feel precise and fair;
- effects are restrained enough that the player always understands what changed.

Working category phrase:

> **The satisfying living-path puzzle.**

This phrase is internal positioning, not final store copy.

---

## 2. Four satisfaction pillars

### Pillar A — Release

Every valid move should feel like tension leaving a mechanism.

Required qualities:

- immediate acknowledgement on tap;
- path visibly activates before escape;
- head leads movement;
- body follows cleanly;
- board feels calmer after removal;
- no unnecessary pause between decision and payoff.

The accepted snake-uncoil motion is the foundation for this pillar.

### Pillar B — Flow

Paths should feel alive rather than like rigid UI primitives.

Required qualities:

- bent paths feed through their own corners;
- body motion preserves readable geometry;
- straight paths remain clean and fast;
- the player can visually track cause and effect;
- no diagonal corner cutting or rubbery distortion that hides the intended path.

### Pillar C — Clarity

Satisfaction is invalid if the player cannot explain why a move worked.

Required qualities:

- head and tail remain unmistakable;
- blocked versus escapable state is readable;
- newly available paths are signalled without revealing the full solution;
- no effect obscures neighbouring paths;
- color is reinforcement, not the only information channel;
- motion never changes the gameplay truth.

Rule:

> **Clarity first, satisfaction second, spectacle third.**

### Pillar D — Unravel

The board should often produce a satisfying sequence:

```text
read
→ choose
→ release
→ board changes
→ notice new opportunity
→ choose again
```

The game should create “unravelling” rather than a collection of independent taps.

Level design should therefore favour meaningful dependency reveals over visual busyness.

---

## 3. Signature Pathbreak feel language

### 3.1 Successful path release

Target sequence:

```text
Tap
→ 40–80 ms tactile acknowledgement
→ restrained accent activation
→ snake/straight escape
→ short clean trail or material response
→ board settles
```

The escape path itself remains the visual hero.

Do not add fireworks, confetti, sparkles, screen shake, or particle noise to ordinary moves.

### 3.2 Newly freed path feedback

When one move causes another previously blocked path to become escapable, Pathbreak may acknowledge that change.

Preferred treatment:

- one soft pulse or brightness lift;
- optional subtle material “relax” motion;
- no persistent glowing outline;
- no automatic selection;
- no flashing every currently valid move repeatedly.

Purpose:

> Let the player feel the dependency they just changed without solving the board for them.

### 3.3 Blocked tap

A blocked tap should communicate resistance, not punishment.

Target response:

- small directional recoil;
- brief error tone;
- distinct but restrained haptic;
- existing life/mistake consequence remains visible;
- no aggressive red full-screen flash.

### 3.4 Final clear

The final path is already automatically cleared. Its presentation should feel like the mechanism finishing itself.

Target sequence:

```text
Second-last meaningful decision
→ last path becomes obviously free
→ short final-clear preview
→ clean automatic escape
→ board settles
→ completion response
```

The completion treatment should be stronger than a normal move but still consistent with Pathbreak’s calm tone.

### 3.5 Board settle

After a meaningful chain or final clear, the board may use a very small settle response:

- restrained scale or luminance pulse;
- no camera shake;
- no UI bounce unrelated to gameplay;
- duration short enough that the next decision is never delayed.

---

## 4. Material and visual direction

Pathbreak should borrow the *qualities* of satisfying 3D animation without becoming a fully 3D physics toy.

Desired qualities:

- clean thickness;
- subtle depth separation from the board;
- soft highlight/shadow when useful;
- consistent rounded geometry;
- precise movement;
- polished surfaces rather than flat placeholder strokes.

Avoid:

- fake plastic gloss everywhere;
- candy-game saturation;
- random material changes per level;
- excessive bloom;
- glassmorphism;
- generic neon cyberpunk treatment;
- particle-heavy mobile-game feedback.

The current programmatic path renderer remains the base. Final material treatment should preserve programmatic scalability and Android performance.

---

## 5. Motion rules

### Timing hierarchy

Ordinary move:
- fast acknowledgement;
- satisfying escape;
- player regains reading control quickly.

Blocked move:
- shorter than a successful move;
- never locks the board unnecessarily.

Final clear:
- slightly longer than ordinary move;
- completion transition begins only after the escape is readable.

### Motion character

Preferred:

- ease-in for tension release;
- smooth follow-through;
- little or no overshoot;
- exact corners;
- body-length preservation during snake motion;
- subtle acceleration as a path leaves the board.

Rejected:

- springy cartoon wobble on every path;
- exaggerated squash/stretch;
- random rotations;
- camera shake;
- slow cinematic delays.

Reduce Motion must keep gameplay readable using static accent treatment and the simpler short translation/fade.

---

## 6. Audio identity

Audio should reinforce mechanical release, not imitate casino reward sounds.

### Successful move

Desired family:

- clean soft click/tick at activation;
- short airy or tonal release as the path escapes;
- pitch may subtly vary by path length or chain position, but variation must remain controlled.

### Blocked move

- muted resistant tap;
- lower/shorter than success;
- no harsh buzzer.

### Newly freed path

Optional very quiet “unlock” tick only if it improves comprehension during testing.

### Completion

- compact resolving motif;
- should sound finished rather than celebratory-chaotic;
- avoid slot-machine arpeggios.

Production audio is deferred until the satisfaction prototype proves which moments need sound.

---

## 7. Haptic language

Haptics should mirror the event hierarchy.

- successful ordinary move: light crisp pulse;
- blocked move: firmer distinct pulse;
- newly freed path: normally no haptic, unless testing proves useful;
- final automatic clear: light pulse;
- level completion: short restrained celebration pattern.

Haptics must remain optional and respect the existing toggle.

---

## 8. Clip-worthy gameplay moments

Pathbreak should naturally produce short moments that are enjoyable even to a viewer who is not playing.

### Clip A — Bent-path uncoil

A compact L/Z-like path becomes free and visibly snakes through its corner before leaving.

### Clip B — Dependency reveal

One path exits and a previously blocked path gives a restrained “now free” response.

### Clip C — Elegant sequence

A player clears several paths in a readable dependency order and the board progressively opens.

### Clip D — Impossible-looking board → clean solution

A visually dense but readable board becomes simple through a short correct sequence.

### Clip E — Final mechanism finish

The player makes the last meaningful decision; the final path clears itself and the board resolves.

Marketing principle:

> The game should produce good footage because the gameplay feels good, not because a separate ad animation fakes the experience.

---

## 9. Satisfaction Prototype v1

This is the next creative/game-feel milestone **after the remaining vertical-slice platform/accessibility gates close** and **before mass level production or final UI art**.

### Prototype scope

Implement only these five systems:

1. **Release Polish v2**
   - preserve accepted snake-uncoil geometry;
   - improve activation/readability/timing;
   - optional subtle trail/material response;
   - no gameplay-rule change.

2. **Newly Freed Path Feedback**
   - board compares escapable state before and after a successful removal;
   - only paths that changed from blocked → escapable receive one restrained acknowledgement;
   - never repeatedly pulse all available paths.

3. **Chain/Opportunity Feedback**
   - test whether successive releases create a readable “unravel” rhythm;
   - do not auto-play the solution.

4. **Completion Finish v1**
   - improve final automatic clear and post-board settle;
   - keep result UI timing responsive.

5. **Audio/Haptic Prototype Pack**
   - one success sound;
   - one blocked sound;
   - one completion sound;
   - existing haptic hierarchy reviewed against the new motion.

### Explicitly out of scope

- final logo;
- final menus;
- chapter artwork;
- monetization;
- accounts/backend;
- large particle systems;
- 100-level content production;
- replacing the existing deterministic puzzle rules;
- adding physics-based randomness.

---

## 10. Technical implementation priorities

### Priority 1 — State transition detection

Add a board-level helper capable of determining which remaining pieces changed from:

```text
blocked → escapable
```

after a successful move.

This should reuse `MovementValidator` / board escape checks rather than create a second gameplay truth.

### Priority 2 — Presentation-only event

Emit or call a presentation event for newly freed pieces.

Suggested responsibility split:

```text
BoardManager
  computes gameplay state change

PuzzlePiece
  renders one-shot freed feedback

LevelManager
  coordinates timing / final clear
```

Do not move rule logic into animation code.

### Priority 3 — Release presentation API

Keep successful escape logic callable through one shared `PuzzlePiece` presentation path. Avoid special per-level effects.

### Priority 4 — Accessibility parity

Every new motion effect must have:

- Reduce Motion behaviour;
- High Contrast readability;
- no color-only meaning.

### Priority 5 — Performance budget

The system should remain comfortable on the already-tested Samsung Galaxy Tab S6 Lite and lower-end Android phones.

Prefer:

- Line2D/Polygon2D updates;
- small one-shot tweens;
- no large persistent particle counts;
- no per-frame allocations when avoidable.

---

## 11. Prototype acceptance test

Test the same prototype with at least three people who have not been coached on the new feedback.

Ask only after they play:

1. Which move felt best?
2. Did you notice when a path became newly available?
3. Did any animation make the puzzle harder to read?
4. Did the game feel satisfying to watch as well as play?
5. Would you watch another short clip of a board solving/unravelling?

Record:

- level;
- completion time;
- mistakes;
- hints;
- whether newly freed feedback was noticed;
- whether it was helpful, neutral, or distracting;
- strongest satisfying moment;
- any motion that felt slow or excessive.

### Pass criteria

Keep the prototype only if:

- direction comprehension does not regress;
- newly freed feedback is noticed without feeling like an auto-hint;
- no tester reports that effects obscure blockers or paths;
- successful moves feel more rewarding than the current slice;
- the game remains responsive;
- Reduce Motion remains understandable;
- Android performance remains smooth.

If feedback is visually impressive but makes solving less clear, reject it.

---

## 12. Social proof experiment

After the prototype passes gameplay testing, capture 5–10 second real gameplay clips from three boards:

1. best bent-path uncoil;
2. best dependency reveal;
3. best final clear/unravel sequence.

No fake ad-only mechanics.

Internal evaluation questions:

- Is the action understandable without narration?
- Does something visually satisfying happen within the first 1–2 seconds?
- Is the result recognisably Pathbreak rather than generic mobile-game footage?
- Does the clip make the viewer want to see the next release?

This is an identity test, not yet a paid marketing campaign.

---

## 13. Production order after this decision

```text
Finish vertical-slice platform/accessibility QA
→ Approve vertical slice
→ Satisfaction Prototype v1
→ Three-person satisfaction/readability test
→ Capture real gameplay clips
→ Lock Pathbreak feel language
→ Build Production Level Studio
→ Produce first 20 polished levels
→ Wider playtest
→ Final UI/art/audio identity
→ Scale content
→ Retention/monetization
→ Google Play launch preparation
```

This intentionally places the satisfaction prototype before mass content production, because the level-production system should eventually preview and support the final Pathbreak feel language rather than generate content for a temporary presentation layer.
