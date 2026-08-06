# Pathbreak — Game Design Document

## 1. Executive Summary
**Pathbreak** is an original Android puzzle game based on the concept of directional paths escaping an obstructed grid board. Players tap paths to escape the board. An unblocked path accelerates off the board in its exit direction; a blocked path produces tactile error feedback (coral red flash & shake).

## 2. Core Mechanics & Rules
- **Grid Board**: N×M grid of cells containing 1 or more directional paths.
- **Paths**: Occupy 1 or more grid cells. Paths can be straight or contain 90-degree bends.
- **Arrowhead & Exit Direction**: Each path has an arrowhead indicating its exit direction (`Vector2i.UP`, `Vector2i.DOWN`, `Vector2i.LEFT`, `Vector2i.RIGHT`).
- **Movement Rule**: A path can only move straight in its designated exit direction.
- **Escape Validation**: A path can escape if no other path occupies any cell along its movement ray out of the board. Self-occupancy (cells belonging to the same path) is ignored during traversal checks.
- **Unblocked Tap**: Disables path input, transitions to primary accent color (`#3978F6`), clears grid occupancy, accelerates off board with a fading trail, and plays a soft escape chime.
- **Blocked Tap**: Triggers coral red flash (`#EF5B5B`), shakes position for 0.25s, records mistake count, and returns to primary navy (`#172033`). Does not end or fail the level during testing.
- **Level Objective**: Clear all paths from the board.

## 3. Progression & Phase Roadmap
- **Phase 1**: Core Playable Prototype (5 handcrafted levels, responsive board, occupancy system, movement validator, unit tests).
- **Phase 2**: Level Resource System & Progress Persistence (`PuzzleLevelData` resources, 10+ levels).
- **Phase 3**: In-engine Level Editor & Solvability Validator.
- **Phase 4**: Full Game Loop & Menus (Main Menu, Level Select, Results, Settings).
- **Phase 5**: Content Expansion (50–75 levels, audio polish, particle effects).
- **Phase 6**: Commercial Systems (Ads, IAP, Google Play Store configuration).
