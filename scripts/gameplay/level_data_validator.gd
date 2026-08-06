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
		if piece.cells.is_empty():
			errors.append("Piece %d has no cells." % piece.piece_id)
			continue
		if piece.exit_direction not in VALID_DIRECTIONS:
			errors.append("Piece %d has an invalid exit direction." % piece.piece_id)

		for cell_index in range(piece.cells.size()):
			var cell := piece.cells[cell_index]
			if not MovementValidator.is_inside_board(cell, level.board_size):
				errors.append("Piece %d contains out-of-bounds cell %s." % [piece.piece_id, cell])
			if occupied_cells.has(cell):
				errors.append(
					"Cell %s is shared by pieces %d and %d." % [cell, occupied_cells[cell], piece.piece_id]
				)
			else:
				occupied_cells[cell] = piece.piece_id

			if cell_index > 0:
				var previous_cell := piece.cells[cell_index - 1]
				var distance := absi(cell.x - previous_cell.x) + absi(cell.y - previous_cell.y)
				if distance != 1:
					errors.append(
					"Piece %d has non-adjacent cells %s and %s." % [piece.piece_id, previous_cell, cell]
				)

	return errors

static func audit_visual_orientation(level: PuzzleLevelData) -> PackedStringArray:
	var warnings := PackedStringArray()
	if level == null:
		warnings.append("Level resource is null.")
		return warnings
	for piece in level.pieces:
		if piece == null or piece.cells.is_empty():
			continue
		if piece.exit_direction not in VALID_DIRECTIONS:
			continue
		var leading_index: int = PathVisualGeometryScript.leading_cell_index(
			piece.cells,
			piece.exit_direction
		)
		var trailing_index: int = PathVisualGeometryScript.trailing_cell_index(
			piece.cells,
			piece.exit_direction
		)
		if leading_index < 0 or trailing_index < 0:
			warnings.append("Piece %d could not resolve visual head/tail anchors." % piece.piece_id)
			continue
		if piece.cells.size() > 1 and leading_index == trailing_index:
			warnings.append("Piece %d resolves visual head and tail to the same cell." % piece.piece_id)
		if PathVisualGeometryScript.cell_projection_span(piece.cells, piece.exit_direction) == 0:
			warnings.append(
				"Piece %d has no cell-to-cell extent along its exit direction; endpoint tie fallback is used." % piece.piece_id
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
