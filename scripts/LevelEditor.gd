extends Node2D

const PuzzlePieceScene: PackedScene = preload("res://scenes/game/puzzle_piece.tscn")
const PuzzlePieceDataScript = preload("res://scripts/gameplay/puzzle_piece_data.gd")
const PathVisualGeometryScript = preload("res://scripts/gameplay/path_visual_geometry.gd")

var board_bounds := Rect2i(0, 0, 8, 8)
var grid_size := 64.0
var pieces_data: Array[Dictionary] = []
var current_path: Array[Vector2i] = []
var is_drawing := false

@onready var grid_dots = $BoardPivot/GridDots
@onready var board_pivot: Node2D = $BoardPivot
@onready var validate_label: Label = $UI/Sidebar/ValidateLabel

func _ready() -> void:
	grid_dots.set_script(preload("res://scripts/gameplay/board_manager.gd"))
	grid_dots.update_grid(board_bounds, grid_size)

	$UI/Sidebar/SaveButton.pressed.connect(_on_save_pressed)
	$UI/Sidebar/LoadButton.pressed.connect(_on_load_pressed)
	$UI/Sidebar/ClearButton.pressed.connect(_on_clear_pressed)
	$UI/Sidebar/DeleteButton.pressed.connect(_on_delete_pressed)
	$UI/Sidebar/ValidateButton.pressed.connect(_on_validate_pressed)

	$UI/Sidebar/BtnUP.pressed.connect(func() -> void: _set_last_dir(Vector2i.UP))
	$UI/Sidebar/BtnDOWN.pressed.connect(func() -> void: _set_last_dir(Vector2i.DOWN))
	$UI/Sidebar/BtnLEFT.pressed.connect(func() -> void: _set_last_dir(Vector2i.LEFT))
	$UI/Sidebar/BtnRIGHT.pressed.connect(func() -> void: _set_last_dir(Vector2i.RIGHT))

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			var cell := _mouse_to_grid(event.position)
			if board_bounds.has_point(cell):
				is_drawing = true
				current_path = [cell]
				queue_redraw()
		else:
			_finish_current_path()
	elif event is InputEventMouseMotion and is_drawing:
		var cell := _mouse_to_grid(event.position)
		if not board_bounds.has_point(cell):
			return
		if current_path.is_empty():
			current_path.append(cell)
			queue_redraw()
			return
		var last_cell: Vector2i = current_path[-1]
		if cell == last_cell or current_path.has(cell):
			return
		var difference := cell - last_cell
		if absi(difference.x) + absi(difference.y) == 1:
			current_path.append(cell)
			queue_redraw()

func _finish_current_path() -> void:
	if not is_drawing:
		return
	is_drawing = false
	if current_path.size() < 2:
		current_path.clear()
		queue_redraw()
		_set_validation_message("Draw at least two adjacent cells.", false)
		return
	var path_errors := PathVisualGeometryScript.validate_ordered_cells(current_path)
	if not path_errors.is_empty():
		current_path.clear()
		queue_redraw()
		_set_validation_message(path_errors[0], false)
		return
	var direction := PathVisualGeometryScript.direction_from_cells(current_path)
	pieces_data.append({
		"cells": current_path.duplicate(),
		"direction": direction
	})
	current_path.clear()
	_refresh_pieces()
	_set_validation_message("Valid: ?", true)

func _mouse_to_grid(position: Vector2) -> Vector2i:
	var local_position := position - board_pivot.position
	var offset_x := -(board_bounds.size.x * grid_size) / 2.0
	var offset_y := -(board_bounds.size.y * grid_size) / 2.0
	var grid_position := local_position - Vector2(offset_x, offset_y)
	return Vector2i(floori(grid_position.x / grid_size), floori(grid_position.y / grid_size))

