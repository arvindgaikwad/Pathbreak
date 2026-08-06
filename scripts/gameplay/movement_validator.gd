class_name MovementValidator
extends RefCounted

static func is_inside_board(cell: Vector2i, board_size: Vector2i) -> bool:
	return cell.x >= 0 and cell.x < board_size.x and cell.y >= 0 and cell.y < board_size.y

static func can_escape_piece(piece_id: int, cells: Array[Vector2i], exit_direction: Vector2i, board_size: Vector2i, occupancy: Dictionary) -> bool:
	for cell in cells:
		var check_cell := cell + exit_direction

		while is_inside_board(check_cell, board_size):
			var occupying_piece_id = occupancy.get(check_cell, null)

			if occupying_piece_id != null:
				if occupying_piece_id != piece_id:
					return false

			check_cell += exit_direction

	return true

static func can_escape(piece_data: PuzzlePieceData, board_size: Vector2i, occupancy: Dictionary) -> bool:
	if not piece_data:
		return false
	return can_escape_piece(piece_data.piece_id, piece_data.cells, piece_data.exit_direction, board_size, occupancy)
