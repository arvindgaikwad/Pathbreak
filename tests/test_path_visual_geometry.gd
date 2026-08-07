extends SceneTree

const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

func _init() -> void:
	print("--- Running Pathbreak Ordered Path Geometry Test Suite ---")
	var tests: Array[Callable] = [
		test_straight_directions_from_final_segment,
		test_l_shaped_directions_from_final_segment,
		test_start_endpoint_support,
		test_triangle_tip_faces_direction,
		test_shaft_trim_preserves_logic_endpoint,
		test_snake_route_follows_corner,
		test_all_authored_levels_are_canonical
	]
	var passed := 0
	for test_index in range(tests.size()):
		var result: bool = tests[test_index].call()
		print("%s Test %d" % ["PASS" if result else "FAIL", test_index + 1])
		if result:
			passed += 1
	print("Ordered path geometry: %d/%d passed" % [passed, tests.size()])
	quit(0 if passed == tests.size() else 1)

func test_straight_directions_from_final_segment() -> bool:
	var c1: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0)]
	var c2: Array[Vector2i] = [Vector2i(1, 0), Vector2i(0, 0)]
	var c3: Array[Vector2i] = [Vector2i(0, 0), Vector2i(0, 1)]
	var c4: Array[Vector2i] = [Vector2i(0, 1), Vector2i(0, 0)]
	var cases := [
		{"cells": c1, "direction": Vector2i.RIGHT},
		{"cells": c2, "direction": Vector2i.LEFT},
		{"cells": c3, "direction": Vector2i.DOWN},
		{"cells": c4, "direction": Vector2i.UP}
	]
	for test_case in cases:
		var cells: Array[Vector2i] = test_case["cells"]
		if PathVisualGeometryScript.direction_from_cells(cells) != test_case["direction"]:
			return false
	return true

func test_l_shaped_directions_from_final_segment() -> bool:
	var l1: Array[Vector2i] = [Vector2i(0, 0), Vector2i(0, 1), Vector2i(1, 1)]
	var l2: Array[Vector2i] = [Vector2i(1, 0), Vector2i(1, 1), Vector2i(0, 1)]
	var l3: Array[Vector2i] = [Vector2i(0, 0), Vector2i(1, 0), Vector2i(1, 1)]
	var l4: Array[Vector2i] = [Vector2i(0, 1), Vector2i(1, 1), Vector2i(1, 0)]
	var cases := [
		{"cells": l1, "direction": Vector2i.RIGHT},
		{"cells": l2, "direction": Vector2i.LEFT},
		{"cells": l3, "direction": Vector2i.DOWN},
		{"cells": l4, "direction": Vector2i.UP}
	]
	for test_case in cases:
		var cells: Array[Vector2i] = test_case["cells"]
		if not PathVisualGeometryScript.validate_ordered_cells(cells).is_empty():
			return false
		if PathVisualGeometryScript.direction_from_cells(cells) != test_case["direction"]:
			return false
	return true

func test_start_endpoint_support() -> bool:
	var cells: Array[Vector2i] = [
		Vector2i(1, 1),
		Vector2i(2, 1),
		Vector2i(2, 2)
	]
	return (
		PathVisualGeometryScript.direction_from_cells(
			cells,
			PathVisualGeometry.HeadEndpoint.START
		) == Vector2i.LEFT
		and PathVisualGeometryScript.direction_from_cells(
			cells,
			PathVisualGeometry.HeadEndpoint.END
		) == Vector2i.DOWN
	)

func test_triangle_tip_faces_direction() -> bool:
	var directions: Array[Vector2] = [
		Vector2.RIGHT,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.UP
	]
	for direction in directions:
		var triangle := PathVisualGeometryScript.make_triangle_from_tip(
			Vector2.ZERO,
			direction,
			24.0,
			12.0
		)
		if triangle.size() != 3:
			return false
		var tip_projection := triangle[0].dot(direction)
		if tip_projection <= triangle[1].dot(direction):
			return false
		if tip_projection <= triangle[2].dot(direction):
			return false
	return true

func test_shaft_trim_preserves_logic_endpoint() -> bool:
	var points := PackedVector2Array([
		Vector2(0.0, 0.0),
		Vector2(64.0, 0.0),
		Vector2(64.0, 64.0)
	])
	var trimmed := PathVisualGeometryScript.trim_shaft_for_head(points, 12.0)
	return (
		points[-1] == Vector2(64.0, 64.0)
		and trimmed[-1] == Vector2(64.0, 52.0)
		and trimmed[0] == points[0]
		and PathVisualGeometryScript.direction_from_points(points) == Vector2.DOWN
	)

func test_snake_route_follows_corner() -> bool:
	var route := PackedVector2Array([
		Vector2(0.0, 0.0),
		Vector2(64.0, 0.0),
		Vector2(64.0, 64.0),
		Vector2(64.0, 256.0)
	])
	var body_length := 128.0

	var early := PathVisualGeometryScript.slice_polyline(route, 32.0, 32.0 + body_length)
	if early.size() != 4:
		return false
	if not early[0].is_equal_approx(Vector2(32.0, 0.0)):
		return false
	if not early[1].is_equal_approx(Vector2(64.0, 0.0)):
		return false
	if not early[2].is_equal_approx(Vector2(64.0, 64.0)):
		return false
	if not early[3].is_equal_approx(Vector2(64.0, 96.0)):
		return false

	var straightened := PathVisualGeometryScript.slice_polyline(
		route,
		body_length,
		body_length * 2.0
	)
	return (
		straightened.size() == 2
		and straightened[0].is_equal_approx(Vector2(64.0, 64.0))
		and straightened[1].is_equal_approx(Vector2(64.0, 192.0))
		and is_equal_approx(
			PathVisualGeometryScript.polyline_length(straightened),
			body_length
		)
	)

func test_all_authored_levels_are_canonical() -> bool:
	var level_count := 0
	var piece_count := 0
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
			piece_count += 1
			if not raw_pieces[piece_index] is Dictionary:
				return false
			var piece_data: Dictionary = raw_pieces[piece_index]
			var cells := _parse_cells(piece_data.get("cells", []))
			var path_errors := PathVisualGeometryScript.validate_ordered_cells(cells)
			if not path_errors.is_empty():
				push_error(
					"Level %d piece %d invalid ordered path: %s" % [
						level_number,
						piece_index + 1,
						"; ".join(path_errors)
					]
				)
				return false
			var direction_data: Array = piece_data.get("direction", [])
			if direction_data.size() < 2:
				push_error("Level %d piece %d has no compatibility direction." % [level_number, piece_index + 1])
				return false
			var stored_direction := Vector2i(
				int(direction_data[0]),
				int(direction_data[1])
			)
			var derived_direction := PathVisualGeometryScript.direction_from_cells(cells)
			if stored_direction != derived_direction:
				push_error(
					"Level %d piece %d mismatch: stored=%s derived=%s." % [
						level_number,
						piece_index + 1,
						stored_direction,
						derived_direction
					]
				)
				return false
	if level_count < 10:
		push_error("Expected at least 10 sequential levels, found %d." % level_count)
		return false
	print("Canonical path audit scanned %d levels and %d pieces." % [level_count, piece_count])
	return true

func _parse_cells(raw_cells: Array) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for raw_cell in raw_cells:
		if raw_cell is Array and raw_cell.size() >= 2:
			cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
	return cells
