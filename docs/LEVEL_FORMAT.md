# Pathbreak — Level Format Specification

## 1. Overview
Pathbreak uses Godot `Resource` files (`.tres`) and JSON definitions for level format data.

## 2. Resource Definition (`PuzzleLevelData`)
```gdscript
class_name PuzzleLevelData
extends Resource

@export var level_id: int
@export var board_size: Vector2i
@export var difficulty: String
@export var starting_lives: int
@export var pieces: Array[PuzzlePieceData]
```

## 3. Piece Definition (`PuzzlePieceData`)
```gdscript
class_name PuzzlePieceData
extends Resource

@export var piece_id: int
@export var cells: Array[Vector2i]
@export var exit_direction: Vector2i
```

## 4. Valid Directions
- `Vector2i(0, -1)` → `Vector2i.UP`
- `Vector2i(0, 1)` → `Vector2i.DOWN`
- `Vector2i(-1, 0)` → `Vector2i.LEFT`
- `Vector2i(1, 0)` → `Vector2i.RIGHT`

## 5. Sample Level JSON Format
```json
{
  "level_id": 1,
  "difficulty": "Normal",
  "starting_lives": 3,
  "board_size": [8, 8],
  "pieces": [
    {
      "piece_id": 1,
      "cells": [[1, 2], [2, 2], [3, 2], [3, 3]],
      "exit_direction": [0, -1]
    }
  ]
}
```
