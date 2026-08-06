class_name PuzzlePieceData
extends Resource

const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

@export var piece_id: int
@export var cells: Array[Vector2i]
@export var exit_direction: Vector2i
@export var head_endpoint: PathVisualGeometry.HeadEndpoint = PathVisualGeometry.HeadEndpoint.END

static func create(
	id: int,
	cell_list: Array,
	legacy_direction: Vector2i = Vector2i.ZERO,
	head_at_end: bool = true
) -> PuzzlePieceData:
	var piece := PuzzlePieceData.new()
	piece.piece_id = id
	piece.head_endpoint = (
		PathVisualGeometry.HeadEndpoint.END
		if head_at_end
		else PathVisualGeometry.HeadEndpoint.START
	)
	for raw_cell in cell_list:
		if raw_cell is Vector2i:
			piece.cells.append(raw_cell)
		elif raw_cell is Vector2:
			piece.cells.append(Vector2i(int(raw_cell.x), int(raw_cell.y)))
		elif raw_cell is Array and raw_cell.size() >= 2:
			piece.cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))

	piece.exit_direction = PathVisualGeometryScript.direction_from_cells(
		piece.cells,
		piece.head_endpoint
	)
	if (
		legacy_direction != Vector2i.ZERO
		and piece.exit_direction != Vector2i.ZERO
		and legacy_direction != piece.exit_direction
	):
		push_warning(
			"Piece %d legacy direction %s does not match ordered endpoint direction %s." % [
				id,
				legacy_direction,
				piece.exit_direction
			]
		)
	return piece

func rebuild_direction_from_path() -> void:
	exit_direction = PathVisualGeometryScript.direction_from_cells(cells, head_endpoint)
