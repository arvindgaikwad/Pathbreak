class_name LevelDataValidator
extends RefCounted

const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

const VALID_DIRECTIONS: Array[Vector2i] = [
	Vector2i.UP,
	Vector2i.DOWN,
	Vector2i.LEFT,
	Vector2i.RIGHT
]

static func validate(level: PuzzleLevelData) -> PackedStringArray:
	var errors := PackedStringArray()
	if level == null:
		errors.append("Level resource is null.")
		return errors
	if level.board_size.x <= 0 or level.board_size.y <= 0:
		errors.append("Board dimensions must be positive.")
	if level.pieces.is_empty():
		errors.append("Level must contain at least one piece.")

	var occupied_cells: Dictionary = {}
	var piece_ids: Dictionary = {}
	for piece_index in range(level.pieces.size()):
		var piece := level.pieces[piece_index]
		if piece == null:
			errors.append("Piece %d is null." % piece_index)
			continue
		if piece_ids.has(piece.piece_id):
			errors.append("Duplicate piece id %d." % piece.piece_id)
		piece_ids[piece.piece_id] = true

		var path_errors := PathVisualGeometryScript.validate_ordered_cells(piece.cells)
		for path_error in path_errors:
			errors.append("Piece %d: %s" % [piece.piece_id, path_error])
		if piece.cells.is_empty():
			continue

		var derived_direction := PathVisualGeometryScript.direction_from_cells(
			piece.cells,
			piece.head_endpoint
		)
		if derived_direction not in VALID_DIRECTIONS:
			errors.append("Piece %d has an invalid derived head direction." % piece.piece_id)
		if piece.exit_direction != derived_direction:
			errors.append(
				"Piece %d movement direction %s does not match ordered head segment %s." % [
					piece.piece_id,
					piece.exit_direction,
					derived_direction
				]
			)

		for cell in piece.cells:
			if not MovementValidator.is_inside_board(cell, level.board_size):
				errors.append("Piece %d contains out-of-bounds cell %s." % [piece.piece_id, cell])
			if occupied_cells.has(cell):
				errors.append(
					"Cell %s is shared by pieces %d and %d." % [cell, occupied_cells[cell], piece.piece_id]
				)
			else:
				occupied_cells[cell] = piece.piece_id

	return errors

static func audit_visual_orientation(level: PuzzleLevelData) -> PackedStringArray:
	var warnings := PackedStringArray()
	if level == null:
		warnings.append("Level resource is null.")
		return warnings
	for piece in level.pieces:
		if piece == null:
			continue
		var path_errors := PathVisualGeometryScript.validate_ordered_cells(piece.cells)
		for path_error in path_errors:
			warnings.append("Piece %d: %s" % [piece.piece_id, path_error])
		if piece.cells.size() < 2:
			continue
		var derived_direction := PathVisualGeometryScript.direction_from_cells(
			piece.cells,
			piece.head_endpoint
		)
		if piece.exit_direction != derived_direction:
			warnings.append(
				"Piece %d direction mismatch: stored=%s derived=%s." % [
					piece.piece_id,
					piece.exit_direction,
					derived_direction
				]
			)
	return warnings

static func is_valid(level: PuzzleLevelData) -> bool:
	return validate(level).is_empty()

static func build_occupancy(level: PuzzleLevelData) -> Dictionary:
	var occupancy: Dictionary = {}
	if level == null:
		return occupancy
	for piece in level.pieces:
		if piece == null:
			continue
		for cell in piece.cells:
			occupancy[cell] = piece.piece_id
	return occupancy
