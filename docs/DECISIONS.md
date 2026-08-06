# Pathbreak — Architecture and Product Decision Log

**Last reviewed:** 2026-08-07  
**Scope:** Current vertical-slice branch. Later decisions should be appended rather than silently replacing old ones.

## Record 001 — Typed runtime level data

- **Status:** Active
- **Decision:** Gameplay uses typed `PuzzleLevelData` and `PuzzlePieceData` objects at runtime.
- **Clarification:** JSON is the canonical authored format. The loader converts validated JSON into these typed runtime objects. Existing `.tres` files are fallback material, not the primary source of truth.
- **Reason:** Gameplay code remains typed and testable while authored data stays easy to diff, generate, validate, and migrate.

## Record 002 — Pure movement validation

- **Status:** Active
- **Decision:** Keep escape checking in the static `MovementValidator` helper with headless tests.
- **Reason:** The core rule remains deterministic and independent from physics, animation, or frame timing.

## Record 003 — Programmatic path rendering

- **Status:** Active
- **Decision:** Render paths, arrowheads, tail dots, highlights, trails, and feedback programmatically.
- **Reason:** The presentation remains sharp across Android resolutions, compact in the repository, themeable, and independent from copied art assets.

## Record 004 — One modular gameplay architecture

- **Status:** Active
- **Decision:** Support the modular stack centered on:
  - `scenes/game/game_screen.tscn`
  - `scripts/gameplay/level_manager.gd`
  - `scripts/gameplay/board_manager.gd`
  - `scripts/gameplay/puzzle_piece.gd`
- **Reason:** Duplicate monolithic and modular implementations caused agents to edit the wrong files and created conflicting behavior.

## Record 005 — JSON is the canonical level format

- **Status:** Active
- **Decision:** Load `data/levelN.json` first. Treat `.tres` definitions as temporary fallback until migration is complete.
- **Reason:** JSON supports reviewable diffs, external generation, validation, migration, and a future internal level editor.

## Record 006 — Central nearest-path touch selection

- **Status:** Active
- **Decision:** The board receives input and chooses the nearest eligible path inside a scale-adjusted acceptance radius.
- **Reason:** Independent enlarged hit areas can overlap and select the wrong path. Central selection is deterministic and fair on phones and tablets.

## Record 007 — Settings persist separately from progression

- **Status:** Active
- **Decision:** Sound, haptics, Reduce Motion, and High Contrast use `SettingsManager` and a dedicated settings file.
- **Reason:** Accessibility and presentation settings can evolve independently from level progress and recover safely from invalid data.

## Record 008 — The five-level vertical slice is the production quality gate

- **Status:** Active
- **Decision:** Approve five representative levels on real devices before building the level editor or producing the full content pack.
- **Reason:** Expanding to dozens of levels before controls, tutorial clarity, feedback, UI, and difficulty are approved would multiply rework.

## Record 009 — Save data has an explicit version

- **Status:** Active
- **Decision:** Progress is stored through `SaveManager` with `SAVE_VERSION`, safe defaults, clamped values, and per-level dictionaries.
- **Reason:** Save migrations and corruption recovery must be possible before public release.

## Record 010 — Menus and overlays are part of the gameplay slice

- **Status:** Active
- **Decision:** Main Menu, Level Select, Gameplay HUD, Pause/Settings, failure, result, and hint-refill flow are tested as one connected experience.
- **Reason:** A technically correct board is not a releasable game loop.

## Record 011 — Hint inventory is persistent

- **Status:** Active
- **Decision:** Non-tutorial hints consume the persistent `SaveManager.hint_count`. The first Level 1 tutorial hint is free while the tutorial is incomplete.
- **Reason:** Hint usage must remain consistent across replay, menu navigation, and application restart.

## Record 012 — Zero hints must remain actionable

- **Status:** Active for vertical-slice testing; commercial rule not final
- **Decision:** At zero, the HUD changes from `Hint 0` to a visible `Refill +3` action. Confirming the current refill popup restores three hints and saves immediately.
- **Reason:** A disabled dead-end control is confusing and prevents continued testing.
- **Launch note:** The current refill is a functional testing rule. Rewarded ads, earned currency, timed refills, purchases, or a permanent free model require a separate economy and monetization decision before launch.

## Record 013 — Current light UI is provisional, not final brand approval

- **Status:** Active
- **Decision:** Treat the existing light-mode screen system as the vertical-slice usability baseline only.
- **Reason:** Final logo, typography, chapter themes, particles, audio identity, store art, and monetization presentation should be designed after the gameplay slice passes.

## Record 014 — Documentation has a source-of-truth hierarchy

- **Status:** Active
- **Decision:** `docs/README.md` identifies which documents are current, provisional, historical, or pending validation.
- **Reason:** Dates alone do not prevent stale documents from being mistaken for current implementation truth.

## Record 015 — AI-assisted output must pass an anti-slop quality gate

- **Status:** Active
- **Decision:** Apply `docs/AI_ANTI_SLOP_STANDARD.md` to code, levels, UI, art, writing, monetization, documentation, and pull-request review.
- **Reason:** AI speed is useful only when authorship, specificity, consistency, and verification are preserved.
- **Consequences:** Parser warnings are defects; generic or placeholder presentation must be removed or labelled provisional; levels require authored decisions rather than quantity; untested changes cannot be described as verified; features without a Pathbreak-specific player purpose should be rejected.

## Record 016 — The living-board demonstration is also a play target

- **Status:** Implemented; pending local and player verification
- **Decision:** Tapping anywhere on the main-menu demonstration starts the same recommended level as the primary Start/Continue button.
- **Reason:** New players tapped the game-like arrows and were confused when nothing happened. The interface should honour the expectation it creates instead of teaching players to ignore the most game-like object on the screen.
- **Consequences:** The board receives a full-card native Button target, displays an explicit start/continue prompt, and shares one guarded navigation path with the primary button.

## Record 017 — Direction is communicated through hierarchy and motion

- **Status:** Implemented; pending local and player verification
- **Decision:** Strengthen arrowheads, reduce tail-dot prominence, and use a moving accent marker from tail to arrowhead during demonstrations, tutorial assistance, and hints.
- **Reason:** New players did not consistently understand direction from the previous arrowhead and dot treatment. A larger arrowhead plus restrained directional motion communicates the rule without adding more labels or decorative symbols.
- **Accessibility consequence:** Reduce Motion replaces travelling cues with static accent treatment or shorter transitions.

## Record 018 — The final obvious path clears automatically

- **Status:** Prototype implemented; pending local and player verification
- **Decision:** When exactly one valid path remains, lock board input, preview that path in blue, and clear it automatically without increasing the player move count.
- **Reason:** The final tap contains no decision once every blocker is gone. Removing it preserves pacing and makes the clear feel like a consequence of the player's last meaningful move.
- **Failure handling:** If the board does not contain exactly one valid remaining path, automatic clear is cancelled, a warning is recorded, and control returns to the player rather than silently corrupting state.
