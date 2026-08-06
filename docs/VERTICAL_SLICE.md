# Pathbreak Vertical Slice

## Objective

Produce five consecutive levels that define the final quality bar for Pathbreak before expanding to 75 levels.

The slice must prove:

- the puzzle is clear and satisfying on a real Android device;
- touch selection is precise and fair;
- the light-mode visual system remains readable on phones and tablets;
- pause, failure, completion, saving, audio, haptics, and accessibility settings work together;
- level data can be validated before it reaches players.

## Current assumptions

- Godot 4.7.1 and typed GDScript.
- Android portrait is the primary target.
- Gameplay remains offline and backend-free.
- JSON is the canonical production level format.
- The modular stack under `scenes/game/` and `scripts/gameplay/` is the only supported gameplay architecture.
- Monetization is excluded from the vertical slice.

## Slice content

### Level 1 — Learn the exit rule

- Two or three paths.
- At least two clearly available moves.
- Valid paths may pulse until the tutorial is completed.
- No long instructional paragraph.

### Level 2 — Understand blockers

- Introduce one obvious blocked path.
- The player should understand the red shake and life loss without additional explanation.

### Level 3 — Read a bend

- Introduce a bent path.
- Keep the board spacious and avoid overlapping touch zones.

### Level 4 — Choose between valid moves

- Multiple valid openings.
- The order changes the visual rhythm but does not create an impossible state.

### Level 5 — Representative challenge

- Denser board using only mechanics already taught.
- Target completion time: 45–90 seconds for a new player.
- Must demonstrate final-quality sound, haptics, transitions, and result presentation.

## Quality requirements

### Controls

- Nearest-path selection is used instead of independent overlapping collision areas.
- The physical tap allowance remains usable when the board scales.
- A tap outside the acceptance radius causes no penalty.
- Rapid repeated taps cannot remove multiple lives or corrupt occupancy.

### Visuals

- Warm off-white canvas, white board card, navy paths, blue success and hint accent, coral error feedback.
- Board scales to available space without entering the header or bottom controls.
- High-contrast mode updates paths and grid dots.
- Reduce-motion mode removes idle pulsing and shortens transitions.

### Game flow

- Main menu → level select or continue → gameplay → result/failure → next/retry/menu.
- Settings pauses gameplay.
- Android/system back opens or closes pause during gameplay.
- Saving survives application restart.

### Metrics

Track independently in local state now and analytics later:

- moves;
- mistakes;
- hints used;
- completion time;
- stars;
- best moves;
- best mistakes;
- best completion time.

## Test matrix

- 360 × 800 phone
- 393 × 873 phone
- 412 × 915 phone
- 800 × 1280 tablet
- 1200 × 1920 tablet
- mouse input in editor
- touch input on at least one Android phone and one Android tablet
- sound on/off
- haptics on/off
- reduce motion on/off
- high contrast on/off
- app background and resume
- Android back button
- corrupt save fallback

## Definition of done

- [ ] Project opens in Godot 4.7.1 without parser errors.
- [ ] Existing movement validator tests pass.
- [ ] Level data validator tests pass.
- [ ] Levels 1–5 pass schema and solvability validation.
- [ ] No duplicated legacy gameplay scene or manager remains.
- [ ] No valid move is revealed outside the tutorial unless the player spends a hint.
- [ ] Pause and settings work without gameplay input leaking through.
- [ ] Moves and mistakes are reported separately.
- [ ] Five levels are manually tested on Android.
- [ ] No known progress-loss, soft-lock, or touch-ambiguity bug remains.

## Next production gate

Do not begin mass level production until this slice passes the complete test matrix. After approval, build the new level editor and solver, then expand content in reviewed packs rather than creating 75 levels manually in code.