func _refresh_pieces() -> void:
	for child in board_pivot.get_children():
		if child is PuzzlePiece:
			child.queue_free()

	var piece_id := 1
	for piece_dictionary in pieces_data:
		var cells: Array[Vector2i] = piece_dictionary["cells"]
		var direction := PathVisualGeometryScript.direction_from_cells(cells)
		piece_dictionary["direction"] = direction
		var piece_data := PuzzlePieceDataScript.create(piece_id, cells, direction)
		var piece := PuzzlePieceScene.instantiate() as PuzzlePiece
		if piece == null:
			push_error("PuzzlePiece scene does not use the PuzzlePiece script.")
			continue
		piece.init_from_data(piece_data, grid_size)
		var offset_x := -(board_bounds.size.x * grid_size) / 2.0
		var offset_y := -(board_bounds.size.y * grid_size) / 2.0
		piece.position = Vector2(offset_x, offset_y)
		board_pivot.add_child(piece)
		piece_id += 1
	queue_redraw()

func _draw() -> void:
	if current_path.is_empty():
		return
	var offset_x := -(board_bounds.size.x * grid_size) / 2.0
	var offset_y := -(board_bounds.size.y * grid_size) / 2.0
	var points := PackedVector2Array()
	for cell in current_path:
		points.append(
			Vector2(
				offset_x + cell.x * grid_size + grid_size * 0.5,
				offset_y + cell.y * grid_size + grid_size * 0.5
			)
		)
	if points.size() > 1:
		draw_polyline(points, Color(0.8, 0.2, 0.2, 0.5), 16.0)
	else:
		draw_circle(points[0], 16.0, Color(0.8, 0.2, 0.2, 0.5))

func _set_last_dir(requested_direction: Vector2i) -> void:
	if pieces_data.is_empty():
		return
	var cells: Array[Vector2i] = pieces_data[-1]["cells"]
	if cells.size() < 2:
		return
	var end_direction := PathVisualGeometryScript.direction_from_cells(
		cells,
		PathVisualGeometry.HeadEndpoint.END
	)
	var start_direction := PathVisualGeometryScript.direction_from_cells(
		cells,
		PathVisualGeometry.HeadEndpoint.START
	)
	if requested_direction == end_direction:
		pieces_data[-1]["direction"] = end_direction
	elif requested_direction == start_direction:
		cells.reverse()
		pieces_data[-1]["cells"] = cells
		pieces_data[-1]["direction"] = requested_direction
	else:
		_set_validation_message(
			"Direction must follow the first or final path segment.",
			false
		)
		return
	_refresh_pieces()
	_set_validation_message("Head endpoint updated.", true)

func _on_clear_pressed() -> void:
	pieces_data.clear()
	_refresh_pieces()
	_set_validation_message("Valid: ?", true)

func _on_delete_pressed() -> void:
	if not pieces_data.is_empty():
		pieces_data.pop_back()
	_refresh_pieces()
	_set_validation_message("Valid: ?", true)

func _on_save_pressed() -> void:
	var save_data: Dictionary = {
		"width": board_bounds.size.x,
		"height": board_bounds.size.y,
		"lives": 3,
		"pieces": []
	}
	for piece_dictionary in pieces_data:
		var cells: Array[Vector2i] = piece_dictionary["cells"]
		var direction := PathVisualGeometryScript.direction_from_cells(cells)
		var serialized_cells: Array = []
		for cell in cells:
			serialized_cells.append([cell.x, cell.y])
		save_data["pieces"].append({
			"cells": serialized_cells,
			"direction": [direction.x, direction.y],
			"head_endpoint": "end"
		})
	var file := FileAccess.open("res://data/editor_level.json", FileAccess.WRITE)
	if file == null:
		_set_validation_message("Could not write editor_level.json.", false)
		return
	file.store_string(JSON.stringify(save_data, "  "))
	_set_validation_message("Saved canonical ordered paths.", true)

