# Pathbreak — Project Handoff and Continuation Guide

**Status:** Current project recovery document  
**Last reviewed:** 2026-08-07  
**Repository:** `arvindgaikwad/Pathbreak`  
**Active branch:** `codex/vertical-slice-level-review`  
**Active draft PR:** `#8 — Direct and approve the Pathbreak vertical slice`

Use this document to continue the project if the current chat is lost. Read it together with `TASKS.md`, `docs/README.md`, `docs/DECISIONS.md`, and the latest playtest record.

## 1. Product summary

Pathbreak is an original portrait puzzle game for Android built in Godot 4.7.1. The player taps directional paths in an order that lets each path escape the board without colliding with another path.

The current goal is not to build a large number of levels. The current production gate is a complete, tested vertical slice that proves the gameplay, tutorial, controls, connected menus, accessibility, persistence, level quality, and Android behaviour.

## 2. Current production state

### Confirmed working from user testing

- Main Menu launches the game and recommends the first uncleared unlocked level.
- Tapping the animated menu board opens the recommended level.
- The normal Start/Continue button opens the same recommended level.
- The travelling blue menu animation plays.
- Level Select, Levels 1–10, progression, failure, retry, result, Replay, and Next Level function.
- Nearest-path touch selection works better than overlapping per-piece hit areas.
- Hint depletion works.
- A hint moves the blue directional marker toward the arrowhead.
- Zero hints display `+3 / Refill`.
- Hint refill popup opens after the native full-card button correction.
- Refill restores three hints.
- Restart works after the native-button correction.
- The final remaining valid path clears automatically.
- Automatic final clear does not add a player Move.
- Reduce Motion alternatives work for the menu, hint, and automatic final clear.
- `No path can leave yet` is useful and liked by testers.
- Level 2 communicates blocking.
- Level 3 communicates bent-path reading.
- New players enjoyed the puzzle interaction.

### Still pending verification

- Exact current parser output and all three automated test-suite outputs.
- Fresh-save Level 1 `FREE` hint behaviour.
- Rapid-tap double-navigation resistance.
- Revised arrowhead/tail-dot comprehension with new players.
- High Contrast regression.
- Sound and Haptics persistence after application restart.
- Android phone/tablet touch, Back, lifecycle, performance, sound, and haptic checks.

## 3. Current game-director findings

### Positive evidence

- The core mechanic is enjoyable.
- Early teaching goals are understandable once the player reaches gameplay.
- Levels 9–10 create enough uncertainty that testers used hints.
- Players liked direct feedback such as `No path can leave yet`.
- The menu-board play target and automatic final clear are manually functional.
- The revised directional cue is manually functional.

### Current blockers

1. Formal parser and automated test evidence is not recorded for the latest branch head.
2. Fresh-save Level 1 `FREE` hint state is still unverified.
3. Revised arrowhead and tail-dot comprehension still needs no-explanation player evidence.
4. Early levels were completed in roughly 10 seconds with zero mistakes.
5. High Contrast and persistence regressions remain incomplete.
6. Android phone/tablet lifecycle and touch checks are incomplete.

### Director decisions

- Keep the core puzzle rule.
- Improve readability before increasing difficulty.
- Keep `No path can leave yet`.
- Keep automatic final clear because the local behaviour works and removes a redundant action.
- Keep the menu board as a valid start target.
- Do not implement the raw AI mockup directly.
- Final UI should combine the current build's clarity with the concept images' stronger hierarchy.
- Avoid AI-slop traits: excessive glow, decorative sparkles, oversized typography, repeated white cards, generic SaaS layout, and unnecessary labels.
- Keep four columns on Level Select for compact Android phones.
- Final art direction remains deferred until the vertical slice passes.

## 4. UI direction to preserve

### Main Menu

- Clear Start/Continue action within one second.
- Tapping the hero board and pressing the primary button must open the same recommended level.
- Hero board may be slightly larger, but must fit 360×800.
- Place the tap instruction below the board without overlapping paths.
- Use a restrained travelling pulse rather than glow and sparkles.
- Keep Levels and How to Play as secondary actions.
- Reduce unused lower-screen space through better vertical composition.

### Level Select

Keep a four-column layout.

Required states:

- **Completed:** navy number, amber stars, quiet white card.
- **Current:** blue outline/tint, stronger number, visible current/play state.
- **Unlocked:** navy number, no earned stars.
- **Locked:** lower contrast and a small lock icon.
- **Perfect:** three clearly filled stars; optional restrained gold emphasis.

The screen must clearly answer: `Which level should I play next?`

Do not copy the generated concept's five-column grid, excessive shadows, repeated `CLEARED/LOCKED` labels, or oversized progress card.

## 5. Architecture that must be preserved

- Godot 4.7.1.
- Typed GDScript.
- Android portrait target.
- Modular gameplay stack:
  - `scenes/game/game_screen.tscn`
  - `scripts/gameplay/level_manager.gd`
  - `scripts/gameplay/board_manager.gd`
  - `scripts/gameplay/puzzle_piece.gd`
