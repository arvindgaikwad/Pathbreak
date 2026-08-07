class_name LevelStudioPreviewSession
extends RefCounted

const META_KEY := "pathbreak_level_studio_preview_session"

static func begin_preview(level: PuzzleLevelData, editor_state: Dictionary) -> void:
	if level == null:
		return
	Engine.set_meta(META_KEY, {
		"level": _serialize_level(level),
		"editor_state": editor_state.duplicate(true)
	})

static func has_preview() -> bool:
	return Engine.has_meta(META_KEY)

static func get_preview_level() -> PuzzleLevelData:
	if not has_preview():
		return null
	var session = Engine.get_meta(META_KEY)
	if not session is Dictionary:
		return null
	var level_data = session.get("level", {})
	if not level_data is Dictionary:
		return null
	return _deserialize_level(level_data)

static func get_editor_state() -> Dictionary:
	if not has_preview():
		return {}
	var session = Engine.get_meta(META_KEY)
	if not session is Dictionary:
		return {}
	var state = session.get("editor_state", {})
	if not state is Dictionary:
		return {}
	return state.duplicate(true)

static func clear() -> void:
	if Engine.has_meta(META_KEY):
		Engine.remove_meta(META_KEY)

static func _serialize_level(level: PuzzleLevelData) -> Dictionary:
	var pieces: Array = []
	for piece in level.pieces:
		if piece == null:
			continue
		var serialized_cells: Array = []
		for cell in piece.cells:
			serialized_cells.append([cell.x, cell.y])
		pieces.append({
			"id": piece.piece_id,
			"cells": serialized_cells,
			"direction": [piece.exit_direction.x, piece.exit_direction.y]
		})
	return {
		"level_id": level.level_id,
		"width": level.board_size.x,
		"height": level.board_size.y,
		"difficulty": level.difficulty,
		"lives": level.starting_lives,
		"pieces": pieces
	}

static func _deserialize_level(data: Dictionary) -> PuzzleLevelData:
	var level := PuzzleLevelData.new()
	level.level_id = int(data.get("level_id", 1))
	level.board_size = Vector2i(
		int(data.get("width", 8)),
		int(data.get("height", 8))
	)
	level.difficulty = str(data.get("difficulty", "Unrated"))
	level.starting_lives = maxi(int(data.get("lives", 3)), 1)

	for raw_piece in data.get("pieces", []):
		if not raw_piece is Dictionary:
			continue
		var direction_data: Array = raw_piece.get("direction", [0, 0])
		var direction := Vector2i.ZERO
		if direction_data.size() >= 2:
			direction = Vector2i(int(direction_data[0]), int(direction_data[1]))
		var piece := PuzzlePieceData.create(
			int(raw_piece.get("id", level.pieces.size() + 1)),
			raw_piece.get("cells", []),
			direction
		)
		if not piece.cells.is_empty():
			level.pieces.append(piece)
	return level