func _on_load_pressed() -> void:
	var path := "res://data/editor_level.json"
	if not FileAccess.file_exists(path):
		_set_validation_message("editor_level.json was not found.", false)
		return
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		_set_validation_message("Could not open editor_level.json.", false)
		return
	var parsed = JSON.parse_string(file.get_as_text())
	if not parsed is Dictionary:
		_set_validation_message("Invalid editor level JSON.", false)
		return
	var data: Dictionary = parsed
	board_bounds.size = Vector2i(int(data.get("width", 8)), int(data.get("height", 8)))
	grid_dots.update_grid(board_bounds, grid_size)
	pieces_data.clear()
	var rejected := 0
	for raw_piece in data.get("pieces", []):
		if not raw_piece is Dictionary:
			rejected += 1
			continue
		var cells: Array[Vector2i] = []
		for raw_cell in raw_piece.get("cells", []):
			if raw_cell is Array and raw_cell.size() >= 2:
				cells.append(Vector2i(int(raw_cell[0]), int(raw_cell[1])))
		var path_errors := PathVisualGeometryScript.validate_ordered_cells(cells)
		if not path_errors.is_empty():
			rejected += 1
			continue
		var direction := PathVisualGeometryScript.direction_from_cells(cells)
		var legacy_direction_data: Array = raw_piece.get("direction", [])
		if legacy_direction_data.size() >= 2:
			var legacy_direction := Vector2i(
				int(legacy_direction_data[0]),
				int(legacy_direction_data[1])
			)
			var endpoint := PathVisualGeometryScript.legacy_head_endpoint(cells, legacy_direction)
			if endpoint == PathVisualGeometry.HeadEndpoint.START:
				cells.reverse()
				direction = legacy_direction
			elif endpoint < 0:
				rejected += 1
				continue
		pieces_data.append({"cells": cells, "direction": direction})
	_refresh_pieces()
	if rejected > 0:
		_set_validation_message("Loaded with %d ambiguous path(s) rejected." % rejected, false)
	else:
		_set_validation_message("Loaded canonical ordered paths.", true)

func _on_validate_pressed() -> void:
	var valid_paths := _validate_editor_paths()
	var solvable := valid_paths and _can_solve()
	_set_validation_message("Valid: Yes!" if solvable else "Valid: NO", solvable)

func _validate_editor_paths() -> bool:
	var occupied: Dictionary = {}
	for piece_index in range(pieces_data.size()):
		var cells: Array[Vector2i] = pieces_data[piece_index]["cells"]
		if not PathVisualGeometryScript.validate_ordered_cells(cells).is_empty():
			return false
		for cell in cells:
			if not board_bounds.has_point(cell) or occupied.has(cell):
				return false
			occupied[cell] = piece_index
	return true

func _can_solve() -> bool:
	var pieces_copy: Array = pieces_data.duplicate(true)
	var occupied: Dictionary = {}
	for piece_id in range(pieces_copy.size()):
		var piece: Dictionary = pieces_copy[piece_id]
		piece["id"] = piece_id
		piece["direction"] = PathVisualGeometryScript.direction_from_cells(piece["cells"])
		for cell in piece["cells"]:
			occupied[cell] = piece_id

	var removed_something := true
	while removed_something and not pieces_copy.is_empty():
		removed_something = false
		for piece_index in range(pieces_copy.size() - 1, -1, -1):
			var piece: Dictionary = pieces_copy[piece_index]
			if _can_escape(piece, occupied):
				for cell in piece["cells"]:
					occupied.erase(cell)
				pieces_copy.remove_at(piece_index)
				removed_something = true
	return pieces_copy.is_empty()

func _can_escape(piece: Dictionary, occupied: Dictionary) -> bool:
	var direction: Vector2i = piece["direction"]
	for cell in piece["cells"]:
		var test_cell: Vector2i = cell + direction
		while board_bounds.has_point(test_cell):
			var blocker = occupied.get(test_cell)
			if blocker != null and blocker != piece["id"]:
				return false
			test_cell += direction
	return true

func _set_validation_message(message: String, positive: bool) -> void:
	validate_label.text = message
	validate_label.add_theme_color_override(
		"font_color",
		Color(0.2, 0.8, 0.2) if positive else Color(0.8, 0.2, 0.2)
	)
