# Pathbreak

**Pathbreak** is an original Android directional path puzzle game built in **Godot 4.7.1**.

## Features
- **Original Light-Mode Palette**: Warm off-white canvas (`#F7F7F4`), white rounded board card (`#FFFFFF`), dark navy paths (`#172033`), soft blue accents (`#3978F6`), coral red error flash (`#EF5B5B`), emerald green success (`#35B779`).
- **Data Architecture**: Decoupled `PuzzleLevelData` and `PuzzlePieceData` `Resource` model.
- **Robust Occupancy Validation**: Tested ray-casting movement validator handling straight paths, bends, self-occupancy, and board boundaries.
- **Offline & Backend-Free**: 100% self-contained gameplay engine.

## Directory Structure
```
res://
├── assets/
│   ├── audio/
│   ├── fonts/
│   ├── icons/
│   └── placeholders/
├── data/
│   ├── levels/
│   └── themes/
├── scenes/
│   ├── boot/
│   ├── game/
│   ├── menus/
│   ├── shared/
│   └── tools/
├── scripts/
│   ├── autoload/
│   ├── gameplay/
│   ├── ui/
│   └── tools/
├── tests/
└── docs/
```

## Running & Testing
- Open project in **Godot 4.7.1 Stable**.
- Launch main scene `scenes/game/game_screen.tscn` (`F5`).
- Run unit tests: `godot --headless --script tests/test_movement_validator.gd`.