- JSON-first level loading from `data/levelN.json`.
- `.tres` is fallback only.
- Pure movement validation through `MovementValidator`.
- Reusable `LevelSolver` and headless tests.
- Central nearest-path touch selection.
- `SaveManager` for progress and persistent hints.
- `SettingsManager` for Sound, Haptics, Reduce Motion, and High Contrast.
- Main Menu remains the project startup scene.

Do not reintroduce the removed legacy `Main.tscn`, duplicate `PuzzlePiece.tscn`, monolithic `GameManager.gd`, or duplicate gameplay architecture.

## 6. Immediate next actions

Follow `TASKS.md` in priority order. The current immediate sequence is:

1. Pull the active branch.
2. Run the Godot parser scan.
3. Run all three automated test suites and record exact output.
4. Back up and remove the save.
5. Verify the fresh-save Main Menu and Level 1 `FREE` hint flow.
6. Verify rapid taps, prompt placement, High Contrast, Sound persistence, and Haptics persistence.
7. Repeat no-explanation testing with new players using the revised path visuals.
8. Tune Levels 4–5 only after visual comprehension improves.
9. Test Android phone and tablet.
10. Approve or reject the vertical slice.

## 7. Local paths and commands

Godot binary:

```bash
/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64
```

Project:

```bash
/home/silver/Downloads/godot games /projects/arrow puzzle
```

Pull current work:

```bash
cd "/home/silver/Downloads/godot games /projects/arrow puzzle"
git fetch origin
git switch codex/vertical-slice-level-review
git pull origin codex/vertical-slice-level-review
```

Run parser and tests:

```bash
GODOT="/home/silver/Downloads/godot games /Godot_v4.7.1-stable_linux.x86_64"

"$GODOT" --headless --path . --editor --quit
"$GODOT" --headless --path . --script tests/test_movement_validator.gd
"$GODOT" --headless --path . --script tests/test_level_data_validator.gd
"$GODOT" --headless --path . --script tests/test_vertical_slice_levels.gd
```

Start the complete game with **F5**, not F6.

## 8. Fresh-save tutorial test

Back up and remove the save before the clean tutorial test:

```bash
SAVE="$HOME/.local/share/godot/app_userdata/Pathbreak/save.json"
mkdir -p "$HOME/.local/share/godot/app_userdata/Pathbreak"
cp "$SAVE" "$SAVE.backup" 2>/dev/null || true
rm -f "$SAVE"
```

Verify:

- Menu shows a new-player Start state.
- Level 1 displays `FREE`.
- The free hint highlights a valid path.
- It does not consume the persistent normal hint bank.
- Completing Level 1 marks the tutorial complete.
- Replaying Level 1 shows the real hint count.

Restore the previous save after testing when needed:

```bash
cp "$SAVE.backup" "$SAVE" 2>/dev/null || true
```

## 9. Vertical-slice exit criteria

The slice is not approved until:

- Parser scan has zero errors and no new warnings.
- Automated tests pass.
- Menu start hierarchy works without explanation.
- Arrow direction is understood by new players.
- Hint/refill/restart/pause/navigation/save flows work.
- Automatic final clear feels clear and counts correctly.
- Reduce Motion and High Contrast work.
- Levels 1–5 pass director review.
- At least three new players provide recorded evidence.
- Android phone and tablet checks pass.
- Remaining defects are documented and prioritised.

## 10. Work after vertical-slice approval

### Milestone 2 — Level-production tools

- Modular level editor.
- Schema validation.
- Solver integration.
- Opening-move and solution-count analysis.
- Dead-end detection.
- Difficulty measurements.
- Playtest notes.
- Versioned JSON export.
- Batch testing.

### Milestone 3 — Launch content

- Produce and test the launch level pack only after the tools are reliable.
- Build a measured difficulty curve rather than relying on labels or visual busyness.

### Milestone 4 — Final art and audio

- Final logo and app icon.
- Ownable visual motif.
- Final typography and iconography.
- Refined main menu and Level Select.
- Gameplay feedback, particles, transitions, sound, and music direction.
- Store presentation.

### Milestone 5 — Commercial launch systems

- Analytics and crash reporting.
- Privacy and consent.
- Google Play configuration and closed testing.
- Rewarded hints and optional remove-ads purchase only after retention validation.

## 11. New-conversation continuation prompt

Copy this into a new ChatGPT/Codex conversation:

```text
Continue development of my Godot project Pathbreak in GitHub repository arvindgaikwad/Pathbreak.

First read these files on branch codex/vertical-slice-level-review:
1. docs/PROJECT_HANDOFF.md
2. TASKS.md
3. docs/README.md
4. docs/DECISIONS.md
5. docs/AI_ANTI_SLOP_STANDARD.md
6. docs/VERTICAL_SLICE_PLAYTEST_2026-08-06.md
7. docs/TESTING_CHECKLIST.md

The active draft is PR #8. Do not merge it yet. Preserve the modular JSON-first architecture. Treat untested changes as unverified. Continue from the first incomplete P0 task in TASKS.md and update the documents whenever behaviour or decisions change.
```
