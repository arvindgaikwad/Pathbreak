extends SceneTree

const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

func _init() -> void:
	print("--- Pathbreak Ordered Path Migration Preview ---")
	var levels_scanned := 0
	var pieces_scanned := 0
	var canonical := 0
	var reversible := 0
	var ambiguous := 0

	for level_number in range(1, 1000):
		var path := "res://data/level%d.json" % level_number
		if not FileAccess.file_exists(path):
			break
		levels_scanned += 1
		var file := FileAccess.open(path, FileAccess.READ)
		if file == null:
			push_error("Could not open %s." % path)
			ambiguous += 1
			continue
		var parsed = JSON.parse_string(file.get_as_text())
		if not parsed is Dictionary:
			push_error("Invalid JSON: %s." % path)
			ambiguous += 1
			continue
		var level_data: Dictionary = parsed
		var raw_pieces: Array = level_data.get("pieces", [])
		for piece_index in range(raw_pieces.size()):
			pieces_scanned += 1
			if not raw_pieces[piece_index] is Dictionary:
				print("Level %02d / Path %02d: AMBIGUOUS — invalid piece data" % [level_number, piece_index + 1])
				ambiguous += 1
				continue
			var piece_data: Dictionary = raw_pieces[piece_index]
			var cells := _parse_cells(piece_data.get("cells", []))
			var path_errors := PathVisualGeometryScript.validate_ordered_cells(cells)
			if not path_errors.is_empty():
				print(
					"Level %02d / Path %02d: AMBIGUOUS — %s" % [
						level_number,
						piece_index + 1,
						"; ".join(path_errors)
					]
				)
				ambiguous += 1
				continue
			var direction_data: Array = piece_data.get("direction", [])
			if direction_data.size() < 2:
				print("Level %02d / Path %02d: CANONICAL — direction derives from final segment" % [level_number, piece_index + 1])
				canonical += 1
				continue
			var legacy_direction := Vector2i(
				int(direction_data[0]),
				int(direction_data[1])
			)
			var endpoint := PathVisualGeometryScript.legacy_head_endpoint(cells, legacy_direction)
			match endpoint:
				PathVisualGeometry.HeadEndpoint.END:
					print("Level %02d / Path %02d: CANONICAL" % [level_number, piece_index + 1])
					canonical += 1
				PathVisualGeometry.HeadEndpoint.START:
					print("Level %02d / Path %02d: REVERSIBLE — reverse cell order" % [level_number, piece_index + 1])
					reversible += 1
				_:
					print(
						"Level %02d / Path %02d: AMBIGUOUS — stored direction %s matches neither endpoint segment" % [
							level_number,
							piece_index + 1,
							legacy_direction
						]
					)
					ambiguous += 1

	print(
		"Migration preview: levels=%d pieces=%d canonical=%d reversible=%d ambiguous=%d" % [
			levels_scanned,
			pieces_scanned,
			canonical,
			reversible,
			ambiguous
		]
	)
	print("Preview only: no files were modified.")
	quit(0 if ambiguous == 0 and reversible == 0 else 1)

func _parse_cells(raw_cells: Array) -> Array[Vector2i]:
	var cells: Array[Vector2i] = []
	for raw_cell in raw_cells:
		if raw_cell is Array and raw_cell.size() >= 2:
			cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
	return cells
