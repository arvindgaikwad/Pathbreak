class_name PuzzleLevelData
extends Resource

@export var level_id: int = 1
@export var board_size: Vector2i = Vector2i(8, 8)
@export var difficulty: String = "Normal"
@export var starting_lives: int = 3
@export var pieces: Array[PuzzlePieceData] = []
