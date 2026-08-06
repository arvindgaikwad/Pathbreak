# Pathbreak

Pathbreak is an original Android directional-path puzzle game built with Godot 4.7.1 and typed GDScript.

## Current product direction

- Portrait Android puzzle game.
- Premium light-mode presentation.
- Offline and backend-free core gameplay.
- Fair nearest-path touch selection rather than overlapping independent hitboxes.
- Relaxed visual feedback with optional haptics, reduced motion, and high contrast.
- Five-level vertical slice before full content production.

## Production architecture

```text
res://
├── data/
│   ├── level1.json ... level10.json
│   └── levels/                 # temporary .tres fallback during migration
├── scenes/
│   ├── MainMenu.tscn
│   ├── LevelSelect.tscn
│   └── game/
│       ├── game_screen.tscn
│       ├── board.tscn
│       ├── puzzle_piece.tscn
│       ├── hud.tscn
│       ├── result_popup.tscn
│       └── pause_menu.tscn
├── scripts/
│   ├── SaveManager.gd
│   ├── SettingsManager.gd
│   ├── AudioManager.gd
│   ├── gameplay/
│   │   ├── level_manager.gd
│   │   ├── board_manager.gd
│   │   ├── puzzle_piece.gd
│   │   ├── movement_validator.gd
│   │   └── level_data_validator.gd
│   └── ui/
├── tests/
└── docs/
```

The modular gameplay stack under `scenes/game/` and `scripts/gameplay/` is the only supported gameplay architecture.

## Running

1. Open the project in Godot 4.7.1.
2. Run the project with `F6`/`F5`; the configured startup scene is `scenes/MainMenu.tscn`.
3. Use mouse input in the editor or touch input on Android.

## Headless tests

```bash
godot --headless --path . --script tests/test_movement_validator.gd
godot --headless --path . --script tests/test_level_data_validator.gd
```

These commands still need to be executed locally before the current production branch is merged.

## Current quality gate

Read `docs/VERTICAL_SLICE.md`. Do not expand to 75 levels until the first five levels pass its full phone, tablet, touch, save, pause, accessibility, and gameplay test matrix.

## Important status

This repository is under active production. The foundation branch improves architecture and game flow, but it is not considered release-ready until it opens cleanly in Godot, both test suites pass, and the vertical slice is manually approved on Android hardware.
