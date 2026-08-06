class_name PuzzlePieceData
extends Resource

@export var piece_id: int
@export var cells: Array[Vector2i]
@export var exit_direction: Vector2i

static func create(id: int, cell_list: Array, dir: Vector2i) -> PuzzlePieceData:
	var p = PuzzlePieceData.new()
	p.piece_id = id
	p.exit_direction = dir
	for c in cell_list:
		if c is Vector2i:
			p.cells.append(c)
		elif c is Vector2:
			p.cells.append(Vector2i(int(c.x), int(c.y)))
		elif c is Array:
			p.cells.append(Vector2i(int(c[0]), int(c[1])))
	return p
