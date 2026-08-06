extends SceneTree

const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

func _init() -> void:
	print("--- Running Pathbreak Path Visual Geometry Test Suite ---")
	var tests: Array[Callable] = [
		test_cardinal_leading_edges,
		test_authored_order_does_not_control_head,
		test_triangle_points_in_movement_direction,
		test_projection_tie_is_deterministic,
		test_all_authored_levels_resolve_visual_anchors
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Path visual geometry: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func test_cardinal_leading_edges() -> bool:
	var right_cells: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(2, 0)]
	var left_cells: Array[Vector2i] = [Vector2i(2, 0), Vector2i(1, 0), Vector2i(0, 0)]
	var down_cells: Array[Vector2i] = [Vector2i(1, 0), Vector2i(1, 1), Vector2i(1, 2)]
	var up_cells: Array[Vector2i] = [Vector2i(1, 2), Vector2i(1, 1), Vector2i(1, 0)]
	return (
		PathVisualGeometryScript.leading_cell_index(right_cells, Vector2i.RIGHT) == 2
		and PathVisualGeometryScript.leading_cell_index(left_cells, Vector2i.LEFT) == 2
		and PathVisualGeometryScript.leading_cell_index(down_cells, Vector2i.DOWN) == 2
		and PathVisualGeometryScript.leading_cell_index(up_cells, Vector2i.UP) == 2
	)

func test_authored_order_does_not_control_head() -> bool:
	var cells: Array[Vector2i] = [
		Vector2i(2, 1),
		Vector2i(2, 0),
		Vector2i(1, 0)
	]
	var leading_index: int = PathVisualGeometryScript.leading_cell_index(cells, Vector2i.DOWN)
	var trailing_index: int = PathVisualGeometryScript.trailing_cell_index(cells, Vector2i.DOWN)
	return leading_index == 0 and trailing_index == 2

func test_triangle_points_in_movement_direction() -> bool:
	var directions: Array[Vector2] = [Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP]
	for direction in directions:
		var triangle: PackedVector2Array = PathVisualGeometryScript.make_triangle(
			Vector2.ZERO,
			direction,
			24.0,
			12.0
		)
		if triangle.size() != 3:
			return false
		var tip_projection: float = triangle[0].dot(direction)
		if tip_projection <= triangle[1].dot(direction):
			return false
		if tip_projection <= triangle[2].dot(direction):
			return false
	return true

func test_projection_tie_is_deterministic() -> bool:
	var cells: Array[Vector2i] = [Vector2i(1, 2), Vector2i(2, 2), Vector2i(3, 2)]
	var leading_index: int = PathVisualGeometryScript.leading_cell_index(cells, Vector2i.UP)
	var trailing_index: int = PathVisualGeometryScript.trailing_cell_index(cells, Vector2i.UP)
	return (
		PathVisualGeometryScript.cell_projection_span(cells, Vector2i.UP) == 0
		and leading_index == cells.size() - 1
		and trailing_index == 0
	)

func test_all_authored_levels_resolve_visual_anchors() -> bool:
	var level_count := 0
	for level_number in range(1, 1000):
		var path := "res://data/level%d.json" % level_number
		if not FileAccess.file_exists(path):
			break
		level_count += 1
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			push_error("Could not open %s." % path)
			return false
		var parsed = JSON.parse_string(file.get_as_text())
		if not parsed is Dictionary:
			push_error("Invalid JSON in %s." % path)
			return false
		var level_data: Dictionary = parsed
		var raw_pieces: Array = level_data.get("pieces", [])
		for piece_index in range(raw_pieces.size()):
			if not raw_pieces[piece_index] is Dictionary:
				return false
			var piece_data: Dictionary = raw_pieces[piece_index]
			var direction_data: Array = piece_data.get("direction", [])
			if direction_data.size() < 2:
				return false
			var direction := Vector2i(int(direction_data[0]), int(direction_data[1]))
			var cells: Array[Vector2i] = _parse_cells(piece_data.get("cells", []))
			var leading_index: int = PathVisualGeometryScript.leading_cell_index(cells, direction)
			var trailing_index: int = PathVisualGeometryScript.trailing_cell_index(cells, direction)
			if leading_index < 0 or trailing_index < 0:
				push_error("Level %d piece %d has no visual anchor." % [level_number, piece_index + 1])
				return false
			if cells.size() > 1 and leading_index == trailing_index:
				push_error("Level %d piece %d resolves head and tail to the same cell." % [level_number, piece_index + 1])
				return false
			var leading_projection: int = _projection(cells[leading_index], direction)
			var trailing_projection: int = _projection(cells[trailing_index], direction)
			for cell in cells:
				var projection: int = _projection(cell, direction)
				if projection > leading_projection or projection < trailing_projection:
					push_error("Level %d piece %d resolved an incorrect leading/trailing edge." % [level_number, piece_index + 1])
					return false
	if level_count == 0:
		push_error("No authored levels were found.")
		return false
	print("Visual anchor audit scanned %d authored levels." % level_count)
	return true

func _parse_cells(raw_cells: Array) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for raw_cell in raw_cells:
		if raw_cell is Array and raw_cell.size() >= 2:
			cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
	return cells

func _projection(cell: Vector2i, direction: Vector2i) -> int:
	return cell.x * direction.x + cell.y * direction.y
