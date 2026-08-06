# Pathbreak — Main Menu and Player Flow Direction

Status: approved design direction required before another main-menu implementation pass.

## Director's diagnosis

The current menu is clean but reads like a product landing page rather than the front door of a puzzle game. The typography and buttons are functional, yet the screen lacks a memorable game identity, an immediate visual explanation of the puzzle, and a clear sense of progression through a world.

The next menu must feel like a calm game, not a SaaS dashboard.

## Product promise

Pathbreak is the fair, readable directional-path puzzle:

- calm rather than noisy;
- precise rather than punishing;
- thoughtful rather than timed;
- original rather than a visual copy of another arrow game.

Every front-end screen should reinforce that promise.

## Chosen main-menu concept — The Living Board

The menu is built around a small animated puzzle tableau rather than decorative floating arrows.

A compact board sits in the upper-middle area. It contains three or four original path shapes. Every few seconds, one valid path softly turns blue and exits. The board then resets. This demonstrates the core rule without text and creates a recognisable visual identity.

The light-mode palette remains:

- warm canvas background;
- white puzzle surface;
- navy path shapes;
- blue active path;
- soft amber progress accents;
- restrained shadows and motion.

The menu must remain lightweight and work offline.

## Main-menu hierarchy

### Top utility row

Left:

- total earned stars, shown compactly;
- no profile/avatar system for version 1.

Right:

- settings button;
- no dead buttons.

### Hero area

- original Pathbreak symbol or wordmark;
- animated Living Board beneath or behind the wordmark;
- one-line promise: `Find the clear path.`

Do not use marketing copy such as `Offline puzzle · Calm pace · Precise touch` on the primary game screen. Those benefits belong in store screenshots, onboarding, or an About screen.

### Primary action card

For a returning player:

- chapter name;
- current level number;
- compact chapter progress;
- large `Continue` button;
- expected copy: `Continue · Level 5`.

For a new player:

- short invitation;
- large `Start` button;
- no progress statistics before the player has progress.

### Secondary actions

Two equal compact buttons:

- `Levels`
- `How to Play`

Settings remains in the top-right utility row.

Daily challenges, shops, events, currencies, and social buttons are excluded from the vertical slice.

## First-launch flow

```text
App launch
  → Main Menu
  → Start
  → Level 1 tutorial
  → Completion
  → Level 2
```

The first launch must not force the player through account creation, permissions, a splash carousel, or a separate tutorial menu.

Level 1 is the tutorial.

## Returning-player flow

```text
App launch
  → Main Menu
  → Continue · Level N
  → Gameplay
```

Alternative path:

```text
Main Menu
  → Levels
  → Select any unlocked level
  → Gameplay
```

## Navigation rules

- Project start always opens `MainMenu.tscn`.
- F5 runs the project and starts at the main menu.
- F6 runs only the currently open scene and is not representative of app launch.
- Gameplay back action returns to the main menu.
- Level-select back action returns to the main menu.
- Pause-menu Main Menu action returns to the main menu.
- Completion Next continues directly to the next level.
- Completing the final available level returns to level select with a completion message.

## Menu states

### State A — New player

- no star total emphasis;
- `Start` primary action;
- `Levels` may open Level 1 only;
- Living Board demonstrates one obvious valid move.

### State B — Returning player

- star total visible;
- current chapter and progress visible;
- `Continue · Level N` primary action;
- `Levels` available.

### State C — All current content complete

- primary action becomes `Replay Latest` or `Choose a Level`;
- message: `Chapter complete`;
- no false promise of unavailable content.

## Visual composition target for 720 × 1280

```text
┌──────────────────────────────────────┐
│  ★ 11                         ⚙      │
│                                      │
│              PATHBREAK               │
│          Find the clear path.         │
│                                      │
│       ┌──────────────────────┐        │
│       │   animated mini board │        │
│       │      ───→   │↓        │        │
│       └──────────────────────┘        │
│                                      │
│       CHAPTER 1 · FIRST PATHS         │
│       Level 5              4 / 10     │
│       ━━━━━━━━━━━━━━━━━━━━            │
│       [     Continue · Level 5     ]  │
│                                      │
│       [ Levels ]  [ How to Play ]    │
│                                      │
└──────────────────────────────────────┘
```

The composition must scale down to 360 × 800 without hiding the primary action or creating scroll requirements.

## Motion direction

- one purposeful path-exit animation in the Living Board;
- subtle button press scale;
- gentle completion-card entrance;
- no random arrows drifting across the whole screen;
- no continuous motion when Reduce Motion is enabled;
- no visual element should compete with Continue.

## Audio direction

- a soft two-note menu confirmation;
- no looping menu music until original music is available;
- sound setting respected immediately.

## User-flow acceptance criteria

- F5 and Android app launch open the main menu.
- A new player understands that the game is about clearing directional paths without reading instructions.
- A returning player reaches the next unfinished level in one tap.
- The menu has one dominant action and no dead controls.
- Levels and How to Play remain clearly secondary.
- The menu fits 360 × 800, 393 × 873, 412 × 915, 800 × 1280, and 1200 × 1920.
- The menu remains understandable with Reduce Motion enabled.
- The menu contains no copied game art, branding, layouts, or level designs.

## Implementation order

1. Preserve `run/main_scene="res://scenes/MainMenu.tscn"`.
2. Replace random floating arrows with the Living Board component.
3. Add explicit new-player, returning-player, and chapter-complete states.
4. Add star total and settings utility row.
5. Add Continue card and two secondary actions.
6. Build a lightweight How to Play overlay.
7. Test the complete navigation graph.
8. Perform phone and tablet visual review before merging.
